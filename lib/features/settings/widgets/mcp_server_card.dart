import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/config.pb.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/tappable_card.dart';

/// A card displaying a single [McpServerInfo] in the MCP servers list.
///
/// Shows server name, type, endpoint, status badge, tools count, and
/// error message if the server is in error state.
class McpServerCard extends StatelessWidget {
  const McpServerCard({super.key, required this.server});

  final McpServerInfo server;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TappableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: server name + status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  server.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildMcpServerStatusBadge(server.status),
            ],
          ),

          const SizedBox(height: 6),

          // Server type + endpoint
          Row(
            children: [
              Text(
                server.serverType,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (server.endpoint.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    server.endpoint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Tools count
          Text(
            '${server.tools.length} ${server.tools.length == 1 ? 'tool' : 'tools'}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          // Error message (only shown when status is ERROR and message is non-empty)
          if (server.status == McpServerStatus.MCP_SERVER_STATUS_ERROR &&
              server.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              server.errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

StatusBadge _buildMcpServerStatusBadge(McpServerStatus status) {
  final (color, label) = _resolveMcpServerStatus(status);
  return StatusBadge(color: color, label: label);
}

(Color, String) _resolveMcpServerStatus(McpServerStatus status) {
  return switch (status) {
    McpServerStatus.MCP_SERVER_STATUS_RUNNING => (Colors.green, 'Running'),
    McpServerStatus.MCP_SERVER_STATUS_STOPPED => (Colors.grey, 'Stopped'),
    McpServerStatus.MCP_SERVER_STATUS_STARTING => (Colors.amber, 'Starting'),
    McpServerStatus.MCP_SERVER_STATUS_ERROR => (Colors.red, 'Error'),
    _ => (Colors.grey, 'Unknown'),
  };
}
