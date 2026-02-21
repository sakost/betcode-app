import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of pipelines fetched from the daemon via gRPC.
///
/// On [build], fetches all pipelines and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Uses [grpcListBuild] which watches connection status and selected machine.
class PipelinesNotifier extends AsyncNotifier<List<PipelineInfo>> {
  @override
  Future<List<PipelineInfo>> build() => grpcListBuild(ref, _fetchPipelines);

  Future<List<PipelineInfo>> _fetchPipelines() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listPipelines(ListPipelinesRequest())
        .timeout(grpcRpcTimeout);
    return response.pipelines.toList();
  }

  /// Re-fetches pipelines from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPipelines);
  }

  /// Fetches a single pipeline by project and pipeline ID.
  Future<PipelineInfo> getPipeline({
    required String project,
    required Int64 pipelineId,
  }) async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .getPipeline(
          GetPipelineRequest(project: project, pipelineId: pipelineId),
        )
        .timeout(grpcRpcTimeout);
    return response.pipeline;
  }
}
