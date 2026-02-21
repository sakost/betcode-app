import 'package:betcode_app/features/worktrees/widgets/create_worktree_dialog.dart';
import 'package:flutter/material.dart';

/// Shows the [CreateWorktreeDialog] and calls [onCreate] with the result.
///
/// Shared between `WorktreesScreen` and `RepoDetailScreen` which differ only
/// in which notifier they call to create the worktree.
Future<void> showCreateWorktreeDialog(
  BuildContext context, {
  required Future<void> Function({
    required String name,
    required String repoId,
    required String branch,
    String? setupScript,
  })
  onCreate,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<CreateWorktreeResult>(
    context: context,
    builder: (_) => const CreateWorktreeDialog(),
  );
  if (result == null) return;
  try {
    await onCreate(
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
