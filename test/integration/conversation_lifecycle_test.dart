import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('Conversation Lifecycle', () {
    testWidgets(
      'full turn cycle: auto-start, send message, streaming response with '
      'tool call, turn completes, input re-enabled',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        // The conversation screen should auto-start. After auto-start the
        // state transitions to ConversationActive immediately.
        // Emit SessionInfo to confirm the session.
        emitSessionInfo(eventController, 'sess-lifecycle', 1);
        await tester.pump();

        // Verify conversation screen is active by finding the input bar.
        expect(find.byType(TextField), findsOneWidget);

        // Agent is idle — input should be enabled.
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);

        // Type and send a message.
        await tester.enterText(find.byType(TextField), 'Hello agent');
        await tester.pump();

        // Find send button and tap it.
        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);
        await tester.tap(sendButton);
        await tester.pump();

        // Verify user message appears.
        expect(find.text('Hello agent'), findsOneWidget);

        // Agent starts thinking.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          2,
        );
        await tester.pump();

        // Streaming text response.
        emitTextDelta(eventController, 'Let me ', 3);
        await tester.pump();
        expect(find.textContaining('Let me'), findsOneWidget);

        emitTextDelta(eventController, 'check that.', 4);
        await tester.pump();
        expect(find.textContaining('Let me check that.'), findsOneWidget);

        // Tool call starts.
        emitToolCallStart(
          eventController,
          'tool-1',
          'Read',
          5,
          description: 'Read file contents',
        );
        await tester.pump();

        // Tool call card should appear with the tool name.
        expect(find.text('Read'), findsOneWidget);

        // Tool call completes.
        emitToolCallResult(
          eventController,
          'tool-1',
          'file contents here',
          6,
        );
        await tester.pump();

        // More text after tool call.
        emitTextDelta(eventController, 'Here is the result.', 7,
            isComplete: true);
        await tester.pump();

        // Turn complete — agent goes idle.
        emitTurnComplete(eventController, 8);
        await tester.pump();

        // Input should be re-enabled.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state = container.read(conversationProvider(null)).value;
        expect(state, isA<ConversationActive>());
        expect(
          (state! as ConversationActive).agentStatus,
          AgentStatus.AGENT_STATUS_IDLE,
        );

        // The TextField should be enabled again.
        final updatedField = tester.widget<TextField>(find.byType(TextField));
        expect(updatedField.enabled, isTrue);
      },
    );

    testWidgets(
      'multiple messages: send two messages in sequence, both get responses',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-multi', 1);
        await tester.pump();

        // Send first message via UI.
        await tester.enterText(find.byType(TextField), 'First message');
        await tester.pump(); // Let _hasText propagate
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();
        expect(find.text('First message'), findsOneWidget);

        // Agent responds to first message.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          2,
        );
        await tester.pump();

        emitTextDelta(eventController, 'First response', 3, isComplete: true);
        await tester.pump();

        emitTurnComplete(eventController, 4);
        await tester.pumpAndSettle();

        // Verify input is re-enabled after first turn.
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);

        // Send second message via notifier. On real devices, the
        // TextField loses focus when disabled during THINKING and
        // enterText can fail to inject text after re-enable. Sending
        // through the notifier still exercises the full state + UI
        // rendering pipeline.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final notifier =
            container.read(conversationProvider(null).notifier);
        notifier.sendMessage('Second message');
        await tester.pump();

        // Agent responds to second message.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          5,
        );
        await tester.pump();

        emitTextDelta(eventController, 'Second response', 6,
            isComplete: true);
        await tester.pump();

        emitTurnComplete(eventController, 7);
        await tester.pump();

        // Verify both messages and responses exist in the UI.
        expect(find.text('First message'), findsOneWidget);
        expect(find.text('Second message'), findsOneWidget);

        // Verify message count in state.
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        // 2 user + 2 agent = 4 messages
        expect(state.messages.length, 4);
      },
    );

    testWidgets(
      'empty message not sent: input bar does not send empty content',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-empty', 1);
        await tester.pump();

        // The send button should exist but be disabled (no text).
        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);

        // Try to tap the send button with empty text.
        await tester.tap(sendButton);
        await tester.pump();

        // State should have no messages.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state = container.read(conversationProvider(null)).value;
        expect(state, isA<ConversationActive>());
        expect((state! as ConversationActive).messages, isEmpty);

        // Enter whitespace and try again.
        await tester.enterText(find.byType(TextField), '   ');
        await tester.pump();
        await tester.tap(sendButton);
        await tester.pump();

        final stateAfter = container.read(conversationProvider(null)).value;
        expect((stateAfter! as ConversationActive).messages, isEmpty);
      },
    );
  });
}
