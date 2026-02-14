import 'package:flutter/material.dart';

import '../models/input_command.dart';

/// Overlay that shows filtered slash commands above the input bar.
class CommandPalette extends StatelessWidget {
  const CommandPalette({
    super.key,
    required this.query,
    required this.onCommandSelected,
  });

  final String query;
  final ValueChanged<InputCommand> onCommandSelected;

  @override
  Widget build(BuildContext context) {
    final commands = InputCommand.filter(query);
    if (commands.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: commands.length,
          itemBuilder: (context, index) {
            final cmd = commands[index];
            return ListTile(
              dense: true,
              title: Text(
                '/${cmd.name}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(cmd.description),
              trailing: Chip(
                label: Text(
                  cmd.category,
                  style: TextStyle(fontSize: 11, color: colorScheme.onSurface),
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onTap: () => onCommandSelected(cmd),
            );
          },
        ),
      ),
    );
  }
}
