import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_display.dart';
import '../notifiers/worktrees_providers.dart';
import '../widgets/create_worktree_dialog.dart';
import '../widgets/worktree_card.dart';

class WorktreesScreen extends ConsumerWidget {
  const WorktreesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worktreesAsync = ref.watch(worktreesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Worktrees')),
      body: worktreesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(worktreesProvider.notifier).refresh(),
        ),
        data: (worktrees) {
          if (worktrees.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(worktreesProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: worktrees.length,
              itemBuilder: (context, index) => WorktreeCard(
                worktree: worktrees[index],
                onDelete: () => _confirmDelete(
                  context,
                  ref,
                  worktrees[index].id,
                  worktrees[index].name,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<CreateWorktreeResult>(
      context: context,
      builder: (_) => const CreateWorktreeDialog(),
    );
    if (result == null) return;

    await ref.read(worktreesProvider.notifier).createWorktree(
          name: result.name,
          repoPath: result.repoPath,
          branch: result.branch,
          setupScript: result.setupScript,
        );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Worktree'),
        content: Text('Remove worktree "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(worktreesProvider.notifier).removeWorktree(id);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No worktrees',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a worktree to start working on a branch.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
