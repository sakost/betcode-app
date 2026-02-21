import 'dart:async';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/features/conversation/widgets/agent_bar.dart';
import 'package:betcode_app/features/conversation/widgets/input_bar.dart';
import 'package:betcode_app/features/conversation/widgets/message_bubble.dart';
import 'package:betcode_app/features/conversation/widgets/permission_sheet.dart';
import 'package:betcode_app/features/conversation/widgets/plan_mode_banner.dart';
import 'package:betcode_app/features/conversation/widgets/status_indicator.dart';
import 'package:betcode_app/features/conversation/widgets/todo_list_panel.dart';
import 'package:betcode_app/features/conversation/widgets/tool_call_card.dart';
import 'package:betcode_app/features/conversation/widgets/usage_display.dart';
import 'package:betcode_app/features/conversation/widgets/user_question_dialog.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, this.sessionId, this.workingDirectory});

  final String? sessionId;
  final String? workingDirectory;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _scrollController = ScrollController();
  bool _isUserScrolledUp = false;
  bool _hasAutoStarted = false;
  bool _hasResumed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Auto-resume existing sessions without requiring user to press Start.
    // For new sessions (null sessionId), also auto-start if worktrees are
    // already available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.sessionId != null) {
        _resumeConversation();
      } else {
        _tryAutoStart();
      }
    });
  }

  @override
  void dispose() {
    // Close the conversation stream so the daemon session is released.
    // This prevents stale streams from blocking subsequent resume
    // attempts. Use Object catch: StateError (an Error, not Exception)
    // is thrown when ref is accessed after the widget is unmounted.
    try {
      ref.read(conversationProvider(widget.sessionId).notifier).close();
    } on Object catch (_) {
      // Provider might already be disposed or ref is no longer valid.
    }
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Attempts to auto-start a new conversation if worktrees are available.
  ///
  /// Only fires when the current state is [ConversationInitial] and a valid
  /// working directory can be resolved. Called from initState (for worktrees
  /// already loaded) and from the worktrees listener (for late-arriving data).
  void _tryAutoStart() {
    if (!mounted || _hasAutoStarted) return;
    final asyncState = ref.read(conversationProvider(widget.sessionId));
    if (asyncState.value is! ConversationInitial) return;
    final workingDirectory =
        widget.workingDirectory ?? _resolveWorkingDirectory();
    if (workingDirectory == null) return;
    _hasAutoStarted = true;
    _startConversation();
  }

  /// Resumes an existing session.
  ///
  /// Only fires when the current state is [ConversationInitial], preventing
  /// duplicate resume attempts when the state has already transitioned.
  /// If worktrees haven't loaded yet, returns early; the worktrees listener
  /// in [build] will retry once worktree data arrives.
  void _resumeConversation() {
    if (!mounted || _hasResumed) return;
    final asyncState = ref.read(conversationProvider(widget.sessionId));
    if (asyncState.value is! ConversationInitial) return;
    final workingDirectory = _resolveWorkingDirectory();
    if (workingDirectory == null) {
      debugPrint(
        '[ConversationScreen] Resume deferred: worktrees not loaded yet',
      );
      return;
    }
    _hasResumed = true;
    unawaited(
      ref
          .read(conversationProvider(widget.sessionId).notifier)
          .startConversation(workingDirectory: workingDirectory),
    );
  }

  Widget? _buildBackButton() {
    final String location;
    try {
      location = GoRouterState.of(context).matchedLocation;
    }
    // ignore: avoid_catching_errors, GoError is thrown by GoRouter for missing state
    on GoError {
      return null;
    }
    if (!location.startsWith('/sessions/')) return null;
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.go('/sessions'),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final atBottom = position.pixels >= position.maxScrollExtent - 50;
    if (atBottom && _isUserScrolledUp) {
      setState(() => _isUserScrolledUp = false);
    } else if (!atBottom && !_isUserScrolledUp) {
      setState(() => _isUserScrolledUp = true);
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (animate) {
        unawaited(
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          ),
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
      setState(() => _isUserScrolledUp = false);
    });
  }

  int _messageCount(ConversationState? state) =>
      state is ConversationActive ? state.messages.length : 0;

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(conversationProvider(widget.sessionId));
    // Auto-start new conversations when worktrees data arrives, and
    // auto-scroll when new messages arrive and user hasn't scrolled up.
    ref
      ..listen(
        worktreesProvider,
        (_, _) {
          // When worktrees load after initState and state is still initial,
          // trigger auto-start or resume via post-frame callback to avoid
          // build-phase state mutations.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (widget.sessionId == null && !_hasAutoStarted) {
              _tryAutoStart();
            } else if (widget.sessionId != null) {
              _resumeConversation();
            }
          });
        },
      )
      ..listen(
        conversationProvider(widget.sessionId),
        (prev, next) {
          if (_isUserScrolledUp) return;
          final prevCount = _messageCount(prev?.value);
          final nextCount = _messageCount(next.value);
          if (nextCount > prevCount) {
            _scrollToBottom();
          }
        },
      );

    return asyncState.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: _buildBackButton(),
          title: const Text('Conversation'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          leading: _buildBackButton(),
          title: const Text('Conversation'),
        ),
        body: Center(child: Text('Error: $error')),
      ),
      data: (state) => switch (state) {
        ConversationInitial() => _buildInitialState(),
        ConversationConnecting() => _buildConnectingState(),
        ConversationActive() => _buildActiveState(state),
        ConversationError(:final message) => _buildErrorState(message),
      },
    );
  }

  String? _resolveWorkingDirectory() {
    final worktrees = ref.read(worktreesProvider).value;
    if (worktrees != null && worktrees.isNotEmpty) {
      // Use the first worktree's path as the default working directory.
      final path = worktrees.first.path;
      if (path.isNotEmpty) return path;
    }
    return null;
  }

  void _startConversation() {
    final workingDirectory =
        widget.workingDirectory ?? _resolveWorkingDirectory();
    if (workingDirectory == null) {
      debugPrint('[ConversationScreen] Cannot start: no working directory');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No worktree available. Create a worktree first.'),
        ),
      );
      return;
    }
    debugPrint(
      '[ConversationScreen] Starting with dir: $workingDirectory',
    );
    unawaited(
      ref
          .read(conversationProvider(widget.sessionId).notifier)
          .startConversation(workingDirectory: workingDirectory),
    );
  }

  Widget _buildInitialState() {
    final worktreesAsync = ref.watch(worktreesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: const Text('Conversation'),
      ),
      body: Center(
        child: worktreesAsync.when(
          loading: () => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading worktrees...'),
            ],
          ),
          error: (error, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Could not load worktrees:\n$error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(worktreesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
          data: (worktrees) {
            if (worktrees.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_tree_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No worktrees available.\n'
                    'Create a worktree to start a conversation.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/code'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Worktree'),
                  ),
                ],
              );
            }

            // Verify a valid working directory can be resolved. If all
            // worktree paths are empty, auto-start will silently fail and
            // the spinner would hang indefinitely.
            final dir =
                widget.workingDirectory ?? _resolveWorkingDirectory();
            if (dir == null) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 48,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No valid worktree path available.\n'
                    'The worktree may still be initialising.',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Starting conversation...'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildConnectingState() {
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: const Text('Conversation'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Connecting...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: const Text('Conversation'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startConversation,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the parentToolUseId of a message, or null for user messages.
  static String? _parentToolUseId(ChatMessage msg) => switch (msg) {
    UserChatMessage() => null,
    AgentChatMessage(:final parentToolUseId) => parentToolUseId,
    ToolCallMessage(:final parentToolUseId) => parentToolUseId,
    PermissionRequestMessage(:final parentToolUseId) => parentToolUseId,
    UserQuestionMessage(:final parentToolUseId) => parentToolUseId,
  };

  String _resolveSessionTitle(String? sessionId) {
    if (sessionId == null) return 'Conversation';
    final sessions = ref.watch(sessionsProvider).value;
    if (sessions == null) return 'Conversation';
    for (final s in sessions) {
      if (s.id == sessionId && s.name.isNotEmpty) return s.name;
    }
    return 'Conversation';
  }

  Widget _buildAppBarTitle(String title) {
    return _AppBarTitle(
      title: title,
      workingDirectory: widget.workingDirectory,
    );
  }

  Widget _buildActiveState(ConversationActive active) {
    final selectedId = active.selectedAgentId;
    final messages = selectedId == null
        ? active.messages
        : active.messages.where((msg) {
            // UserChatMessages have no parentToolUseId — always show them.
            if (msg is UserChatMessage) return true;
            return _parentToolUseId(msg) == selectedId;
          }).toList();
    final isIdle =
        active.agentStatus == AgentStatus.AGENT_STATUS_IDLE ||
        active.agentStatus == AgentStatus.AGENT_STATUS_WAITING_FOR_USER;

    final title = _resolveSessionTitle(active.sessionId);

    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: _buildAppBarTitle(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StatusIndicator(status: active.agentStatus),
          ),
        ],
      ),
      floatingActionButton: _isUserScrolledUp
          ? FloatingActionButton(
              mini: true,
              tooltip: 'Scroll to bottom',
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            )
          : null,
      body: Column(
        children: [
          // Error banner
          if (active.errorMessage != null)
            MaterialBanner(
              content: Text(active.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              actions: [
                TextButton(
                  onPressed: () => ref
                      .read(conversationProvider(widget.sessionId).notifier)
                      .clearErrorMessage(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),

          // Plan mode banner
          PlanModeBanner(
            planModeActive: active.planModeActive,
            planContent: active.planContent,
          ),

          // Task list panel
          TodoListPanel(todos: active.todos),

          // Agent bar
          if (active.agents.isNotEmpty)
            AgentBar(
              agents: active.agents,
              selectedAgentId: active.selectedAgentId,
              onAgentSelected: (agentId) => ref
                  .read(conversationProvider(widget.sessionId).notifier)
                  .setSelectedAgent(agentId),
            ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) => _buildMessage(messages[index]),
            ),
          ),

          // Usage display
          if (active.usage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: UsageDisplay(
                inputTokens: active.usage!.inputTokens,
                outputTokens: active.usage!.outputTokens,
                costUsd: active.usage!.costUsd,
                model: active.usage!.model.isNotEmpty
                    ? active.usage!.model
                    : null,
                durationMs: active.usage!.durationMs > 0
                    ? active.usage!.durationMs
                    : null,
              ),
            ),

          // Input bar
          InputBar(
            enabled: isIdle,
            sessionId: widget.sessionId,
            onSubmit: (text) => ref
                .read(conversationProvider(widget.sessionId).notifier)
                .sendMessage(text),
            onCancel: isIdle
                ? null
                : () => ref
                      .read(conversationProvider(widget.sessionId).notifier)
                      .cancelTurn(),
            agents: active.agents,
            onAgentSelected: (agentId) => ref
                .read(conversationProvider(widget.sessionId).notifier)
                .setSelectedAgent(agentId),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return switch (message) {
      UserChatMessage(:final content) => MessageBubble(
        content: content,
        isUser: true,
      ),
      AgentChatMessage(:final content, :final isComplete) => MessageBubble(
        content: content,
        isUser: false,
        isStreaming: !isComplete,
      ),
      ToolCallMessage(
        :final toolName,
        :final description,
        :final input,
        :final output,
        :final isError,
        :final isComplete,
        :final durationMs,
      ) =>
        ToolCallCard(
          toolName: toolName,
          description: description,
          input: input,
          output: output,
          isError: isError,
          isComplete: isComplete,
          durationMs: durationMs,
        ),
      PermissionRequestMessage() => _buildPermissionCard(message),
      UserQuestionMessage() => _buildQuestionCard(message),
    };
  }

  Widget _buildPermissionCard(PermissionRequestMessage msg) {
    return ToolCallCard(
      toolName: msg.toolName,
      description: msg.description,
      input: msg.input,
      isPermission: true,
      decision: msg.decision,
      onPermissionTap: msg.decision == null
          ? () async {
              final decision = await PermissionSheet.show(
                context,
                toolName: msg.toolName,
                description: msg.description,
                input: msg.input,
              );
              if (decision != null && mounted) {
                ref
                    .read(conversationProvider(widget.sessionId).notifier)
                    .respondToPermission(msg.requestId, decision);
              }
            }
          : null,
    );
  }

  Widget _buildQuestionCard(UserQuestionMessage msg) {
    final answered = msg.answers != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: ListTile(
          leading: Icon(
            answered ? Icons.check_circle : Icons.help_outline,
            color: answered
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
          title: Text(msg.question),
          trailing: answered
              ? const Text('Answered')
              : const Text(
                  'Tap to answer',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
          onTap: answered
              ? null
              : () async {
                  final options = msg.options
                      .map(
                        (o) => QuestionOptionData(
                          value: o.value,
                          label: o.label,
                          description: o.description.isNotEmpty
                              ? o.description
                              : null,
                        ),
                      )
                      .toList();
                  final answers = await UserQuestionDialog.show(
                    context,
                    question: msg.question,
                    options: options,
                    multiSelect: msg.multiSelect,
                  );
                  if (answers != null && mounted) {
                    ref
                        .read(conversationProvider(widget.sessionId).notifier)
                        .respondToQuestion(msg.questionId, answers);
                  }
                },
        ),
      ),
    );
  }
}

/// Isolated widget for the AppBar title + machine/worktree subtitle.
///
/// Extracted from [_ConversationScreenState] so that the `ref.watch` calls on
/// [machinesProvider] and [worktreesProvider] only rebuild this small widget
/// tree instead of the entire conversation screen.
class _AppBarTitle extends ConsumerWidget {
  const _AppBarTitle({required this.title, this.workingDirectory});

  final String title;
  final String? workingDirectory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitle = _resolveContextSubtitle(ref);
    if (subtitle == null) return Text(title);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String? _resolveContextSubtitle(WidgetRef ref) {
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return null;

    final machines = ref.watch(machinesProvider).value;
    var machineName = machineId;
    if (machines != null) {
      for (final m in machines) {
        if (m.machineId == machineId) {
          machineName = m.name.isNotEmpty ? m.name : m.machineId;
          break;
        }
      }
    }

    final worktrees = ref.watch(worktreesProvider).value;
    final worktreeName = _resolveWorktreeName(worktrees);

    if (worktreeName != null && worktreeName.isNotEmpty) {
      return '$machineName \u00b7 $worktreeName';
    }
    return machineName;
  }

  /// Resolves the active worktree name from [workingDirectory] if available,
  /// falling back to the first worktree's name.
  String? _resolveWorktreeName(List<WorktreeDetail>? worktrees) {
    if (worktrees == null || worktrees.isEmpty) return null;
    if (workingDirectory != null) {
      for (final wt in worktrees) {
        if (wt.path == workingDirectory) return wt.name;
      }
    }
    return worktrees.first.name;
  }
}
