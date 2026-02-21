import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/grpc/worktree_helpers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of worktrees fetched from the daemon via gRPC.
///
/// On [build], fetches all worktrees and returns them. Callers can
/// pull-to-refresh via [refresh], create new worktrees, or remove existing
/// ones.
///
/// Uses [grpcListBuild] which watches connection status and selected machine,
/// so worktrees are re-fetched when either changes.
///
/// When [repoId] is set, filters worktrees by that repository.
class WorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  /// Optional repo ID to filter worktrees by. When null, lists all worktrees.
  String? repoId;

  @override
  Future<List<WorktreeDetail>> build() => grpcListBuild(ref, _fetchWorktrees);

  Future<List<WorktreeDetail>> _fetchWorktrees() async {
    final client = ref.read(worktreeServiceProvider);
    final response = await client
        .listWorktrees(ListWorktreesRequest(repoId: repoId ?? ''))
        .timeout(grpcRpcTimeout);
    return response.worktrees.toList();
  }

  /// Re-fetches worktrees from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchWorktrees);
  }

  /// Creates a new worktree via gRPC and refreshes the list.
  Future<void> createWorktree({
    required String name,
    required String repoId,
    required String branch,
    String? setupScript,
  }) async {
    final client = ref.read(worktreeServiceProvider);
    await createWorktreeRpc(
      client,
      name: name,
      repoId: repoId,
      branch: branch,
      setupScript: setupScript,
    ).timeout(grpcMutationTimeout);
    await refresh();
  }

  /// Fetches a single worktree by ID.
  Future<WorktreeDetail> getWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    return client
        .getWorktree(GetWorktreeRequest(id: id))
        .timeout(grpcRpcTimeout);
  }

  /// Removes a worktree by ID via gRPC and refreshes the list.
  Future<void> removeWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    await client
        .removeWorktree(RemoveWorktreeRequest(id: id))
        .timeout(grpcMutationTimeout);
    await refresh();
  }
}
