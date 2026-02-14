import 'package:flutter/material.dart';

/// A small colored chip indicating a status.
///
/// Used across multiple card widgets (machine, session, pipeline, issue, merge
/// request) to display a colored badge with a text label. Callers resolve the
/// appropriate [color] and [label] for their domain-specific status value and
/// pass them directly.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.color,
    required this.label,
  });

  /// The semantic color for the badge (both the text and the tinted background).
  final Color color;

  /// The human-readable status text displayed inside the badge.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
