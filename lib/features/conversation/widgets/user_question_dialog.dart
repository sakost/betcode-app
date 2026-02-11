import 'package:flutter/material.dart';

/// A dialog for answering an agent question with single or multi select options.
///
/// Returns a `Map<String, String>` of selected answers, or null if dismissed.
class UserQuestionDialog extends StatefulWidget {
  const UserQuestionDialog({
    super.key,
    required this.question,
    required this.options,
    required this.multiSelect,
  });

  final String question;
  final List<QuestionOptionData> options;
  final bool multiSelect;

  /// Shows the question dialog and returns the user's answers.
  static Future<Map<String, String>?> show(
    BuildContext context, {
    required String question,
    required List<QuestionOptionData> options,
    required bool multiSelect,
  }) {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UserQuestionDialog(
        question: question,
        options: options,
        multiSelect: multiSelect,
      ),
    );
  }

  @override
  State<UserQuestionDialog> createState() => _UserQuestionDialogState();
}

/// Simple data class for question options to avoid depending on proto types
/// in a pure widget.
class QuestionOptionData {
  const QuestionOptionData({
    required this.value,
    required this.label,
    this.description,
  });

  final String value;
  final String label;
  final String? description;
}

class _UserQuestionDialogState extends State<UserQuestionDialog> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.question),
      content: SingleChildScrollView(
        child: widget.multiSelect
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.options.map((option) {
                  final isSelected = _selected.contains(option.value);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(option.label),
                    subtitle: option.description != null
                        ? Text(
                            option.description!,
                            style: theme.textTheme.bodySmall,
                          )
                        : null,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selected.add(option.value);
                        } else {
                          _selected.remove(option.value);
                        }
                      });
                    },
                  );
                }).toList(),
              )
            : RadioGroup<String>(
                groupValue: _selected.length == 1 ? _selected.first : null,
                onChanged: (String? value) {
                  if (value == null) return;
                  setState(() {
                    _selected
                      ..clear()
                      ..add(value);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.options.map((option) {
                    return RadioListTile<String>(
                      value: option.value,
                      title: Text(option.label),
                      subtitle: option.description != null
                          ? Text(
                              option.description!,
                              style: theme.textTheme.bodySmall,
                            )
                          : null,
                    );
                  }).toList(),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () {
                  final answers = {for (final value in _selected) value: value};
                  Navigator.pop(context, answers);
                },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
