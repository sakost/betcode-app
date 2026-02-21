import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:betcode_app/shared/widgets/compact_chip.dart';
import 'package:betcode_app/shared/widgets/icon_label_row.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:betcode_app/shared/widgets/tappable_card.dart';
import 'package:flutter/material.dart';

/// A card displaying a single [MergeRequestInfo] in the merge requests list.
///
/// Shows title (bold), IID (!123 format), state badge, source->target branches,
/// author, draft indicator (chip), and labels (chips). Accepts an optional
/// [onTap] callback.
class MergeRequestCard extends StatelessWidget {
  const MergeRequestCard({required this.mergeRequest, super.key, this.onTap});

  final MergeRequestInfo mergeRequest;
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
              Expanded(
                child: Text(
                  mergeRequest.title.isNotEmpty
                      ? mergeRequest.title
                      : 'Untitled',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildMergeRequestStateBadge(mergeRequest.state),
            ],
          ),

          const SizedBox(height: 6),

          // IID
          Text(
            '!${mergeRequest.iid}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontFamily: 'JetBrains Mono',
            ),
          ),

          // Branches
          if (mergeRequest.sourceBranch.isNotEmpty ||
              mergeRequest.targetBranch.isNotEmpty) ...[
            const SizedBox(height: 4),
            IconLabelRow(
              icon: Icons.call_merge,
              label:
                  '${mergeRequest.sourceBranch} '
                  '\u2192 ${mergeRequest.targetBranch}',
              expanded: true,
            ),
          ],

          // Author
          if (mergeRequest.author.isNotEmpty) ...[
            const SizedBox(height: 4),
            IconLabelRow(
              icon: Icons.person_outline,
              label: mergeRequest.author,
            ),
          ],

          // Draft indicator + labels
          if (mergeRequest.draft || mergeRequest.labels.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                if (mergeRequest.draft) const CompactChip(label: 'Draft'),
                ...mergeRequest.labels.map(
                  (label) => CompactChip(label: label),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

StatusBadge _buildMergeRequestStateBadge(MergeRequestState state) {
  final (color, label) = _resolveMergeRequestState(state);
  return StatusBadge(color: color, label: label);
}

(Color, String) _resolveMergeRequestState(MergeRequestState state) {
  return switch (state) {
    MergeRequestState.MERGE_REQUEST_STATE_OPENED => (
      AppColors.online,
      'Opened',
    ),
    MergeRequestState.MERGE_REQUEST_STATE_CLOSED => (
      AppColors.offline,
      'Closed',
    ),
    MergeRequestState.MERGE_REQUEST_STATE_MERGED => (
      AppColors.agentWaiting,
      'Merged',
    ),
    MergeRequestState.MERGE_REQUEST_STATE_LOCKED => (
      AppColors.agentIdle,
      'Locked',
    ),
    _ => (AppColors.agentIdle, 'Unknown'),
  };
}
