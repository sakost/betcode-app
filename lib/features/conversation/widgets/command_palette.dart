import 'package:betcode_app/features/commands/models/command_category_colors.dart';
import 'package:betcode_app/features/commands/models/command_item.dart';
import 'package:betcode_app/features/commands/notifiers/commands_providers.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Overlay that shows filtered slash commands above the input bar.
///
/// Merges static local commands with dynamic daemon commands fetched
/// via [commandsProvider]. Groups commands by their [CommandItem.group]
/// field and displays category badges with semantic colors.
class CommandPalette extends ConsumerWidget {
  const CommandPalette({
    required this.query,
    required this.onCommandSelected,
    required this.sessionId,
    super.key,
  });

  final String query;
  final ValueChanged<CommandItem> onCommandSelected;
  final String? sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lower = query.toLowerCase();

    // Local static commands filtered by query.
    final localCommands = InputCommand.filter(query)
        .map(CommandItem.fromLocal)
        .toList();

    // Dynamic daemon commands filtered by query.
    final daemonCommandsAsync = ref.watch(commandsProvider(sessionId));
    final daemonCommands = daemonCommandsAsync.value
            ?.where(
              (e) =>
                  e.name.toLowerCase().contains(lower) ||
                  (e.displayName.isNotEmpty &&
                      e.displayName.toLowerCase().contains(lower)),
            )
            .map(CommandItem.fromDaemon)
            .toList() ??
        [];

    // Daemon commands take precedence over local ones with the same name.
    final daemonNames = daemonCommands.map((c) => c.name).toSet();
    final allCommands = [
      ...localCommands.where((c) => !daemonNames.contains(c.name)),
      ...daemonCommands,
    ];
    if (allCommands.isEmpty) return const SizedBox.shrink();

    final grouped = _groupCommands(allCommands);
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          children: [
            for (final entry in grouped.entries) ...[
              if (entry.key != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    entry.key!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              for (final cmd in entry.value)
                ListTile(
                  dense: true,
                  title: Text(
                    '/${cmd.label}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(cmd.description),
                  trailing: StatusBadge(
                    color: CommandCategoryColors.colorForCategory(cmd.category),
                    label: cmd.category,
                  ),
                  onTap: () => onCommandSelected(cmd),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Groups commands by [CommandItem.group]. Ungrouped commands (null group)
  /// are placed first. Named groups follow in insertion order (Dart's default
  /// [Map] preserves insertion order).
  Map<String?, List<CommandItem>> _groupCommands(List<CommandItem> commands) {
    final grouped = <String?, List<CommandItem>>{};
    for (final cmd in commands) {
      grouped.putIfAbsent(cmd.group, () => []).add(cmd);
    }
    // Ensure ungrouped (null key) comes first.
    final sorted = <String?, List<CommandItem>>{};
    if (grouped.containsKey(null)) {
      sorted[null] = grouped.remove(null)!;
    }
    sorted.addAll(grouped);
    return sorted;
  }
}
