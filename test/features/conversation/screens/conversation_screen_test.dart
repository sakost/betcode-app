import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/screens/conversation_screen.dart';

Widget _app(Widget child) => ProviderScope(
      child: MaterialApp(home: child),
    );

void main() {
  group('ConversationScreen', () {
    testWidgets('shows default prompt when no sessionId', (tester) async {
      await tester.pumpWidget(_app(const ConversationScreen()));
      expect(find.text('Start a conversation'), findsOneWidget);
    });

    testWidgets('shows session prompt when sessionId provided',
        (tester) async {
      await tester
          .pumpWidget(_app(const ConversationScreen(sessionId: 'sess-1')));
      expect(
        find.text('Conversation messages will appear here'),
        findsOneWidget,
      );
    });

    testWidgets('has message input field', (tester) async {
      await tester.pumpWidget(_app(const ConversationScreen()));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Type a message...'), findsOneWidget);
    });

    testWidgets('has send button', (tester) async {
      await tester.pumpWidget(_app(const ConversationScreen()));
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('has app bar with title', (tester) async {
      await tester.pumpWidget(_app(const ConversationScreen()));
      expect(find.text('Conversation'), findsOneWidget);
    });

    testWidgets('text field accepts input', (tester) async {
      await tester.pumpWidget(_app(const ConversationScreen()));
      await tester.enterText(find.byType(TextField), 'Hello agent');
      await tester.pump();
      expect(find.text('Hello agent'), findsOneWidget);
    });
  });
}
