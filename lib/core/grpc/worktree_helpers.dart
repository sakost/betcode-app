import '../../generated/betcode/v1/worktree.pb.dart';
import '../../generated/betcode/v1/worktree.pbgrpc.dart';

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
