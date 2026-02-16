import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter/foundation.dart';

/// A unified command model bridging static local commands ([InputCommand])
/// and dynamic daemon commands ([CommandEntry]).
@immutable
class CommandItem {
  const CommandItem({
    required this.name,
    required this.description,
    required this.category,
    this.group,
    this.displayName,
  });

  /// Creates a [CommandItem] from a static local [InputCommand].
  factory CommandItem.fromLocal(InputCommand cmd) => CommandItem(
    name: cmd.name,
    description: cmd.description,
    category: cmd.category,
  );

  /// Creates a [CommandItem] from a daemon [CommandEntry].
  factory CommandItem.fromDaemon(CommandEntry entry) => CommandItem(
    name: entry.name,
    description: entry.description,
    category: _categoryLabel(entry.category),
    group: entry.group.isNotEmpty ? entry.group : null,
    displayName: entry.displayName.isNotEmpty ? entry.displayName : null,
  );

  final String name;
  final String description;

  /// Human-readable category label (e.g. "Service", "Skill", "MCP", "App").
  final String category;

  /// Optional group for section headers in the palette.
  final String? group;

  /// Optional display name (shown instead of [name] when present).
  final String? displayName;

  /// The label to show in the palette (prefers [displayName] over [name]).
  String get label => displayName ?? name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommandItem &&
          name == other.name &&
          description == other.description &&
          category == other.category &&
          group == other.group &&
          displayName == other.displayName;

  @override
  int get hashCode =>
      Object.hash(name, description, category, group, displayName);

  static String _categoryLabel(CommandCategory cat) {
    return switch (cat) {
      CommandCategory.COMMAND_CATEGORY_UNSPECIFIED => 'Unknown',
      CommandCategory.COMMAND_CATEGORY_SERVICE => 'Service',
      CommandCategory.COMMAND_CATEGORY_CLAUDE_CODE => 'Claude',
      CommandCategory.COMMAND_CATEGORY_PLUGIN => 'Plugin',
      CommandCategory.COMMAND_CATEGORY_SKILL => 'Skill',
      CommandCategory.COMMAND_CATEGORY_MCP => 'MCP',
      _ => 'Unknown',
    };
  }
}

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputCommand &&
          name == other.name &&
          description == other.description &&
          category == other.category;

  @override
  int get hashCode => Object.hash(name, description, category);

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
