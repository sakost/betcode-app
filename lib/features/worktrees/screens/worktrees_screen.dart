import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/features/worktrees/widgets/create_worktree_action.dart';
import 'package:betcode_app/features/worktrees/widgets/worktree_card.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/widgets/async_list_scaffold.dart';
import 'package:betcode_app/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorktreesScreen extends ConsumerWidget {
  const WorktreesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worktreesAsync = ref.watch(worktreesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Worktrees')),
      body: AsyncListScaffold<WorktreeDetail>(
        asyncValue: worktreesAsync,
        onRefresh: () => ref.read(worktreesProvider.notifier).refresh(),
        emptyIcon: Icons.account_tree_outlined,
        emptyTitle: 'No worktrees',
        emptySubtitle: 'Create a worktree to start working on a branch.',
        itemBuilder: (context, worktree) => WorktreeCard(
          worktree: worktree,
          onDelete: () =>
              _confirmDelete(context, ref, worktree.id, worktree.name),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateWorktreeDialog(
          context,
          onCreate: ref.read(worktreesProvider.notifier).createWorktree,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove Worktree',
      content: 'Remove worktree "$name"? This cannot be undone.',
    );
    if (confirmed != true) return;
    try {
      await ref.read(worktreesProvider.notifier).removeWorktree(id);
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to remove worktree: $e')),
      );
    }
  }
}
