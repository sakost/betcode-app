import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/features/git_repos/notifiers/repo_worktrees_provider.dart';
import 'package:betcode_app/features/worktrees/widgets/create_worktree_dialog.dart';
import 'package:betcode_app/features/worktrees/widgets/worktree_card.dart';
import 'package:betcode_app/shared/widgets/empty_state.dart';
import 'package:betcode_app/shared/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RepoDetailScreen extends ConsumerWidget {
  const RepoDetailScreen({required this.repoId, super.key});

  final String repoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(gitReposProvider);

    final repos = reposAsync.value;
    final repo = repos?.where((r) => r.id == repoId).firstOrNull;

    final repoName = repo != null && repo.name.isNotEmpty
        ? repo.name
        : repo?.repoPath
                  .split('/')
                  .lastWhere((s) => s.isNotEmpty, orElse: () => 'Repository') ??
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
              Tab(icon: Icon(Icons.merge_outlined), text: 'Merge Requests'),
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
      await ref
          .read(repoWorktreesProvider(repoId).notifier)
          .createWorktree(
            name: result.name,
            repoId: result.repoId,
            branch: result.branch,
            setupScript: result.setupScript,
          );
    } on Exception catch (e) {
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
            itemBuilder: (context, index) => WorktreeCard(
              worktree: worktrees[index],
              onStartConversation: () =>
                  context.go('/sessions/new', extra: worktrees[index].path),
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
