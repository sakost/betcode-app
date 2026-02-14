import 'package:flutter/material.dart';

/// Builds the standard Cancel + confirm [FilledButton] pair used in form
/// dialogs throughout the app.
///
/// [onCancel] defaults to popping the current route with no result.
/// [onConfirm] is called when the confirm button is pressed.
/// [confirmLabel] is the text shown on the confirm button (e.g. 'Create',
/// 'Register').
List<Widget> buildDialogActions(
  BuildContext context, {
  required VoidCallback onConfirm,
  required String confirmLabel,
  VoidCallback? onCancel,
}) {
  return [
    TextButton(
      onPressed: onCancel ?? () => Navigator.of(context).pop(),
      child: const Text('Cancel'),
    ),
    FilledButton(
      onPressed: onConfirm,
      child: Text(confirmLabel),
    ),
  ];
}
