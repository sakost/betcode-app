import 'package:flutter/material.dart';

/// A compact row with a leading [icon] and a text [label], styled in
/// `onSurfaceVariant`. Used for metadata rows in card widgets (e.g. author,
/// source, branch info).
class IconLabelRow extends StatelessWidget {
  const IconLabelRow({
    super.key,
    required this.icon,
    required this.label,
    this.expanded = false,
  });

  /// The leading icon.
  final IconData icon;

  /// The text to display next to the icon.
  final String label;

  /// When true, the label is wrapped in [Expanded] to allow ellipsis on
  /// overflow. Defaults to false.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    final textWidget = Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        if (expanded) Expanded(child: textWidget) else textWidget,
      ],
    );
  }
}
