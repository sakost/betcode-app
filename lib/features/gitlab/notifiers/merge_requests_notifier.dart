import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of merge requests fetched from the daemon via gRPC.
///
/// On [build], fetches all merge requests and returns them. Callers can
/// pull-to-refresh via [refresh].
class MergeRequestsNotifier extends AsyncNotifier<List<MergeRequestInfo>> {
  @override
  Future<List<MergeRequestInfo>> build() async {
    return _fetchMergeRequests();
  }

  Future<List<MergeRequestInfo>> _fetchMergeRequests() async {
    final client = ref.read(gitlabServiceProvider);
    final response =
        await client.listMergeRequests(ListMergeRequestsRequest());
    return response.mergeRequests.toList();
  }

  /// Re-fetches merge requests from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMergeRequests());
  }
}
