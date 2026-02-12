import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/common.pb.dart';
import '../../../shared/theme/app_colors.dart';

/// Displays the current agent status as a colored dot with label.
///
/// Maps [AgentStatus] proto enum values to visual indicators.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  final AgentStatus status;

  Color _color() {
    if (status == AgentStatus.AGENT_STATUS_THINKING) {
      return AppColors.agentThinking;
    }
    if (status == AgentStatus.AGENT_STATUS_EXECUTING_TOOL) {
      return AppColors.agentExecuting;
    }
    if (status == AgentStatus.AGENT_STATUS_WAITING_FOR_USER) {
      return AppColors.agentWaiting;
    }
    if (status == AgentStatus.AGENT_STATUS_IDLE) {
      return AppColors.agentIdle;
    }
    if (status == AgentStatus.AGENT_STATUS_COMPACTING) {
      return AppColors.agentThinking;
    }
    if (status == AgentStatus.AGENT_STATUS_ERROR) {
      return AppColors.agentError;
    }
    return AppColors.agentIdle;
  }

  String _label() {
    if (status == AgentStatus.AGENT_STATUS_THINKING) {
      return 'Thinking...';
    }
    if (status == AgentStatus.AGENT_STATUS_EXECUTING_TOOL) {
      return 'Executing tool...';
    }
    if (status == AgentStatus.AGENT_STATUS_WAITING_FOR_USER) {
      return 'Waiting for you';
    }
    if (status == AgentStatus.AGENT_STATUS_IDLE) {
      return 'Idle';
    }
    if (status == AgentStatus.AGENT_STATUS_COMPACTING) {
      return 'Compacting...';
    }
    if (status == AgentStatus.AGENT_STATUS_ERROR) {
      return 'Error';
    }
    return 'Unknown';
  }

  IconData _icon() {
    if (status == AgentStatus.AGENT_STATUS_THINKING) {
      return Icons.psychology;
    }
    if (status == AgentStatus.AGENT_STATUS_EXECUTING_TOOL) {
      return Icons.construction;
    }
    if (status == AgentStatus.AGENT_STATUS_WAITING_FOR_USER) {
      return Icons.person;
    }
    if (status == AgentStatus.AGENT_STATUS_IDLE) {
      return Icons.check_circle_outline;
    }
    if (status == AgentStatus.AGENT_STATUS_COMPACTING) {
      return Icons.compress;
    }
    if (status == AgentStatus.AGENT_STATUS_ERROR) {
      return Icons.error_outline;
    }
    return Icons.help_outline;
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
