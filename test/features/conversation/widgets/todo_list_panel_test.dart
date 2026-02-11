import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/widgets/todo_list_panel.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

TodoItem _item({
  String id = '1',
  String subject = 'Task',
  String description = '',
  String activeForm = '',
  TodoStatus status = TodoStatus.TODO_STATUS_PENDING,
}) =>
    TodoItem(
      id: id,
      subject: subject,
      description: description,
      activeForm: activeForm,
      status: status,
    );

void main() {
  group('TodoListPanel', () {
    testWidgets('renders nothing when todo list is empty', (t) async {
      await t.pumpWidget(_app(const TodoListPanel(todos: [])));

      // The widget should produce an empty SizedBox (nothing visible).
      expect(find.byType(TodoListPanel), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets('shows count badge with completed / total', (t) async {
      final todos = [
        _item(id: '1', subject: 'A', status: TodoStatus.TODO_STATUS_COMPLETED),
        _item(id: '2', subject: 'B', status: TodoStatus.TODO_STATUS_PENDING),
        _item(id: '3', subject: 'C', status: TodoStatus.TODO_STATUS_IN_PROGRESS),
        _item(id: '4', subject: 'D', status: TodoStatus.TODO_STATUS_COMPLETED),
        _item(id: '5', subject: 'E', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Should show "2/5 done"
      expect(find.text('2/5 done'), findsOneWidget);
    });

    testWidgets('pending item shows unchecked checkbox icon', (t) async {
      final todos = [
        _item(subject: 'Pending task', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Expand the panel
      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      expect(find.text('Pending task'), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    testWidgets('in-progress item shows spinning indicator', (t) async {
      final todos = [
        _item(
          subject: 'Working on it',
          activeForm: 'Working...',
          status: TodoStatus.TODO_STATUS_IN_PROGRESS,
        ),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Expand the panel. Use pump(duration) instead of pumpAndSettle because
      // the spinner animation never settles.
      await t.tap(find.byType(ExpansionTile));
      await t.pump(const Duration(milliseconds: 300));

      expect(find.text('Working on it'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('completed item shows check icon', (t) async {
      final todos = [
        _item(subject: 'Done task', status: TodoStatus.TODO_STATUS_COMPLETED),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Expand the panel
      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      expect(find.text('Done task'), findsOneWidget);
      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });

    testWidgets('unspecified status treated as pending', (t) async {
      final todos = [
        _item(subject: 'Unknown', status: TodoStatus.TODO_STATUS_UNSPECIFIED),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    testWidgets('description shown as subtitle when expanded', (t) async {
      final todos = [
        _item(
          subject: 'Fix bug',
          description: 'Detailed description of bug',
          status: TodoStatus.TODO_STATUS_PENDING,
        ),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Expand the panel
      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      expect(find.text('Detailed description of bug'), findsOneWidget);
    });

    testWidgets('empty description not shown', (t) async {
      final todos = [
        _item(subject: 'No desc', description: '', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      expect(find.text('No desc'), findsOneWidget);
      // Only the subject text, no subtitle with empty string
    });

    testWidgets('multiple items rendered in order', (t) async {
      final todos = [
        _item(id: '1', subject: 'First', status: TodoStatus.TODO_STATUS_COMPLETED),
        _item(id: '2', subject: 'Second', status: TodoStatus.TODO_STATUS_IN_PROGRESS),
        _item(id: '3', subject: 'Third', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Expand the panel. Use pump(duration) instead of pumpAndSettle because
      // the in-progress spinner animation never settles.
      await t.tap(find.byType(ExpansionTile));
      await t.pump(const Duration(milliseconds: 300));

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
    });

    testWidgets('panel is initially collapsed', (t) async {
      final todos = [
        _item(subject: 'Hidden item', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Items should not be visible before expanding
      expect(find.text('Hidden item'), findsNothing);
    });

    testWidgets('panel can be expanded and collapsed', (t) async {
      final todos = [
        _item(subject: 'Toggle item', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      // Initially collapsed
      expect(find.text('Toggle item'), findsNothing);

      // Expand
      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();
      expect(find.text('Toggle item'), findsOneWidget);

      // Collapse
      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();
      expect(find.text('Toggle item'), findsNothing);
    });

    testWidgets('in-progress item shows activeForm as subtitle', (t) async {
      final todos = [
        _item(
          subject: 'Run tests',
          activeForm: 'Running tests',
          description: 'Execute the test suite',
          status: TodoStatus.TODO_STATUS_IN_PROGRESS,
        ),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      await t.tap(find.byType(ExpansionTile));
      await t.pump(const Duration(milliseconds: 300));

      // activeForm should be shown instead of description for in-progress items
      expect(find.text('Running tests'), findsOneWidget);
      expect(find.text('Execute the test suite'), findsNothing);
    });

    testWidgets('pending item shows description not activeForm', (t) async {
      final todos = [
        _item(
          subject: 'Fix bug',
          activeForm: 'Fixing bug',
          description: 'A real description',
          status: TodoStatus.TODO_STATUS_PENDING,
        ),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      await t.tap(find.byType(ExpansionTile));
      await t.pumpAndSettle();

      // For non-in-progress items, description takes precedence
      expect(find.text('A real description'), findsOneWidget);
      expect(find.text('Fixing bug'), findsNothing);
    });

    testWidgets('shows todos icon in header', (t) async {
      final todos = [
        _item(subject: 'Task', status: TodoStatus.TODO_STATUS_PENDING),
      ];
      await t.pumpWidget(_app(TodoListPanel(todos: todos)));

      expect(find.byIcon(Icons.checklist), findsOneWidget);
    });
  });
}
