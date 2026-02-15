import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/common.pb.dart';

/// A collapsible card showing a tool invocation and its result.
///
/// While the tool is executing, shows a spinner. Once complete, the card
/// can be expanded to reveal the tool output.
///
/// When [isPermission] is true the card renders as a permission request:
/// - Shield icon as the leading indicator
/// - Auto-expands when [decision] is null (awaiting user input)
/// - Collapses with Allowed/Denied badge once decided
/// - Tapping while awaiting calls [onPermissionTap] instead of toggling
class ToolCallCard extends StatelessWidget {
  const ToolCallCard({
    super.key,
    required this.toolName,
    required this.description,
    this.input,
    this.output,
    this.isError = false,
    this.isComplete = false,
    this.durationMs,
    this.isPermission = false,
    this.decision,
    this.onPermissionTap,
  });

  final String toolName;
  final String description;
  final String? input;
  final String? output;
  final bool isError;
  final bool isComplete;
  final int? durationMs;

  /// When true, this card renders as a permission request card.
  final bool isPermission;

  /// The user's permission decision. Null means awaiting decision.
  final PermissionDecision? decision;

  /// Called when user taps the card while awaiting a permission decision.
  final VoidCallback? onPermissionTap;

  bool get _isDecided => decision != null;

  bool get _isAllowed =>
      decision == PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE ||
      decision == PermissionDecision.PERMISSION_DECISION_ALLOW_SESSION;

  String? get _decisionLabel {
    if (!_isDecided) return null;
    return _isAllowed ? 'Allowed' : 'Denied';
  }

  @override
  Widget build(BuildContext context) {
    if (isPermission) return _buildPermissionCard(context);
    return _buildToolCard(context);
  }

  /// Shared title widget for both tool and permission expansion tiles.
  Text _buildTitle(ThemeData theme) => Text(
    toolName,
    style: theme.textTheme.titleSmall?.copyWith(fontFamily: 'JetBrains Mono'),
  );

  /// Shared subtitle widget for both tool and permission expansion tiles.
  Text _buildSubtitle(ThemeData theme) => Text(
    description,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: theme.textTheme.bodySmall,
  );

  /// Wraps an [ExpansionTile] in the standard padded card chrome.
  Widget _wrapInCard(Widget tile) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Card(clipBehavior: Clip.antiAlias, child: tile),
  );

  Widget _buildToolCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _wrapInCard(
      ExpansionTile(
        leading: isComplete
            ? Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? colorScheme.error : Colors.green,
                size: 20,
              )
            : SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
        title: _buildTitle(theme),
        subtitle: _buildSubtitle(theme),
        trailing: durationMs != null
            ? Text(
                '${durationMs}ms',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        children: [
          if (input != null)
            _Section(label: 'Input', content: input!, theme: theme),
          if (output != null)
            _Section(
              label: isError ? 'Error' : 'Output',
              content: output!,
              theme: theme,
              isError: isError,
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final awaiting = !_isDecided;

    Widget tile = ExpansionTile(
      initiallyExpanded: awaiting,
      leading: Icon(
        Icons.shield,
        color: _isDecided
            ? (_isAllowed ? Colors.green : colorScheme.error)
            : colorScheme.primary,
        size: 20,
      ),
      title: _buildTitle(theme),
      subtitle: _buildSubtitle(theme),
      trailing: _decisionLabel != null
          ? Text(
              _decisionLabel!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: _isAllowed ? Colors.green : colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      children: [
        if (input != null)
          _Section(label: 'Input', content: input!, theme: theme),
      ],
    );

    // When awaiting a permission decision, intercept taps on the whole card
    // to open the permission sheet instead of just toggling the expansion.
    if (awaiting && onPermissionTap != null) {
      tile = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPermissionTap,
        child: IgnorePointer(child: tile),
      );
    }

    return _wrapInCard(tile);
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.content,
    required this.theme,
    this.isError = false,
  });

  final String label;
  final String content;
  final ThemeData theme;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isError ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SelectableText(
              content,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'JetBrains Mono',
                color: isError ? colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
