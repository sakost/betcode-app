import 'package:betcode_app/features/commands/models/command_item.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommandItem.fromLocal', () {
    test('maps all InputCommand fields', () {
      const input = InputCommand(
        name: 'exit',
        description: 'End session',
        category: 'App',
      );

      final item = CommandItem.fromLocal(input);

      expect(item.name, 'exit');
      expect(item.description, 'End session');
      expect(item.category, 'App');
      expect(item.group, isNull);
      expect(item.displayName, isNull);
    });

    test('label falls back to name when no displayName', () {
      const input = InputCommand(
        name: 'clear',
        description: 'Clear display',
        category: 'App',
      );

      expect(CommandItem.fromLocal(input).label, 'clear');
    });
  });

  group('CommandItem.fromDaemon', () {
    test('maps all CommandEntry fields', () {
      final entry = CommandEntry(
        name: 'deploy',
        description: 'Deploy to production',
        category: CommandCategory.COMMAND_CATEGORY_SERVICE,
        group: 'ops',
        displayName: 'Deploy Now',
      );

      final item = CommandItem.fromDaemon(entry);

      expect(item.name, 'deploy');
      expect(item.description, 'Deploy to production');
      expect(item.category, 'Service');
      expect(item.group, 'ops');
      expect(item.displayName, 'Deploy Now');
    });

    test('label prefers displayName over name', () {
      final entry = CommandEntry(
        name: 'deploy',
        description: 'desc',
        displayName: 'Deploy Now',
      );

      expect(CommandItem.fromDaemon(entry).label, 'Deploy Now');
    });

    test('label falls back to name when displayName is empty', () {
      final entry = CommandEntry(name: 'deploy', description: 'desc');

      expect(CommandItem.fromDaemon(entry).label, 'deploy');
    });

    test('normalizes empty group to null', () {
      final entry = CommandEntry(name: 'cmd', description: 'desc');

      expect(CommandItem.fromDaemon(entry).group, isNull);
    });

    test('normalizes empty displayName to null', () {
      final entry = CommandEntry(name: 'cmd', description: 'desc');

      expect(CommandItem.fromDaemon(entry).displayName, isNull);
    });

    test('maps each CommandCategory to its label', () {
      final cases = <CommandCategory, String>{
        CommandCategory.COMMAND_CATEGORY_UNSPECIFIED: 'Unknown',
        CommandCategory.COMMAND_CATEGORY_SERVICE: 'Service',
        CommandCategory.COMMAND_CATEGORY_CLAUDE_CODE: 'Claude',
        CommandCategory.COMMAND_CATEGORY_PLUGIN: 'Plugin',
        CommandCategory.COMMAND_CATEGORY_SKILL: 'Skill',
        CommandCategory.COMMAND_CATEGORY_MCP: 'MCP',
      };

      for (final MapEntry(:key, :value) in cases.entries) {
        final entry = CommandEntry(
          name: 'cmd',
          description: 'desc',
          category: key,
        );
        expect(
          CommandItem.fromDaemon(entry).category,
          value,
          reason: '$key should map to "$value"',
        );
      }
    });
  });

  group('CommandItem equality', () {
    test('equal items are ==', () {
      const a = CommandItem(
        name: 'x',
        description: 'd',
        category: 'c',
        group: 'g',
        displayName: 'dn',
      );
      const b = CommandItem(
        name: 'x',
        description: 'd',
        category: 'c',
        group: 'g',
        displayName: 'dn',
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different items are not ==', () {
      const a = CommandItem(name: 'x', description: 'd', category: 'c');
      const b = CommandItem(name: 'y', description: 'd', category: 'c');

      expect(a, isNot(equals(b)));
    });
  });

  group('InputCommand equality', () {
    test('equal commands are ==', () {
      const a = InputCommand(
        name: 'exit',
        description: 'End session',
        category: 'App',
      );
      const b = InputCommand(
        name: 'exit',
        description: 'End session',
        category: 'App',
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different commands are not ==', () {
      const a = InputCommand(
        name: 'exit',
        description: 'End session',
        category: 'App',
      );
      const b = InputCommand(
        name: 'clear',
        description: 'Clear display',
        category: 'App',
      );

      expect(a, isNot(equals(b)));
    });
  });
}
