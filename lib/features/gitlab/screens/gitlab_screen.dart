import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_display.dart';
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

    return pipelinesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: () => ref.read(pipelinesProvider.notifier).refresh(),
      ),
      data: (pipelines) {
        if (pipelines.isEmpty) {
          return const EmptyState(
            icon: Icons.rocket_launch_outlined,
            title: 'No pipelines',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(pipelinesProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pipelines.length,
            itemBuilder: (context, index) =>
                PipelineCard(pipeline: pipelines[index]),
          ),
        );
      },
    );
  }
}

class _MergeRequestsTab extends ConsumerWidget {
  const _MergeRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mergeRequestsAsync = ref.watch(mergeRequestsProvider);

    return mergeRequestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: () => ref.read(mergeRequestsProvider.notifier).refresh(),
      ),
      data: (mergeRequests) {
        if (mergeRequests.isEmpty) {
          return const EmptyState(
            icon: Icons.call_merge_outlined,
            title: 'No merge requests',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(mergeRequestsProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: mergeRequests.length,
            itemBuilder: (context, index) =>
                MergeRequestCard(mergeRequest: mergeRequests[index]),
          ),
        );
      },
    );
  }
}

class _IssuesTab extends ConsumerWidget {
  const _IssuesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider);

    return issuesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: () => ref.read(issuesProvider.notifier).refresh(),
      ),
      data: (issues) {
        if (issues.isEmpty) {
          return const EmptyState(
            icon: Icons.bug_report_outlined,
            title: 'No issues',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(issuesProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: issues.length,
            itemBuilder: (context, index) => IssueCard(issue: issues[index]),
          ),
        );
      },
    );
  }
}

