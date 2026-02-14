import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/worktree.pb.dart';

/// Provides the list of [WorktreeDetail] objects for a specific repo.
///
/// Fetches worktrees filtered by [repoId] from the daemon via gRPC.
final repoWorktreesProvider = AsyncNotifierProvider.family<
    RepoWorktreesNotifier, List<WorktreeDetail>, String>((repoId) {
  final notifier = RepoWorktreesNotifier();
  notifier.repoId = repoId;
  return notifier;
});

class RepoWorktreesNotifier extends AsyncNotifier<List<WorktreeDetail>> {
  static const _rpcTimeout = Duration(seconds: 10);

  late String repoId;

  @override
  Future<List<WorktreeDetail>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      // Stay in loading state until connected; the reactive watch on
      // connectionStatusProvider will rebuild this provider automatically
      // when the connection resumes.
      return Completer<List<WorktreeDetail>>().future;
    }
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
    await client
        .createWorktree(
          CreateWorktreeRequest(
            name: name,
            repoId: repoId,
            branch: branch,
            setupScript: setupScript ?? '',
          ),
        )
        .timeout(_rpcTimeout);
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWorktrees());
  }
}
