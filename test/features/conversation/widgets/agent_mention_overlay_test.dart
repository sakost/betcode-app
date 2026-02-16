import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/widgets/agent_mention_overlay.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  home: Scaffold(body: SizedBox(height: 600, width: 400, child: child)),
);

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
  'a3': const AgentInfo(
    id: 'a3',
    name: 'tester',
    status: AgentStatus.AGENT_STATUS_IDLE,
  ),
};

void main() {
  group('AgentMentionOverlay', () {
    testWidgets('shows all agents when query is empty', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.text('@researcher'), findsOneWidget);
      expect(find.text('@coder'), findsOneWidget);
      expect(find.text('@tester'), findsOneWidget);
    });

    testWidgets('filters agents by query', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'cod',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.text('@coder'), findsOneWidget);
      expect(find.text('@researcher'), findsNothing);
      expect(find.text('@tester'), findsNothing);
    });

    testWidgets('returns SizedBox.shrink when agents is empty', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: const {},
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('returns SizedBox.shrink when no matches', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'zzz',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('tapping agent calls onAgentSelected with agent id', (t) async {
      String? selectedId;
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'coder',
            onAgentSelected: (id) => selectedId = id,
          ),
        ),
      );
      await t.tap(find.text('@coder'));
      await t.pump();
      expect(selectedId, 'a2');
    });

    testWidgets('uses Material with elevation 4', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      final materials = t.widgetList<Material>(find.byType(Material)).toList();
      final hasMaterialWith4 = materials.any((m) => m.elevation == 4);
      expect(hasMaterialWith4, isTrue);
    });

    testWidgets('has ConstrainedBox with maxHeight 200', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      final boxes = t
          .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
          .toList();
      final hasConstraint = boxes.any((b) => b.constraints.maxHeight == 200);
      expect(hasConstraint, isTrue);
    });

    testWidgets('filter is case-insensitive', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'COD',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.text('@coder'), findsOneWidget);
    });
  });
}
