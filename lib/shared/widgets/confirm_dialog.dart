import 'package:flutter/material.dart';

/// Shows a confirmation dialog with a title, content message, and two buttons
/// (Cancel and a configurable confirm label).
///
/// Returns `true` if the user confirmed, `false` if cancelled, or `null` if
/// dismissed.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmLabel = 'Remove',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
