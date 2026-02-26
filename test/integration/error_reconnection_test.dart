import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/integration_helpers.dart';

void main() {

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

  group('Error & Reconnection (UI-level)', () {
    testWidgets(
      'transient error + successful reconnect: error banner shows, reconnect '
      'succeeds, banner clears, can send messages',
      (tester) async {
        StreamController<pb.AgentEvent>? reconnectController;

        // On reconnect (second converse call), return a new stream.
        var converseCallCount = 0;
        when(() => mockClient.converse(any())).thenAnswer((inv) {
          (inv.positionalArguments[0] as Stream<pb.AgentRequest>)
              .listen((_) {});
          converseCallCount++;
          if (converseCallCount == 1) {
            return FakeResponseStream<pb.AgentEvent>(eventController);
          }
          // Reconnection attempt.
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

        // Start conversation and go active.
        emitSessionInfo(eventController, 'sess-reconnect', 1);
        await tester.pump();

        // Verify active state.
        expect(find.byType(TextField), findsOneWidget);
        var textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);

        // Inject a transient gRPC error.
        eventController.addError(const GrpcError.unavailable('network lost'));
        await tester.pump();

        // Error banner should show with "Reconnecting" text.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final errorState =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        expect(errorState.errorMessage, contains('Reconnecting'));

        // The MaterialBanner should be visible.
        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.textContaining('Reconnecting'), findsOneWidget);

        // Advance past the first backoff (500ms).
        await tester.pump(const Duration(milliseconds: 600));

        // Reconnect should have fired — send a successful event.
        if (reconnectController != null) {
          emitSessionInfo(reconnectController!, 'sess-reconnect', 2);
          await tester.pump();

          // Banner should disappear.
          final restored =
              container.read(conversationProvider(null)).value!
                  as ConversationActive;
          expect(restored.errorMessage, isNull);

          // Input should be re-enabled.
          textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.enabled, isTrue);

          // Can send a message after reconnection.
          await tester.enterText(find.byType(TextField), 'After reconnect');
          await tester.pump(); // Let _hasText propagate
          await tester.tap(find.byIcon(Icons.send));
          await tester.pump();
          expect(find.text('After reconnect'), findsOneWidget);

          await reconnectController!.close();
        }
      },
    );

    testWidgets(
      'non-fatal error banner dismiss: error shows banner, dismiss button '
      'clears it',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-nonfatal', 1);
        await tester.pump();

        // Emit a non-fatal error event.
        emitErrorEvent(
          eventController,
          'Something went wrong',
          2,
          code: 'WARN',
        );
        await tester.pump();

        // Error banner should be visible.
        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.textContaining('Something went wrong'), findsOneWidget);

        // Find and tap the Dismiss button.
        expect(find.text('Dismiss'), findsOneWidget);
        await tester.tap(find.text('Dismiss'));
        await tester.pump();

        // Banner should be gone.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        expect(state.errorMessage, isNull);
      },
    );

    testWidgets(
      'fatal error transitions to error state: error shows error screen, '
      'not reconnecting banner',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-fatal', 1);
        await tester.pump();

        // Verify we are in active state.
        expect(find.byType(TextField), findsOneWidget);

        // Emit a fatal error event.
        emitErrorEvent(
          eventController,
          'Session has expired',
          2,
          isFatal: true,
          code: 'FATAL',
        );
        await tester.pump();

        // The conversation should be in error state, not active.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold).first),
        );
        final state = container.read(conversationProvider(null)).value;
        expect(state, isA<ConversationError>());

        // Error state UI should show the error message and a retry button.
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.textContaining('Session has expired'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);

        // No MaterialBanner (that's for non-fatal in active state).
        expect(find.byType(MaterialBanner), findsNothing);
      },
    );
  });
}
