import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/git_repos/notifiers/git_repos_notifier.dart';
import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/features/git_repos/notifiers/repo_worktrees_provider.dart';
import 'package:betcode_app/features/git_repos/screens/repo_detail_screen.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

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

class _FakeGitReposNotifier extends GitReposNotifier {
  _FakeGitReposNotifier(this._value);

  final AsyncValue<List<GitRepoDetail>> _value;

  @override
  Future<List<GitRepoDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<GitRepoDetail>>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

class _FakeRepoWorktreesNotifier extends RepoWorktreesNotifier {
  _FakeRepoWorktreesNotifier(this._value);

  final AsyncValue<List<WorktreeDetail>> _value;

  @override
  Future<List<WorktreeDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<WorktreeDetail>>().future,
      error: (e, st) => Future.error(e, st),
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
      gitReposProvider.overrideWith(() => _FakeGitReposNotifier(repos)),
      repoWorktreesProvider(repoId).overrideWith(
        () => _FakeRepoWorktreesNotifier(worktrees),
      ),
    ],
    child: child,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RepoDetailScreen - tabs', () {
    testWidgets('shows 4 tabs in the AppBar', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Worktrees'), findsOneWidget);
      expect(find.text('Pipelines'), findsOneWidget);
      expect(find.text('Merge Requests'), findsOneWidget);
      expect(find.text('Issues'), findsOneWidget);
    });

    testWidgets('shows Worktrees tab content by default', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      // Empty worktrees state should be visible by default
      expect(find.text('No worktrees'), findsOneWidget);
    });

    testWidgets('Pipelines tab shows placeholder', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      // Tap Pipelines tab
      await t.tap(find.text('Pipelines'));
      await t.pumpAndSettle();

      expect(find.text('Pipelines coming soon'), findsOneWidget);
    });

    testWidgets('Merge Requests tab shows placeholder', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();

      expect(find.text('Merge Requests coming soon'), findsOneWidget);
    });

    testWidgets('Issues tab shows placeholder', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();

      expect(find.text('Issues coming soon'), findsOneWidget);
    });
  });

  group('RepoDetailScreen - worktrees tab', () {
    testWidgets('shows loading indicator while fetching worktrees', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncLoading(),
        ),
      );
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows repo name in app bar', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo(name: 'payments-api')]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('payments-api'), findsOneWidget);
    });

    testWidgets('shows empty state when no worktrees exist', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('No worktrees'), findsOneWidget);
      // The icon appears in both the tab and the empty state
      expect(find.byIcon(Icons.account_tree_outlined), findsWidgets);
    });

    testWidgets('displays worktree cards when data arrives', (t) async {
      final worktrees = [
        _makeWorktree(id: 'wt-1', name: 'feature-a', branch: 'feat/a'),
        _makeWorktree(id: 'wt-2', name: 'feature-b', branch: 'feat/b'),
      ];

      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: AsyncData(worktrees),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('feature-a'), findsOneWidget);
      expect(find.text('feature-b'), findsOneWidget);
      expect(find.text('feat/a'), findsOneWidget);
      expect(find.text('feat/b'), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
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
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: AsyncData([
            _makeWorktree(
              branch: 'main',
              path: '/home/user/worktrees/main',
            ),
          ]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('main'), findsOneWidget);
      expect(find.text('/home/user/worktrees/main'), findsOneWidget);
    });

    testWidgets('worktree card shows session count', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: AsyncData([_makeWorktree(sessionCount: 5)]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('worktree card shows disk status icon', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: AsyncData([_makeWorktree(existsOnDisk: true)]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('worktree card shows Start Conversation button', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: AsyncData([_makeWorktree()]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Start Conversation'), findsOneWidget);
      expect(find.byIcon(Icons.chat_outlined), findsOneWidget);
    });

    testWidgets('has FAB for creating worktrees', (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([_makeRepo()]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('falls back to path-derived name when repo name is empty',
        (t) async {
      await t.pumpWidget(
        _withProviders(
          _app(const RepoDetailScreen(repoId: 'repo-1')),
          repos: AsyncData([
            _makeRepo(
              name: '',
              repoPath: '/home/user/projects/awesome-tool',
            ),
          ]),
          worktrees: const AsyncData([]),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('awesome-tool'), findsOneWidget);
    });
  });
}
