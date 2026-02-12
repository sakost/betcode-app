import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/common.pb.dart';
import '../../worktrees/notifiers/worktrees_providers.dart';
import '../models/conversation_state.dart';
import '../notifiers/conversation_providers.dart';
import '../widgets/input_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/permission_sheet.dart';
import '../widgets/plan_mode_banner.dart';
import '../widgets/status_indicator.dart';
import '../widgets/todo_list_panel.dart';
import '../widgets/tool_call_card.dart';
import '../widgets/usage_display.dart';
import '../widgets/user_question_dialog.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(conversationProvider(widget.sessionId));
    // Pre-load worktrees so they're available when the user taps Start.
    ref.watch(worktreesProvider);

    return asyncState.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Conversation')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Conversation')),
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
    final workingDirectory = _resolveWorkingDirectory();
    if (workingDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No worktree available. Create a worktree first.'),
        ),
      );
      return;
    }
    ref
        .read(conversationProvider(widget.sessionId).notifier)
        .startConversation(workingDirectory: workingDirectory);
  }

  Widget _buildInitialState() {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Start a conversation'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startConversation,
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectingState() {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation')),
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
      appBar: AppBar(title: const Text('Conversation')),
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

  Widget _buildActiveState(ConversationActive active) {
    final messages = active.messages;
    final isIdle =
        active.agentStatus == AgentStatus.AGENT_STATUS_IDLE ||
        active.agentStatus == AgentStatus.AGENT_STATUS_WAITING_FOR_USER;

    // Auto-scroll on new messages.
    if (messages.length > _lastMessageCount) {
      _lastMessageCount = messages.length;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StatusIndicator(status: active.agentStatus),
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (active.errorMessage != null)
            MaterialBanner(
              content: Text(active.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              actions: [
                TextButton(
                  onPressed: () {
                    // Dismiss by ignoring — the reconnection logic will clear it
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),

          // Plan mode banner
          PlanModeBanner(
            planModeActive: active.planModeActive,
            planContent: active.planContent,
          ),

          // Todo list panel
          TodoListPanel(todos: active.todos),

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
            onSubmit: (text) => ref
                .read(conversationProvider(widget.sessionId).notifier)
                .sendMessage(text),
            onCancel: isIdle
                ? null
                : () => ref
                      .read(conversationProvider(widget.sessionId).notifier)
                      .cancelTurn(),
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
    final decided = msg.decision != null;
    final decisionLabel = switch (msg.decision) {
      PermissionDecision p
          when p == PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE ||
              p == PermissionDecision.PERMISSION_DECISION_ALLOW_SESSION =>
        'Allowed',
      PermissionDecision p
          when p == PermissionDecision.PERMISSION_DECISION_DENY =>
        'Denied',
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: ListTile(
          leading: Icon(
            decided ? Icons.check_circle : Icons.security,
            color: decided
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
          title: Text(msg.toolName),
          subtitle: Text(decided ? decisionLabel! : msg.description),
          trailing: decided
              ? null
              : const Text(
                  'Tap to respond',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
          onTap: decided
              ? null
              : () async {
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
                },
        ),
      ),
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
