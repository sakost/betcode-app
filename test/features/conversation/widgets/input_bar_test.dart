import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/widgets/agent_mention_overlay.dart';
import 'package:betcode_app/features/conversation/widgets/command_palette.dart';
import 'package:betcode_app/features/conversation/widgets/input_bar.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

final _agents = <String, AgentInfo>{
  'a1': const AgentInfo(
    id: 'a1',
    name: 'researcher',
    status: AgentStatus.AGENT_STATUS_THINKING,
  ),
  'a2': const AgentInfo(
    id: 'a2',
    name: 'coder',
    status: AgentStatus.AGENT_STATUS_IDLE,
  ),
};

void main() {
  group('InputBar command palette', () {
    testWidgets('typing / shows CommandPalette', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), '/');
      await t.pump();
      expect(find.byType(CommandPalette), findsOneWidget);
    });

    testWidgets('typing /can filters palette to cancel', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), '/can');
      await t.pump();
      expect(find.byType(CommandPalette), findsOneWidget);
      expect(find.text('/cancel'), findsOneWidget);
      expect(find.text('/exit'), findsNothing);
    });

    testWidgets('selecting command calls onSubmit with /command', (t) async {
      String? submitted;
      await t.pumpWidget(_app(InputBar(onSubmit: (s) => submitted = s)));
      await t.enterText(find.byType(TextField), '/exit');
      await t.pump();
      // Tap the ListTile in the palette, not the text in the TextField
      await t.tap(find.byType(ListTile).first);
      await t.pump();
      expect(submitted, '/exit');
    });

    testWidgets('no palette when / is not at start', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), 'hello /exit');
      await t.pump();
      expect(find.byType(CommandPalette), findsNothing);
    });

    testWidgets('palette hides when text is cleared', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), '/');
      await t.pump();
      expect(find.byType(CommandPalette), findsOneWidget);
      await t.enterText(find.byType(TextField), '');
      await t.pump();
      expect(find.byType(CommandPalette), findsNothing);
    });
  });

  group('InputBar @ mentions', () {
    testWidgets('typing @ shows mention overlay when agents provided', (
      t,
    ) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {}, agents: _agents)));
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      expect(find.byType(AgentMentionOverlay), findsOneWidget);
    });

    testWidgets('no overlay when agents is null', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      expect(find.byType(AgentMentionOverlay), findsNothing);
    });

    testWidgets('no overlay when agents is empty', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {}, agents: const {})));
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      expect(find.byType(AgentMentionOverlay), findsNothing);
    });

    testWidgets('selecting agent inserts @name into text', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {}, agents: _agents)));
      await t.enterText(find.byType(TextField), '@cod');
      await t.pump();
      await t.tap(find.text('@coder'));
      await t.pump();
      final controller = t
          .widget<TextField>(find.byType(TextField))
          .controller!;
      expect(controller.text, contains('@coder'));
    });

    testWidgets('selecting agent calls onAgentSelected', (t) async {
      String? selectedId;
      await t.pumpWidget(
        _app(
          InputBar(
            onSubmit: (_) {},
            agents: _agents,
            onAgentSelected: (id) => selectedId = id,
          ),
        ),
      );
      await t.enterText(find.byType(TextField), '@cod');
      await t.pump();
      await t.tap(find.text('@coder'));
      await t.pump();
      expect(selectedId, 'a2');
    });
  });

  group('InputBar paperclip button', () {
    testWidgets('attach file button is present', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });
  });
}
