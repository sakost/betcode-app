import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of pipelines fetched from the daemon via gRPC.
///
/// On [build], fetches all pipelines and returns them. Callers can
/// pull-to-refresh via [refresh].
class PipelinesNotifier extends AsyncNotifier<List<PipelineInfo>> {
  @override
  Future<List<PipelineInfo>> build() async {
    return _fetchPipelines();
  }

  Future<List<PipelineInfo>> _fetchPipelines() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client.listPipelines(ListPipelinesRequest());
    return response.pipelines.toList();
  }

  /// Re-fetches pipelines from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPipelines());
  }
}
