import 'dart:async';

import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/features/git_repos/screens/repo_detail_screen.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/git_repo_test_helpers.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

WorktreeDetail _makeWorktree({
  String id = 'wt-1',
  String name = 'feature-branch',
  String path = '/home/user/worktrees/feature-branch',
  String branch = 'feature/new-thing',
  String repoId = 'repo-1',
  bool existsOnDisk = true,
  int sessionCount = 2,
}) {
  return WorktreeDetail(
    id: id,
    name: name,
    path: path,
    branch: branch,
    repoId: repoId,
    existsOnDisk: existsOnDisk,
    sessionCount: sessionCount,
  );
}

class _FakeRepoWorktreesNotifier extends WorktreesNotifier {
  _FakeRepoWorktreesNotifier(this._value);

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

ProviderScope _withProviders(
  Widget child, {
  required AsyncValue<List<GitRepoDetail>> repos,
  required AsyncValue<List<WorktreeDetail>> worktrees,
  String repoId = 'repo-1',
}) {
  return ProviderScope(
    overrides: [
      gitReposProvider.overrideWith(() => FakeGitReposNotifier(repos)),
      repoWorktreesProvider(
        repoId,
      ).overrideWith(() => _FakeRepoWorktreesNotifier(worktrees)),
    ],
    child: child,
  );
}

/// Shorthand to pump [RepoDetailScreen] with default repo and worktrees.
Widget _repoDetailApp({
  GitRepoDetail? repo,
  AsyncValue<List<WorktreeDetail>> worktrees = const AsyncData([]),
  String repoId = 'repo-1',
}) {
  return _withProviders(
    _app(RepoDetailScreen(repoId: repoId)),
    repos: AsyncData([repo ?? makeTestRepo()]),
    worktrees: worktrees,
    repoId: repoId,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RepoDetailScreen - tabs', () {
    testWidgets('shows 4 tabs in the AppBar', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Worktrees'), findsOneWidget);
      expect(find.text('Pipelines'), findsOneWidget);
      expect(find.text('Merge Requests'), findsOneWidget);
      expect(find.text('Issues'), findsOneWidget);
    });

    testWidgets('shows Worktrees tab content by default', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      expect(find.text('No worktrees'), findsOneWidget);
    });

    testWidgets('Pipelines tab shows placeholder', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      await t.tap(find.text('Pipelines'));
      await t.pumpAndSettle();

      expect(find.text('Pipelines coming soon'), findsOneWidget);
    });

    testWidgets('Merge Requests tab shows placeholder', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();

      expect(find.text('Merge Requests coming soon'), findsOneWidget);
    });

    testWidgets('Issues tab shows placeholder', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();

      expect(find.text('Issues coming soon'), findsOneWidget);
    });
  });

  group('RepoDetailScreen - worktrees tab', () {
    testWidgets('shows loading indicator while fetching worktrees', (t) async {
      await t.pumpWidget(_repoDetailApp(worktrees: const AsyncLoading()));
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows repo name in app bar', (t) async {
      await t.pumpWidget(
        _repoDetailApp(repo: makeTestRepo(name: 'payments-api')),
      );
      await t.pumpAndSettle();

      expect(find.text('payments-api'), findsOneWidget);
    });

    testWidgets('shows empty state when no worktrees exist', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      expect(find.text('No worktrees'), findsOneWidget);
      expect(find.byIcon(Icons.account_tree_outlined), findsWidgets);
    });

    testWidgets('displays worktree cards when data arrives', (t) async {
      final worktrees = [
        _makeWorktree(name: 'feature-a', branch: 'feat/a'),
        _makeWorktree(id: 'wt-2', name: 'feature-b', branch: 'feat/b'),
      ];

      await t.pumpWidget(_repoDetailApp(worktrees: AsyncData(worktrees)));
      await t.pumpAndSettle();

      expect(find.text('feature-a'), findsOneWidget);
      expect(find.text('feature-b'), findsOneWidget);
      expect(find.text('feat/a'), findsOneWidget);
      expect(find.text('feat/b'), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        _repoDetailApp(
          worktrees: AsyncError(
            Exception('connection refused'),
            StackTrace.empty,
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('worktree card shows branch and path', (t) async {
      await t.pumpWidget(
        _repoDetailApp(
          worktrees: AsyncData([
            _makeWorktree(branch: 'main', path: '/home/user/worktrees/main'),
          ]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('main'), findsOneWidget);
      expect(find.text('/home/user/worktrees/main'), findsOneWidget);
    });

    testWidgets('worktree card shows session count', (t) async {
      await t.pumpWidget(
        _repoDetailApp(worktrees: AsyncData([_makeWorktree(sessionCount: 5)])),
      );
      await t.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('worktree card shows disk status icon', (t) async {
      await t.pumpWidget(
        _repoDetailApp(
          worktrees: AsyncData([_makeWorktree()]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('worktree card shows Start Conversation button', (t) async {
      await t.pumpWidget(
        _repoDetailApp(worktrees: AsyncData([_makeWorktree()])),
      );
      await t.pumpAndSettle();

      expect(find.text('Start Conversation'), findsOneWidget);
      expect(find.byIcon(Icons.chat_outlined), findsOneWidget);
    });

    testWidgets('has FAB for creating worktrees', (t) async {
      await t.pumpWidget(_repoDetailApp());
      await t.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('falls back to path-derived name when repo name is empty', (
      t,
    ) async {
      await t.pumpWidget(
        _repoDetailApp(
          repo: makeTestRepo(
            name: '',
            repoPath: '/home/user/projects/awesome-tool',
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('awesome-tool'), findsOneWidget);
    });
  });
}
