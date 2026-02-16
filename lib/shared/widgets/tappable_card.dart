import 'package:flutter/material.dart';

/// A reusable tappable card with consistent styling across the app.
///
/// Wraps a [Card] with [InkWell] and [Padding], providing the standard card
/// appearance used throughout machine, session, GitLab, and git repo lists.
///
/// Supports optional [onTap], [onLongPress], and an [isSelected] state that
/// shows a primary-colored border.
class TappableCard extends StatelessWidget {
  /// Creates a [TappableCard] wrapping [child] with optional tap handlers.
  const TappableCard({
    required this.child,
    super.key,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  /// The content displayed inside the card.
  final Widget child;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Called when the card is long-pressed.
  final VoidCallback? onLongPress;

  /// When true, a primary-colored border is shown around the card.
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
        child: Padding(padding: const EdgeInsets.all(14), child: child),
      ),
    );
  }
}
