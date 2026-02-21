import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/features/worktrees/widgets/create_worktree_dialog.dart';
import 'package:betcode_app/features/worktrees/widgets/worktree_card.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/widgets/async_list_scaffold.dart';
import 'package:betcode_app/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorktreesScreen extends ConsumerStatefulWidget {
  const WorktreesScreen({super.key});

  @override
  ConsumerState<WorktreesScreen> createState() => _WorktreesScreenState();
}

class _WorktreesScreenState extends ConsumerState<WorktreesScreen> {
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
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
        onPressed: _isCreating ? null : () => _showCreateDialog(context, ref),
        child: _isCreating
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
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
    setState(() => _isCreating = true);
    try {
      await ref.read(worktreesProvider.notifier).createWorktree(
            name: result.name,
            repoId: result.repoId,
            branch: result.branch,
            setupScript: result.setupScript,
          );
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to create worktree: $e')),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
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
