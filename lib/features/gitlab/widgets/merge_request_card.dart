import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import '../../../generated/betcode/v1/gitlab.pbenum.dart';
import '../../../shared/theme/app_colors.dart';

/// A card displaying a single [MergeRequestInfo] in the merge requests list.
///
/// Shows title (bold), IID (!123 format), state badge, source->target branches,
/// author, draft indicator (chip), and labels (chips). Accepts an optional
/// [onTap] callback.
class MergeRequestCard extends StatelessWidget {
  const MergeRequestCard({super.key, required this.mergeRequest, this.onTap});

  final MergeRequestInfo mergeRequest;
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
                  _MergeRequestStateBadge(state: mergeRequest.state),
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
                Row(
                  children: [
                    Icon(
                      Icons.call_merge,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${mergeRequest.sourceBranch} \u2192 ${mergeRequest.targetBranch}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Author
              if (mergeRequest.author.isNotEmpty) ...[
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
                      mergeRequest.author,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              // Draft indicator + labels
              if (mergeRequest.draft || mergeRequest.labels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (mergeRequest.draft)
                      Chip(
                        label: const Text('Draft'),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ...mergeRequest.labels.map(
                      (label) => Chip(
                        label: Text(label),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A small colored chip indicating the merge request state.
class _MergeRequestStateBadge extends StatelessWidget {
  const _MergeRequestStateBadge({required this.state});

  final MergeRequestState state;

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

  (Color, String) _resolve(MergeRequestState state) {
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
}
