import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/worktree.pb.dart';

/// Manages the list of worktrees fetched from the daemon via gRPC.
///
/// On [build], fetches all worktrees and returns them. Callers can
/// pull-to-refresh via [refresh], create new worktrees, or remove existing
/// ones.
class WorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  @override
  Future<List<WorktreeDetail>> build() async => _fetchWorktrees();

  Future<List<WorktreeDetail>> _fetchWorktrees() async {
    final client = ref.read(worktreeServiceProvider);
    final response = await client.listWorktrees(ListWorktreesRequest());
    return response.worktrees.toList();
  }

  /// Re-fetches worktrees from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWorktrees());
  }

  /// Creates a new worktree via gRPC and refreshes the list.
  Future<void> createWorktree({
    required String name,
    required String repoPath,
    required String branch,
    String? setupScript,
  }) async {
    final client = ref.read(worktreeServiceProvider);
    await client.createWorktree(CreateWorktreeRequest(
      name: name,
      repoPath: repoPath,
      branch: branch,
      setupScript: setupScript ?? '',
    ));
    await refresh();
  }

  /// Removes a worktree by ID via gRPC and refreshes the list.
  Future<void> removeWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    await client.removeWorktree(RemoveWorktreeRequest(id: id));
    await refresh();
  }
}
