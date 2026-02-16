import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:flutter/material.dart';

/// Overlay that shows filtered agent mentions above the input bar.
class AgentMentionOverlay extends StatelessWidget {
  const AgentMentionOverlay({
    required this.agents,
    required this.query,
    required this.onAgentSelected,
    super.key,
  });

  final Map<String, AgentInfo> agents;
  final String query;
  final ValueChanged<String> onAgentSelected;

  @override
  Widget build(BuildContext context) {
    if (agents.isEmpty) return const SizedBox.shrink();

    final lower = query.toLowerCase();
    final filtered = agents.entries
        .where(
          (e) => lower.isEmpty || e.value.name.toLowerCase().contains(lower),
        )
        .toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final entry = filtered[index];
            final agent = entry.value;
            return ListTile(
              dense: true,
              title: Text(
                '@${agent.name}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () => onAgentSelected(entry.key),
            );
          },
        ),
      ),
    );
  }
}
