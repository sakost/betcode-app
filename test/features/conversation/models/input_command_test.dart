import 'package:betcode_app/features/commands/models/command_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputCommand', () {
    test('allCommands is non-empty', () {
      expect(InputCommand.allCommands, isNotEmpty);
    });

    test('each command has non-empty name, description, category', () {
      for (final cmd in InputCommand.allCommands) {
        expect(cmd.name, isNotEmpty);
        expect(cmd.description, isNotEmpty);
        expect(cmd.category, isNotEmpty);
      }
    });

    test('allCommands names are unique', () {
      final names = InputCommand.allCommands.map((c) => c.name).toSet();
      expect(names.length, InputCommand.allCommands.length);
    });
  });

  group('InputCommand.filter', () {
    test('empty query returns all commands', () {
      final result = InputCommand.filter('');
      expect(result, InputCommand.allCommands);
    });

    test('filters by name substring', () {
      final result = InputCommand.filter('can');
      expect(result.length, 1);
      expect(result.first.name, 'cancel');
    });

    test('filter is case-insensitive', () {
      final result = InputCommand.filter('CAN');
      expect(result.length, 1);
      expect(result.first.name, 'cancel');
    });

    test('no match returns empty list', () {
      final result = InputCommand.filter('zzzzz');
      expect(result, isEmpty);
    });

    test('partial match works', () {
      final result = InputCommand.filter('ex');
      expect(result.any((c) => c.name == 'exit'), isTrue);
    });

    test('filter "re" matches retry', () {
      final result = InputCommand.filter('re');
      expect(result.any((c) => c.name == 'retry'), isTrue);
    });

    test('filter "cl" matches clear', () {
      final result = InputCommand.filter('cl');
      expect(result.any((c) => c.name == 'clear'), isTrue);
    });
  });
}
