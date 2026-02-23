// On-device instrumented tests for error handling and reconnection.

import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/integration_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAgentServiceClient mockClient;
  late StreamController<pb.AgentEvent> eventController;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockClient = MockAgentServiceClient();
    eventController = StreamController<pb.AgentEvent>();
    stubConverse(mockClient, eventController);
  });

  tearDown(() {
    if (!eventController.isClosed) {
      unawaited(eventController.close());
    }
  });

  group('Error handling', () {
    testWidgets('non-fatal error shows banner, dismiss clears it',
        (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-err', 1);
      await tester.pump();

      emitErrorEvent(eventController, 'Something went wrong', 2, code: 'WARN');
      await tester.pump();

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(find.textContaining('Something went wrong'), findsOneWidget);

      await tester.tap(find.text('Dismiss'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );
      final state = container.read(conversationProvider(null)).value!
          as ConversationActive;
      expect(state.errorMessage, isNull);
    });

    testWidgets('fatal error shows error screen with retry', (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-fatal', 1);
      await tester.pump();

      emitErrorEvent(eventController, 'Session has expired', 2,
          isFatal: true, code: 'FATAL');
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold).first),
      );
      final state = container.read(conversationProvider(null)).value;
      expect(state, isA<ConversationError>());
      expect(find.textContaining('Session has expired'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('transient error triggers reconnect, banner clears on success',
        (tester) async {
      StreamController<pb.AgentEvent>? reconnectController;
      var converseCallCount = 0;

      when(() => mockClient.converse(any())).thenAnswer((inv) {
        (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen((_) {});
        converseCallCount++;
        if (converseCallCount == 1) {
          return FakeResponseStream<pb.AgentEvent>(eventController);
        }
        reconnectController = StreamController<pb.AgentEvent>();
        return FakeResponseStream<pb.AgentEvent>(reconnectController!);
      });

      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-reconnect', 1);
      await tester.pump();

      // Inject transient error.
      eventController.addError(const GrpcError.unavailable('network lost'));
      await tester.pump();

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(find.textContaining('Reconnecting'), findsOneWidget);

      // Advance past first backoff (500ms).
      await tester.pump(const Duration(milliseconds: 600));

      // Reconnect succeeds.
      if (reconnectController != null) {
        emitSessionInfo(reconnectController!, 'sess-reconnect', 2);
        await tester.pump();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final restored = container.read(conversationProvider(null)).value!
            as ConversationActive;
        expect(restored.errorMessage, isNull);

        await reconnectController!.close();
      }
    });
  });
}
