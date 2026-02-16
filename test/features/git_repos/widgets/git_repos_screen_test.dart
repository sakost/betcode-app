import 'package:betcode_app/features/git_repos/screens/git_repos_screen.dart';
import 'package:betcode_app/features/git_repos/widgets/git_repo_card.dart';
import 'package:betcode_app/features/git_repos/widgets/register_repo_dialog.dart';
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

// ---------------------------------------------------------------------------
// GitReposScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('GitReposScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(
        withFakeRepos(_app(const GitReposScreen()), const AsyncLoading()),
      );
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Repositories'), findsOneWidget);
    });

    testWidgets('displays list of GitRepoCard widgets when data arrives', (
      t,
    ) async {
      final repos = [
        makeTestRepo(id: 'r-1', name: 'alpha'),
        makeTestRepo(id: 'r-2', name: 'beta'),
        makeTestRepo(id: 'r-3', name: 'gamma'),
      ];

      await t.pumpWidget(
        withFakeRepos(_app(const GitReposScreen()), AsyncData(repos)),
      );
      await t.pumpAndSettle();

      expect(find.byType(GitRepoCard), findsNWidgets(3));
      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('beta'), findsOneWidget);
      expect(find.text('gamma'), findsOneWidget);
    });

    testWidgets('shows empty state when no repos exist', (t) async {
      await t.pumpWidget(
        withFakeRepos(_app(const GitReposScreen()), const AsyncData([])),
      );
      await t.pumpAndSettle();

      expect(find.text('No repositories'), findsOneWidget);
      expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
      expect(find.byType(GitRepoCard), findsNothing);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        withFakeRepos(
          _app(const GitReposScreen()),
          AsyncError(Exception('connection refused'), StackTrace.empty),
        ),
      );
      await t.pumpAndSettle();

      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('has FAB for registering repos', (t) async {
      await t.pumpWidget(
        withFakeRepos(_app(const GitReposScreen()), const AsyncData([])),
      );
      await t.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // GitRepoCard tests
  // ---------------------------------------------------------------------------

  group('GitRepoCard', () {
    testWidgets('displays repo name', (t) async {
      await t.pumpWidget(
        _app(
          GitRepoCard(
            repo: makeTestRepo(name: 'payments'),
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('payments'), findsOneWidget);
    });

    testWidgets('displays repo path', (t) async {
      await t.pumpWidget(
        _app(
          GitRepoCard(
            repo: makeTestRepo(repoPath: '/home/user/code/my-app'),
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('/home/user/code/my-app'), findsOneWidget);
    });

    testWidgets('displays worktree count', (t) async {
      await t.pumpWidget(
        _app(
          GitRepoCard(repo: makeTestRepo(worktreeCount: 7), onDelete: () {}),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('displays worktree mode badge', (t) async {
      await t.pumpWidget(
        _app(
          GitRepoCard(
            repo: makeTestRepo(),
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Global'), findsOneWidget);
    });

    testWidgets('has delete icon button', (t) async {
      var deleted = false;
      await t.pumpWidget(
        _app(GitRepoCard(repo: makeTestRepo(), onDelete: () => deleted = true)),
      );
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await t.tap(find.byIcon(Icons.delete_outline));
      await t.pumpAndSettle();

      expect(deleted, isTrue);
    });

    testWidgets('renders card widget', (t) async {
      await t.pumpWidget(
        _app(GitRepoCard(repo: makeTestRepo(), onDelete: () {})),
      );
      await t.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('invokes onTap when card body is tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(
          GitRepoCard(
            repo: makeTestRepo(name: 'tap-target'),
            onTap: () => tapped = true,
            onDelete: () {},
          ),
        ),
      );
      await t.pumpAndSettle();

      // Tap on the repo name text which is inside the InkWell
      await t.tap(find.text('tap-target'));
      await t.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // RegisterRepoDialog tests
  // ---------------------------------------------------------------------------

  group('RegisterRepoDialog', () {
    testWidgets('has required form fields', (t) async {
      await t.pumpWidget(_app(const Scaffold(body: RegisterRepoDialog())));
      await t.pumpAndSettle();

      expect(find.text('Repository Path'), findsOneWidget);
      expect(find.text('Display Name (optional)'), findsOneWidget);
      expect(find.text('Worktree Mode'), findsOneWidget);
      expect(find.text('Setup Script (optional)'), findsOneWidget);
    });

    testWidgets('has Cancel and Register buttons', (t) async {
      await t.pumpWidget(_app(const Scaffold(body: RegisterRepoDialog())));
      await t.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });
  });
}
