import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/betcode/v1/agent.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/time_utils.dart';

/// A card displaying a single [SessionSummary] in the sessions list.
///
/// Shows model name, status badge, last message preview, message count, cost,
/// and a relative timestamp. Tapping navigates to the conversation screen to
/// resume the session.
class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final SessionSummary session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/sessions/${session.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: model name + status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.model.isNotEmpty ? session.model : 'Unknown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: session.status),
                ],
              ),

              // Last message preview
              if (session.lastMessagePreview.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  session.lastMessagePreview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 10),

              // Bottom row: message count, cost, relative time
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${session.messageCount}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    session.totalCostUsd.toStringAsFixed(4),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _relativeTime(session),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(SessionSummary session) {
    final DateTime dateTime;
    if (session.hasUpdatedAt()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        session.updatedAt.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else if (session.hasCreatedAt()) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        session.createdAt.seconds.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    } else {
      return '';
    }
    return relativeTime(dateTime);
  }
}

/// A small colored chip indicating the session status.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = _resolve(status);
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

  (Color, String) _resolve(String status) {
    return switch (status.toLowerCase()) {
      'active' || 'thinking' => (AppColors.agentThinking, 'Active'),
      'executing' => (AppColors.agentExecuting, 'Executing'),
      'waiting' => (AppColors.agentWaiting, 'Waiting'),
      'idle' => (AppColors.agentIdle, 'Idle'),
      'error' => (AppColors.agentError, 'Error'),
      _ => (AppColors.agentIdle, status.isNotEmpty ? status : 'Unknown'),
    };
  }
}
