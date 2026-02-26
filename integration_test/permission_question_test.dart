// On-device instrumented tests for permission and user question flows.

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

  // ---------------------------------------------------------------------------
  // Permission flow
  // ---------------------------------------------------------------------------

  group('Permission flow', () {
    testWidgets('approve permission, agent resumes', (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-perm', 1);
      await tester.pump();

      emitPermissionRequest(eventController, 'perm-1', 'Bash', 2,
          description: 'Run shell command');
      await tester.pump();

      expect(find.text('Bash'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);

      // Open permission sheet.
      await tester.tap(find.text('Bash'));
      await tester.pumpAndSettle();

      expect(find.text('Permission Required'), findsOneWidget);
      expect(find.text('Allow Session'), findsOneWidget);

      // Approve.
      await tester.tap(find.text('Allow Session'));
      await tester.pumpAndSettle();

      expect(find.text('Allowed'), findsOneWidget);

      // Agent resumes.
      emitTextDelta(eventController, 'Command executed.', 3,
          isComplete: true);
      await tester.pump();
      emitTurnComplete(eventController, 4);
      await tester.pump();

      expect(find.textContaining('Command executed.'), findsOneWidget);
    });

    testWidgets('deny permission', (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-deny', 1);
      await tester.pump();

      emitPermissionRequest(eventController, 'perm-deny', 'Write', 2,
          description: 'Write to file');
      await tester.pump();

      await tester.tap(find.text('Write'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deny'));
      await tester.pumpAndSettle();

      expect(find.text('Denied'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // User questions
  // ---------------------------------------------------------------------------

  group('User questions', () {
    testWidgets('single-select: pick option and submit', (tester) async {
      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions/new',
        ),
      );
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-q', 1);
      await tester.pump();

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

      expect(find.text('Which approach do you prefer?'), findsOneWidget);

      // Open question dialog.
      await tester.tap(find.text('Tap to answer'));
      await tester.pumpAndSettle();

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);

      await tester.tap(find.text('Option A'));
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Answered'), findsOneWidget);
    });

    testWidgets('multi-select: pick multiple options', (tester) async {
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

      await tester.tap(find.text('Tap to answer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Feature X'));
      await tester.pump();
      await tester.tap(find.text('Feature Z'));
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );
      final state = container.read(conversationProvider(null)).value!
          as ConversationActive;
      final qMsg = state.messages.whereType<UserQuestionMessage>();
      expect(qMsg.first.answers!.keys, containsAll(['x', 'z']));
      expect(qMsg.first.answers!.containsKey('y'), isFalse);
    });
  });
}
