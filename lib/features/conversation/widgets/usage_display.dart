import 'package:flutter/material.dart';

/// Displays token usage and cost for the current conversation turn.
class UsageDisplay extends StatelessWidget {
  const UsageDisplay({
    required this.inputTokens,
    required this.outputTokens,
    required this.costUsd,
    super.key,
    this.model,
    this.durationMs,
  });

  final int inputTokens;
  final int outputTokens;
  final double costUsd;
  final String? model;
  final int? durationMs;

  String _formatTokens(int tokens) {
    if (tokens >= 1000) {
      return '${(tokens / 1000).toStringAsFixed(1)}k';
    }
    return tokens.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (model != null) ...[
            Text(model!, style: labelStyle),
            _dot(colorScheme),
          ],
          Icon(
            Icons.arrow_upward,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          Text(' ${_formatTokens(inputTokens)}', style: labelStyle),
          _dot(colorScheme),
          Icon(
            Icons.arrow_downward,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          Text(' ${_formatTokens(outputTokens)}', style: labelStyle),
          _dot(colorScheme),
          Text('\$${costUsd.toStringAsFixed(4)}', style: labelStyle),
          if (durationMs != null) ...[
            _dot(colorScheme),
            Text(
              '${(durationMs! / 1000).toStringAsFixed(1)}s',
              style: labelStyle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _dot(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '\u00b7',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
