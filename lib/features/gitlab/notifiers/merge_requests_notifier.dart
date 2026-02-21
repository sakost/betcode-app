import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of merge requests fetched from the daemon via gRPC.
///
/// On [build], fetches all merge requests and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Uses [grpcListBuild] which watches connection status and selected machine.
class MergeRequestsNotifier extends AsyncNotifier<List<MergeRequestInfo>> {
  @override
  Future<List<MergeRequestInfo>> build() =>
      grpcListBuild(ref, _fetchMergeRequests);

  Future<List<MergeRequestInfo>> _fetchMergeRequests() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listMergeRequests(ListMergeRequestsRequest())
        .timeout(grpcRpcTimeout);
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
        .timeout(grpcRpcTimeout);
    return response.mergeRequest;
  }
}
