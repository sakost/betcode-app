import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../generated/betcode/v1/common.pb.dart';

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
  }) = ToolCallMessage;
  const factory ChatMessage.permissionRequest({
    required String requestId,
    required String toolName,
    required String description,
    String? input,
    PermissionDecision? decision,
  }) = PermissionRequestMessage;
  const factory ChatMessage.userQuestion({
    required String questionId,
    required String question,
    required List<QuestionOption> options,
    required bool multiSelect,
    Map<String, String>? answers,
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
