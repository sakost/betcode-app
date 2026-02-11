import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/worktree.pb.dart';

/// A card displaying a single [WorktreeDetail] in the worktrees list.
///
/// Shows the worktree name, branch, path, disk status, session count,
/// relative time from last activity, and a delete button.
class WorktreeCard extends StatelessWidget {
  const WorktreeCard({
    super.key,
    required this.worktree,
    required this.onDelete,
  });

  final WorktreeDetail worktree;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: name + disk status + delete button
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
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
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

            // Path row (monospace)
            Text(
              worktree.path,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Bottom row: session count + relative time
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
                Text(
                  _relativeTime(worktree),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(WorktreeDetail wt) {
    final DateTime dateTime;
    if (wt.hasLastActive()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        wt.lastActive.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else if (wt.hasCreatedAt()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        wt.createdAt.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else {
      return '';
    }

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}
