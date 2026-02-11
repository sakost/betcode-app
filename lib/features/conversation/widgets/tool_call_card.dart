import 'package:flutter/material.dart';

/// A collapsible card showing a tool invocation and its result.
///
/// While the tool is executing, shows a spinner. Once complete, the card
/// can be expanded to reveal the tool output.
class ToolCallCard extends StatelessWidget {
  const ToolCallCard({
    super.key,
    required this.toolName,
    required this.description,
    this.input,
    this.output,
    this.isError = false,
    this.isComplete = false,
    this.durationMs,
  });

  final String toolName;
  final String description;
  final String? input;
  final String? output;
  final bool isError;
  final bool isComplete;
  final int? durationMs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          leading: isComplete
              ? Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? colorScheme.error : Colors.green,
                  size: 20,
                )
              : SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
          title: Text(
            toolName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontFamily: 'JetBrains Mono',
            ),
          ),
          subtitle: Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          trailing: durationMs != null
              ? Text(
                  '${durationMs}ms',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          children: [
            if (input != null)
              _Section(label: 'Input', content: input!, theme: theme),
            if (output != null)
              _Section(
                label: isError ? 'Error' : 'Output',
                content: output!,
                theme: theme,
                isError: isError,
              ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.content,
    required this.theme,
    this.isError = false,
  });

  final String label;
  final String content;
  final ThemeData theme;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isError ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SelectableText(
              content,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'JetBrains Mono',
                color: isError ? colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
