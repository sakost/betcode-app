import 'dart:async';
import 'dart:math' show min;

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/agent.pb.dart' as pb;
import '../../../generated/betcode/v1/agent.pbgrpc.dart';
import '../../../generated/betcode/v1/common.pb.dart';
import '../models/conversation_state.dart';
import 'conversation_event_handler.dart';

/// Manages the bidirectional gRPC streaming conversation with the Claude agent.
///
/// Created via [AsyncNotifierProvider.family] keyed by session ID.
/// A null session ID means "start new session"; a non-null ID resumes.
class ConversationNotifier extends AsyncNotifier<ConversationState>
    with ConversationEventHandler {
  static const _maxReconnectAttempts = 5;
  static const _backoffDurations = [
    Duration(milliseconds: 500),
    Duration(seconds: 1),
    Duration(seconds: 3),
    Duration(seconds: 10),
    Duration(seconds: 30),
  ];

  StreamController<pb.AgentRequest>? _requestController;
  StreamSubscription<pb.AgentEvent>? _eventSubscription;
  int _reconnectAttempt = 0;
  Timer? _reconnectTimer;

  /// The session ID this notifier was created with.
  /// Set by the family provider factory.
  String? sessionId;

  AgentServiceClient get _client => ref.read(agentServiceProvider);

  @override
  FutureOr<ConversationState> build() {
    ref.onDispose(_cleanup);
    return const ConversationState.initial();
  }

  /// Opens the bidi stream and sends a [StartConversation] request.
  ///
  /// If [sessionId] is non-null, it is sent as an existing session ID to
  /// resume. The daemon will reply with [SessionInfo] containing the
  /// canonical session ID.
  Future<void> startConversation() async {
    state = const AsyncData(ConversationState.connecting());

    try {
      _requestController = StreamController<pb.AgentRequest>();

      final responseStream = _client.converse(_requestController!.stream);

      _requestController!.add(
        pb.AgentRequest(
          start: pb.StartConversation(sessionId: sessionId ?? ''),
        ),
      );

      _eventSubscription = responseStream.listen(
        handleEvent,
        onError: _handleStreamError,
        onDone: _handleStreamDone,
        cancelOnError: false,
      );
    } catch (e) {
      state = AsyncData(ConversationState.error(e.toString()));
    }
  }

  /// Sends a user message through the active bidi stream.
  void sendMessage(String content) {
    final current = state.value;
    if (current is! ConversationActive || _requestController == null) return;

    final userMsg = ChatMessage.user(
      content: content,
      timestamp: DateTime.now(),
    );
    state = AsyncData(
      current.copyWith(messages: [...current.messages, userMsg]),
    );

    _requestController!.add(
      pb.AgentRequest(message: pb.UserMessage(content: content)),
    );
  }

  /// Responds to a permission request from the agent.
  void respondToPermission(String requestId, PermissionDecision decision) {
    final current = state.value;
    if (current is! ConversationActive || _requestController == null) return;

    final updatedMessages = current.messages.map((msg) {
      if (msg is PermissionRequestMessage && msg.requestId == requestId) {
        return ChatMessage.permissionRequest(
          requestId: msg.requestId,
          toolName: msg.toolName,
          description: msg.description,
          input: msg.input,
          decision: decision,
        );
      }
      return msg;
    }).toList();

    state = AsyncData(current.copyWith(messages: updatedMessages));

    _requestController!.add(
      pb.AgentRequest(
        permission: pb.PermissionResponse(
          requestId: requestId,
          decision: decision,
        ),
      ),
    );
  }

  /// Responds to a user question from the agent.
  void respondToQuestion(String questionId, Map<String, String> answers) {
    final current = state.value;
    if (current is! ConversationActive || _requestController == null) return;

    final updatedMessages = current.messages.map((msg) {
      if (msg is UserQuestionMessage && msg.questionId == questionId) {
        return ChatMessage.userQuestion(
          questionId: msg.questionId,
          question: msg.question,
          options: msg.options,
          multiSelect: msg.multiSelect,
          answers: answers,
        );
      }
      return msg;
    }).toList();

    state = AsyncData(current.copyWith(messages: updatedMessages));

    final questionResponse = pb.UserQuestionResponse(questionId: questionId);
    questionResponse.answers.addAll(answers);

    _requestController!.add(
      pb.AgentRequest(questionResponse: questionResponse),
    );
  }

  /// Cancels the current agent turn via the bidi stream.
  void cancelTurn() {
    if (_requestController == null) return;

    _requestController!.add(
      pb.AgentRequest(cancel: pb.CancelRequest(reason: 'User cancelled')),
    );
  }

  // ---------------------------------------------------------------------------
  // Stream lifecycle
  // ---------------------------------------------------------------------------

  void _handleStreamError(Object error) {
    _eventSubscription?.cancel();
    _eventSubscription = null;

    // Don't retry fatal errors.
    if (_isFatalError(error)) {
      state = AsyncData(ConversationState.error('Stream error: $error'));
      _requestController?.close();
      _requestController = null;
      return;
    }

    // Attempt reconnection if we have an active session.
    final current = state.value;
    if (current is ConversationActive && current.sessionId.isNotEmpty) {
      _attemptReconnection(current);
    } else {
      state = AsyncData(ConversationState.error('Stream error: $error'));
      _requestController?.close();
      _requestController = null;
    }
  }

  bool _isFatalError(Object error) {
    if (error is GrpcError) {
      return error.code == StatusCode.unauthenticated ||
          error.code == StatusCode.permissionDenied ||
          error.code == StatusCode.notFound;
    }
    return false;
  }

  void _attemptReconnection(ConversationActive active) {
    if (_reconnectAttempt >= _maxReconnectAttempts) {
      state = AsyncData(ConversationState.error(
        'Connection lost after $_maxReconnectAttempts reconnection attempts',
      ));
      _cleanup();
      return;
    }

    final delay =
        _backoffDurations[min(_reconnectAttempt, _backoffDurations.length - 1)];
    _reconnectAttempt++;

    state = AsyncData(active.copyWith(
      errorMessage: 'Reconnecting (attempt $_reconnectAttempt)...',
    ));

    _reconnectTimer = Timer(delay, () {
      if (state.value is! ConversationActive) return;

      try {
        final responseStream = _client.resumeSession(
          pb.ResumeSessionRequest(
            sessionId: active.sessionId,
            fromSequence: Int64(active.lastSequence),
          ),
        );

        _eventSubscription = responseStream.listen(
          handleEvent,
          onError: _handleStreamError,
          onDone: _handleStreamDone,
          cancelOnError: false,
        );

        // Success — reset counter and clear error.
        _reconnectAttempt = 0;
        final current = state.value;
        if (current is ConversationActive) {
          state = AsyncData(current.copyWith(errorMessage: null));
        }
      } catch (e) {
        // Retry on failure.
        final current = state.value;
        if (current is ConversationActive) {
          _attemptReconnection(current);
        }
      }
    });
  }

  void _handleStreamDone() {
    final current = state.value;
    if (current is ConversationActive) {
      state = AsyncData(
        current.copyWith(agentStatus: AgentStatus.AGENT_STATUS_IDLE),
      );
    }
    _cleanup();
  }

  void _cleanup() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    _requestController?.close();
    _requestController = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }
}
