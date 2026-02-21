import 'dart:async';

import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/lifecycle/app_lifecycle_notifier.dart';
import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_notifier.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pbenum.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'conversation_notifier_helpers.dart';

void main() {
  late MockAgentServiceClient mockClient;
  late ProviderContainer container;
  late StreamController<pb.AgentEvent> eventController;
  late List<pb.AgentRequest> capturedRequests;

  setUpAll(() {
    registerFallbackValue(const Stream<pb.AgentRequest>.empty());
    registerFallbackValue(pb.ResumeSessionRequest());
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    eventController = StreamController<pb.AgentEvent>();
    capturedRequests = [];

    when(() => mockClient.converse(any())).thenAnswer((inv) {
      (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen(
        capturedRequests.add,
      );
      return FakeResponseStream<pb.AgentEvent>(eventController);
    });

    // Default: resumeSession returns empty stream (no history).
    when(() => mockClient.resumeSession(any())).thenAnswer((_) {
      final c = StreamController<pb.AgentEvent>();
      unawaited(c.close());
      return FakeResponseStream<pb.AgentEvent>(c);
    });

    container = ProviderContainer(
      overrides: [agentServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() {
    container.dispose();
    if (!eventController.isClosed) unawaited(eventController.close());
  });

  ConversationNotifier notifier([String? id]) {
    container.read(conversationProvider(id));
    return container.read(conversationProvider(id).notifier);
  }

  ConversationState? stateVal([String? id]) =>
      container.read(conversationProvider(id)).value;

  /// Seeds the notifier into active state via SessionInfo event.
  Future<void> goActive(
    ConversationNotifier n, {
    String sessionId = 'sess-1',
  }) async {
    await n.startConversation(workingDirectory: '/tmp');
    eventController.add(
      pb.AgentEvent(
        sequence: Int64(1),
        sessionInfo: pb.SessionInfo(sessionId: sessionId),
      ),
    );
    await Future<void>.delayed(Duration.zero);
  }

  group('build', () {
    test('starts with ConversationInitial', () {
      final n = notifier();
      expect(stateVal(), isA<ConversationInitial>());
      expect(n.sessionId, isNull);
    });

    test('preserves sessionId from family parameter', () {
      expect(notifier('sess-42').sessionId, 'sess-42');
    });
  });

  group('startConversation', () {
    test('transitions to connecting then wires bidi stream', () async {
      final states = <AsyncValue<ConversationState>>[];
      final n = notifier();
      container.listen(conversationProvider(null), (_, next) {
        states.add(next);
      });

      await n.startConversation(workingDirectory: '/tmp');

      expect(states.any((s) => s.value is ConversationConnecting), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(capturedRequests, hasLength(1));
      expect(capturedRequests.first.hasStart(), isTrue);
      expect(capturedRequests.first.start.sessionId, '');
    });

    test('sends existing sessionId for resume', () async {
      await notifier('sess-resume').startConversation(workingDirectory: '/tmp');
      await Future<void>.delayed(Duration.zero);
      expect(capturedRequests.first.start.sessionId, 'sess-resume');
    });

    test('receives SessionInfo and transitions to active', () async {
      final n = notifier();
      await goActive(n, sessionId: 'sess-assigned');
      final s = stateVal()! as ConversationActive;
      expect(s.sessionId, 'sess-assigned');
    });

    test('catches error if converse() throws', () async {
      final fc = ProviderContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(
            FailingConverseClient(const GrpcError.unavailable('no conn')),
          ),
        ],
      );
      addTearDown(fc.dispose);

      fc.read(conversationProvider(null));
      final n = fc.read(conversationProvider(null).notifier);
      await n.startConversation(workingDirectory: '/tmp');

      final s = fc.read(conversationProvider(null)).value;
      expect(s, isA<ConversationError>());
      expect(
        (s! as ConversationError).message,
        contains('Failed to start conversation'),
      );
    });
  });

  group('sendMessage', () {
    test('adds user message and sends through request stream', () async {
      final n = notifier();
      await goActive(n);

      n.sendMessage('Hello agent');
      await Future<void>.delayed(Duration.zero);

      final active = stateVal()! as ConversationActive;
      expect(active.messages, hasLength(1));
      expect(active.messages.first, isA<UserChatMessage>());
      expect(
        (active.messages.first as UserChatMessage).content,
        'Hello agent',
      );
      expect(capturedRequests.last.hasMessage(), isTrue);
      expect(capturedRequests.last.message.content, 'Hello agent');
    });

    test('no-ops when state is not active', () {
      notifier().sendMessage('ignored');
      expect(stateVal(), isA<ConversationInitial>());
      expect(capturedRequests, isEmpty);
    });
  });

  group('respondToPermission', () {
    test('updates message and sends response', () async {
      final n = notifier();
      await goActive(n);

      eventController.add(
        pb.AgentEvent(
          sequence: Int64(2),
          permissionRequest: pb.PermissionRequest(
            requestId: 'perm-1',
            toolName: 'Bash',
            description: 'Run ls',
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      n.respondToPermission(
        'perm-1',
        PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE,
      );
      await Future<void>.delayed(Duration.zero);

      final active = stateVal()! as ConversationActive;
      final pm = active.messages.whereType<PermissionRequestMessage>().first;
      expect(pm.decision, PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE);

      final req = capturedRequests.last;
      expect(req.hasPermission(), isTrue);
      expect(req.permission.requestId, 'perm-1');
    });

    test('no-ops when state is not active', () {
      notifier().respondToPermission(
        'x',
        PermissionDecision.PERMISSION_DECISION_DENY,
      );
      expect(stateVal(), isA<ConversationInitial>());
    });
  });

  group('respondToQuestion', () {
    test('updates message and sends response', () async {
      final n = notifier();
      await goActive(n);

      eventController.add(
        pb.AgentEvent(
          sequence: Int64(2),
          userQuestion: pb.UserQuestion(
            questionId: 'q-1',
            question: 'Which?',
            multiSelect: false,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      n.respondToQuestion('q-1', {'choice': 'A'});
      await Future<void>.delayed(Duration.zero);

      final qm = (stateVal()! as ConversationActive).messages
          .whereType<UserQuestionMessage>()
          .first;
      expect(qm.answers, {'choice': 'A'});

      final req = capturedRequests.last;
      expect(req.hasQuestionResponse(), isTrue);
      expect(req.questionResponse.questionId, 'q-1');
    });

    test('no-ops when state is not active', () {
      notifier().respondToQuestion('q-1', {'a': 'b'});
      expect(stateVal(), isA<ConversationInitial>());
    });
  });

  group('cancelTurn', () {
    test('sends CancelRequest through the stream', () async {
      final n = notifier();
      await goActive(n);

      n.cancelTurn();
      await Future<void>.delayed(Duration.zero);

      expect(capturedRequests.last.hasCancel(), isTrue);
      expect(capturedRequests.last.cancel.reason, 'User cancelled');
    });

    test('no-ops when request controller is null', () {
      notifier().cancelTurn();
      expect(capturedRequests, isEmpty);
    });
  });

  group('history load', () {
    test(
      'AppException during history load sets errorMessage, not fatal',
      () async {
        // When the ErrorMappingInterceptor maps a GrpcError to an AppException
        // during history load, the conversation should stay active with a soft
        // error message rather than transitioning to ConversationError.
        const sid = 'sess-history';
        final historyController = StreamController<pb.AgentEvent>();
        when(() => mockClient.resumeSession(any())).thenAnswer((_) {
          historyController.addError(
            const NetworkError(message: 'Connection lost. Retrying...'),
          );
          return FakeResponseStream<pb.AgentEvent>(historyController);
        });

        final n = notifier(sid);
        await n.startConversation(workingDirectory: '/tmp');
        await Future<void>.delayed(Duration.zero);

        // startConversation sets state to ConversationActive before calling
        // _loadHistory. The history load should catch the AppException
        // gracefully and set errorMessage without killing the conversation.
        final s = stateVal(sid);
        expect(s, isA<ConversationActive>());
        expect(
          (s! as ConversationActive).errorMessage,
          "Couldn't load message history.",
        );

        await historyController.close();
      },
    );
  });

  group('stream error handling', () {
    test(
      'transient stream error triggers reconnection on active session',
      () async {
        final n = notifier();
        await goActive(n);

        eventController.addError(const GrpcError.unavailable('lost'));
        await Future<void>.delayed(Duration.zero);

        // Should still be active (attempting reconnection), not error.
        final s = stateVal();
        expect(s, isA<ConversationActive>());
        expect(
          (s! as ConversationActive).errorMessage,
          contains('Reconnecting'),
        );
      },
    );

    test('fatal stream error transitions to ConversationError', () async {
      final n = notifier();
      await goActive(n);

      eventController.addError(
        const AuthExpiredError(
          message: 'Your session has expired. Please log in again.',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final s = stateVal();
      expect(s, isA<ConversationError>());
      expect(
        (s! as ConversationError).message,
        'Your session has expired. Please log in again.',
      );
    });

    test('stream done triggers reconnection on active session', () async {
      // After the fix, stream done on an active session triggers
      // reconnection rather than leaving the UI broken with no request
      // controller.
      final n = notifier();
      await goActive(n);

      eventController.add(
        pb.AgentEvent(
          sequence: Int64(2),
          statusChange: pb.StatusChange(
            status: AgentStatus.AGENT_STATUS_THINKING,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      await eventController.close();
      await Future<void>.delayed(Duration.zero);

      final a = stateVal()! as ConversationActive;
      expect(a.errorMessage, contains('Reconnecting'));
    });
  });

  group('dispose/cleanup', () {
    test('container dispose cleans up without errors', () async {
      final lc = StreamController<pb.AgentEvent>();
      final lm = MockAgentServiceClient();
      when(() => lm.converse(any())).thenAnswer((inv) {
        (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen((_) {});
        return FakeResponseStream<pb.AgentEvent>(lc);
      });

      final lCont = ProviderContainer(
        overrides: [agentServiceProvider.overrideWithValue(lm)],
      )..read(conversationProvider(null));
      final n = lCont.read(
        conversationProvider(null).notifier,
      );
      await n.startConversation(workingDirectory: '/tmp');

      lCont.dispose();

      // Adding events after dispose should not throw.
      lc.add(
        pb.AgentEvent(
          sequence: Int64(99),
          sessionInfo: pb.SessionInfo(sessionId: 'ghost'),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      await lc.close();
    });
  });

  group('full flow', () {
    test('start -> session -> message -> text -> complete', () async {
      final n = notifier();
      await goActive(n, sessionId: 'sess-full');

      n.sendMessage('2+2?');
      await Future<void>.delayed(Duration.zero);

      eventController
        ..add(
          pb.AgentEvent(
            sequence: Int64(2),
            statusChange: pb.StatusChange(
              status: AgentStatus.AGENT_STATUS_THINKING,
            ),
          ),
        )
        ..add(
          pb.AgentEvent(
            sequence: Int64(3),
            textDelta: pb.TextDelta(text: '4'),
          ),
        )
        ..add(
          pb.AgentEvent(
            sequence: Int64(4),
            turnComplete: pb.TurnComplete(stopReason: 'end_turn'),
          ),
        );
      await Future<void>.delayed(Duration.zero);

      final a = stateVal()! as ConversationActive;
      expect(a.sessionId, 'sess-full');
      expect(a.agentStatus, AgentStatus.AGENT_STATUS_IDLE);
      expect(a.messages, hasLength(2));
      expect(a.messages[0], isA<UserChatMessage>());
      expect((a.messages[1] as AgentChatMessage).content, '4');
      expect((a.messages[1] as AgentChatMessage).isComplete, true);
    });
  });

  group('reconnection', () {
    /// Starts a conversation and transitions to active state inside fakeAsync.
    ///
    /// Returns the notifier. After calling, the event stream has received
    /// a SessionInfo with the given [sessionId] and [sequence].
    ConversationNotifier startActive(
      FakeAsync async, {
      String sessionId = 'sess-1',
      int sequence = 1,
    }) {
      final n = notifier();
      unawaited(n.startConversation(workingDirectory: '/tmp'));
      async.flushMicrotasks();

      eventController.add(
        pb.AgentEvent(
          sequence: Int64(sequence),
          sessionInfo: pb.SessionInfo(sessionId: sessionId),
        ),
      );
      async.flushMicrotasks();
      return n;
    }

    /// Injects a transient error and flushes microtasks.
    void injectError(FakeAsync async, [GrpcError? error]) {
      eventController.addError(error ?? const GrpcError.unavailable('lost'));
      async.flushMicrotasks();
    }

    /// Counts reconnection converse calls (calls after the initial one).
    /// Returns a function that provides the current reconnection call count,
    /// and sets up the mock to return fresh event controllers on each call.
    ///
    /// [onReconnect] is called with each new event controller.
    ({
      int Function() callCount,
      StreamController<pb.AgentEvent> Function() latestController,
    })
    setupReconnectMock({
      void Function(StreamController<pb.AgentEvent>)? onReconnect,
      bool immediateError = false,
      GrpcError? throwOnConverse,
    }) {
      var reconnectCount = 0;
      StreamController<pb.AgentEvent>? latest;
      var isFirstCall = true;

      when(() => mockClient.converse(any())).thenAnswer((inv) {
        final reqStream = inv.positionalArguments[0] as Stream<pb.AgentRequest>;

        if (isFirstCall) {
          // First call is the initial startConversation.
          isFirstCall = false;
          reqStream.listen(capturedRequests.add);
          return FakeResponseStream<pb.AgentEvent>(eventController);
        }

        // Subsequent calls are reconnection attempts.
        reconnectCount++;

        if (throwOnConverse != null) {
          throw throwOnConverse;
        }

        if (immediateError) {
          reqStream.listen(capturedRequests.add);
          return ErrorResponseStream<pb.AgentEvent>(
            const GrpcError.unavailable('dns fail'),
          );
        }

        latest = StreamController<pb.AgentEvent>();
        reqStream.listen(capturedRequests.add);
        onReconnect?.call(latest!);
        return FakeResponseStream<pb.AgentEvent>(latest!);
      });

      return (
        callCount: () => reconnectCount,
        latestController: () => latest!,
      );
    }

    test('attempts reconnection on transient stream error', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async);
        injectError(async);

        async.elapse(const Duration(milliseconds: 600));

        expect(mock.callCount(), 1);

        unawaited(mock.latestController().close());
      });
    });

    test('sends StartConversation with correct session ID on reconnect', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async, sessionId: 'sess-42', sequence: 7);
        // Clear captured requests from initial start.
        capturedRequests.clear();

        injectError(async);

        async
          ..elapse(const Duration(milliseconds: 600))
          ..flushMicrotasks();

        expect(mock.callCount(), 1);
        // The reconnection should send a StartConversation request
        // with the existing session ID.
        expect(capturedRequests, isNotEmpty);
        final req = capturedRequests.first;
        expect(req.hasStart(), isTrue);
        expect(req.start.sessionId, 'sess-42');

        unawaited(mock.latestController().close());
      });
    });

    test('does not attempt reconnection when no session ID available', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        final n = notifier();
        unawaited(
          n.startConversation(workingDirectory: '/tmp'),
        );
        async.flushMicrotasks();

        // Error before SessionInfo
        injectError(async);

        async.elapse(const Duration(seconds: 60));

        expect(mock.callCount(), 0);

        final s = stateVal();
        expect(s, isA<ConversationError>());
      });
    });

    test('does not attempt reconnection on fatal error (unauthenticated)', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async);

        eventController.addError(
          const AuthExpiredError(
            message: 'Your session has expired. Please log in again.',
          ),
        );
        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 60));

        expect(mock.callCount(), 0);

        final s = stateVal();
        expect(s, isA<ConversationError>());
      });
    });

    test('transitions to error state after max reconnection attempts', () {
      fakeAsync((async) {
        setupReconnectMock(
          throwOnConverse: const GrpcError.unavailable('still down'),
        );

        startActive(async);
        injectError(async);

        // Advance well past all backoff durations.
        async.elapse(const Duration(minutes: 2));

        final s = stateVal();
        expect(s, isA<ConversationError>());
        expect((s! as ConversationError).message, contains('5'));
      });
    });

    test('successful reconnection resumes event processing', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async);
        injectError(async);

        async.elapse(const Duration(milliseconds: 600));

        mock.latestController().add(
          pb.AgentEvent(
            sequence: Int64(2),
            textDelta: pb.TextDelta(text: 'Hello again'),
          ),
        );
        async.flushMicrotasks();

        final a = stateVal()! as ConversationActive;
        expect(a.messages, hasLength(1));
        expect(
          (a.messages.first as AgentChatMessage).content,
          'Hello again',
        );
        expect(a.errorMessage, isNull);

        unawaited(mock.latestController().close());
      });
    });

    test('resets reconnect counter on successful reconnection', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async);

        // First disconnect.
        injectError(async);
        async.elapse(const Duration(milliseconds: 600));
        expect(mock.callCount(), 1);

        // Send an event so reconnect is considered successful.
        mock.latestController().add(
          pb.AgentEvent(
            sequence: Int64(2),
            statusChange: pb.StatusChange(
              status: AgentStatus.AGENT_STATUS_IDLE,
            ),
          ),
        );
        async.flushMicrotasks();

        // Second disconnect on the resumed stream.
        mock.latestController().addError(
          const GrpcError.unavailable('lost again'),
        );
        // Second reconnection should use first backoff (500ms).
        async
          ..flushMicrotasks()
          ..elapse(const Duration(milliseconds: 600));
        expect(mock.callCount(), 2);

        // State should still be active.
        final s = stateVal();
        expect(s, isA<ConversationActive>());

        unawaited(mock.latestController().close());
      });
    });

    test(
      'immediate stream error does not reset counter (backoff progresses)',
      () {
        fakeAsync((async) {
          final mock = setupReconnectMock(immediateError: true);

          startActive(async);
          injectError(async);

          // First attempt: 500ms backoff.
          async
            ..elapse(const Duration(milliseconds: 600))
            ..flushMicrotasks();
          expect(mock.callCount(), 1);

          // Second attempt: 1s backoff (counter NOT reset).
          async
            ..elapse(const Duration(seconds: 1))
            ..flushMicrotasks();
          expect(mock.callCount(), 2);

          // Third attempt: 3s backoff.
          async
            ..elapse(const Duration(seconds: 3))
            ..flushMicrotasks();
          expect(mock.callCount(), 3);
        });
      },
    );

    test(
      'exhausts max attempts with immediate stream errors (no infinite loop)',
      () {
        fakeAsync((async) {
          final mock = setupReconnectMock(immediateError: true);

          startActive(async);
          injectError(async);

          // Advance past all backoff durations.
          async.elapse(const Duration(minutes: 2));

          // Should have made exactly 5 attempts then stopped.
          expect(mock.callCount(), 5);

          final s = stateVal();
          expect(s, isA<ConversationError>());
          expect((s! as ConversationError).message, contains('5'));
        });
      },
    );

    test('counter only resets after receiving a successful event', () {
      fakeAsync((async) {
        final mock = setupReconnectMock();

        startActive(async);
        injectError(async);

        // First attempt fires at 500ms.
        async.elapse(const Duration(milliseconds: 600));
        expect(mock.callCount(), 1);

        // Stream is set up but no events sent yet — error it immediately.
        // The counter should NOT have been reset.
        mock.latestController().addError(
          const GrpcError.unavailable('still failing'),
        );
        // Second attempt should use 1s backoff (not 500ms).
        async
          ..flushMicrotasks()
          ..elapse(const Duration(milliseconds: 600));
        expect(
          mock.callCount(),
          1,
          reason: 'Should not retry yet at 500ms',
        );

        async.elapse(const Duration(milliseconds: 500));
        expect(mock.callCount(), 2, reason: 'Should retry at ~1s');
      });
    });
  });

  group('app lifecycle', () {
    /// Creates a container with lifecycle notifier override for testing.
    ProviderContainer createLifecycleContainer() {
      return ProviderContainer(
        overrides: [agentServiceProvider.overrideWithValue(mockClient)],
      );
    }

    AppLifecycleNotifier lifecycleNotifier(ProviderContainer c) =>
        c.read(appLifecycleProvider.notifier);

    test('paused state prevents reconnection while backgrounded', () {
      fakeAsync((async) {
        final c = createLifecycleContainer();
        addTearDown(c.dispose);

        // Track reconnection attempts (calls after initial).
        var reconnectCount = 0;
        var isFirstCall = true;
        when(() => mockClient.converse(any())).thenAnswer((inv) {
          final reqStream =
              inv.positionalArguments[0] as Stream<pb.AgentRequest>;
          if (isFirstCall) {
            isFirstCall = false;
            reqStream.listen(capturedRequests.add);
            return FakeResponseStream<pb.AgentEvent>(eventController);
          }
          reconnectCount++;
          reqStream.listen(capturedRequests.add);
          return ErrorResponseStream<pb.AgentEvent>(
            const GrpcError.unavailable('dns fail'),
          );
        });

        // Go active.
        c.read(conversationProvider(null));
        final n = c.read(
          conversationProvider(null).notifier,
        );
        unawaited(
          n.startConversation(workingDirectory: '/tmp'),
        );
        async.flushMicrotasks();

        eventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(
              sessionId: 'sess-lifecycle',
            ),
          ),
        );
        async.flushMicrotasks();

        // Background the app BEFORE any error occurs.
        lifecycleNotifier(c).transition(
          AppLifecycleState.paused,
        );
        async.flushMicrotasks();

        // Inject stream error while backgrounded.
        eventController.addError(
          const GrpcError.unavailable('lost'),
        );
        // Advance past all backoff durations.
        async
          ..flushMicrotasks()
          ..elapse(const Duration(minutes: 2));
        expect(
          reconnectCount,
          0,
          reason: 'No reconnect while paused',
        );

        c.dispose();
      });
    });

    test('resumed state triggers reconnection after background error', () {
      fakeAsync((async) {
        final c = createLifecycleContainer();
        addTearDown(c.dispose);

        var reconnectCount = 0;
        StreamController<pb.AgentEvent>? reconnectController;
        var isFirstCall = true;
        when(() => mockClient.converse(any())).thenAnswer((inv) {
          final reqStream =
              inv.positionalArguments[0] as Stream<pb.AgentRequest>;
          if (isFirstCall) {
            isFirstCall = false;
            reqStream.listen(capturedRequests.add);
            return FakeResponseStream<pb.AgentEvent>(eventController);
          }
          reconnectCount++;
          reconnectController = StreamController<pb.AgentEvent>();
          reqStream.listen(capturedRequests.add);
          return FakeResponseStream<pb.AgentEvent>(reconnectController!);
        });

        // Go active.
        c.read(conversationProvider(null));
        final n = c.read(
          conversationProvider(null).notifier,
        );
        unawaited(
          n.startConversation(workingDirectory: '/tmp'),
        );
        async.flushMicrotasks();

        eventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(
              sessionId: 'sess-lifecycle',
            ),
          ),
        );
        async.flushMicrotasks();

        // Inject error to trigger reconnection.
        eventController.addError(
          const GrpcError.unavailable('lost'),
        );
        async.flushMicrotasks();

        // Background the app (this should pause reconnection).
        lifecycleNotifier(c).transition(AppLifecycleState.paused);
        // Advance time — no reconnect while paused.
        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 5));
        expect(reconnectCount, 0);

        // Foreground the app.
        lifecycleNotifier(c).transition(AppLifecycleState.resumed);

        // Counter should be reset; first attempt fires at 500ms.
        async
          ..flushMicrotasks()
          ..elapse(const Duration(milliseconds: 600));
        expect(reconnectCount, 1, reason: 'Reconnect after resume');

        unawaited(reconnectController?.close());
        c.dispose();
      });
    });

    test('cleanup resets paused flag so new conversation works', () {
      fakeAsync((async) {
        final c = createLifecycleContainer();
        addTearDown(c.dispose);

        // Go active.
        c.read(conversationProvider(null));
        final n = c.read(
          conversationProvider(null).notifier,
        );
        unawaited(
          n.startConversation(workingDirectory: '/tmp'),
        );
        async.flushMicrotasks();

        eventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(
              sessionId: 'sess-cleanup',
            ),
          ),
        );
        async.flushMicrotasks();

        // Background the app (sets _paused = true).
        lifecycleNotifier(c).transition(
          AppLifecycleState.paused,
        );
        async.flushMicrotasks();

        // Use close() to explicitly terminate the conversation.
        // This resets state to initial and clears the paused flag.
        n.close();
        async.flushMicrotasks();

        // Foreground the app.
        lifecycleNotifier(c).transition(
          AppLifecycleState.resumed,
        );
        async.flushMicrotasks();

        // Start a new conversation (paused was reset).
        final newEventController = StreamController<pb.AgentEvent>();
        when(() => mockClient.converse(any())).thenAnswer(
          (inv) {
            (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen(
              (_) {},
            );
            return FakeResponseStream<pb.AgentEvent>(
              newEventController,
            );
          },
        );

        unawaited(
          n.startConversation(workingDirectory: '/tmp'),
        );
        async.flushMicrotasks();

        newEventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(sessionId: 'sess-new'),
          ),
        );
        async.flushMicrotasks();

        final s = c.read(conversationProvider(null)).value;
        expect(s, isA<ConversationActive>());
        expect((s! as ConversationActive).sessionId, 'sess-new');

        unawaited(newEventController.close());
        c.dispose();
      });
    });
  });

  group('close', () {
    test('resets state to initial and cleans up stream', () async {
      final n = notifier();
      await goActive(n);

      // Verify we're active.
      expect(stateVal(), isA<ConversationActive>());

      n.close();
      await Future<void>.delayed(Duration.zero);

      expect(stateVal(), isA<ConversationInitial>());
    });

    test('can start a new conversation after close', () async {
      final n = notifier();
      await goActive(n, sessionId: 'sess-old');

      n.close();
      await Future<void>.delayed(Duration.zero);

      // Need fresh event controller since old stream was cleaned up.
      final newEventController = StreamController<pb.AgentEvent>();
      when(() => mockClient.converse(any())).thenAnswer((inv) {
        (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen(
          capturedRequests.add,
        );
        return FakeResponseStream<pb.AgentEvent>(newEventController);
      });

      await n.startConversation(workingDirectory: '/tmp');
      newEventController.add(
        pb.AgentEvent(
          sequence: Int64(1),
          sessionInfo: pb.SessionInfo(sessionId: 'sess-new'),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(stateVal(), isA<ConversationActive>());
      expect((stateVal()! as ConversationActive).sessionId, 'sess-new');

      await newEventController.close();
    });

    test('close is safe to call when already initial', () {
      final n = notifier();
      expect(stateVal(), isA<ConversationInitial>());
      n.close(); // should not throw
      expect(stateVal(), isA<ConversationInitial>());
    });
  });

  group('startConversation without workingDirectory', () {
    test('resume sends empty workingDirectory when not provided', () async {
      await notifier('sess-resume').startConversation();
      await Future<void>.delayed(Duration.zero);
      expect(capturedRequests.first.start.sessionId, 'sess-resume');
      expect(capturedRequests.first.start.workingDirectory, '');
    });

    test('new session sends provided workingDirectory', () async {
      await notifier().startConversation(workingDirectory: '/my/dir');
      await Future<void>.delayed(Duration.zero);
      expect(capturedRequests.first.start.workingDirectory, '/my/dir');
    });
  });
}
