import 'package:betcode_app/features/git_repos/notifiers/branches_provider.dart';
import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:betcode_app/shared/widgets/dialog_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
///
/// When [initialRepoId] is provided, the repo dropdown is pre-selected and
/// the setup script is pre-filled from the repo's configuration.
class CreateWorktreeDialog extends ConsumerStatefulWidget {
  const CreateWorktreeDialog({this.initialRepoId, super.key});

  /// When set, the repo dropdown starts with this repo selected and the
  /// setup script is pre-filled from the repo's [GitRepoDetail.setupScript].
  final String? initialRepoId;

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

  /// Whether the user has manually edited the setup script field.
  /// When true, repo changes no longer auto-fill the script.
  bool _setupScriptManuallyEdited = false;

  /// Tracks the branch name entered by the user. Updated both by autocomplete
  /// selection and manual typing.
  String? _selectedBranchName;

  @override
  void initState() {
    super.initState();
    _selectedRepoId = widget.initialRepoId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _branchController.dispose();
    _setupScriptController.dispose();
    super.dispose();
  }

  void _onRepoChanged(String? repoId, List<GitRepoDetail> repos) {
    setState(() {
      _selectedRepoId = repoId;
      // Clear the branch field when switching repos.
      _branchController.clear();
      _selectedBranchName = null;
    });
    _maybePreFillSetupScript(repoId, repos);
  }

  void _maybePreFillSetupScript(String? repoId, List<GitRepoDetail> repos) {
    if (_setupScriptManuallyEdited || repoId == null) return;
    final repo = repos.where((r) => r.id == repoId).firstOrNull;
    if (repo != null && repo.setupScript.isNotEmpty) {
      _setupScriptController.text = repo.setupScript;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        CreateWorktreeResult(
          name: _nameController.text.trim(),
          repoId: _selectedRepoId!,
          branch: (_selectedBranchName ?? _branchController.text).trim(),
          setupScript: _setupScriptController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reposAsync = ref.watch(gitReposProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('New Worktree'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -- Name --
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // -- Repository dropdown --
              reposAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Failed to load repos: $e'),
                data: (repos) {
                  // Pre-fill setup script on first build when initialRepoId
                  // is provided.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _maybePreFillSetupScript(_selectedRepoId, repos);
                  });

                  return DropdownButtonFormField<String>(
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
                    onChanged: (v) => _onRepoChanged(v, repos),
                  );
                },
              ),
              const SizedBox(height: 12),

              // -- Branch autocomplete --
              _BranchField(
                controller: _branchController,
                repoId: _selectedRepoId,
                onSelected: (branch) {
                  _selectedBranchName = branch.name;
                  _branchController.text = branch.name;
                },
                theme: theme,
              ),
              const SizedBox(height: 12),

              // -- Setup Script --
              TextFormField(
                controller: _setupScriptController,
                decoration: const InputDecoration(labelText: 'Setup Script'),
                maxLines: 3,
                onChanged: (_) => _setupScriptManuallyEdited = true,
              ),
            ],
          ),
        ),
      ),
      actions: buildDialogActions(
        context,
        onConfirm: _submit,
        confirmLabel: 'Create',
      ),
    );
  }
}

/// Branch autocomplete field that loads suggestions from [branchesProvider].
///
/// Disabled when no repo is selected. Shows existing branches with indicators
/// for HEAD and worktree status. If the typed text doesn't match any branch,
/// a "Create new branch" option appears.
class _BranchField extends ConsumerWidget {
  const _BranchField({
    required this.controller,
    required this.repoId,
    required this.onSelected,
    required this.theme,
  });

  final TextEditingController controller;
  final String? repoId;
  final ValueChanged<BranchInfo> onSelected;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (repoId == null) {
      return TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          labelText: 'Branch',
          hintText: 'Select a repository first',
        ),
      );
    }

    final branchesAsync = ref.watch(branchesProvider(repoId!));

    return branchesAsync.when(
      loading: () => TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Branch'),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
      error: (_, _) => TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Branch'),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
      data: (branches) => _BranchAutocomplete(
        controller: controller,
        branches: branches,
        onSelected: onSelected,
        theme: theme,
      ),
    );
  }
}

/// The actual [Autocomplete] widget for branch selection.
///
/// Manages its own [FocusNode] because Flutter's [Autocomplete] requires
/// both `textEditingController` and `focusNode` to be provided together.
class _BranchAutocomplete extends StatefulWidget {
  const _BranchAutocomplete({
    required this.controller,
    required this.branches,
    required this.onSelected,
    required this.theme,
  });

  final TextEditingController controller;
  final List<BranchInfo> branches;
  final ValueChanged<BranchInfo> onSelected;
  final ThemeData theme;

  @override
  State<_BranchAutocomplete> createState() => _BranchAutocompleteState();
}

class _BranchAutocompleteState extends State<_BranchAutocomplete> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<BranchInfo>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.toLowerCase().trim();
        if (query.isEmpty) return widget.branches;

        final matches = widget.branches
            .where((b) => b.name.toLowerCase().contains(query))
            .toList();

        // If no exact match, add a synthetic "create new" option.
        final hasExactMatch = widget.branches.any(
          (b) => b.name.toLowerCase() == query,
        );
        if (!hasExactMatch && query.isNotEmpty) {
          matches.insert(0, BranchInfo(name: query));
        }

        return matches;
      },
      displayStringForOption: (branch) => branch.name,
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, textController, focusNode, onSubmitted) {
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          decoration: const InputDecoration(labelText: 'Branch'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
          onFieldSubmitted: (_) => onSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final branch = options.elementAt(index);
                  final isNew = !widget.branches.contains(branch);

                  return ListTile(
                    dense: true,
                    title: Text(
                      isNew
                          ? 'Create new branch: ${branch.name}'
                          : branch.name,
                      style: isNew
                          ? TextStyle(
                              fontStyle: FontStyle.italic,
                              color: widget.theme.colorScheme.primary,
                            )
                          : null,
                    ),
                    trailing: _buildTrailing(branch, isNew),
                    onTap: () => onSelected(branch),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? _buildTrailing(BranchInfo branch, bool isNew) {
    if (isNew) return null;

    final chips = <Widget>[];
    if (branch.isHead) {
      chips.add(
        Icon(Icons.star, size: 16, color: widget.theme.colorScheme.primary),
      );
    }
    if (branch.hasWorktree) {
      chips.add(
        Icon(
          Icons.account_tree,
          size: 16,
          color: widget.theme.colorScheme.tertiary,
        ),
      );
    }
    if (chips.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, children: chips);
  }
}
