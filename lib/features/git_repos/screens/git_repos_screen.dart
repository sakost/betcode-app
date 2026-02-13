import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_display.dart';
import '../notifiers/git_repos_providers.dart';
import '../widgets/git_repo_card.dart';
import '../widgets/register_repo_dialog.dart';

class GitReposScreen extends ConsumerWidget {
  const GitReposScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(gitReposProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Repositories')),
      body: reposAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(gitReposProvider.notifier).refresh(),
        ),
        data: (repos) {
          if (repos.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(gitReposProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: repos.length,
              itemBuilder: (context, index) => GitRepoCard(
                repo: repos[index],
                onDelete: () => _confirmUnregister(
                  context,
                  ref,
                  repos[index].id,
                  repos[index].name.isNotEmpty
                      ? repos[index].name
                      : repos[index].repoPath,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRegisterDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showRegisterDialog(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showDialog<RegisterRepoResult>(
      context: context,
      builder: (_) => const RegisterRepoDialog(),
    );
    if (result == null) return;
    try {
      await ref
          .read(gitReposProvider.notifier)
          .registerRepo(
            repoPath: result.repoPath,
            name: result.name,
            worktreeMode: result.worktreeMode,
            setupScript: result.setupScript,
          );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to register repository: $e')),
      );
    }
  }

  Future<void> _confirmUnregister(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unregister Repository'),
        content:
            Text('Unregister "$name"? This will not delete the repository.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Unregister'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(gitReposProvider.notifier).unregisterRepo(id);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to unregister repository: $e')),
      );
    }
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
              Icons.folder_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No repositories',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register a git repository to manage worktrees.',
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
