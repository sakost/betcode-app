import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    debugPrint('[Conversation] Event received: ${event.whichEvent().name} seq=${event.sequence}');
    final seq = event.sequence.toInt();
    final current = state.value;

    // Dedup: skip events we have already processed.
    if (current is ConversationActive && seq <= current.lastSequence) return;

    final parentId = event.parentToolUseId;

    // Normalize empty string to null for optional parentToolUseId.
    final parentIdOrNull = parentId.isEmpty ? null : parentId;

    switch (event.whichEvent()) {
      case pb.AgentEvent_Event.sessionInfo:
        _onSessionInfo(event.sessionInfo, seq);
      case pb.AgentEvent_Event.textDelta:
        _onTextDelta(event.textDelta, seq, parentIdOrNull);
      case pb.AgentEvent_Event.toolCallStart:
        _onToolCallStart(event.toolCallStart, seq, parentIdOrNull);
      case pb.AgentEvent_Event.toolCallResult:
        _onToolCallResult(event.toolCallResult, seq);
      case pb.AgentEvent_Event.permissionRequest:
        _onPermissionRequest(event.permissionRequest, seq, parentIdOrNull);
      case pb.AgentEvent_Event.userQuestion:
        _onUserQuestion(event.userQuestion, seq, parentIdOrNull);
      case pb.AgentEvent_Event.statusChange:
        _onStatusChange(event.statusChange, seq, parentId);
      case pb.AgentEvent_Event.turnComplete:
        _onTurnComplete(seq);
      case pb.AgentEvent_Event.usage:
        _onUsageReport(event.usage, seq);
      case pb.AgentEvent_Event.todoUpdate:
        _onTodoUpdate(event.todoUpdate, seq);
      case pb.AgentEvent_Event.planMode:
        _onPlanModeChange(event.planMode, seq);
      case pb.AgentEvent_Event.userInput:
        _onUserInput(event.userInput, seq);
      case pb.AgentEvent_Event.encrypted:
        break; // Encrypted envelope – handled at transport layer, not here.
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
  // Agent tracking
  // ---------------------------------------------------------------------------

  /// Regex to extract agent name from Task tool description.
  static final _agentNameRegex = RegExp(r'(?:Launch agent|agent):\s*(.+)', caseSensitive: false);

  /// Whether a tool name indicates an agent-spawning tool.
  bool _isAgentTool(String toolName) =>
      toolName == 'Task';

  /// Extracts agent name from tool description or input JSON, falling back to "Agent N".
  String _extractAgentName(String description, int agentIndex, {String? input}) {
    // Try regex on description first.
    final match = _agentNameRegex.firstMatch(description);
    if (match != null) return match.group(1)!.trim();

    // Try parsing tool input JSON for a "name" or "description" field.
    if (input != null) {
      try {
        final json = jsonDecode(input);
        if (json is Map<String, dynamic>) {
          final name = _extractStringField(json, 'name') ??
              _extractStringField(json, 'description');
          if (name != null && name.isNotEmpty) return name;
        }
      } on Object {
        // Input is not valid JSON or not a map — ignore.
      }
    }

    return 'Agent $agentIndex';
  }

  /// Extracts a string value from a JSON map.
  /// Handles both plain JSON (`{"name": "x"}`) and protobuf Struct JSON
  /// (`{"fields": {"name": {"stringValue": "x"}}}`).
  static String? _extractStringField(Map<String, dynamic> json, String key) {
    // Plain JSON format.
    final direct = json[key];
    if (direct is String) return direct;

    // Protobuf Struct JSON format.
    final fields = json['fields'];
    if (fields is Map<String, dynamic>) {
      final field = fields[key];
      if (field is Map<String, dynamic>) {
        final sv = field['stringValue'];
        if (sv is String) return sv;
      }
    }

    return null;
  }

  /// Apply agent tracking to an active state (pure function, no state mutation).
  ConversationActive _withAgentTracking(ConversationActive active, String? parentId) {
    if (parentId == null || parentId.isEmpty) return active;
    final agents = Map<String, AgentInfo>.from(active.agents);
    final agent = agents[parentId];
    if (agent == null) return active;
    agents[parentId] = agent.copyWith(
      messageCount: agent.messageCount + 1,
      lastActivity: DateTime.now(),
    );
    return active.copyWith(agents: agents);
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

  void _onTextDelta(pb.TextDelta delta, int seq, String? parentToolUseId) {
    _updateActive((active) {
      final messages = [...active.messages];
      final lastMsg = messages.isNotEmpty ? messages.last : null;

      if (lastMsg is AgentChatMessage && !lastMsg.isComplete) {
        messages[messages.length - 1] =
            ChatMessage.agent(
                  content: lastMsg.content + delta.text,
                  timestamp: lastMsg.timestamp,
                  isComplete: delta.isComplete,
                  parentToolUseId: lastMsg.parentToolUseId,
                )
                as AgentChatMessage;
      } else {
        messages.add(
          ChatMessage.agent(
            content: delta.text,
            timestamp: DateTime.now(),
            isComplete: delta.isComplete,
            parentToolUseId: parentToolUseId,
          ),
        );
      }

      var result = active.copyWith(messages: messages, lastSequence: seq);
      return _withAgentTracking(result, parentToolUseId);
    });
  }

  void _onToolCallStart(pb.ToolCallStart tool, int seq, String? parentToolUseId) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.toolCall(
          toolId: tool.toolId,
          toolName: tool.toolName,
          description: tool.description,
          input: tool.hasInput() ? tool.input.toString() : null,
          parentToolUseId: parentToolUseId,
        ),
      ];

      // Register agent if this is a Task tool call.
      var agents = active.agents;
      if (_isAgentTool(tool.toolName)) {
        agents = Map<String, AgentInfo>.from(agents);
        final agentIndex = agents.length + 1;
        final inputJson = tool.hasInput()
            ? jsonEncode(tool.input.toProto3Json())
            : null;
        agents[tool.toolId] = AgentInfo(
          id: tool.toolId,
          name: _extractAgentName(tool.description, agentIndex, input: inputJson),
          status: AgentStatus.AGENT_STATUS_EXECUTING_TOOL,
        );
      }

      var result = active.copyWith(
        messages: messages,
        agents: agents,
        lastSequence: seq,
      );
      return _withAgentTracking(result, parentToolUseId);
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
            parentToolUseId: msg.parentToolUseId,
          );
        }
        return msg;
      }).toList();

      // Mark agent as complete if this was a Task tool.
      var agents = active.agents;
      if (agents.containsKey(result.toolId)) {
        agents = Map<String, AgentInfo>.from(agents);
        agents[result.toolId] = agents[result.toolId]!.copyWith(
          isComplete: true,
          status: AgentStatus.AGENT_STATUS_IDLE,
        );
      }

      return active.copyWith(
        messages: messages,
        agents: agents,
        lastSequence: seq,
      );
    });
  }

  void _onPermissionRequest(pb.PermissionRequest perm, int seq, String? parentToolUseId) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.permissionRequest(
          requestId: perm.requestId,
          toolName: perm.toolName,
          description: perm.description,
          input: perm.hasInput() ? perm.input.toString() : null,
          parentToolUseId: parentToolUseId,
        ),
      ];
      var result = active.copyWith(
        messages: messages,
        agentStatus: AgentStatus.AGENT_STATUS_WAITING_FOR_USER,
        lastSequence: seq,
      );
      return _withAgentTracking(result, parentToolUseId);
    });
  }

  void _onUserQuestion(pb.UserQuestion question, int seq, String? parentToolUseId) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.userQuestion(
          questionId: question.questionId,
          question: question.question,
          options: List<QuestionOption>.from(question.options),
          multiSelect: question.multiSelect,
          parentToolUseId: parentToolUseId,
        ),
      ];
      var result = active.copyWith(
        messages: messages,
        agentStatus: AgentStatus.AGENT_STATUS_WAITING_FOR_USER,
        lastSequence: seq,
      );
      return _withAgentTracking(result, parentToolUseId);
    });
  }

  void _onStatusChange(pb.StatusChange change, int seq, String parentId) {
    _updateActive((active) {
      // If the status change is for a sub-agent, update that agent's status.
      if (parentId.isNotEmpty && active.agents.containsKey(parentId)) {
        final agents = Map<String, AgentInfo>.from(active.agents);
        agents[parentId] = agents[parentId]!.copyWith(status: change.status);
        var result = active.copyWith(agents: agents, lastSequence: seq);
        return _withAgentTracking(result, parentId);
      }
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
            parentToolUseId: msg.parentToolUseId,
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

  void _onUserInput(pb.UserInput input, int seq) {
    _updateActive((active) {
      final messages = [
        ...active.messages,
        ChatMessage.user(
          content: input.content,
          timestamp: DateTime.now(),
        ),
      ];
      return active.copyWith(messages: messages, lastSequence: seq);
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
