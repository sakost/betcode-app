import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/grpc/worktree_helpers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [WorktreeDetail] objects for a specific repo.
///
/// Fetches worktrees filtered by `repoId` from the daemon via gRPC.
// ignore: specify_nonobvious_property_types, the family provider type is not publicly exported
final repoWorktreesProvider =
    AsyncNotifierProvider.family<
      RepoWorktreesNotifier,
      List<WorktreeDetail>,
      String
    >((repoId) {
      final notifier = RepoWorktreesNotifier()..repoId = repoId;
      return notifier;
    });

class RepoWorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  static const _rpcTimeout = Duration(seconds: 10);

  late String repoId;

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
        .listWorktrees(ListWorktreesRequest(repoId: repoId))
        .timeout(_rpcTimeout);
    return response.worktrees.toList();
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
    ).timeout(_rpcTimeout);
    await refresh();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetchWorktrees);
    ref.invalidate(worktreesProvider);
  }
}
