import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of merge requests fetched from the daemon via gRPC.
///
/// On [build], fetches all merge requests and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class MergeRequestsNotifier extends AsyncNotifier<List<MergeRequestInfo>> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<List<MergeRequestInfo>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchMergeRequests();
  }

  Future<List<MergeRequestInfo>> _fetchMergeRequests() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listMergeRequests(ListMergeRequestsRequest())
        .timeout(_rpcTimeout);
    return response.mergeRequests.toList();
  }

  /// Re-fetches merge requests from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMergeRequests());
  }
}
