// On-device instrumented tests for conversation lifecycle.

import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

  group('Conversation lifecycle', () {
    testWidgets(
      'full turn: auto-start, send message, streaming response with tool, '
      'turn completes',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-lifecycle', 1);
        await tester.pump();

        // Input should be enabled.
        expect(find.byType(TextField), findsOneWidget);
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);

        // Type and send.
        await tester.enterText(find.byType(TextField), 'Hello agent');
        await tester.pump();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();
        expect(find.text('Hello agent'), findsOneWidget);

        // Agent thinking + streaming text.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          2,
        );
        await tester.pump();

        emitTextDelta(eventController, 'Let me check that.', 3);
        await tester.pump();
        expect(find.textContaining('Let me check that.'), findsOneWidget);

        // Tool call.
        emitToolCallStart(eventController, 'tool-1', 'Read', 4,
            description: 'Read file');
        await tester.pump();
        expect(find.text('Read'), findsOneWidget);

        emitToolCallResult(eventController, 'tool-1', 'contents', 5);
        await tester.pump();

        // Final text + turn complete.
        emitTextDelta(eventController, 'Here is the result.', 6,
            isComplete: true);
        await tester.pump();
        emitTurnComplete(eventController, 7);
        await tester.pump();

        // Input re-enabled.
        final updated = tester.widget<TextField>(find.byType(TextField));
        expect(updated.enabled, isTrue);
      },
    );

    testWidgets('empty message is not sent', (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-empty', 1);
      await tester.pump();

      // Tap send with empty text.
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );
      final state = container.read(conversationProvider(null)).value;
      expect(state, isA<ConversationActive>());
      expect((state! as ConversationActive).messages, isEmpty);
    });
  });
}
