// On-device instrumented tests for session resume flow.

import 'dart:async';

import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:flutter/material.dart';
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

  group('Session resume', () {
    testWidgets('tap session card, history replayed, send new message',
        (tester) async {
      final historyController = StreamController<pb.AgentEvent>();
      stubResumeSession(mockClient, historyController);

      await tester.pumpWidget(
        buildIntegrationApp(
          mockAgentClient: mockClient,
          initialLocation: '/sessions',
          overrides: [
            sessionsProvider.overrideWith(
              () => FakeSessionsNotifier([
                makeTestSession(
                  id: 'sess-resume',
                  name: 'My Session',
                  lastMessagePreview: 'Previous chat',
                ),
              ]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('My Session'), findsOneWidget);

      // Tap session card to navigate to conversation.
      await tester.tap(find.text('My Session'));
      await tester.pumpAndSettle();

      emitSessionInfo(eventController, 'sess-resume', 1);
      await tester.pump();

      // Replay history.
      emitTextDelta(historyController, 'Historical message', 2,
          isComplete: true);
      emitTurnComplete(historyController, 3);
      await historyController.close();
      await tester.pump();

      expect(find.textContaining('Historical message'), findsOneWidget);

      // Input enabled.
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isTrue);

      // Send new message.
      await tester.enterText(find.byType(TextField), 'New message');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.text('New message'), findsOneWidget);
    });
  });
}
