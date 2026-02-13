import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git_repos/notifiers/git_repos_providers.dart';

/// The result returned from [CreateWorktreeDialog] when the user presses
/// Create and validation passes.
class CreateWorktreeResult {
  const CreateWorktreeResult({
    required this.name,
    required this.repoId,
    required this.branch,
    required this.setupScript,
  });

  final String name;
  final String repoId;
  final String branch;
  final String setupScript;
}

/// A dialog with form fields for creating a new worktree.
///
/// Returns a [CreateWorktreeResult] when the user fills in required fields
/// and presses Create, or `null` if cancelled.
class CreateWorktreeDialog extends ConsumerStatefulWidget {
  const CreateWorktreeDialog({super.key});

  @override
  ConsumerState<CreateWorktreeDialog> createState() =>
      _CreateWorktreeDialogState();
}

class _CreateWorktreeDialogState extends ConsumerState<CreateWorktreeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _branchController = TextEditingController();
  final _setupScriptController = TextEditingController();
  String? _selectedRepoId;

  @override
  void dispose() {
    _nameController.dispose();
    _branchController.dispose();
    _setupScriptController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        CreateWorktreeResult(
          name: _nameController.text.trim(),
          repoId: _selectedRepoId!,
          branch: _branchController.text.trim(),
          setupScript: _setupScriptController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reposAsync = ref.watch(gitReposProvider);

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
              reposAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Failed to load repos: $e'),
                data: (repos) => DropdownButtonFormField<String>(
                  initialValue: _selectedRepoId,
                  decoration: const InputDecoration(labelText: 'Repository'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                  items: repos
                      .map(
                        (r) => DropdownMenuItem(
                          value: r.id,
                          child: Text(
                            r.name.isNotEmpty
                                ? r.name
                                : r.repoPath.split('/').last,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRepoId = v),
                ),
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
        FilledButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}
