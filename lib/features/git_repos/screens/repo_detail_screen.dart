import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/betcode/v1/worktree.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_display.dart';
import '../../../shared/widgets/tappable_card.dart';
import '../../worktrees/widgets/create_worktree_dialog.dart';
import '../notifiers/git_repos_providers.dart';
import '../notifiers/repo_worktrees_provider.dart';

class RepoDetailScreen extends ConsumerWidget {
  const RepoDetailScreen({super.key, required this.repoId});

  final String repoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(gitReposProvider);

    final repos = reposAsync.value;
    final repo = repos?.where((r) => r.id == repoId).firstOrNull;

    final repoName = repo != null && repo.name.isNotEmpty
        ? repo.name
        : repo?.repoPath.split('/').lastWhere(
              (s) => s.isNotEmpty,
              orElse: () => 'Repository',
            ) ??
            'Repository';

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(repoName),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.account_tree_outlined), text: 'Worktrees'),
              Tab(icon: Icon(Icons.rocket_launch_outlined), text: 'Pipelines'),
              Tab(
                icon: Icon(Icons.merge_outlined),
                text: 'Merge Requests',
              ),
              Tab(icon: Icon(Icons.bug_report_outlined), text: 'Issues'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _WorktreesTab(repoId: repoId),
            const _PlaceholderTab(
              icon: Icons.rocket_launch_outlined,
              label: 'Pipelines coming soon',
            ),
            const _PlaceholderTab(
              icon: Icons.merge_outlined,
              label: 'Merge Requests coming soon',
            ),
            const _PlaceholderTab(
              icon: Icons.bug_report_outlined,
              label: 'Issues coming soon',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateDialog(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showDialog<CreateWorktreeResult>(
      context: context,
      builder: (_) => const CreateWorktreeDialog(),
    );
    if (result == null) return;
    try {
      await ref.read(repoWorktreesProvider(repoId).notifier).createWorktree(
        name: result.name,
        repoId: result.repoId,
        branch: result.branch,
        setupScript: result.setupScript,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to create worktree: $e')),
      );
    }
  }
}

class _WorktreesTab extends ConsumerWidget {
  const _WorktreesTab({required this.repoId});

  final String repoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worktreesAsync = ref.watch(repoWorktreesProvider(repoId));

    return worktreesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: () =>
            ref.read(repoWorktreesProvider(repoId).notifier).refresh(),
      ),
      data: (worktrees) {
        if (worktrees.isEmpty) {
          return const EmptyState(
            icon: Icons.account_tree_outlined,
            title: 'No worktrees',
            subtitle: 'Create a worktree to start working on a branch.',
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(repoWorktreesProvider(repoId).notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: worktrees.length,
            itemBuilder: (context, index) => _RepoWorktreeCard(
              worktree: worktrees[index],
              onStartConversation: () => context.go(
                '/sessions/new',
                extra: worktrees[index].path,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoWorktreeCard extends StatelessWidget {
  const _RepoWorktreeCard({
    required this.worktree,
    required this.onStartConversation,
  });

  final WorktreeDetail worktree;
  final VoidCallback onStartConversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TappableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + disk status
          Row(
            children: [
              Expanded(
                child: Text(
                  worktree.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                worktree.existsOnDisk ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: worktree.existsOnDisk
                    ? AppColors.online
                    : AppColors.offline,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Branch row
          Row(
            children: [
              Icon(
                Icons.fork_right,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  worktree.branch,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Path row
          Text(
            worktree.path,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Bottom row: session count + start conversation button
          Row(
            children: [
              Icon(
                Icons.terminal,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${worktree.sessionCount}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onStartConversation,
                icon: const Icon(Icons.chat_outlined, size: 16),
                label: const Text('Start Conversation'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
