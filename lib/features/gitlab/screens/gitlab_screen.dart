import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import '../../../shared/widgets/async_list_scaffold.dart';
import '../notifiers/gitlab_providers.dart';
import '../widgets/issue_card.dart';
import '../widgets/merge_request_card.dart';
import '../widgets/pipeline_card.dart';

class GitLabScreen extends ConsumerWidget {
  const GitLabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GitLab'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pipelines'),
              Tab(text: 'Merge Requests'),
              Tab(text: 'Issues'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_PipelinesTab(), _MergeRequestsTab(), _IssuesTab()],
        ),
      ),
    );
  }
}

class _PipelinesTab extends ConsumerWidget {
  const _PipelinesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipelinesAsync = ref.watch(pipelinesProvider);

    return AsyncListScaffold<PipelineInfo>(
      asyncValue: pipelinesAsync,
      onRefresh: () => ref.read(pipelinesProvider.notifier).refresh(),
      emptyIcon: Icons.rocket_launch_outlined,
      emptyTitle: 'No pipelines',
      itemBuilder: (context, pipeline) => PipelineCard(pipeline: pipeline),
    );
  }
}

class _MergeRequestsTab extends ConsumerWidget {
  const _MergeRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mergeRequestsAsync = ref.watch(mergeRequestsProvider);

    return AsyncListScaffold<MergeRequestInfo>(
      asyncValue: mergeRequestsAsync,
      onRefresh: () => ref.read(mergeRequestsProvider.notifier).refresh(),
      emptyIcon: Icons.call_merge_outlined,
      emptyTitle: 'No merge requests',
      itemBuilder: (context, mergeRequest) =>
          MergeRequestCard(mergeRequest: mergeRequest),
    );
  }
}

class _IssuesTab extends ConsumerWidget {
  const _IssuesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider);

    return AsyncListScaffold<IssueInfo>(
      asyncValue: issuesAsync,
      onRefresh: () => ref.read(issuesProvider.notifier).refresh(),
      emptyIcon: Icons.bug_report_outlined,
      emptyTitle: 'No issues',
      itemBuilder: (context, issue) => IssueCard(issue: issue),
    );
  }
}
