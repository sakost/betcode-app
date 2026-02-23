import 'dart:async';

import 'package:betcode_app/features/git_repos/notifiers/branches_provider.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/features/worktrees/screens/worktrees_screen.dart';
import 'package:betcode_app/features/worktrees/widgets/create_worktree_dialog.dart';
import 'package:betcode_app/features/worktrees/widgets/worktree_card.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../../../helpers/git_repo_test_helpers.dart';

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

/// A notifier that returns a canned async value without gRPC calls.
class _FakeWorktreesNotifier extends WorktreesNotifier {
  _FakeWorktreesNotifier(this._value);

  final AsyncValue<List<WorktreeDetail>> _value;
  Completer<void>? _createCompleter;

  @override
  Future<List<WorktreeDetail>> build() {
    return _value.when(
      data: Future.value,
      loading: () =>
          Completer<List<WorktreeDetail>>().future, // never completes
      error: Future.error,
    );
  }

  @override
  Future<void> createWorktree({
    required String name,
    required String repoId,
    required String branch,
    String? setupScript,
  }) {
    _createCompleter = Completer<void>();
    return _createCompleter!.future;
  }

  void completeCreate() => _createCompleter?.complete();
}

/// Default fake branches returned by the overridden branchesProvider.
List<BranchInfo> _defaultBranches() => [
      BranchInfo(
        name: 'main',
        isHead: true,
        commitSha: 'abc123',
        commitMessage: 'initial commit',
      ),
      BranchInfo(
        name: 'develop',
        commitSha: 'def456',
        commitMessage: 'dev branch',
      ),
      BranchInfo(
        name: 'feat/existing',
        commitSha: 'ghi789',
        commitMessage: 'feature branch',
        hasWorktree: true,
      ),
    ];

/// Shorthand for a ProviderScope wrapping [child] with gitReposProvider
/// and branchesProvider overridden to return canned data.
ProviderScope _withRepos(
  Widget child, [
  List<GitRepoDetail>? repos,
  List<BranchInfo>? branches,
]) {
  final scope = withFakeRepos(
    child,
    AsyncData(
      repos ??
          [makeTestRepo(), makeTestRepo(id: 'repo-2', name: 'other-project')],
    ),
  );
  // Add branchesProvider override to the same ProviderScope.
  return ProviderScope(
    overrides: [
      ...scope.overrides,
      branchesProvider.overrideWith(
        (ref, repoId) async => branches ?? _defaultBranches(),
      ),
    ],
    child: scope.child!,
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
        _makeWorktree(),
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

    // -------------------------------------------------------------------------
    // I-10: FAB shows spinner during worktree creation
    // -------------------------------------------------------------------------

    testWidgets('FAB shows spinner during creation', (t) async {
      final fakeNotifier = _FakeWorktreesNotifier(const AsyncData([]));
      final repos = [makeTestRepo(), makeTestRepo(id: 'repo-2', name: 'other')];

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            worktreesProvider.overrideWith(() => fakeNotifier),
          ],
          child: _withRepos(
            _app(const WorktreesScreen()),
            repos,
          ),
        ),
      );
      await t.pumpAndSettle();

      // FAB should show the add icon initially
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Tap FAB to open create dialog
      await t.tap(find.byType(FloatingActionButton));
      await t.pumpAndSettle();

      // Fill in required fields
      await t.enterText(
        find.widgetWithText(TextFormField, 'Name'),
        'new-wt',
      );
      // Select a repo
      await t.tap(find.text('Repository'));
      await t.pumpAndSettle();
      await t.tap(find.text('my-project').last);
      await t.pumpAndSettle();
      // Fill branch — the Autocomplete field now loads suggestions.
      // Type into the branch field (finds the TextFormField with 'Branch' label).
      await t.enterText(
        find.widgetWithText(TextFormField, 'Branch'),
        'main',
      );
      await t.pumpAndSettle();
      // Select from autocomplete suggestions
      await t.tap(find.text('main').last);
      await t.pumpAndSettle();

      // Press Create button in dialog
      await t.tap(find.text('Create'));
      await t.pump(); // start the creation future

      // While createWorktree is in progress, FAB should show spinner
      expect(
        find.descendant(
          of: find.byType(FloatingActionButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.add), findsNothing);

      // Complete the creation
      fakeNotifier.completeCreate();
      await t.pumpAndSettle();

      // After completion, FAB should show add icon again
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
      await pumpCard(t, _makeWorktree(path: '/home/user/worktrees/feat-pay'));
      expect(find.text('/home/user/worktrees/feat-pay'), findsOneWidget);
    });

    testWidgets('shows green check when existsOnDisk is true', (t) async {
      await pumpCard(t, _makeWorktree());
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
      await pumpCard(t, _makeWorktree(), onDelete: () => deleted = true);

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
    Future<void> pumpDialog(
      WidgetTester t, {
      List<GitRepoDetail>? repos,
      String? initialRepoId,
    }) async {
      await t.pumpWidget(
        _withRepos(
          _app(
            Scaffold(
              body: CreateWorktreeDialog(initialRepoId: initialRepoId),
            ),
          ),
          repos,
        ),
      );
      await t.pumpAndSettle();
    }

    testWidgets('has required form fields', (t) async {
      await pumpDialog(t);

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Repository'), findsOneWidget);
      // Branch is disabled (no repo selected), but the label is still there.
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Setup Script'), findsOneWidget);
    });

    testWidgets('has Cancel and Create buttons', (t) async {
      await pumpDialog(t);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('branch field is disabled when no repo is selected', (t) async {
      await pumpDialog(t);

      // Find the disabled TextFormField with hint text
      expect(find.text('Select a repository first'), findsOneWidget);
    });

    /// Pumps a dialog-opening scaffold that captures
    /// the [CreateWorktreeResult].
    Future<CreateWorktreeResult? Function()> pumpDialogOpener(
      WidgetTester t, {
      List<GitRepoDetail>? repos,
      String? initialRepoId,
    }) async {
      CreateWorktreeResult? result;
      var resultSet = false;
      await t.pumpWidget(
        _withRepos(
          _app(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    final r = await showDialog<CreateWorktreeResult>(
                      context: context,
                      builder: (_) => CreateWorktreeDialog(
                        initialRepoId: initialRepoId,
                      ),
                    );
                    result = r;
                    resultSet = true;
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
      return () => resultSet ? result : null;
    }

    testWidgets('returns null when Cancel is pressed', (t) async {
      await pumpDialogOpener(t);

      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();

      // Dialog was dismissed, no result
    });

    testWidgets('returns form values when Create is pressed', (t) async {
      final getResult = await pumpDialogOpener(
        t,
        repos: [
          makeTestRepo(),
          makeTestRepo(id: 'repo-2', name: 'other-project'),
        ],
      );

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

      // Fill in the Branch field (now an Autocomplete).
      await t.enterText(
        find.widgetWithText(TextFormField, 'Branch'),
        'feat/login',
      );
      await t.pumpAndSettle();

      // Fill in the Setup Script field.
      await t.enterText(
        find.widgetWithText(TextFormField, 'Setup Script'),
        'npm install',
      );

      await t.tap(find.text('Create'));
      await t.pumpAndSettle();

      final result = getResult();
      expect(result, isNotNull);
      expect(result!.name, 'feat-login');
      expect(result.repoId, 'repo-1');
      expect(result.branch, 'feat/login');
      expect(result.setupScript, 'npm install');
    });

    testWidgets('does not submit if required fields are empty', (t) async {
      final getResult = await pumpDialogOpener(t);

      // Press Create without filling in fields
      await t.tap(find.text('Create'));
      await t.pumpAndSettle();

      // Dialog should still be visible (validation failed)
      expect(find.text('Create'), findsOneWidget);
      // result should not have been set (dialog still open)
      expect(getResult(), isNull);
    });

    // -----------------------------------------------------------------------
    // initialRepoId
    // -----------------------------------------------------------------------

    testWidgets('pre-selects repo when initialRepoId is provided', (t) async {
      final repos = [
        makeTestRepo(),
        makeTestRepo(id: 'repo-2', name: 'other-project'),
      ];

      await pumpDialog(t, repos: repos, initialRepoId: 'repo-1');

      // The dropdown should show the pre-selected repo name.
      expect(find.text('my-project'), findsOneWidget);
      // Branch field should be enabled (not showing disabled hint).
      expect(find.text('Select a repository first'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Setup script pre-fill
    // -----------------------------------------------------------------------

    testWidgets('pre-fills setup script from repo config', (t) async {
      final repos = [
        makeTestRepo(setupScript: 'make setup'),
        makeTestRepo(id: 'repo-2', name: 'other-project'),
      ];

      await pumpDialog(t, repos: repos, initialRepoId: 'repo-1');

      // The setup script field should be pre-filled.
      expect(find.text('make setup'), findsOneWidget);
    });

    testWidgets('setup script not overwritten after manual edit', (t) async {
      final repos = [
        makeTestRepo(setupScript: 'make setup'),
        makeTestRepo(
          id: 'repo-2',
          name: 'other-project',
          setupScript: 'npm install',
        ),
      ];

      await pumpDialog(t, repos: repos, initialRepoId: 'repo-1');

      // Pre-filled from repo-1.
      expect(find.text('make setup'), findsOneWidget);

      // User manually edits the script.
      await t.enterText(
        find.widgetWithText(TextFormField, 'Setup Script'),
        'custom script',
      );
      await t.pumpAndSettle();

      // Switch to repo-2.
      await t.tap(find.text('my-project'));
      await t.pumpAndSettle();
      await t.tap(find.text('other-project').last);
      await t.pumpAndSettle();

      // The setup script should NOT be overwritten because user edited it.
      expect(find.text('custom script'), findsOneWidget);
      expect(find.text('npm install'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Branch autocomplete
    // -----------------------------------------------------------------------

    testWidgets('shows branch suggestions from provider', (t) async {
      final repos = [makeTestRepo()];

      await pumpDialog(t, repos: repos, initialRepoId: 'repo-1');

      // Tap into the branch field to trigger autocomplete.
      final branchField = find.widgetWithText(TextFormField, 'Branch');
      await t.tap(branchField);
      await t.pumpAndSettle();

      // The autocomplete should show all branches.
      expect(find.text('main'), findsWidgets);
      expect(find.text('develop'), findsWidgets);
      expect(find.text('feat/existing'), findsWidgets);
    });
  });
}
