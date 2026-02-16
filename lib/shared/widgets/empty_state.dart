import 'package:flutter/material.dart';

/// A reusable empty-state placeholder shown when a list has no items.
///
/// Displays a centered column with a large [icon], a [title], and a [subtitle].
/// Used across multiple screens (repos, machines, sessions, worktrees, etc.)
/// to provide a consistent "nothing here yet" experience.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState] with the given [icon], [title], and optional
  /// [subtitle].
  const EmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
  });

  /// The large icon displayed at the top of the empty state.
  final IconData icon;

  /// The primary text (e.g. "No repositories").
  final String title;

  /// The optional secondary explanatory text
  /// (e.g. "Register a git repository...").
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
