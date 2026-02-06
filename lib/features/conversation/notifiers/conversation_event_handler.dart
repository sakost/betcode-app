import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/agent.pb.dart' as pb;
import '../../../generated/betcode/v1/common.pb.dart';
import '../models/conversation_state.dart';

/// Mixin that processes incoming [pb.AgentEvent]s and updates the
/// [ConversationState] accordingly.
///
/// Separated from [ConversationNotifier] to keep file sizes manageable
/// and isolate event-processing logic from stream lifecycle management.
mixin ConversationEventHandler on AsyncNotifier<ConversationState> {
  /// Dispatches a single [pb.AgentEvent] to the appropriate handler.
  void handleEvent(pb.AgentEvent event) {
    final seq = event.sequence.toInt();
    final current = state.value;

    // Dedup: skip events we have already processed.
    if (current is ConversationActive && seq <= current.lastSequence) return;

    switch (event.whichEvent()) {
      case pb.AgentEvent_Event.sessionInfo:
        _onSessionInfo(event.sessionInfo, seq);
      case pb.AgentEvent_Event.textDelta:
        _onTextDelta(event.textDelta, seq);
      case pb.AgentEvent_Event.toolCallStart:
        _onToolCallStart(event.toolCallStart, seq);
      case pb.AgentEvent_Event.toolCallResult:
        _onToolCallResult(event.toolCallResult, seq);
      case pb.AgentEvent_Event.permissionRequest:
        _onPermissionRequest(event.permissionRequest, seq);
      case pb.AgentEvent_Event.userQuestion:
        _onUserQuestion(event.userQuestion, seq);
      case pb.AgentEvent_Event.statusChange:
        _onStatusChange(event.statusChange, seq);
      case pb.AgentEvent_Event.turnComplete:
        _onTurnComplete(seq);
      case pb.AgentEvent_Event.usage:
        _onUsageReport(event.usage, seq);
      case pb.AgentEvent_Event.todoUpdate:
        _onTodoUpdate(event.todoUpdate, seq);
      case pb.AgentEvent_Event.planMode:
        _onPlanModeChange(event.planMode, seq);
      case pb.AgentEvent_Event.error:
        _onError(event.error, seq);
      case pb.AgentEvent_Event.notSet:
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the current state as [ConversationActive] or null.
  ConversationActive? get _active {
    final current = state.value;
    return current is ConversationActive ? current : null;
  }

  /// Updates state only if currently [ConversationActive].
  void _updateActive(
    ConversationActive Function(ConversationActive active) updater,
  ) {
    final active = _active;
    if (active == null) return;
    state = AsyncData(updater(active));
  }

  // ---------------------------------------------------------------------------
  // Individual event handlers
  // ---------------------------------------------------------------------------

  void _onSessionInfo(pb.SessionInfo info, int seq) {
    final active = _active;
    if (active != null) {
      state = AsyncData(
        active.copyWith(sessionId: info.sessionId, lastSequence: seq),
      );
    } else {
      state = AsyncData(
        ConversationState.active(
          sessionId: info.sessionId,
          messages: [],
          agentStatus: AgentStatus.AGENT_STATUS_IDLE,
          lastSequence: seq,
        ),
      );
    }
  }

  void _onTextDelta(pb.TextDelta delta, int seq) {
    _updateActive((active) {
      final messages = [...active.messages];
      final lastMsg = messages.isNotEmpty ? messages.last : null;

      if (lastMsg is AgentChatMessage && !lastMsg.isComplete) {
        messages[messages.length - 1] =
            ChatMessage.agent(
                  content: lastMsg.content + delta.text,
                  timestamp: lastMsg.timestamp,
                  isComplete: delta.isComplete,
                )
                as AgentChatMessage;
      } else {
        messages.add(
          ChatMessage.agent(
            content: delta.text,
            timestamp: DateTime.now(),
            isComplete: delta.isComplete,
          ),
        );
      }

      return active.copyWith(messages: messages, lastSequence: seq);
    });
  }

  void _onToolCallStart(pb.ToolCallStart tool, int seq) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.toolCall(
          toolId: tool.toolId,
          toolName: tool.toolName,
          description: tool.description,
          input: tool.hasInput() ? tool.input.toString() : null,
        ),
      ];
      return active.copyWith(messages: messages, lastSequence: seq);
    });
  }

  void _onToolCallResult(pb.ToolCallResult result, int seq) {
    _updateActive((active) {
      final messages = active.messages.map((msg) {
        if (msg is ToolCallMessage &&
            msg.toolId == result.toolId &&
            !msg.isComplete) {
          return ChatMessage.toolCall(
            toolId: msg.toolId,
            toolName: msg.toolName,
            description: msg.description,
            input: msg.input,
            output: result.output,
            isError: result.isError,
            durationMs: result.hasDurationMs() ? result.durationMs : null,
            isComplete: true,
          );
        }
        return msg;
      }).toList();
      return active.copyWith(messages: messages, lastSequence: seq);
    });
  }

  void _onPermissionRequest(pb.PermissionRequest perm, int seq) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.permissionRequest(
          requestId: perm.requestId,
          toolName: perm.toolName,
          description: perm.description,
          input: perm.hasInput() ? perm.input.toString() : null,
        ),
      ];
      return active.copyWith(
        messages: messages,
        agentStatus: AgentStatus.AGENT_STATUS_WAITING_FOR_USER,
        lastSequence: seq,
      );
    });
  }

  void _onUserQuestion(pb.UserQuestion question, int seq) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.userQuestion(
          questionId: question.questionId,
          question: question.question,
          options: List<QuestionOption>.from(question.options),
          multiSelect: question.multiSelect,
        ),
      ];
      return active.copyWith(
        messages: messages,
        agentStatus: AgentStatus.AGENT_STATUS_WAITING_FOR_USER,
        lastSequence: seq,
      );
    });
  }

  void _onStatusChange(pb.StatusChange change, int seq) {
    _updateActive((active) {
      return active.copyWith(agentStatus: change.status, lastSequence: seq);
    });
  }

  void _onTurnComplete(int seq) {
    _updateActive((active) {
      final messages = [...active.messages];
      for (var i = messages.length - 1; i >= 0; i--) {
        final msg = messages[i];
        if (msg is AgentChatMessage && !msg.isComplete) {
          messages[i] = ChatMessage.agent(
            content: msg.content,
            timestamp: msg.timestamp,
            isComplete: true,
          );
          break;
        }
      }
      return active.copyWith(
        messages: messages,
        agentStatus: AgentStatus.AGENT_STATUS_IDLE,
        lastSequence: seq,
      );
    });
  }

  void _onUsageReport(pb.UsageReport report, int seq) {
    _updateActive((active) {
      return active.copyWith(
        usage: UsageInfo(
          inputTokens: report.inputTokens,
          outputTokens: report.outputTokens,
          cacheReadTokens: report.cacheReadTokens,
          cacheCreationTokens: report.cacheCreationTokens,
          model: report.model,
          costUsd: report.costUsd,
          durationMs: report.durationMs,
        ),
        lastSequence: seq,
      );
    });
  }

  void _onTodoUpdate(pb.TodoUpdate update, int seq) {
    _updateActive((active) {
      return active.copyWith(
        todos: List<TodoItem>.from(update.items),
        lastSequence: seq,
      );
    });
  }

  void _onPlanModeChange(pb.PlanModeChange change, int seq) {
    _updateActive((active) {
      return active.copyWith(
        planModeActive: change.active,
        planContent: change.hasPlan() ? change.plan : null,
        lastSequence: seq,
      );
    });
  }

  void _onError(pb.ErrorEvent error, int seq) {
    if (error.isFatal) {
      state = AsyncData(
        ConversationState.error('[${error.code}] ${error.message}'),
      );
      return;
    }

    _updateActive((active) {
      return active.copyWith(
        errorMessage: '[${error.code}] ${error.message}',
        lastSequence: seq,
      );
    });
  }
}
