import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:betcode_app/features/conversation/widgets/input_bar.dart';
import 'package:betcode_app/features/conversation/widgets/message_bubble.dart';
import 'package:betcode_app/features/conversation/widgets/permission_sheet.dart';
import 'package:betcode_app/features/conversation/widgets/status_indicator.dart';
import 'package:betcode_app/features/conversation/widgets/tool_call_card.dart';
import 'package:betcode_app/features/conversation/widgets/usage_display.dart';
import 'package:betcode_app/features/conversation/widgets/user_question_dialog.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

Widget _dialogHost(VoidCallback onPressed) => MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: onPressed.call,
            child: const Text('Open'),
          ),
        ),
      ),
    );

final _qOptions = [
  const QuestionOptionData(value: 'a', label: 'Option A'),
  const QuestionOptionData(value: 'b', label: 'Option B', description: 'B desc'),
  const QuestionOptionData(value: 'c', label: 'Option C'),
];

void main() {
  // -- MessageBubble --
  group('MessageBubble', () {
    testWidgets('user message right-aligned, plain Text', (t) async {
      await t.pumpWidget(_app(const MessageBubble(content: 'hi', isUser: true)));
      expect(t.widget<Align>(find.byType(Align)).alignment, Alignment.centerRight);
      expect(find.text('hi'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsNothing);
    });
    testWidgets('agent message left-aligned, MarkdownBody', (t) async {
      await t.pumpWidget(_app(const MessageBubble(content: '**bold**', isUser: false)));
      expect(t.widget<Align>(find.byType(Align)).alignment, Alignment.centerLeft);
      expect(find.byType(MarkdownBody), findsOneWidget);
    });
    testWidgets('streaming indicator shown/hidden', (t) async {
      await t.pumpWidget(_app(const MessageBubble(content: 'x', isUser: false, isStreaming: true)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await t.pumpWidget(_app(const MessageBubble(content: 'x', isUser: false)));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // -- ToolCallCard --
  group('ToolCallCard', () {
    testWidgets('shows name, description, initially collapsed', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(
        toolName: 'Read', description: 'Read file', output: 'data', isComplete: true,
      )));
      expect(find.text('Read'), findsOneWidget);
      expect(find.text('Read file'), findsOneWidget);
      expect(find.text('data'), findsNothing); // collapsed
    });
    testWidgets('loading indicator when not complete', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(toolName: 'B', description: 'd')));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('shows output when expanded', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(
        toolName: 'R', description: 'd', output: 'contents', isComplete: true,
      )));
      await t.tap(find.text('R'));
      await t.pumpAndSettle();
      expect(find.text('contents'), findsOneWidget);
    });
    testWidgets('error styling: error icon and Error label', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(
        toolName: 'B', description: 'd', output: 'err', isError: true, isComplete: true,
      )));
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      await t.tap(find.text('B'));
      await t.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });
    testWidgets('check icon when complete without error', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(toolName: 'B', description: 'd', isComplete: true)));
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });
    testWidgets('duration displayed', (t) async {
      await t.pumpWidget(_app(const ToolCallCard(
        toolName: 'B', description: 'd', isComplete: true, durationMs: 350,
      )));
      expect(find.text('350ms'), findsOneWidget);
    });
  });

  // -- StatusIndicator --
  group('StatusIndicator', () {
    final cases = {
      AgentStatus.AGENT_STATUS_THINKING: ('Thinking...', AppColors.agentThinking),
      AgentStatus.AGENT_STATUS_EXECUTING_TOOL: ('Executing tool...', AppColors.agentExecuting),
      AgentStatus.AGENT_STATUS_WAITING_FOR_USER: ('Waiting for you', AppColors.agentWaiting),
      AgentStatus.AGENT_STATUS_IDLE: ('Idle', AppColors.agentIdle),
      AgentStatus.AGENT_STATUS_COMPACTING: ('Compacting...', AppColors.agentThinking),
      AgentStatus.AGENT_STATUS_ERROR: ('Error', AppColors.agentError),
    };
    for (final e in cases.entries) {
      testWidgets('status "${e.key}" -> label "${e.value.$1}" with correct color', (t) async {
        await t.pumpWidget(_app(StatusIndicator(status: e.key)));
        expect(find.text(e.value.$1), findsOneWidget);
        expect(t.widget<Icon>(find.byType(Icon)).color, e.value.$2);
      });
    }
    testWidgets('unknown status shows "Unknown"', (t) async {
      await t.pumpWidget(_app(StatusIndicator(status: AgentStatus.AGENT_STATUS_UNSPECIFIED)));
      expect(find.text('Unknown'), findsOneWidget);
    });
  });

  // -- UsageDisplay --
  group('UsageDisplay', () {
    testWidgets('tokens >= 1000 formatted with k suffix', (t) async {
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 1500, outputTokens: 2300, costUsd: 0.0042)));
      expect(find.text(' 1.5k'), findsOneWidget);
      expect(find.text(' 2.3k'), findsOneWidget);
    });
    testWidgets('tokens < 1000 as plain integers', (t) async {
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 500, outputTokens: 42, costUsd: 0.001)));
      expect(find.text(' 500'), findsOneWidget);
      expect(find.text(' 42'), findsOneWidget);
    });
    testWidgets('cost with 4 decimal places', (t) async {
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 0, outputTokens: 0, costUsd: 0.1234)));
      expect(find.text('\$0.1234'), findsOneWidget);
    });
    testWidgets('model shown/hidden', (t) async {
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 0, outputTokens: 0, costUsd: 0, model: 'opus')));
      expect(find.text('opus'), findsOneWidget);
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 0, outputTokens: 0, costUsd: 0)));
      expect(find.text('opus'), findsNothing);
    });
    testWidgets('duration shown/hidden', (t) async {
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 0, outputTokens: 0, costUsd: 0, durationMs: 3500)));
      expect(find.text('3.5s'), findsOneWidget);
      await t.pumpWidget(_app(const UsageDisplay(inputTokens: 0, outputTokens: 0, costUsd: 0)));
      expect(find.text('3.5s'), findsNothing);
    });
  });

  // -- InputBar --
  group('InputBar', () {
    testWidgets('send disabled when empty, enabled with text', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      expect(t.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
      await t.enterText(find.byType(TextField), 'hello');
      await t.pump();
      expect(t.widget<IconButton>(find.byType(IconButton)).onPressed, isNotNull);
    });
    testWidgets('onSubmit called with trimmed text, field cleared', (t) async {
      String? submitted;
      await t.pumpWidget(_app(InputBar(onSubmit: (s) => submitted = s)));
      await t.enterText(find.byType(TextField), '  hello  ');
      await t.pump();
      await t.tap(find.byType(IconButton));
      await t.pump();
      expect(submitted, 'hello');
      expect(t.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
    });
    testWidgets('disabled state prevents interaction', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {}, enabled: false)));
      expect(t.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(t.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
    });
    testWidgets('whitespace-only text keeps send disabled', (t) async {
      await t.pumpWidget(_app(InputBar(onSubmit: (_) {})));
      await t.enterText(find.byType(TextField), '   ');
      await t.pump();
      expect(t.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
    });
  });

  // -- UserQuestionDialog --
  group('UserQuestionDialog', () {
    testWidgets('single select shows RadioListTile, submit disabled until selected', (t) async {
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () => UserQuestionDialog.show(ctx, question: 'Pick', options: _qOptions, multiSelect: false),
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(find.byType(RadioListTile<String>), findsNWidgets(3));
      expect(find.byType(CheckboxListTile), findsNothing);
      expect(t.widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit')).onPressed, isNull);
      await t.tap(find.text('Option A'));
      await t.pumpAndSettle();
      expect(t.widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit')).onPressed, isNotNull);
    });
    testWidgets('multi select shows CheckboxListTile', (t) async {
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () => UserQuestionDialog.show(ctx, question: 'Pick', options: _qOptions, multiSelect: true),
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(find.byType(CheckboxListTile), findsNWidgets(3));
    });
    testWidgets('cancel returns null', (t) async {
      Map<String, String>? result = const {'x': 'y'};
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () async { result = await UserQuestionDialog.show(ctx, question: 'Q', options: _qOptions, multiSelect: false); },
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();
      expect(result, isNull);
    });
    testWidgets('submit returns selected answers map', (t) async {
      Map<String, String>? result;
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () async { result = await UserQuestionDialog.show(ctx, question: 'Q', options: _qOptions, multiSelect: false); },
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.tap(find.text('Option B'));
      await t.pumpAndSettle();
      await t.tap(find.text('Submit'));
      await t.pumpAndSettle();
      expect(result, {'b': 'b'});
    });
    testWidgets('multi select submit returns multiple answers', (t) async {
      Map<String, String>? result;
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () async { result = await UserQuestionDialog.show(ctx, question: 'Q', options: _qOptions, multiSelect: true); },
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.tap(find.text('Option A'));
      await t.pumpAndSettle();
      await t.tap(find.text('Option C'));
      await t.pumpAndSettle();
      await t.tap(find.text('Submit'));
      await t.pumpAndSettle();
      expect(result, {'a': 'a', 'c': 'c'});
    });
    testWidgets('option description displayed', (t) async {
      await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
        onPressed: () => UserQuestionDialog.show(ctx, question: 'Q', options: _qOptions, multiSelect: false),
        child: const Text('Open'),
      )))));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(find.text('B desc'), findsOneWidget);
    });
  });

  // -- PermissionSheet --
  group('PermissionSheet', () {
    testWidgets('shows tool name, description, and all buttons', (t) async {
      await t.pumpWidget(_app(const PermissionSheet(toolName: 'Bash', description: 'Run cmd')));
      expect(find.text('Bash'), findsOneWidget);
      expect(find.text('Run cmd'), findsOneWidget);
      expect(find.text('Permission Required'), findsOneWidget);
      expect(find.text('Allow Once'), findsOneWidget);
      expect(find.text('Allow Session'), findsOneWidget);
      expect(find.text('Deny'), findsOneWidget);
    });
    testWidgets('shows input when provided', (t) async {
      await t.pumpWidget(_app(const PermissionSheet(toolName: 'B', description: 'd', input: 'rm -rf')));
      expect(find.text('rm -rf'), findsOneWidget);
    });

    for (final entry in {
      'Allow Once': PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE,
      'Allow Session': PermissionDecision.PERMISSION_DECISION_ALLOW_SESSION,
      'Deny': PermissionDecision.PERMISSION_DECISION_DENY,
    }.entries) {
      testWidgets('${entry.key} returns ${entry.value}', (t) async {
        PermissionDecision? result;
        await t.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
          onPressed: () async { result = await PermissionSheet.show(ctx, toolName: 'B', description: 'd'); },
          child: const Text('Open'),
        )))));
        await t.tap(find.text('Open'));
        await t.pumpAndSettle();
        await t.tap(find.text(entry.key));
        await t.pumpAndSettle();
        expect(result, entry.value);
      });
    }
  });
}
