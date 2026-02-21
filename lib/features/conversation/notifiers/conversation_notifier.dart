import 'dart:async';
import 'dart:math' show min;

import 'package:betcode_app/core/grpc/app_exceptions.dart';
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

  /// Default model used for new sessions when no model is explicitly chosen.
  static const _defaultModel = 'claude-sonnet-4';

  StreamController<pb.AgentRequest>? _requestController;
  StreamSubscription<pb.AgentEvent>? _eventSubscription;
  StreamSubscription<pb.AgentEvent>? _historySubscription;
  Completer<void>? _historyCompleter;
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

    // Reset reconnect state so a fresh start gets the full backoff budget.
    _reconnectAttempt = 0;
    _isReconnecting = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    state = const AsyncData(ConversationState.connecting());

    try {
      // Close any existing streams from a previous attempt (e.g. retry
      // after error) to prevent leaked subscriptions.
      unawaited(_eventSubscription?.cancel());
      _eventSubscription = null;
      unawaited(_historySubscription?.cancel());
      _historySubscription = null;
      _completeHistoryIfPending();
      unawaited(_requestController?.close());

      _requestController = StreamController<pb.AgentRequest>();

      final responseStream = _client.converse(_requestController!.stream);

      debugPrint('[Conversation] Converse stream opened');
      _eventSubscription = responseStream.listen(
        handleEvent,
        onError: (Object error) {
          _handleStreamError(error);
        },
        onDone: _handleStreamDone,
        cancelOnError: false,
      );

      final startReq = pb.StartConversation(
        sessionId: sessionId ?? '',
        workingDirectory: workingDirectory,
        model: _defaultModel,
      );
      final startFields =
          'sessionId: ${startReq.sessionId}, '
          'workingDirectory: ${startReq.workingDirectory}, '
          'model: ${startReq.model}';
      debugPrint(
        '[Conversation] Sending StartConversation($startFields)',
      );
      _requestController!.add(pb.AgentRequest(start: startReq));

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

      // When resuming an existing session, load conversation history from
      // the daemon's event store via the ResumeSession RPC. Events are
      // processed through the same handler and deduplicated by sequence.
      // History replay uses a flag so _onError treats past fatal errors
      // as non-fatal banners instead of killing the conversation state.
      if (sessionId != null && sessionId!.isNotEmpty) {
        isReplayingHistory = true;
        try {
          await _loadHistory(sessionId!);
        } finally {
          isReplayingHistory = false;
        }
      }
    } on Exception catch (e) {
      // After async gaps the notifier may have been disposed (e.g. a second
      // startConversation call was issued, or the provider was torn down).
      if (!ref.mounted) return;
      final message = e is AppException
          ? e.message
          : 'Failed to start conversation: $e';
      state = AsyncData(ConversationState.error(message));
    }
  }

  /// Loads conversation history from the daemon via the ResumeSession RPC.
  ///
  /// Events are replayed through [handleEvent] which builds up the messages
  /// list. The dedup logic (sequence check) prevents double-processing if
  /// the bidi stream has already delivered some events.
  Future<void> _loadHistory(String sid) async {
    debugPrint('[Conversation] Loading history for session $sid');
    try {
      final historyStream = _client.resumeSession(
        pb.ResumeSessionRequest(
          sessionId: sid,
          fromSequence: Int64.ZERO,
        ),
      );
      final myCompleter = Completer<void>();
      _historyCompleter = myCompleter;
      _historySubscription = historyStream.listen(
        handleEvent,
        onError: myCompleter.completeError,
        onDone: myCompleter.complete,
        cancelOnError: true,
      );
      await myCompleter.future;

      // After the await, a new startConversation may have replaced our
      // completer. Only clean up if we are still the active history load.
      if (_historyCompleter != myCompleter) return;
      _historySubscription = null;
      _historyCompleter = null;
      final current = state.value;
      final seq = current is ConversationActive ? current.lastSequence : 0;
      debugPrint('[Conversation] History loaded, lastSequence=$seq');
    } on Exception catch (e) {
      debugPrint('[Conversation] History load failed: $e');
      if (!ref.mounted) return;
      final current = state.value;
      if (current is ConversationActive) {
        state = AsyncData(
          current.copyWith(errorMessage: "Couldn't load message history."),
        );
      }
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

    final userRequest = pb.AgentRequest(
      message: pb.UserMessage(
        content: content,
        agentId: current.selectedAgentId ?? '',
      ),
    );
    final msgFields =
        'agentId: ${userRequest.message.agentId}, '
        'sessionId: ${current.sessionId}, '
        'streamAlive: ${_eventSubscription != null}';
    debugPrint(
      '[Conversation] Sending UserMessage($msgFields)',
    );
    _requestController!.add(userRequest);
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
          parentToolUseId: msg.parentToolUseId,
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
          parentToolUseId: msg.parentToolUseId,
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

  /// Clears the error banner in the active state.
  ///
  /// No-ops if the state is not [ConversationActive].
  void clearErrorMessage() {
    final current = state.value;
    if (current is! ConversationActive) return;
    state = AsyncData(current.copyWith(errorMessage: null));
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
    final causeInfo = error is AppException && error.cause != null
        ? error.cause
        : '';
    debugPrint(
      '[Conversation] Stream error: $error '
      '(type: ${error.runtimeType}, cause: $causeInfo, '
      'fatal: ${_isFatalError(error)}, paused: $_paused)',
    );
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = null;

    // Don't retry fatal errors.
    if (_isFatalError(error)) {
      _isReconnecting = false;
      _transitionToError(error);
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
      _transitionToError(error);
    }
  }

  /// Transitions state to [ConversationError] from a stream error.
  void _transitionToError(Object error) {
    final message = error is AppException
        ? error.message
        : 'Stream error: $error';
    state = AsyncData(ConversationState.error(message));
    unawaited(_requestController?.close());
    _requestController = null;
  }

  bool _isFatalError(Object error) {
    return error is AuthExpiredError ||
        error is PermissionDeniedError ||
        error is SessionNotFoundError;
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
        // Close the old request controller before creating a new one.
        unawaited(_requestController?.close());

        // Re-open a bidirectional Converse stream so the user can continue
        // sending messages after reconnection. The previous implementation
        // used resumeSession (server-streaming, read-only) which left
        // _requestController null — silently dropping all user messages.
        _requestController = StreamController<pb.AgentRequest>();
        final responseStream = _client.converse(_requestController!.stream);

        _eventSubscription = responseStream.listen(
          _onReconnectEvent,
          onError: _handleStreamError,
          onDone: _handleStreamDone,
          cancelOnError: false,
        );

        // Send a StartConversation with the existing session ID so the
        // daemon knows this is a resume, not a new session.
        _requestController!.add(
          pb.AgentRequest(
            start: pb.StartConversation(sessionId: active.sessionId),
          ),
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
    if (current is ConversationActive && current.sessionId.isNotEmpty) {
      // Reconnect if stream is gone (died while backgrounded) or if a
      // reconnect was already in progress when we paused.
      if (_eventSubscription == null || _isReconnecting) {
        debugPrint('[Conversation] Resuming reconnection from attempt 0');
        _reconnectAttempt = 0;
        _attemptReconnection(current);
      }
    }
  }

  void _handleStreamDone() {
    final current = state.value;
    final sessionId =
        current is ConversationActive ? current.sessionId : 'n/a';
    final lastSeq =
        current is ConversationActive ? current.lastSequence : -1;
    debugPrint(
      '[Conversation] Stream done '
      '(sessionId: $sessionId, lastSeq: $lastSeq, '
      'paused: $_paused, reconnecting: $_isReconnecting)',
    );
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = null;

    if (current is ConversationActive && current.sessionId.isNotEmpty) {
      // Stream closed while conversation is active — attempt reconnection
      // so the user can continue sending messages. Without this, the UI
      // stays in ConversationActive but _requestController is null, causing
      // sendMessage() to silently drop all messages.
      debugPrint('[Conversation] Stream closed unexpectedly, reconnecting');
      _attemptReconnection(current);
    } else {
      debugPrint('[Conversation] Stream done with no active session, cleaning');
      _cleanup();
    }
  }

  /// Completes the history completer if it is pending, unblocking any
  /// awaiting `_loadHistory` call. Called when the history subscription is
  /// cancelled externally (by a new `startConversation` or `_cleanup`).
  void _completeHistoryIfPending() {
    if (_historyCompleter != null && !_historyCompleter!.isCompleted) {
      _historyCompleter!.complete();
    }
    _historyCompleter = null;
  }

  void _cleanup() {
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = null;
    unawaited(_historySubscription?.cancel());
    _historySubscription = null;
    _completeHistoryIfPending();
    unawaited(_requestController?.close());
    _requestController = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempt = 0;
    _isReconnecting = false;
    // Note: _paused is NOT reset here. It tracks the app lifecycle state and
    // is managed by _onAppPaused / _onAppResumed. Resetting it in _cleanup
    // would cause _onAppResumed to exit early if close() runs while the app
    // is backgrounded.
  }
}
