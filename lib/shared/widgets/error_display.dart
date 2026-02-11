import 'package:flutter/material.dart';

/// A widget that displays an error state with an icon, message, and an
/// optional retry button.
///
/// Designed to pair with Riverpod's `AsyncValue.error` — pass the error
/// object and stack trace directly.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  /// The error object to display. Its [toString] value is shown as the
  /// error message.
  final Object error;

  /// Optional stack trace for debugging. Currently not rendered in the UI
  /// but available for logging or debug builds.
  final StackTrace? stackTrace;

  /// When provided, a "Retry" button is shown that invokes this callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
