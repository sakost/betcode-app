import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:betcode_app/features/git_repos/notifiers/git_repos_notifier.dart';
import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';

// ---------------------------------------------------------------------------
// Factory helpers
// ---------------------------------------------------------------------------

/// Creates a [GitRepoDetail] with sensible defaults for tests.
GitRepoDetail makeTestRepo({
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

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

/// A notifier that returns a canned async value without gRPC calls.
class FakeGitReposNotifier extends GitReposNotifier {
  FakeGitReposNotifier(this._value);

  final AsyncValue<List<GitRepoDetail>> _value;

  @override
  Future<List<GitRepoDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<GitRepoDetail>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

/// Wraps [child] in a [ProviderScope] with [gitReposProvider] overridden.
ProviderScope withFakeRepos(
  dynamic child,
  AsyncValue<List<GitRepoDetail>> value,
) {
  return ProviderScope(
    overrides: [
      gitReposProvider.overrideWith(() => FakeGitReposNotifier(value)),
    ],
    child: child,
  );
}
