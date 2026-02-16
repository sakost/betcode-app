import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/shared/utils/time_utils.dart';
import 'package:betcode_app/shared/widgets/tappable_card.dart';
import 'package:flutter/material.dart';

/// A card displaying a single [GitRepoDetail] in the repositories list.
///
/// Shows the repo name (or last path component), worktree mode badge,
/// repo path, worktree count, relative time from last activity, and a
/// delete button.
class GitRepoCard extends StatelessWidget {
  const GitRepoCard({
    required this.repo,
    required this.onDelete,
    super.key,
    this.onTap,
  });

  final GitRepoDetail repo;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayName = repo.name.isNotEmpty
        ? repo.name
        : repo.repoPath
              .split('/')
              .lastWhere((s) => s.isNotEmpty, orElse: () => repo.repoPath);

    return TappableCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + worktree mode badge + delete button
          Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (repo.worktreeMode != WorktreeMode.WORKTREE_MODE_UNSPECIFIED)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _badgeColor(repo.worktreeMode, colorScheme),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _modeLabel(repo.worktreeMode),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
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

          // Path row (monospace)
          Text(
            repo.repoPath,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Bottom row: worktree count + relative time
          Row(
            children: [
              Icon(
                Icons.account_tree,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${repo.worktreeCount}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                _relativeTime(repo),
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

  static String _modeLabel(WorktreeMode mode) {
    return switch (mode) {
      WorktreeMode.WORKTREE_MODE_GLOBAL => 'Global',
      WorktreeMode.WORKTREE_MODE_LOCAL => 'Local',
      WorktreeMode.WORKTREE_MODE_CUSTOM => 'Custom',
      _ => 'Unknown',
    };
  }

  Color _badgeColor(WorktreeMode mode, ColorScheme colorScheme) {
    return switch (mode) {
      WorktreeMode.WORKTREE_MODE_GLOBAL => colorScheme.primary,
      WorktreeMode.WORKTREE_MODE_LOCAL => colorScheme.secondary,
      WorktreeMode.WORKTREE_MODE_CUSTOM => colorScheme.tertiary,
      _ => colorScheme.outline,
    };
  }

  String _relativeTime(GitRepoDetail r) {
    final DateTime dateTime;
    if (r.hasLastActive()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        r.lastActive.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else if (r.hasCreatedAt()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        r.createdAt.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else {
      return '';
    }
    return relativeTime(dateTime);
  }
}
