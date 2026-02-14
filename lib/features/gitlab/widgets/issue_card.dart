import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/tappable_card.dart';

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

    return TappableCard(
      onTap: onTap,
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
              _buildIssueStateBadge(issue.state),
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
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

StatusBadge _buildIssueStateBadge(IssueState state) {
  final (color, label) = _resolveIssueState(state);
  return StatusBadge(color: color, label: label);
}

(Color, String) _resolveIssueState(IssueState state) {
  return switch (state) {
    IssueState.ISSUE_STATE_OPENED => (AppColors.online, 'Opened'),
    IssueState.ISSUE_STATE_CLOSED => (AppColors.offline, 'Closed'),
    _ => (AppColors.agentIdle, 'Unknown'),
  };
}
