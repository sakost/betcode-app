import 'package:flutter/material.dart';

/// The result returned from [RegisterRepoDialog] when the user presses
/// Register and validation passes.
class RegisterRepoResult {
  const RegisterRepoResult({
    required this.repoPath,
    required this.name,
    required this.worktreeMode,
    required this.setupScript,
  });

  final String repoPath;
  final String name;
  final String worktreeMode;
  final String setupScript;
}

/// A dialog with form fields for registering a new git repository.
///
/// Returns a [RegisterRepoResult] when the user fills in required fields
/// and presses Register, or `null` if cancelled.
class RegisterRepoDialog extends StatefulWidget {
  const RegisterRepoDialog({super.key});

  @override
  State<RegisterRepoDialog> createState() => _RegisterRepoDialogState();
}

class _RegisterRepoDialogState extends State<RegisterRepoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _repoPathController = TextEditingController();
  final _nameController = TextEditingController();
  final _setupScriptController = TextEditingController();
  String _worktreeMode = 'global';

  static const _worktreeModes = ['global', 'local', 'custom'];

  @override
  void dispose() {
    _repoPathController.dispose();
    _nameController.dispose();
    _setupScriptController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        RegisterRepoResult(
          repoPath: _repoPathController.text.trim(),
          name: _nameController.text.trim(),
          worktreeMode: _worktreeMode,
          setupScript: _setupScriptController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register Repository'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _repoPathController,
                decoration: const InputDecoration(
                  labelText: 'Repository Path',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name (optional)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _worktreeMode,
                decoration: const InputDecoration(
                  labelText: 'Worktree Mode',
                ),
                items: _worktreeModes
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(mode),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _worktreeMode = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _setupScriptController,
                decoration: const InputDecoration(
                  labelText: 'Setup Script (optional)',
                ),
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
        FilledButton(onPressed: _submit, child: const Text('Register')),
      ],
    );
  }
}
