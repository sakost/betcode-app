import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/agent.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/time_utils.dart';

/// A card displaying a single [SessionSummary] in the sessions list.
///
/// Shows session name (or last message preview as fallback), model name, status
/// badge, message count, cost, and a relative timestamp.
///
/// [onTap] is called when the card is tapped.
/// [onRename] is called with the current name when the user picks Rename from
/// the long-press context menu.
/// [onDelete] is called when the user picks Delete from the context menu.
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.onRename,
    this.onDelete,
  });

  final SessionSummary session;
  final VoidCallback? onTap;
  final ValueChanged<String>? onRename;
  final VoidCallback? onDelete;

  String get _title {
    if (session.name.isNotEmpty) return session.name;
    if (session.lastMessagePreview.isNotEmpty) return session.lastMessagePreview;
    return session.model.isNotEmpty ? session.model : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: title + status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _title,
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

              // Subtitle: show model when name is used as title, or preview
              // when model was used as title
              if (session.name.isNotEmpty &&
                  session.lastMessagePreview.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  session.lastMessagePreview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ] else if (session.name.isEmpty &&
                  session.lastMessagePreview.isNotEmpty) ...[
                // Title IS the preview — show model as subtitle instead
                const SizedBox(height: 4),
                Text(
                  session.model.isNotEmpty ? session.model : 'Unknown',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
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

  Future<void> _showContextMenu(BuildContext context) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final button = context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      button.localToGlobal(Offset.zero, ancestor: overlay) & button.size,
      Offset.zero & overlay.size,
    );

    final result = await showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(value: 'rename', child: Text('Rename')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );

    if (result == 'rename') {
      onRename?.call(session.name);
    } else if (result == 'delete') {
      onDelete?.call();
    }
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
