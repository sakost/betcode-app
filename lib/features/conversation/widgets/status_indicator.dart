import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

/// Displays the current agent status as a colored dot with label.
///
/// Maps agent status strings to visual indicators.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  /// Agent status string matching AgentStatus proto enum values:
  /// thinking, executing_tool, waiting_for_user, idle, compacting, error
  final String status;

  Color _color() {
    return switch (status) {
      'thinking' => AppColors.agentThinking,
      'executing_tool' => AppColors.agentExecuting,
      'waiting_for_user' => AppColors.agentWaiting,
      'idle' => AppColors.agentIdle,
      'compacting' => AppColors.agentThinking,
      'error' => AppColors.agentError,
      _ => AppColors.agentIdle,
    };
  }

  String _label() {
    return switch (status) {
      'thinking' => 'Thinking...',
      'executing_tool' => 'Executing tool...',
      'waiting_for_user' => 'Waiting for you',
      'idle' => 'Idle',
      'compacting' => 'Compacting...',
      'error' => 'Error',
      _ => 'Unknown',
    };
  }

  IconData _icon() {
    return switch (status) {
      'thinking' => Icons.psychology,
      'executing_tool' => Icons.construction,
      'waiting_for_user' => Icons.person,
      'idle' => Icons.check_circle_outline,
      'compacting' => Icons.compress,
      'error' => Icons.error_outline,
      _ => Icons.help_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _color();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon(), size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          _label(),
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
