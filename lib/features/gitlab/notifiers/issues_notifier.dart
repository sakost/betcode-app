import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of issues fetched from the daemon via gRPC.
///
/// On [build], fetches all issues and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Uses [grpcListBuild] which watches connection status and selected machine.
class IssuesNotifier extends AsyncNotifier<List<IssueInfo>> {
  @override
  Future<List<IssueInfo>> build() => grpcListBuild(ref, _fetchIssues);

  Future<List<IssueInfo>> _fetchIssues() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listIssues(ListIssuesRequest())
        .timeout(grpcRpcTimeout);
    return response.issues.toList();
  }

  /// Re-fetches issues from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchIssues);
  }

  /// Fetches a single issue by project and IID.
  Future<IssueInfo> getIssue({
    required String project,
    required Int64 iid,
  }) async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .getIssue(GetIssueRequest(project: project, iid: iid))
        .timeout(grpcRpcTimeout);
    return response.issue;
  }
}
