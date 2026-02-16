import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:betcode_app/shared/utils/time_utils.dart';
import 'package:betcode_app/shared/widgets/tappable_card.dart';
import 'package:flutter/material.dart';

/// A card displaying a single [WorktreeDetail] in the worktrees list.
///
/// Shows the worktree name, branch, path, disk status, and session count.
///
/// Optional callbacks:
/// - [onDelete] shows a delete icon button in the top-right corner.
/// - [onStartConversation] shows a "Start Conversation" text button in the
///   bottom-right corner.
///
/// When neither trailing action is provided, relative time from last activity
/// is shown in the bottom row.
class WorktreeCard extends StatelessWidget {
  const WorktreeCard({
    required this.worktree,
    super.key,
    this.onDelete,
    this.onStartConversation,
  });

  final WorktreeDetail worktree;
  final VoidCallback? onDelete;
  final VoidCallback? onStartConversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TappableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + disk status + optional delete button
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
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
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

          // Bottom row: session count + trailing widget
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
              if (onStartConversation != null)
                TextButton.icon(
                  onPressed: onStartConversation,
                  icon: const Icon(Icons.chat_outlined, size: 16),
                  label: const Text('Start Conversation'),
                )
              else
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
    return relativeTime(dateTime);
  }
}
