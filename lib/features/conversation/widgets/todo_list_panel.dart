import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/common.pb.dart';

/// A collapsible panel that displays the agent's todo list.
///
/// Shows between the app bar and message list when [todos] is non-empty.
/// Each item displays a status icon (unchecked, spinner, or checked) and
/// the subject as title. Description is shown as subtitle when expanded.
/// A count badge (e.g. "3/5 done") appears in the header.
class TodoListPanel extends StatelessWidget {
  const TodoListPanel({super.key, required this.todos});

  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) return const SizedBox.shrink();

    final completed = todos
        .where((t) => t.status == TodoStatus.TODO_STATUS_COMPLETED)
        .length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: const Icon(Icons.checklist),
        title: Row(
          children: [
            const Text('Todos'),
            const SizedBox(width: 8),
            Text(
              '$completed/${todos.length} done',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        children: [for (final item in todos) _TodoItemTile(item: item)],
      ),
    );
  }
}

class _TodoItemTile extends StatelessWidget {
  const _TodoItemTile({required this.item});

  final TodoItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: _buildStatusIcon(colorScheme),
      title: Text(
        item.subject,
        style: theme.textTheme.bodyMedium?.copyWith(
          decoration: item.status == TodoStatus.TODO_STATUS_COMPLETED
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: _buildSubtitle(),
      dense: true,
    );
  }

  /// For in-progress items, prefer activeForm (e.g. "Running tests") over
  /// description. For other statuses, show description when non-empty.
  Widget? _buildSubtitle() {
    if (item.status == TodoStatus.TODO_STATUS_IN_PROGRESS &&
        item.activeForm.isNotEmpty) {
      return Text(item.activeForm);
    }
    if (item.description.isNotEmpty) return Text(item.description);
    return null;
  }

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    if (item.status == TodoStatus.TODO_STATUS_COMPLETED) {
      return Icon(Icons.check_box, color: colorScheme.primary, size: 20);
    }
    if (item.status == TodoStatus.TODO_STATUS_IN_PROGRESS) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.primary,
        ),
      );
    }
    // PENDING, UNSPECIFIED, or any other status
    return Icon(
      Icons.check_box_outline_blank,
      color: colorScheme.onSurfaceVariant,
      size: 20,
    );
  }
}
