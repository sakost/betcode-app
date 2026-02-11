import 'package:flutter/material.dart';

/// The result returned from [CreateWorktreeDialog] when the user presses
/// Create and validation passes.
class CreateWorktreeResult {
  const CreateWorktreeResult({
    required this.name,
    required this.repoPath,
    required this.branch,
    required this.setupScript,
  });

  final String name;
  final String repoPath;
  final String branch;
  final String setupScript;
}

/// A dialog with form fields for creating a new worktree.
///
/// Returns a [CreateWorktreeResult] when the user fills in required fields
/// and presses Create, or `null` if cancelled.
class CreateWorktreeDialog extends StatefulWidget {
  const CreateWorktreeDialog({super.key});

  @override
  State<CreateWorktreeDialog> createState() => _CreateWorktreeDialogState();
}

class _CreateWorktreeDialogState extends State<CreateWorktreeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _repoPathController = TextEditingController();
  final _branchController = TextEditingController();
  final _setupScriptController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _repoPathController.dispose();
    _branchController.dispose();
    _setupScriptController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(CreateWorktreeResult(
        name: _nameController.text.trim(),
        repoPath: _repoPathController.text.trim(),
        branch: _branchController.text.trim(),
        setupScript: _setupScriptController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Worktree'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _repoPathController,
                decoration:
                    const InputDecoration(labelText: 'Repository Path'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _branchController,
                decoration: const InputDecoration(labelText: 'Branch'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _setupScriptController,
                decoration: const InputDecoration(labelText: 'Setup Script'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
