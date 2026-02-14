import 'package:flutter/foundation.dart';

/// A slash command available in the input bar.
@immutable
class InputCommand {
  const InputCommand({
    required this.name,
    required this.description,
    required this.category,
  });

  final String name;
  final String description;
  final String category;

  static const allCommands = <InputCommand>[
    InputCommand(name: 'exit', description: 'End session', category: 'App'),
    InputCommand(name: 'clear', description: 'Clear display', category: 'App'),
    InputCommand(
      name: 'compact',
      description: 'Compact context',
      category: 'App',
    ),
    InputCommand(
      name: 'plan',
      description: 'Toggle plan mode',
      category: 'Claude',
    ),
    InputCommand(
      name: 'model',
      description: 'Switch model',
      category: 'Claude',
    ),
    InputCommand(
      name: 'cancel',
      description: 'Cancel current turn',
      category: 'Agent',
    ),
    InputCommand(
      name: 'retry',
      description: 'Retry last turn',
      category: 'Agent',
    ),
  ];

  static List<InputCommand> filter(String query) {
    if (query.isEmpty) return allCommands;
    final lower = query.toLowerCase();
    return allCommands
        .where((c) => c.name.toLowerCase().contains(lower))
        .toList();
  }
}
