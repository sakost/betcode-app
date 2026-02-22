import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A dialog that lets the user pick a worktree before starting a new session.
///
/// Returns the selected [WorktreeDetail], or `null` if the user cancels.
class WorktreePickerDialog extends ConsumerWidget {
  const WorktreePickerDialog({super.key});

  /// Shows the dialog and returns the selected [WorktreeDetail] or null.
  static Future<WorktreeDetail?> show(BuildContext context) {
    return showDialog<WorktreeDetail>(
      context: context,
      builder: (_) => const WorktreePickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worktreesAsync = ref.watch(worktreesProvider);

    return AlertDialog(
      title: const Text('Select Worktree'),
      content: SizedBox(
        width: double.maxFinite,
        child: worktreesAsync.when(
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text(
            error.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          data: (worktrees) {
            if (worktrees.isEmpty) {
              return const Text('No worktrees available');
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: worktrees.length,
              itemBuilder: (context, index) {
                final wt = worktrees[index];
                return ListTile(
                  leading: const Icon(Icons.account_tree_outlined),
                  title: Text(wt.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wt.branch),
                      Text(
                        wt.path,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => Navigator.of(context).pop(wt),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
