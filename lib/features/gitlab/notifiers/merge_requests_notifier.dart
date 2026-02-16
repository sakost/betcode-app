import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
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
    state = await AsyncValue.guard(_fetchMergeRequests);
  }

  /// Fetches a single merge request by project and IID.
  Future<MergeRequestInfo> getMergeRequest({
    required String project,
    required Int64 iid,
  }) async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .getMergeRequest(GetMergeRequestRequest(project: project, iid: iid))
        .timeout(_rpcTimeout);
    return response.mergeRequest;
  }
}
