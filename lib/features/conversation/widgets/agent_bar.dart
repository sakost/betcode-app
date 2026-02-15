import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/common.pb.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/conversation_state.dart';

/// Horizontally scrolling bar of filter chips for tracked sub-agents.
///
/// Shows an "All" chip plus one chip per agent. Each chip displays the agent
/// name, a status icon, and a message count badge. Tapping a chip calls
/// [onAgentSelected] with the agent ID (or null for "All").
///
/// Collapses to [SizedBox.shrink] when [agents] is empty.
class AgentBar extends StatelessWidget {
  const AgentBar({
    super.key,
    required this.agents,
    this.selectedAgentId,
    required this.onAgentSelected,
  });

  final Map<String, AgentInfo> agents;
  final String? selectedAgentId;
  final ValueChanged<String?> onAgentSelected;

  @override
  Widget build(BuildContext context) {
    if (agents.isEmpty) return const SizedBox.shrink();

    final sortedAgents = agents.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: ChoiceChip(
              selected: selectedAgentId == null,
              label: const Text('All'),
              onSelected: (_) => onAgentSelected(null),
            ),
          ),
          for (final agent in sortedAgents)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: ChoiceChip(
                selected: selectedAgentId == agent.id,
                avatar: _StatusDot(color: _statusColor(agent)),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(agent.name),
                    if (agent.messageCount > 0) ...[
                      const SizedBox(width: 6),
                      _Badge(count: agent.messageCount),
                    ],
                  ],
                ),
                onSelected: (_) => onAgentSelected(agent.id),
              ),
            ),
        ],
      ),
    );
  }

  Color _statusColor(AgentInfo agent) {
    if (agent.isComplete) return AppColors.online; // green
    if (agent.status == AgentStatus.AGENT_STATUS_THINKING) {
      return AppColors.agentThinking; // amber
    }
    if (agent.status == AgentStatus.AGENT_STATUS_EXECUTING_TOOL) {
      return AppColors.agentExecuting; // blue
    }
    if (agent.status == AgentStatus.AGENT_STATUS_ERROR) {
      return AppColors.agentError; // red
    }
    return AppColors.agentIdle; // grey
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
