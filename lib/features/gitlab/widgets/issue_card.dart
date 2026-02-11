import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import '../../../generated/betcode/v1/gitlab.pbenum.dart';
import '../../../shared/theme/app_colors.dart';

/// A card displaying a single [IssueInfo] in the issues list.
///
/// Shows title (bold), IID (#123 format), state badge, author, labels (chips),
/// and confidential indicator (lock icon). Accepts an optional [onTap] callback.
class IssueCard extends StatelessWidget {
  const IssueCard({super.key, required this.issue, this.onTap});

  final IssueInfo issue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: title + state badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidential icon
                  if (issue.confidential) ...[
                    Icon(
                      Icons.lock,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      issue.title.isNotEmpty ? issue.title : 'Untitled',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _IssueStateBadge(state: issue.state),
                ],
              ),

              const SizedBox(height: 6),

              // IID
              Text(
                '#${issue.iid}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'JetBrains Mono',
                ),
              ),

              // Author
              if (issue.author.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      issue.author,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              // Labels
              if (issue.labels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: issue.labels
                      .map(
                        (label) => Chip(
                          label: Text(label),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 6),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A small colored chip indicating the issue state.
class _IssueStateBadge extends StatelessWidget {
  const _IssueStateBadge({required this.state});

  final IssueState state;

  @override
  Widget build(BuildContext context) {
    final (color, label) = _resolve(state);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) _resolve(IssueState state) {
    return switch (state) {
      IssueState.ISSUE_STATE_OPENED => (AppColors.online, 'Opened'),
      IssueState.ISSUE_STATE_CLOSED => (AppColors.offline, 'Closed'),
      _ => (AppColors.agentIdle, 'Unknown'),
    };
  }
}
