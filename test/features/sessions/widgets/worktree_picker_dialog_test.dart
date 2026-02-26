import 'dart:async';

import 'package:betcode_app/features/sessions/widgets/worktree_picker_dialog.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _FakeWorktreesNotifier extends WorktreesNotifier {
  _FakeWorktreesNotifier(this._value);
  final AsyncValue<List<WorktreeDetail>> _value;

  @override
  Future<List<WorktreeDetail>> build() {
    return _value.when(
      data: Future.value,
      loading: () => Completer<List<WorktreeDetail>>().future,
      error: Future.error,
    );
  }
}

WorktreeDetail _makeWorktree({
  String id = 'wt-1',
  String name = 'main-worktree',
  String path = '/home/user/project',
  String branch = 'main',
  bool existsOnDisk = true,
}) =>
    WorktreeDetail(
      id: id,
      name: name,
      path: path,
      branch: branch,
      existsOnDisk: existsOnDisk,
    );

/// Shows the [WorktreePickerDialog] inside a test scaffold and returns
/// the [Future] that resolves to the selected [WorktreeDetail] or null.
Future<WorktreeDetail?> _showDialog(
  WidgetTester t, {
  required AsyncValue<List<WorktreeDetail>> worktrees,
}) async {
  WorktreeDetail? result;
  await t.pumpWidget(
    ProviderScope(
      overrides: [
        worktreesProvider.overrideWith(
          () => _FakeWorktreesNotifier(worktrees),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await WorktreePickerDialog.show(context);
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );
  await t.pumpAndSettle();

  // Tap the button to open the dialog.
  await t.tap(find.text('Open'));
  await t.pumpAndSettle();

  return result;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('WorktreePickerDialog', () {
    testWidgets('shows title and worktree list', (t) async {
      await _showDialog(
        t,
        worktrees: AsyncData([
          _makeWorktree(name: 'alpha', branch: 'feat-a'),
          _makeWorktree(id: 'wt-2', name: 'beta', branch: 'feat-b'),
        ]),
      );

      expect(find.text('Select Worktree'), findsOneWidget);
      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('beta'), findsOneWidget);
      expect(find.text('feat-a'), findsOneWidget);
      expect(find.text('feat-b'), findsOneWidget);
    });

    testWidgets('shows loading indicator while worktrees load', (t) async {
      // Use _showDialog internals manually since pumpAndSettle times out
      // when a CircularProgressIndicator is animating.
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            worktreesProvider.overrideWith(
              () => _FakeWorktreesNotifier(const AsyncLoading()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => WorktreePickerDialog.show(context),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Open'));
      // Use pump() instead of pumpAndSettle to avoid timeout from spinner.
      await t.pump();

      expect(find.text('Select Worktree'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await _showDialog(
        t,
        worktrees: AsyncError(Exception('network error'), StackTrace.empty),
      );

      expect(find.textContaining('network error'), findsOneWidget);
    });

    testWidgets('shows empty state when no worktrees', (t) async {
      await _showDialog(t, worktrees: const AsyncData([]));

      expect(find.text('No worktrees available'), findsOneWidget);
    });

    testWidgets('tapping a worktree returns it', (t) async {
      final wt = _makeWorktree(name: 'my-wt', path: '/home/proj');
      WorktreeDetail? result;

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            worktreesProvider.overrideWith(
              () => _FakeWorktreesNotifier(AsyncData([wt])),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await WorktreePickerDialog.show(context);
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      await t.tap(find.text('my-wt'));
      await t.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.name, 'my-wt');
      expect(result!.path, '/home/proj');
    });

    testWidgets('cancel button returns null', (t) async {
      WorktreeDetail? result = _makeWorktree(); // non-null sentinel

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            worktreesProvider.overrideWith(
              () => _FakeWorktreesNotifier(
                AsyncData([_makeWorktree()]),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await WorktreePickerDialog.show(context);
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('shows branch and path info per worktree', (t) async {
      await _showDialog(
        t,
        worktrees: AsyncData([
          _makeWorktree(
            name: 'test-wt',
            branch: 'feature/login',
            path: '/home/user/code',
          ),
        ]),
      );

      expect(find.text('test-wt'), findsOneWidget);
      expect(find.text('feature/login'), findsOneWidget);
      expect(find.text('/home/user/code'), findsOneWidget);
    });
  });
}
