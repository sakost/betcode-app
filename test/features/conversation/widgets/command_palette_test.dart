import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:betcode_app/features/conversation/widgets/command_palette.dart';
import 'package:betcode_app/features/conversation/models/input_command.dart';

Widget _app(Widget child) => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600,
          width: 400,
          child: child,
        ),
      ),
    );

void main() {
  group('CommandPalette', () {
    testWidgets('shows filtered commands with /name format', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'exit', onCommandSelected: (_) {})),
      );
      expect(find.text('/exit'), findsOneWidget);
      expect(find.text('End session'), findsOneWidget);
    });

    testWidgets('filters commands by query', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'can', onCommandSelected: (_) {})),
      );
      expect(find.text('/cancel'), findsOneWidget);
      expect(find.text('/exit'), findsNothing);
    });

    testWidgets('returns SizedBox.shrink when no matches', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'zzzz', onCommandSelected: (_) {})),
      );
      final palette = find.byType(CommandPalette);
      expect(palette, findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('tapping a command calls onCommandSelected', (t) async {
      InputCommand? selected;
      await t.pumpWidget(
        _app(
          CommandPalette(
            query: 'exit',
            onCommandSelected: (cmd) => selected = cmd,
          ),
        ),
      );
      await t.tap(find.text('/exit'));
      await t.pump();
      expect(selected, isNotNull);
      expect(selected!.name, 'exit');
    });

    testWidgets('shows category chip for a command', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'exit', onCommandSelected: (_) {})),
      );
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('uses Material with elevation 4', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'exit', onCommandSelected: (_) {})),
      );
      final materials = t.widgetList<Material>(find.byType(Material)).toList();
      final hasMaterialWith4 = materials.any((m) => m.elevation == 4);
      expect(hasMaterialWith4, isTrue);
    });

    testWidgets('has ConstrainedBox with maxHeight 240', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: 'exit', onCommandSelected: (_) {})),
      );
      final boxes =
          t.widgetList<ConstrainedBox>(find.byType(ConstrainedBox)).toList();
      final hasConstraint =
          boxes.any((b) => b.constraints.maxHeight == 240);
      expect(hasConstraint, isTrue);
    });

    testWidgets('empty query shows multiple commands', (t) async {
      await t.pumpWidget(
        _app(CommandPalette(query: '', onCommandSelected: (_) {})),
      );
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
