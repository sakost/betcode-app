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

  group('Permission & Question Flows', () {
    testWidgets(
      'permission approve: permission card appears, tap to approve, '
      'agent resumes',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-perm', 1);
        await tester.pump();

        // Agent sends a permission request.
        emitPermissionRequest(
          eventController,
          'perm-1',
          'Bash',
          2,
          description: 'Run shell command',
        );
        await tester.pump();

        // Permission card should render with the tool name.
        expect(find.text('Bash'), findsOneWidget);

        // The card has a shield icon indicating permission.
        expect(find.byIcon(Icons.shield), findsOneWidget);

        // Tap the permission card to open the permission sheet.
        await tester.tap(find.text('Bash'));
        await tester.pumpAndSettle();

        // The bottom sheet should show "Permission Required" and buttons.
        expect(find.text('Permission Required'), findsOneWidget);
        expect(find.text('Allow Once'), findsOneWidget);
        expect(find.text('Allow Session'), findsOneWidget);
        expect(find.text('Deny'), findsOneWidget);

        // Tap "Allow Session".
        await tester.tap(find.text('Allow Session'));
        await tester.pumpAndSettle();

        // Verify the permission card is marked as decided.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        final permMsg = state.messages.whereType<PermissionRequestMessage>();
        expect(permMsg.length, 1);
        expect(
          permMsg.first.decision,
          PermissionDecision.PERMISSION_DECISION_ALLOW_SESSION,
        );

        // The "Allowed" label should now be visible on the card.
        expect(find.text('Allowed'), findsOneWidget);

        // Agent resumes with text.
        emitStatusChange(
          eventController,
          AgentStatus.AGENT_STATUS_THINKING,
          3,
        );
        await tester.pump();

        emitTextDelta(eventController, 'Command executed.', 4,
            isComplete: true);
        await tester.pump();

        emitTurnComplete(eventController, 5);
        await tester.pump();

        expect(find.textContaining('Command executed.'), findsOneWidget);
      },
    );

    testWidgets(
      'permission deny: tap deny, agent receives denial',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-deny', 1);
        await tester.pump();

        emitPermissionRequest(
          eventController,
          'perm-deny',
          'Write',
          2,
          description: 'Write to file',
        );
        await tester.pump();

        // Tap the permission card.
        await tester.tap(find.text('Write'));
        await tester.pumpAndSettle();

        // Tap "Deny".
        await tester.tap(find.text('Deny'));
        await tester.pumpAndSettle();

        // Verify the card shows "Denied".
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        final permMsg = state.messages.whereType<PermissionRequestMessage>();
        expect(
          permMsg.first.decision,
          PermissionDecision.PERMISSION_DECISION_DENY,
        );
        expect(find.text('Denied'), findsOneWidget);
      },
    );

    testWidgets(
      'user question single-select: question appears, select option, submit',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-question', 1);
        await tester.pump();

        // Agent sends a user question.
        emitUserQuestion(
          eventController,
          'q-1',
          'Which approach do you prefer?',
          [
            QuestionOption(value: 'a', label: 'Option A', description: 'Fast'),
            QuestionOption(
                value: 'b', label: 'Option B', description: 'Reliable'),
          ],
          2,
        );
        await tester.pump();

        // Question card should render.
        expect(
          find.text('Which approach do you prefer?'),
          findsOneWidget,
        );
        expect(find.text('Tap to answer'), findsOneWidget);

        // Tap the question card to open the dialog.
        await tester.tap(find.text('Tap to answer'));
        await tester.pumpAndSettle();

        // The dialog should show the question and options.
        expect(find.text('Option A'), findsOneWidget);
        expect(find.text('Option B'), findsOneWidget);

        // Select Option A.
        await tester.tap(find.text('Option A'));
        await tester.pump();

        // Submit.
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Verify the question card is now marked as answered.
        expect(find.text('Answered'), findsOneWidget);

        // Verify state.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        final qMsg = state.messages.whereType<UserQuestionMessage>();
        expect(qMsg.length, 1);
        expect(qMsg.first.answers, isNotNull);
        expect(qMsg.first.answers!.containsKey('a'), isTrue);
      },
    );

    testWidgets(
      'user question multi-select: multiple options selectable',
      (tester) async {
        await tester.pumpWidget(
          buildIntegrationApp(
            mockAgentClient: mockClient,
            initialLocation: '/sessions/new',
          ),
        );
        await tester.pumpAndSettle();

        emitSessionInfo(eventController, 'sess-multi-q', 1);
        await tester.pump();

        emitUserQuestion(
          eventController,
          'q-multi',
          'Select features to enable:',
          [
            QuestionOption(value: 'x', label: 'Feature X'),
            QuestionOption(value: 'y', label: 'Feature Y'),
            QuestionOption(value: 'z', label: 'Feature Z'),
          ],
          2,
          multiSelect: true,
        );
        await tester.pump();

        // Tap to answer.
        await tester.tap(find.text('Tap to answer'));
        await tester.pumpAndSettle();

        // Select Feature X and Feature Z.
        await tester.tap(find.text('Feature X'));
        await tester.pump();
        await tester.tap(find.text('Feature Z'));
        await tester.pump();

        // Submit.
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Verify answers.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TextField)),
        );
        final state =
            container.read(conversationProvider(null)).value!
                as ConversationActive;
        final qMsg = state.messages.whereType<UserQuestionMessage>();
        expect(qMsg.first.answers, isNotNull);
        expect(qMsg.first.answers!.keys, containsAll(['x', 'z']));
        expect(qMsg.first.answers!.containsKey('y'), isFalse);
      },
    );
  });
}
