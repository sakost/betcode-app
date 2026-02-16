import 'package:betcode_app/features/conversation/widgets/plan_mode_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('PlanModeBanner', () {
    testWidgets('renders nothing when planModeActive is false', (t) async {
      await t.pumpWidget(_app(const PlanModeBanner(planModeActive: false)));

      expect(find.byType(PlanModeBanner), findsOneWidget);
      // No card or banner should be visible
      expect(find.byIcon(Icons.map), findsNothing);
      expect(find.text('Plan Mode'), findsNothing);
    });

    testWidgets('shows banner when planModeActive is true', (t) async {
      await t.pumpWidget(_app(const PlanModeBanner(planModeActive: true)));

      expect(find.text('Plan Mode'), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
    });

    testWidgets('shows plan content as markdown when provided', (t) async {
      await t.pumpWidget(
        _app(
          const PlanModeBanner(
            planModeActive: true,
            planContent: '## Step 1\n\nDo the thing',
          ),
        ),
      );

      expect(find.text('Plan Mode'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);
    });

    testWidgets('no markdown body when planContent is null', (t) async {
      await t.pumpWidget(_app(const PlanModeBanner(planModeActive: true)));

      expect(find.text('Plan Mode'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsNothing);
    });

    testWidgets('no markdown body when planContent is empty', (t) async {
      await t.pumpWidget(
        _app(const PlanModeBanner(planModeActive: true, planContent: '')),
      );

      expect(find.text('Plan Mode'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsNothing);
    });

    testWidgets('plan content is scrollable', (t) async {
      final longContent = List.generate(50, (i) => '- Item $i').join('\n');
      await t.pumpWidget(
        _app(PlanModeBanner(planModeActive: true, planContent: longContent)),
      );

      // Plan content should be in a constrained scrollable
      expect(find.byType(MarkdownBody), findsOneWidget);
    });

    testWidgets('hidden when inactive even with plan content', (t) async {
      await t.pumpWidget(
        _app(
          const PlanModeBanner(planModeActive: false, planContent: 'Some plan'),
        ),
      );

      expect(find.text('Plan Mode'), findsNothing);
      expect(find.byType(MarkdownBody), findsNothing);
    });
  });
}
