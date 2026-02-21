import 'dart:async';

import 'package:betcode_app/features/commands/models/command_item.dart';
import 'package:betcode_app/features/commands/notifiers/commands_notifier.dart';
import 'package:betcode_app/features/commands/notifiers/commands_providers.dart';
import 'package:betcode_app/features/conversation/widgets/command_palette.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// A notifier that returns canned async value without gRPC calls.
class _FakeCommandsNotifier extends CommandsNotifier {
  _FakeCommandsNotifier(this._value);

  final AsyncValue<List<CommandEntry>> _value;

  @override
  Future<List<CommandEntry>> build() {
    return _value.when(
      data: Future.value,
      loading: () => Completer<List<CommandEntry>>().future,
      error: Future.error,
    );
  }
}

Widget _app({
  required Widget child,
  AsyncValue<List<CommandEntry>> daemonCommands = const AsyncData([]),
}) {
  return ProviderScope(
    overrides: [
      commandsProvider(null).overrideWith(
        () => _FakeCommandsNotifier(daemonCommands),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(body: SizedBox(height: 600, width: 400, child: child)),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CommandPalette', () {
    testWidgets('shows filtered commands with /name format', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.text('/exit'), findsOneWidget);
      expect(find.text('End session'), findsOneWidget);
    });

    testWidgets('filters commands by query', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'can',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.text('/cancel'), findsOneWidget);
      expect(find.text('/exit'), findsNothing);
    });

    testWidgets('returns SizedBox.shrink when no matches', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'zzzz',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      final palette = find.byType(CommandPalette);
      expect(palette, findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('tapping a command calls onCommandSelected', (t) async {
      CommandItem? selected;
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (cmd) => selected = cmd,
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      await t.tap(find.text('/exit'));
      await t.pump();
      expect(selected, isNotNull);
      expect(selected!.name, 'exit');
    });

    testWidgets('shows category badge for a command', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.byType(StatusBadge), findsOneWidget);
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('uses Material with elevation 4', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      final materials = t.widgetList<Material>(find.byType(Material)).toList();
      final hasMaterialWith4 = materials.any((m) => m.elevation == 4);
      expect(hasMaterialWith4, isTrue);
    });

    testWidgets('has ConstrainedBox with maxHeight 240', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      final boxes = t
          .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
          .toList();
      final hasConstraint = boxes.any((b) => b.constraints.maxHeight == 240);
      expect(hasConstraint, isTrue);
    });

    testWidgets('empty query shows multiple commands', (t) async {
      await t.pumpWidget(
        _app(
          child: CommandPalette(
            query: '',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('merges daemon commands with local commands', (t) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'deploy',
          description: 'Deploy to prod',
          category: CommandCategory.COMMAND_CATEGORY_SERVICE,
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: '',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      // Local commands (exit, clear, etc.) + daemon command.
      expect(find.text('/deploy'), findsOneWidget);
      expect(find.text('/exit'), findsOneWidget);
    });

    testWidgets('daemon command overrides local command with same name', (
      t,
    ) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'exit',
          description: 'Exit (daemon version)',
          category: CommandCategory.COMMAND_CATEGORY_SERVICE,
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: 'exit',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      // Only one /exit entry — daemon version wins.
      expect(find.text('/exit'), findsOneWidget);
      expect(find.text('Exit (daemon version)'), findsOneWidget);
      expect(find.text('End session'), findsNothing);
    });

    testWidgets('shows group headers for grouped daemon commands', (t) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'my-skill',
          description: 'A skill',
          category: CommandCategory.COMMAND_CATEGORY_SKILL,
          group: 'Skills',
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: 'my-skill',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('/my-skill'), findsOneWidget);
    });

    testWidgets('uses displayName as label when present', (t) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'deploy-cmd',
          description: 'Deploy',
          category: CommandCategory.COMMAND_CATEGORY_SERVICE,
          displayName: 'Deploy App',
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: 'deploy',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      // Should show displayName, not raw name.
      expect(find.text('/Deploy App'), findsOneWidget);
      expect(find.text('/deploy-cmd'), findsNothing);
    });

    testWidgets('shows StatusBadge with category label', (t) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'mcp-tool',
          description: 'An MCP tool',
          category: CommandCategory.COMMAND_CATEGORY_MCP,
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: 'mcp-tool',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.byType(StatusBadge), findsOneWidget);
      expect(find.text('MCP'), findsOneWidget);
    });

    testWidgets('filters daemon commands by displayName', (t) async {
      final daemonCommands = AsyncData([
        CommandEntry(
          name: 'xyz-internal',
          description: 'Hidden name',
          category: CommandCategory.COMMAND_CATEGORY_SKILL,
          displayName: 'Pretty Skill',
        ),
      ]);
      await t.pumpWidget(
        _app(
          daemonCommands: daemonCommands,
          child: CommandPalette(
            query: 'Pretty',
            onCommandSelected: (_) {},
            sessionId: null,
          ),
        ),
      );
      await t.pump();
      expect(find.text('/Pretty Skill'), findsOneWidget);
    });
  });
}
