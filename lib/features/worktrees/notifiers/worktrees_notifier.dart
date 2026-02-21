import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/grpc/worktree_helpers.dart';
import 'package:betcode_app/features/git_repos/notifiers/repo_worktrees_provider.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of worktrees fetched from the daemon via gRPC.
///
/// On [build], fetches all worktrees and returns them. Callers can
/// pull-to-refresh via [refresh], create new worktrees, or remove existing
/// ones.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes. Also watches [selectedMachineIdProvider]
/// so worktrees are re-fetched when the active machine changes.
class WorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  Future<List<WorktreeDetail>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }

    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];

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
  ///
  /// Transitions directly from data→data without an intermediate loading state.
  /// The external `RefreshIndicator` handles the spinner; emitting
  /// [AsyncLoading] here would cause a visible flash/rebuild of the list.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetchWorktrees);
    ref.invalidate(repoWorktreesProvider);
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
    ).timeout(_mutationTimeout);
    await refresh();
  }

  /// Fetches a single worktree by ID.
  Future<WorktreeDetail> getWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    return client.getWorktree(GetWorktreeRequest(id: id)).timeout(_rpcTimeout);
  }

  /// Removes a worktree by ID via gRPC and refreshes the list.
  Future<void> removeWorktree(String id) async {
    final client = ref.read(worktreeServiceProvider);
    final response = await client
        .removeWorktree(RemoveWorktreeRequest(id: id))
        .timeout(_mutationTimeout);
    if (!response.removed) {
      throw StateError('Worktree "$id" could not be removed');
    }
    await refresh();
  }
}
