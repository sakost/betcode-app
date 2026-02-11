import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import 'issues_notifier.dart';
import 'merge_requests_notifier.dart';
import 'pipelines_notifier.dart';

/// Provides the list of [PipelineInfo] objects fetched from the daemon.
///
/// Use `ref.watch(pipelinesProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final pipelinesProvider =
    AsyncNotifierProvider<PipelinesNotifier, List<PipelineInfo>>(
      PipelinesNotifier.new,
    );

/// Provides the list of [MergeRequestInfo] objects fetched from the daemon.
///
/// Use `ref.watch(mergeRequestsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final mergeRequestsProvider =
    AsyncNotifierProvider<MergeRequestsNotifier, List<MergeRequestInfo>>(
      MergeRequestsNotifier.new,
    );

/// Provides the list of [IssueInfo] objects fetched from the daemon.
///
/// Use `ref.watch(issuesProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final issuesProvider = AsyncNotifierProvider<IssuesNotifier, List<IssueInfo>>(
  IssuesNotifier.new,
);
