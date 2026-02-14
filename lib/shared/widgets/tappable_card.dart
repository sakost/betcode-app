import 'package:flutter/material.dart';

/// A reusable tappable card with consistent styling across the app.
///
/// Wraps a [Card] with [InkWell] and [Padding], providing the standard card
/// appearance used throughout machine, session, GitLab, and git repo lists.
///
/// Supports optional [onTap], [onLongPress], and an [isSelected] state that
/// shows a primary-colored border.
class TappableCard extends StatelessWidget {
  const TappableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.primary, width: 2),
            )
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: child,
        ),
      ),
    );
  }
}
