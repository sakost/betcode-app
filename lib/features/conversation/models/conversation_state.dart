import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_state.freezed.dart';

/// Top-level conversation state machine.
///
/// Transitions: initial -> connecting -> active (or error).
/// Once active, the state accumulates messages, usage, todos, etc.
@freezed
sealed class ConversationState with _$ConversationState {
  const factory ConversationState.initial() = ConversationInitial;
  const factory ConversationState.connecting() = ConversationConnecting;
  const factory ConversationState.active({
    required String sessionId,
    required List<ChatMessage> messages,
    required AgentStatus agentStatus,
    required int lastSequence,
    @Default([]) List<TodoItem> todos,
    @Default(false) bool planModeActive,
    String? planContent,
    UsageInfo? usage,
    String? errorMessage,
    @Default({}) Map<String, AgentInfo> agents,
    String? selectedAgentId,
  }) = ConversationActive;
  const factory ConversationState.error(String message) = ConversationError;
}

/// Individual message in the conversation timeline.
///
/// Each variant maps to a distinct UI treatment: plain text bubbles,
/// collapsible tool cards, permission dialogs, or question forms.
@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage.user({
    required String content,
    required DateTime timestamp,
  }) = UserChatMessage;
  const factory ChatMessage.agent({
    required String content,
    required DateTime timestamp,
    @Default(false) bool isComplete,
    String? parentToolUseId,
  }) = AgentChatMessage;
  const factory ChatMessage.toolCall({
    required String toolId,
    required String toolName,
    required String description,
    String? input,
    String? output,
    @Default(false) bool isError,
    int? durationMs,
    @Default(false) bool isComplete,
    String? parentToolUseId,
  }) = ToolCallMessage;
  const factory ChatMessage.permissionRequest({
    required String requestId,
    required String toolName,
    required String description,
    String? input,
    PermissionDecision? decision,
    String? parentToolUseId,
  }) = PermissionRequestMessage;
  const factory ChatMessage.userQuestion({
    required String questionId,
    required String question,
    required List<QuestionOption> options,
    required bool multiSelect,
    Map<String, String>? answers,
    String? parentToolUseId,
  }) = UserQuestionMessage;
}

/// Accumulated token usage and cost for the current session.
@freezed
abstract class UsageInfo with _$UsageInfo {
  const factory UsageInfo({
    @Default(0) int inputTokens,
    @Default(0) int outputTokens,
    @Default(0) int cacheReadTokens,
    @Default(0) int cacheCreationTokens,
    @Default('') String model,
    @Default(0.0) double costUsd,
    @Default(0) int durationMs,
  }) = _UsageInfo;
}

/// Tracks a sub-agent spawned via a Task tool call.
@freezed
abstract class AgentInfo with _$AgentInfo {
  const factory AgentInfo({
    required String id,
    required String name,
    required AgentStatus status,
    @Default(false) bool isComplete,
    @Default(0) int messageCount,
    DateTime? lastActivity,
  }) = _AgentInfo;
}
