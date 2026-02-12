import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/gitlab.pb.dart';

/// Manages the list of issues fetched from the daemon via gRPC.
///
/// On [build], fetches all issues and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class IssuesNotifier extends AsyncNotifier<List<IssueInfo>> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<List<IssueInfo>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchIssues();
  }

  Future<List<IssueInfo>> _fetchIssues() async {
    final client = ref.read(gitlabServiceProvider);
    final response = await client
        .listIssues(ListIssuesRequest())
        .timeout(_rpcTimeout);
    return response.issues.toList();
  }

  /// Re-fetches issues from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchIssues());
  }
}
