import 'dart:async';
import 'dart:math' show min;

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/lifecycle/lifecycle.dart';
import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_event_handler.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

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
  bool _isReconnecting = false;
  bool _paused = false;

  /// The session ID this notifier was created with.
  /// Set by the family provider factory.
  String? sessionId;

  AgentServiceClient get _client => ref.read(agentServiceProvider);

  @override
  FutureOr<ConversationState> build() {
    ref
      ..listen<AppLifecycleState>(
        appLifecycleProvider,
        _onLifecycleChanged,
      )
      ..onDispose(_cleanup);
    return const ConversationState.initial();
  }

  void _onLifecycleChanged(AppLifecycleState? prev, AppLifecycleState next) {
    if (next == AppLifecycleState.paused || next == AppLifecycleState.hidden) {
      _onAppPaused();
    } else if (next == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  /// Explicitly closes the conversation stream and resets to initial state.
  ///
  /// Called when the user navigates away from the conversation screen so the
  /// gRPC stream is released. This prevents stale streams from blocking
  /// subsequent resume attempts for the same session.
  void close() {
    _cleanup();
    state = const AsyncData(ConversationState.initial());
  }

  /// Opens the bidi stream and sends a [StartConversation] request.
  ///
  /// [workingDirectory] is the absolute path on the daemon machine where the
  /// Claude Code subprocess will be spawned. Required for new sessions; for
  /// resume (when [sessionId] is set), the daemon ignores it so it defaults
  /// to empty string.
  ///
  /// If [sessionId] is non-null, it is sent as an existing session ID to
  /// resume. The daemon will reply with [SessionInfo] containing the
  /// canonical session ID.
  ///
  /// The state transitions to [ConversationActive] immediately after the
  /// stream is established so the user can type their first message. The
  /// daemon defers subprocess start until the first [UserMessage] arrives,
  /// so waiting for [SessionInfo] before showing the input bar would deadlock.
  Future<void> startConversation({String workingDirectory = ''}) async {
    debugPrint(
      '[Conversation] startConversation(workingDirectory: $workingDirectory, '
      'sessionId: $sessionId)',
    );
    state = const AsyncData(ConversationState.connecting());

    try {
      _requestController = StreamController<pb.AgentRequest>();

      final responseStream = _client.converse(_requestController!.stream);

      _eventSubscription = responseStream.listen(
        handleEvent,
        onError: (Object error) {
          _handleStreamError(error);
        },
        onDone: _handleStreamDone,
        cancelOnError: false,
      );

      _requestController!.add(
        pb.AgentRequest(
          start: pb.StartConversation(
            sessionId: sessionId ?? '',
            workingDirectory: workingDirectory,
          ),
        ),
      );

      // Transition to active immediately so the user can type their first
      // message. The daemon defers subprocess creation until this message
      // arrives, then sends SessionInfo which updates the session ID.
      state = AsyncData(
        ConversationState.active(
          sessionId: sessionId ?? '',
          messages: [],
          agentStatus: AgentStatus.AGENT_STATUS_IDLE,
          lastSequence: 0,
        ),
      );
    } on Exception catch (e) {
      state = AsyncData(ConversationState.error(e.toString()));
    }
  }

  /// Sends a user message through the active bidi stream.
  void sendMessage(String content) {
    final current = state.value;
    if (current is! ConversationActive || _requestController == null) {
      debugPrint(
        '[Conversation] sendMessage ignored: '
        'state=${state.value.runtimeType}, '
        'hasStream=${_requestController != null}',
      );
      return;
    }

    debugPrint(
      '[Conversation] sendMessage: '
      '"${content.substring(0, content.length.clamp(0, 80))}"',
    );

    final userMsg = ChatMessage.user(
      content: content,
      timestamp: DateTime.now(),
    );
    state = AsyncData(
      current.copyWith(messages: [...current.messages, userMsg]),
    );

    _requestController!.add(
      pb.AgentRequest(
        message: pb.UserMessage(
          content: content,
          agentId: current.selectedAgentId ?? '',
        ),
      ),
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

  /// Sets the selected agent for filtering conversation messages.
  void setSelectedAgent(String? agentId) {
    final current = state.value;
    if (current is! ConversationActive) return;
    state = AsyncData(current.copyWith(selectedAgentId: agentId));
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
    debugPrint('[Conversation] Stream error: $error');
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = null;

    // Don't retry fatal errors.
    if (_isFatalError(error)) {
      _isReconnecting = false;
      state = AsyncData(
        ConversationState.error('Stream error: $error'),
      );
      unawaited(_requestController?.close());
      _requestController = null;
      return;
    }

    // Don't retry while app is backgrounded.
    if (_paused) {
      debugPrint('[Conversation] App paused, deferring reconnection');
      return;
    }

    // Attempt reconnection if we have an active session.
    final current = state.value;
    if (current is ConversationActive && current.sessionId.isNotEmpty) {
      _attemptReconnection(current);
    } else {
      _isReconnecting = false;
      state = AsyncData(
        ConversationState.error('Stream error: $error'),
      );
      unawaited(_requestController?.close());
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
    if (_paused) {
      debugPrint('[Conversation] App paused, deferring reconnection');
      return;
    }

    if (_reconnectAttempt >= _maxReconnectAttempts) {
      _isReconnecting = false;
      state = const AsyncData(
        ConversationState.error(
          'Connection lost after $_maxReconnectAttempts reconnection attempts',
        ),
      );
      _cleanup();
      return;
    }

    _isReconnecting = true;
    final delay =
        _backoffDurations[min(_reconnectAttempt, _backoffDurations.length - 1)];
    _reconnectAttempt++;

    debugPrint(
      '[Conversation] Reconnecting in ${delay.inMilliseconds}ms '
      '(attempt $_reconnectAttempt/$_maxReconnectAttempts)',
    );

    state = AsyncData(
      active.copyWith(
        errorMessage: 'Reconnecting (attempt $_reconnectAttempt)...',
      ),
    );

    _reconnectTimer = Timer(delay, () {
      if (_paused || state.value is! ConversationActive) return;

      try {
        final responseStream = _client.resumeSession(
          pb.ResumeSessionRequest(
            sessionId: active.sessionId,
            fromSequence: Int64(active.lastSequence),
          ),
        );

        _eventSubscription = responseStream.listen(
          _onReconnectEvent,
          onError: _handleStreamError,
          onDone: _handleStreamDone,
          cancelOnError: false,
        );

        // Don't reset _reconnectAttempt here — the stream setup is
        // non-blocking. The counter is reset in _onReconnectEvent when
        // the first successful event arrives.
      } on Exception {
        // Retry on failure.
        final current = state.value;
        if (current is ConversationActive) {
          _attemptReconnection(current);
        }
      }
    });
  }

  /// Handles the first successful event after reconnection, confirming the
  /// connection is truly established. Resets the reconnect counter and
  /// switches to the normal event handler.
  void _onReconnectEvent(pb.AgentEvent event) {
    debugPrint('[Conversation] Reconnection confirmed, stream active');
    _reconnectAttempt = 0;
    _isReconnecting = false;

    // Clear error message.
    final current = state.value;
    if (current is ConversationActive) {
      state = AsyncData(current.copyWith(errorMessage: null));
    }

    // Switch to normal event handler for subsequent events.
    _eventSubscription?.onData(handleEvent);

    // Process this event normally.
    handleEvent(event);
  }

  // ---------------------------------------------------------------------------
  // App lifecycle
  // ---------------------------------------------------------------------------

  void _onAppPaused() {
    _paused = true;
    if (_isReconnecting) {
      debugPrint('[Conversation] App paused, suspending reconnection');
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
  }

  void _onAppResumed() {
    if (!_paused) return;
    _paused = false;
    debugPrint('[Conversation] App resumed');

    final current = state.value;
    if (current is ConversationActive && _isReconnecting) {
      // Restart reconnection with a fresh counter.
      debugPrint('[Conversation] Resuming reconnection from attempt 0');
      _reconnectAttempt = 0;
      _attemptReconnection(current);
    }
  }

  void _handleStreamDone() {
    debugPrint('[Conversation] Stream done');
    final current = state.value;
    if (current is ConversationActive) {
      state = AsyncData(
        current.copyWith(agentStatus: AgentStatus.AGENT_STATUS_IDLE),
      );
    }
    _cleanup();
  }

  void _cleanup() {
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = null;
    unawaited(_requestController?.close());
    _requestController = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _paused = false;
  }
}
