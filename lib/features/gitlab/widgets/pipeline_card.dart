import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/gitlab.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/tappable_card.dart';

/// A card displaying a single [PipelineInfo] in the pipelines list.
///
/// Shows status badge with color, ref branch name, SHA (truncated, monospace),
/// source, and timestamps. Accepts an optional [onTap] callback.
class PipelineCard extends StatelessWidget {
  const PipelineCard({super.key, required this.pipeline, this.onTap});

  final PipelineInfo pipeline;
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
          // Top row: ref name + status badge
          Row(
            children: [
              Icon(
                Icons.call_split,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  pipeline.refName.isNotEmpty
                      ? pipeline.refName
                      : 'Unknown',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildPipelineStatusBadge(pipeline.status),
            ],
          ),

          const SizedBox(height: 6),

          // SHA (truncated)
          if (pipeline.sha.isNotEmpty)
            Text(
              pipeline.sha.length > 8
                  ? pipeline.sha.substring(0, 8)
                  : pipeline.sha,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'JetBrains Mono',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // Source
          if (pipeline.source.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.source_outlined,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  pipeline.source,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

StatusBadge _buildPipelineStatusBadge(PipelineStatus status) {
  final (color, label) = _resolvePipelineStatus(status);
  return StatusBadge(color: color, label: label);
}

(Color, String) _resolvePipelineStatus(PipelineStatus status) {
  return switch (status) {
    PipelineStatus.PIPELINE_STATUS_SUCCESS => (AppColors.online, 'Success'),
    PipelineStatus.PIPELINE_STATUS_FAILED => (AppColors.offline, 'Failed'),
    PipelineStatus.PIPELINE_STATUS_RUNNING => (
      AppColors.agentThinking,
      'Running',
    ),
    PipelineStatus.PIPELINE_STATUS_PENDING => (
      AppColors.syncPending,
      'Pending',
    ),
    PipelineStatus.PIPELINE_STATUS_CANCELED => (
      AppColors.agentIdle,
      'Canceled',
    ),
    PipelineStatus.PIPELINE_STATUS_CREATED => (
      AppColors.agentIdle,
      'Created',
    ),
    PipelineStatus.PIPELINE_STATUS_SKIPPED => (
      AppColors.agentIdle,
      'Skipped',
    ),
    PipelineStatus.PIPELINE_STATUS_MANUAL => (
      AppColors.agentWaiting,
      'Manual',
    ),
    PipelineStatus.PIPELINE_STATUS_SCHEDULED => (
      AppColors.scheduled,
      'Scheduled',
    ),
    PipelineStatus.PIPELINE_STATUS_PREPARING => (
      AppColors.syncPending,
      'Preparing',
    ),
    PipelineStatus.PIPELINE_STATUS_WAITING_FOR_RESOURCE => (
      AppColors.syncPending,
      'Waiting',
    ),
    _ => (AppColors.agentIdle, 'Unknown'),
  };
}
