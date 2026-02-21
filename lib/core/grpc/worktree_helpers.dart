import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';

/// Shared helper for creating a worktree via gRPC.
///
/// Used by `WorktreesNotifier` (both global and per-repo instances) to make
/// the `createWorktree` RPC call, then refresh state independently.
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
