import 'package:betcode_app/features/git_repos/git_repos.dart'
    show RepoWorktreesNotifier;

import 'package:betcode_app/features/git_repos/notifiers/notifiers.dart'
    show RepoWorktreesNotifier;

import 'package:betcode_app/features/git_repos/notifiers/repo_worktrees_provider.dart'
    show RepoWorktreesNotifier;

import 'package:betcode_app/features/worktrees/notifiers/notifiers.dart'
    show WorktreesNotifier;

import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart'
    show WorktreesNotifier;

import 'package:betcode_app/features/worktrees/worktrees.dart'
    show WorktreesNotifier;

import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';

/// Shared helper for creating a worktree via gRPC.
///
/// Both [RepoWorktreesNotifier] and [WorktreesNotifier] need to make the same
/// `createWorktree` RPC call. This function extracts that common logic so each
/// notifier can call it and then refresh its own state independently.
Future<WorktreeDetail> createWorktreeRpc(
  WorktreeServiceClient client, {
  required String name,
  required String repoId,
  required String branch,
  String? setupScript,
}) {
  return client.createWorktree(
    CreateWorktreeRequest(
      name: name,
      repoId: repoId,
      branch: branch,
      setupScript: setupScript ?? '',
    ),
  );
}
