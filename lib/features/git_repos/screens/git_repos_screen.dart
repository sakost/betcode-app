import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/features/git_repos/widgets/git_repo_card.dart';
import 'package:betcode_app/features/git_repos/widgets/register_repo_dialog.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/shared/widgets/async_list_scaffold.dart';
import 'package:betcode_app/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GitReposScreen extends ConsumerWidget {
  const GitReposScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(gitReposProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Repositories')),
      body: AsyncListScaffold<GitRepoDetail>(
        asyncValue: reposAsync,
        onRefresh: () => ref.read(gitReposProvider.notifier).refresh(),
        emptyIcon: Icons.folder_outlined,
        emptyTitle: 'No repositories',
        emptySubtitle: 'Register a git repository to manage worktrees.',
        itemBuilder: (context, repo) => GitRepoCard(
          repo: repo,
          onTap: () => context.go('/code/repos/${repo.id}'),
          onDelete: () => _confirmUnregister(
            context,
            ref,
            repo.id,
            repo.name.isNotEmpty ? repo.name : repo.repoPath,
          ),
        ),
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
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to register repository: $e'),
        ),
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
    final confirmed = await showConfirmDialog(
      context,
      title: 'Unregister Repository',
      content: 'Unregister "$name"? This will not delete the repository.',
      confirmLabel: 'Unregister',
    );
    if (confirmed != true) return;
    try {
      await ref.read(gitReposProvider.notifier).unregisterRepo(id);
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to unregister repository: $e'),
        ),
      );
    }
  }
}
