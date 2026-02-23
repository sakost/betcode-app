import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/integration_helpers.dart';

void main() {

  late MockAgentServiceClient mockClient;
  late StreamController<pb.AgentEvent> eventController;
  late StreamController<pb.AgentEvent> historyController;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockClient = MockAgentServiceClient();
    eventController = StreamController<pb.AgentEvent>();
    historyController = StreamController<pb.AgentEvent>();

    stubConverse(mockClient, eventController);
    stubResumeSession(mockClient, historyController);
  });

  tearDown(() {
    if (!eventController.isClosed) unawaited(eventController.close());
    if (!historyController.isClosed) unawaited(historyController.close());
  });

  group('Session Resume', () {
    testWidgets(
      'resume with history: tap session, history events replayed, then '
      'send new message',
      (tester) async {
        final sessions = [
          makeTestSession(
            id: 'sess-resume',
            name: 'My Session',
            lastMessagePreview: 'Previous chat',
          ),
        ];

        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions',
            overrides: [
              sessionsProvider.overrideWith(
                () => FakeSessionsNotifier(sessions),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify sessions list renders.
        expect(find.text('My Session'), findsOneWidget);

        // Tap the session card.
        await tester.tap(find.text('My Session'));
        await tester.pumpAndSettle();

        // After navigation, the conversation screen auto-resumes.
        // Emit session info through the converse stream.
        emitSessionInfo(eventController, 'sess-resume', 1);
        await tester.pump();

        // Emit history events through the history stream.
        emitTextDelta(
          historyController,
          'Historical message',
          2,
          isComplete: true,
        );
        emitTurnComplete(historyController, 3);
        // Close history stream to signal completion.
        await historyController.close();
        await tester.pump();

        // Verify historical message appears in the message list.
        expect(
          find.textContaining('Historical message'),
          findsOneWidget,
        );

        // Verify the conversation is in active state.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state = container
            .read(conversationProvider('sess-resume'))
            .value;
        expect(state, isA<ConversationActive>());
        final active = state! as ConversationActive;
        expect(active.sessionId, 'sess-resume');

        // Input should be enabled (agent is idle after turn complete).
        final textField =
            tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);

        // Send a new message.
        await tester.enterText(
          find.byType(TextField),
          'New message',
        );
        await tester.pump(); // Let _hasText propagate
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        expect(find.text('New message'), findsOneWidget);

        // Agent responds.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          4,
        );
        await tester.pump();

        emitTextDelta(
          eventController,
          'New response',
          5,
          isComplete: true,
        );
        await tester.pump();

        emitTurnComplete(eventController, 6);
        await tester.pump();

        expect(find.textContaining('New response'), findsOneWidget);
      },
    );

    testWidgets(
      'resume empty session: session has no history, conversation starts '
      'fresh',
      (tester) async {
        final sessions = [
          makeTestSession(
            id: 'sess-empty',
            name: 'Empty Session',
            messageCount: 0,
            lastMessagePreview: '',
          ),
        ];

        // Use a new history controller that closes immediately.
        final emptyHistoryController =
            StreamController<pb.AgentEvent>();

        when(() => mockClient.resumeSession(any())).thenAnswer((_) {
          return FakeResponseStream<pb.AgentEvent>(
            emptyHistoryController,
          );
        });

        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions',
            overrides: [
              sessionsProvider.overrideWith(
                () => FakeSessionsNotifier(sessions),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Tap the empty session.
        await tester.tap(find.text('Empty Session'));
        await tester.pumpAndSettle();

        // Emit session info.
        emitSessionInfo(eventController, 'sess-empty', 1);
        await tester.pump();

        // Close history immediately — no events.
        await emptyHistoryController.close();
        await tester.pump();

        // Verify conversation is active with no messages.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state = container
            .read(conversationProvider('sess-empty'))
            .value;
        expect(state, isA<ConversationActive>());
        expect(
          (state! as ConversationActive).messages,
          isEmpty,
        );

        // Input should be enabled.
        final textField =
            tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isTrue);
      },
    );
  });
}
