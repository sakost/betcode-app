import 'package:flutter/material.dart';

/// The three possible decisions for a permission request.
enum PermissionChoice { allowOnce, allowSession, deny }

/// A bottom sheet that presents a tool permission request to the user.
///
/// Returns a [PermissionChoice] when the user makes a decision, or null
/// if dismissed.
class PermissionSheet extends StatelessWidget {
  const PermissionSheet({
    super.key,
    required this.toolName,
    required this.description,
    this.input,
  });

  final String toolName;
  final String description;
  final String? input;

  /// Shows the permission sheet and returns the user's decision.
  static Future<PermissionChoice?> show(
    BuildContext context, {
    required String toolName,
    required String description,
    String? input,
  }) {
    return showModalBottomSheet<PermissionChoice>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PermissionSheet(
        toolName: toolName,
        description: description,
        input: input,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Row(
              children: [
                Icon(Icons.security, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Permission Required',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tool info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toolName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: theme.textTheme.bodySmall),
                  if (input != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      input!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'JetBrains Mono',
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, PermissionChoice.deny),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                    child: const Text('Deny'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, PermissionChoice.allowOnce),
                    child: const Text('Allow Once'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pop(context, PermissionChoice.allowSession),
                    child: const Text('Allow Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
