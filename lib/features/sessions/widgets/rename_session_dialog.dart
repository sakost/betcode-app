import 'package:flutter/material.dart';

/// A dialog that lets the user rename a session.
///
/// Returns the trimmed new name on confirm, or `null` on cancel.
class RenameSessionDialog extends StatefulWidget {
  const RenameSessionDialog({super.key, required this.currentName});

  /// The current session name, pre-filled in the text field.
  final String currentName;

  /// Convenience method to show the dialog and return the result.
  static Future<String?> show(
    BuildContext context, {
    required String currentName,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => RenameSessionDialog(currentName: currentName),
    );
  }

  @override
  State<RenameSessionDialog> createState() => _RenameSessionDialogState();
}

class _RenameSessionDialogState extends State<RenameSessionDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Session'),
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Session name',
          hintText: 'Enter a name for this session',
        ),
        onFieldSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            return FilledButton(
              onPressed: value.text.trim().isEmpty ? null : _submit,
              child: const Text('Rename'),
            );
          },
        ),
      ],
    );
  }

  void _submit() {
    final trimmed = _controller.text.trim();
    if (trimmed.isNotEmpty) {
      Navigator.of(context).pop(trimmed);
    }
  }
}
