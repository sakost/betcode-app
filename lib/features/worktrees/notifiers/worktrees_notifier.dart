import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/worktree.pb.dart';

/// Manages the list of worktrees fetched from the daemon via gRPC.
///
/// On [build], fetches all worktrees and returns them. Callers can
/// pull-to-refresh via [refresh], create new worktrees, or remove existing
/// ones.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class WorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  Future<List<WorktreeDetail>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchWorktrees();
  }

  Future<List<WorktreeDetail>> _fetchWorktrees() async {
    final client = ref.read(worktreeServiceProvider);
    final response = await client
        .listWorktrees(ListWorktreesRequest())
        .timeout(_rpcTimeout);
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
    await client
        .createWorktree(
          CreateWorktreeRequest(
            name: name,
            repoPath: repoPath,
            branch: branch,
            setupScript: setupScript ?? '',
          ),
        )
        .timeout(_mutationTimeout);
    await refresh();
  }

  /// Removes a worktree by ID via gRPC and refreshes the list.
  Future<void> removeWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    await client
        .removeWorktree(RemoveWorktreeRequest(id: id))
        .timeout(_mutationTimeout);
    await refresh();
  }
}
