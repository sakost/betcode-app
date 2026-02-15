import 'package:flutter/material.dart';

import '../models/conversation_state.dart';
import '../models/input_command.dart';
import 'agent_mention_overlay.dart';
import 'command_palette.dart';

/// The message input bar at the bottom of the conversation screen.
///
/// Shows a text field and send button. Can be disabled when the agent
/// is processing a turn. Supports slash-command palette and @-mention overlay.
class InputBar extends StatefulWidget {
  const InputBar({
    super.key,
    required this.onSubmit,
    this.enabled = true,
    this.hintText = 'Type a message...',
    this.onCancel,
    this.agents,
    this.onAgentSelected,
  });

  final ValueChanged<String> onSubmit;
  final bool enabled;
  final String hintText;

  /// When non-null and [enabled] is false, a stop button is shown
  /// instead of the disabled send button.
  final VoidCallback? onCancel;

  /// Available agents for the @-mention overlay.
  final Map<String, AgentInfo>? agents;

  /// Called when an agent is selected via @-mention.
  final ValueChanged<String?>? onAgentSelected;

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;
  bool _showCommandPalette = false;
  String _commandQuery = '';
  bool _showMentionOverlay = false;
  String _mentionQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final hasText = text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    // Command palette: text starts with /
    if (text.startsWith('/')) {
      setState(() {
        _showCommandPalette = true;
        _commandQuery = text.substring(1);
        _showMentionOverlay = false;
        _mentionQuery = '';
      });
      return;
    }

    // @ mention: detect @ at word boundary
    final mentionMatch = RegExp(r'(?:^|\s)@(\w*)$').firstMatch(text);
    if (mentionMatch != null &&
        widget.agents != null &&
        widget.agents!.isNotEmpty) {
      setState(() {
        _showMentionOverlay = true;
        _mentionQuery = mentionMatch.group(1) ?? '';
        _showCommandPalette = false;
        _commandQuery = '';
      });
      return;
    }

    // Neither
    if (_showCommandPalette || _showMentionOverlay) {
      setState(() {
        _showCommandPalette = false;
        _commandQuery = '';
        _showMentionOverlay = false;
        _mentionQuery = '';
      });
    }
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    _controller.clear();
  }

  void _onCommand(InputCommand cmd) {
    _controller.clear();
    widget.onSubmit('/${cmd.name}');
  }

  void _onMention(String agentId) {
    final agents = widget.agents;
    if (agents == null) return;
    final agent = agents[agentId];
    if (agent == null) return;

    final text = _controller.text;
    // Replace the @query with @name
    final mentionMatch = RegExp(r'(?:^|\s)@(\w*)$').firstMatch(text);
    if (mentionMatch != null) {
      final start = mentionMatch.start;
      final prefix = text.substring(0, start);
      final separator = prefix.isNotEmpty ? ' ' : '';
      _controller.text = '$prefix$separator@${agent.name} ';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    setState(() {
      _showMentionOverlay = false;
      _mentionQuery = '';
    });

    widget.onAgentSelected?.call(agentId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showCommandPalette)
              CommandPalette(
                query: _commandQuery,
                onCommandSelected: _onCommand,
              ),
            if (_showMentionOverlay)
              AgentMentionOverlay(
                agents: widget.agents ?? {},
                query: _mentionQuery,
                onAgentSelected: _onMention,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: null,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: widget.enabled ? (_) => _submit() : null,
                  ),
                ),
                const SizedBox(width: 8),
                if (!widget.enabled && widget.onCancel != null)
                  _CancelButton(onCancel: widget.onCancel!)
                else
                  IconButton.filled(
                    onPressed: widget.enabled && _hasText ? _submit : null,
                    icon: const Icon(Icons.send, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor: colorScheme.onSurface.withAlpha(
                        30,
                      ),
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

/// A stop/cancel button shown when the agent is actively working.
class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: onCancel,
      icon: const Icon(Icons.stop, size: 20),
      label: const Text('Stop'),
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
      ),
    );
  }
}
