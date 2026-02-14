import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import 'package:betcode_app/features/git_repos/notifiers/git_repos_notifier.dart';
import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/features/worktrees/screens/worktrees_screen.dart';
import 'package:betcode_app/features/worktrees/widgets/worktree_card.dart';
import 'package:betcode_app/features/worktrees/widgets/create_worktree_dialog.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

WorktreeDetail _makeWorktree({
  String id = 'wt-1',
  String name = 'feat-login',
  String branch = 'feat/login',
  String path = '/home/user/worktrees/feat-login',
  String repoId = 'repo-1',
  bool existsOnDisk = true,
  int sessionCount = 2,
  int? lastActiveSeconds,
}) {
  final wt = WorktreeDetail(
    id: id,
    name: name,
    branch: branch,
    path: path,
    repoId: repoId,
    existsOnDisk: existsOnDisk,
    sessionCount: sessionCount,
  );
  if (lastActiveSeconds != null) {
    wt.lastActive = Timestamp(seconds: Int64(lastActiveSeconds));
  }
  return wt;
}

GitRepoDetail _makeRepo({
  String id = 'repo-1',
  String name = 'my-project',
  String repoPath = '/home/user/projects/my-project',
  WorktreeMode worktreeMode = WorktreeMode.WORKTREE_MODE_GLOBAL,
  int worktreeCount = 3,
}) {
  return GitRepoDetail(
    id: id,
    name: name,
    repoPath: repoPath,
    worktreeMode: worktreeMode,
    worktreeCount: worktreeCount,
  );
}

/// A notifier that returns a canned async value without gRPC calls.
class _FakeWorktreesNotifier extends WorktreesNotifier {
  _FakeWorktreesNotifier(this._value);

  final AsyncValue<List<WorktreeDetail>> _value;

  @override
  Future<List<WorktreeDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () =>
          Completer<List<WorktreeDetail>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

/// A notifier that returns a canned async value without gRPC calls.
class _FakeGitReposNotifier extends GitReposNotifier {
  _FakeGitReposNotifier(this._value);

  final AsyncValue<List<GitRepoDetail>> _value;

  @override
  Future<List<GitRepoDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () =>
          Completer<List<GitRepoDetail>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

/// Shorthand for a ProviderScope wrapping [child] with gitReposProvider
/// overridden to return canned data.
ProviderScope _withRepos(Widget child, [List<GitRepoDetail>? repos]) {
  return ProviderScope(
    overrides: [
      gitReposProvider.overrideWith(
        () => _FakeGitReposNotifier(
          AsyncData(
            repos ??
                [
                  _makeRepo(),
                  _makeRepo(id: 'repo-2', name: 'other-project'),
                ],
          ),
        ),
      ),
    ],
    child: child,
  );
}

/// Wraps [WorktreesScreen] with a fake worktrees provider.
Widget _worktreesApp(AsyncValue<List<WorktreeDetail>> value) {
  return ProviderScope(
    overrides: [
      worktreesProvider.overrideWith(() => _FakeWorktreesNotifier(value)),
    ],
    child: _app(const WorktreesScreen()),
  );
}

// ---------------------------------------------------------------------------
// WorktreesScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('WorktreesScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(_worktreesApp(const AsyncLoading()));
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Worktrees'), findsOneWidget);
    });

    testWidgets('displays list of WorktreeCard widgets when data arrives', (
      t,
    ) async {
      final worktrees = [
        _makeWorktree(id: 'wt-1', name: 'feat-login'),
        _makeWorktree(id: 'wt-2', name: 'feat-auth'),
        _makeWorktree(id: 'wt-3', name: 'fix-bug'),
      ];

      await t.pumpWidget(_worktreesApp(AsyncData(worktrees)));
      await t.pumpAndSettle();

      expect(find.byType(WorktreeCard), findsNWidgets(3));
      expect(find.text('feat-login'), findsOneWidget);
      expect(find.text('feat-auth'), findsOneWidget);
      expect(find.text('fix-bug'), findsOneWidget);
    });

    testWidgets('shows empty state when no worktrees exist', (t) async {
      await t.pumpWidget(_worktreesApp(const AsyncData([])));
      await t.pumpAndSettle();

      expect(find.text('No worktrees'), findsOneWidget);
      expect(find.byIcon(Icons.account_tree_outlined), findsOneWidget);
      expect(find.byType(WorktreeCard), findsNothing);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        _worktreesApp(
          AsyncError(Exception('connection refused'), StackTrace.empty),
        ),
      );
      await t.pumpAndSettle();

      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('has a FloatingActionButton for creating worktrees', (t) async {
      await t.pumpWidget(_worktreesApp(const AsyncData([])));
      await t.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // WorktreeCard tests
  // ---------------------------------------------------------------------------

  group('WorktreeCard', () {
    /// Pumps a [WorktreeCard] with the given worktree and settles.
    Future<void> pumpCard(
      WidgetTester t,
      WorktreeDetail worktree, {
      VoidCallback? onDelete,
    }) async {
      await t.pumpWidget(
        _app(WorktreeCard(worktree: worktree, onDelete: onDelete ?? () {})),
      );
      await t.pumpAndSettle();
    }

    testWidgets('displays worktree name', (t) async {
      await pumpCard(t, _makeWorktree(name: 'feat-payments'));
      expect(find.text('feat-payments'), findsOneWidget);
    });

    testWidgets('displays branch name with git branch icon', (t) async {
      await pumpCard(t, _makeWorktree(branch: 'feat/payments'));
      expect(find.text('feat/payments'), findsOneWidget);
    });

    testWidgets('displays path', (t) async {
      await pumpCard(
        t,
        _makeWorktree(path: '/home/user/worktrees/feat-pay'),
      );
      expect(find.text('/home/user/worktrees/feat-pay'), findsOneWidget);
    });

    testWidgets('shows green check when existsOnDisk is true', (t) async {
      await pumpCard(t, _makeWorktree(existsOnDisk: true));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows red X when existsOnDisk is false', (t) async {
      await pumpCard(t, _makeWorktree(existsOnDisk: false));
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('displays session count', (t) async {
      await pumpCard(t, _makeWorktree(sessionCount: 7));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('has a delete icon button', (t) async {
      var deleted = false;
      await pumpCard(
        t,
        _makeWorktree(),
        onDelete: () => deleted = true,
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await t.tap(find.byIcon(Icons.delete_outline));
      await t.pumpAndSettle();

      expect(deleted, isTrue);
    });

    testWidgets('renders card widget', (t) async {
      await pumpCard(t, _makeWorktree());
      expect(find.byType(Card), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // CreateWorktreeDialog tests
  // ---------------------------------------------------------------------------

  group('CreateWorktreeDialog', () {
    /// Pumps the dialog directly (not via showDialog).
    Future<void> pumpDialog(WidgetTester t, [List<GitRepoDetail>? repos]) async {
      await t.pumpWidget(
        _withRepos(_app(const Scaffold(body: CreateWorktreeDialog())), repos),
      );
      await t.pumpAndSettle();
    }

    testWidgets('has required form fields', (t) async {
      await pumpDialog(t);

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Repository'), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Setup Script'), findsOneWidget);
    });

    testWidgets('has Cancel and Create buttons', (t) async {
      await pumpDialog(t);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('returns null when Cancel is pressed', (t) async {
      Object? result = 'sentinel';

      await t.pumpWidget(
        _withRepos(
          _app(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<CreateWorktreeResult>(
                      context: context,
                      builder: (_) => const CreateWorktreeDialog(),
                    );
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

    testWidgets('returns form values when Create is pressed', (t) async {
      CreateWorktreeResult? result;

      final repos = [
        _makeRepo(id: 'repo-1', name: 'my-project'),
        _makeRepo(id: 'repo-2', name: 'other-project'),
      ];

      await t.pumpWidget(
        _withRepos(
          _app(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<CreateWorktreeResult>(
                      context: context,
                      builder: (_) => const CreateWorktreeDialog(),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          repos,
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      // Fill in the Name field.
      await t.enterText(
        find.widgetWithText(TextFormField, 'Name'),
        'feat-login',
      );

      // Select a repo from the dropdown.
      await t.tap(find.text('Repository'));
      await t.pumpAndSettle();
      await t.tap(find.text('my-project').last);
      await t.pumpAndSettle();

      // Fill in the Branch field.
      await t.enterText(
        find.widgetWithText(TextFormField, 'Branch'),
        'feat/login',
      );

      // Fill in the Setup Script field.
      await t.enterText(
        find.widgetWithText(TextFormField, 'Setup Script'),
        'npm install',
      );

      await t.tap(find.text('Create'));
      await t.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.name, 'feat-login');
      expect(result!.repoId, 'repo-1');
      expect(result!.branch, 'feat/login');
      expect(result!.setupScript, 'npm install');
    });

    testWidgets('does not submit if required fields are empty', (t) async {
      CreateWorktreeResult? result = const CreateWorktreeResult(
        name: 'sentinel',
        repoId: '',
        branch: '',
        setupScript: '',
      );

      await t.pumpWidget(
        _withRepos(
          _app(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    final r = await showDialog<CreateWorktreeResult>(
                      context: context,
                      builder: (_) => const CreateWorktreeDialog(),
                    );
                    if (r != null) result = r;
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

      // Press Create without filling in fields
      await t.tap(find.text('Create'));
      await t.pumpAndSettle();

      // Dialog should still be visible (validation failed)
      expect(find.text('Create'), findsOneWidget);
      // result should not have been updated
      expect(result!.name, 'sentinel');
    });
  });
}
