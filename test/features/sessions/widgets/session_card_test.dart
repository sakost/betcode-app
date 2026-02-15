import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/sessions/widgets/session_card.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

import '../../../helpers/session_test_helpers.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('SessionCard - title display', () {
    testWidgets('shows session.name as title when non-empty', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(name: 'My Session'))),
      );
      await t.pumpAndSettle();

      expect(find.text('My Session'), findsOneWidget);
    });

    testWidgets('shows lastMessagePreview as title when name is empty', (
      t,
    ) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(name: '', lastMessagePreview: 'Fix bug'),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Fix bug'), findsOneWidget);
    });

    testWidgets('shows model as title when both name and preview empty', (
      t,
    ) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(
              name: '',
              lastMessagePreview: '',
              model: 'sonnet',
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('sonnet'), findsOneWidget);
    });

    testWidgets('shows "Unknown" when all title sources empty', (t) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(
              name: '',
              lastMessagePreview: '',
              model: '',
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Unknown'), findsOneWidget);
    });
  });

  group('SessionCard - callbacks', () {
    testWidgets('onTap is called when tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(
          SessionCard(session: makeTestSession(), onTap: () => tapped = true),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.byType(SessionCard));
      expect(tapped, isTrue);
    });

    testWidgets('long press shows context menu with Rename and Delete', (
      t,
    ) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(),
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();

      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('selecting Rename calls onRename with current name', (t) async {
      String? renamedWith;
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(name: 'Old Name'),
            onRename: (name) => renamedWith = name,
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();

      await t.tap(find.text('Rename'));
      await t.pumpAndSettle();

      expect(renamedWith, 'Old Name');
    });

    testWidgets('selecting Delete calls onDelete', (t) async {
      var deleted = false;
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(),
            onRename: (_) {},
            onDelete: () => deleted = true,
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();

      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();

      expect(deleted, isTrue);
    });
  });

  group('SessionCard - status and info', () {
    testWidgets('displays status badge', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(status: 'active'))),
      );
      await t.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('displays message count', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(messageCount: 42))),
      );
      await t.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('displays formatted cost', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(totalCostUsd: 0.0042))),
      );
      await t.pumpAndSettle();

      expect(find.text('0.0042'), findsOneWidget);
    });
  });
}
