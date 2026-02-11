import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of issues fetched from the daemon via gRPC.
///
/// On [build], fetches all issues and returns them. Callers can
/// pull-to-refresh via [refresh].
class IssuesNotifier extends AsyncNotifier<List<IssueInfo>> {
  @override
  Future<List<IssueInfo>> build() async {
    return _fetchIssues();
  }

  Future<List<IssueInfo>> _fetchIssues() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client.listIssues(ListIssuesRequest());
    return response.issues.toList();
  }

  /// Re-fetches issues from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchIssues());
  }
}
