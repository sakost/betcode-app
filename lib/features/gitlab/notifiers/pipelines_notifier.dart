import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of pipelines fetched from the daemon via gRPC.
///
/// On [build], fetches all pipelines and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class PipelinesNotifier extends AsyncNotifier<List<PipelineInfo>> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<List<PipelineInfo>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchPipelines();
  }

  Future<List<PipelineInfo>> _fetchPipelines() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listPipelines(ListPipelinesRequest())
        .timeout(_rpcTimeout);
    return response.pipelines.toList();
  }

  /// Re-fetches pipelines from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPipelines());
  }

  /// Fetches a single pipeline by project and pipeline ID.
  Future<PipelineInfo> getPipeline({
    required String project,
    required Int64 pipelineId,
  }) async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .getPipeline(GetPipelineRequest(project: project, pipelineId: pipelineId))
        .timeout(_rpcTimeout);
    return response.pipeline;
  }
}
