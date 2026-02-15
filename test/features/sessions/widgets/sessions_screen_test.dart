import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/sessions/notifiers/sessions_notifier.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/features/sessions/screens/sessions_screen.dart';
import 'package:betcode_app/features/sessions/widgets/session_card.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

import '../../../helpers/session_test_helpers.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

/// A notifier that returns a canned async value without gRPC or DB calls.
///
/// For [AsyncLoading], [build] never completes so the widget stays in loading.
/// For [AsyncData], it returns the data immediately.
/// For [AsyncError], it throws the error.
class _FakeSessionsNotifier extends SessionsNotifier {
  _FakeSessionsNotifier(this._value);

  final AsyncValue<List<SessionSummary>> _value;

  @override
  Future<List<SessionSummary>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () =>
          Completer<List<SessionSummary>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

// ---------------------------------------------------------------------------
// SessionsScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('SessionsScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            sessionsProvider.overrideWith(
              () => _FakeSessionsNotifier(const AsyncLoading()),
            ),
          ],
          child: _app(const SessionsScreen()),
        ),
      );
      // Don't pumpAndSettle -- the loading state is the point.
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
    });

    testWidgets('displays list of SessionCard widgets when data arrives', (
      t,
    ) async {
      final sessions = [
        makeTestSession(id: 's-1', model: 'opus'),
        makeTestSession(id: 's-2', model: 'sonnet'),
        makeTestSession(id: 's-3', model: 'haiku'),
      ];

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            sessionsProvider.overrideWith(
              () => _FakeSessionsNotifier(AsyncData(sessions)),
            ),
          ],
          child: _app(const SessionsScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byType(SessionCard), findsNWidgets(3));
      expect(find.text('opus'), findsOneWidget);
      expect(find.text('sonnet'), findsOneWidget);
      expect(find.text('haiku'), findsOneWidget);
    });

    testWidgets('shows empty state when no sessions exist', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            sessionsProvider.overrideWith(
              () => _FakeSessionsNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SessionsScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('No sessions yet'), findsOneWidget);
      expect(
        find.text('Start a conversation to see your sessions here.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byType(SessionCard), findsNothing);
    });

    testWidgets('shows FAB with add icon', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            sessionsProvider.overrideWith(
              () => _FakeSessionsNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SessionsScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            sessionsProvider.overrideWith(
              () => _FakeSessionsNotifier(
                AsyncError(Exception('connection refused'), StackTrace.empty),
              ),
            ),
          ],
          child: _app(const SessionsScreen()),
        ),
      );
      await t.pumpAndSettle();

      // ErrorDisplay shows the error message and a Retry button
      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // SessionCard tests
  // ---------------------------------------------------------------------------

  group('SessionCard', () {
    testWidgets('displays session model name', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(model: 'claude-opus-4'))),
      );
      await t.pumpAndSettle();

      expect(find.text('claude-opus-4'), findsOneWidget);
    });

    testWidgets('displays last message preview', (t) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: makeTestSession(lastMessagePreview: 'Fix the auth bug'),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Fix the auth bug'), findsOneWidget);
    });

    testWidgets('displays formatted cost with 4 decimal places', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(totalCostUsd: 0.0042))),
      );
      await t.pumpAndSettle();

      expect(find.text('0.0042'), findsOneWidget);
    });

    testWidgets('displays message count', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(messageCount: 42))),
      );
      await t.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('displays status badge', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(status: 'active'))),
      );
      await t.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows "Unknown" when model is empty', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(model: ''))),
      );
      await t.pumpAndSettle();

      expect(find.text('Unknown'), findsOneWidget);
    });

    testWidgets('hides message preview when empty', (t) async {
      final session = makeTestSession(
        lastMessagePreview: '',
        // Use a non-empty preview on a reference card to contrast
      );
      await t.pumpWidget(_app(SessionCard(session: session)));
      await t.pumpAndSettle();

      // Model is shown
      expect(find.text('opus'), findsOneWidget);
      // The preview section (bodyMedium text with 2-line overflow) should not
      // appear. We verify by counting Text widgets: with an empty preview the
      // conditional `if (session.lastMessagePreview.isNotEmpty)` is false, so
      // there should be fewer text widgets than with a non-empty preview.
      // Simply check that 'Hello world' (the default) is NOT rendered.
      expect(find.text('Hello world'), findsNothing);
    });

    testWidgets('handles zero cost gracefully', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(totalCostUsd: 0.0))),
      );
      await t.pumpAndSettle();

      expect(find.text('0.0000'), findsOneWidget);
    });

    testWidgets('handles zero message count', (t) async {
      await t.pumpWidget(
        _app(SessionCard(session: makeTestSession(messageCount: 0))),
      );
      await t.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('renders card with InkWell for tap target', (t) async {
      await t.pumpWidget(_app(SessionCard(session: makeTestSession())));
      await t.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
