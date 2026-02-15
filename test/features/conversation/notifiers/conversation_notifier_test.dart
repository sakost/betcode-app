import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_notifier.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pbenum.dart';

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
      final reqStream = inv.positionalArguments[0] as Stream<pb.AgentRequest>;
      reqStream.listen(capturedRequests.add);
      return FakeResponseStream<pb.AgentEvent>(eventController);
    });

    container = ProviderContainer(
      overrides: [agentServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() {
    container.dispose();
    if (!eventController.isClosed) eventController.close();
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
      final s = stateVal() as ConversationActive;
      expect(s.sessionId, 'sess-assigned');
    });

    test('catches error if converse() throws', () async {
      final fc = ProviderContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(
            FailingConverseClient(GrpcError.unavailable('no conn')),
          ),
        ],
      );
      addTearDown(fc.dispose);

      fc.read(conversationProvider(null));
      final n = fc.read(conversationProvider(null).notifier);
      await n.startConversation(workingDirectory: '/tmp');

      final s = fc.read(conversationProvider(null)).value;
      expect(s, isA<ConversationError>());
      expect((s as ConversationError).message, contains('UNAVAILABLE'));
    });
  });

  group('sendMessage', () {
    test('adds user message and sends through request stream', () async {
      final n = notifier();
      await goActive(n);

      n.sendMessage('Hello agent');
      await Future<void>.delayed(Duration.zero);

      final active = stateVal() as ConversationActive;
      expect(active.messages, hasLength(1));
      expect(active.messages.first, isA<UserChatMessage>());
      expect((active.messages.first as UserChatMessage).content, 'Hello agent');
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

      final active = stateVal() as ConversationActive;
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

      final qm = (stateVal() as ConversationActive).messages
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

  group('stream error handling', () {
    test(
      'transient stream error triggers reconnection on active session',
      () async {
        when(() => mockClient.resumeSession(any())).thenAnswer(
          (_) => FakeResponseStream<pb.AgentEvent>(
            StreamController<pb.AgentEvent>(),
          ),
        );

        final n = notifier();
        await goActive(n);

        eventController.addError(GrpcError.unavailable('lost'));
        await Future<void>.delayed(Duration.zero);

        // Should still be active (attempting reconnection), not error.
        final s = stateVal();
        expect(s, isA<ConversationActive>());
        expect(
          (s as ConversationActive).errorMessage,
          contains('Reconnecting'),
        );
      },
    );

    test('fatal stream error transitions to ConversationError', () async {
      final n = notifier();
      await goActive(n);

      eventController.addError(GrpcError.unauthenticated('expired'));
      await Future<void>.delayed(Duration.zero);

      final s = stateVal();
      expect(s, isA<ConversationError>());
      expect((s as ConversationError).message, contains('expired'));
    });

    test('stream done sets idle status on active state', () async {
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

      final a = stateVal() as ConversationActive;
      expect(a.agentStatus, AgentStatus.AGENT_STATUS_IDLE);
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
      );
      lCont.read(conversationProvider(null));
      final n = lCont.read(conversationProvider(null).notifier);
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

      final a = stateVal() as ConversationActive;
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
      n.startConversation(workingDirectory: '/tmp');
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
      eventController.addError(error ?? GrpcError.unavailable('lost'));
      async.flushMicrotasks();
    }

    test('attempts reconnection on transient stream error', () {
      fakeAsync((async) {
        final resumeController = StreamController<pb.AgentEvent>();
        when(() => mockClient.resumeSession(any())).thenAnswer(
          (_) => FakeResponseStream<pb.AgentEvent>(resumeController),
        );

        startActive(async);
        injectError(async);

        async.elapse(const Duration(milliseconds: 600));

        verify(() => mockClient.resumeSession(any())).called(1);

        resumeController.close();
      });
    });

    test('sends ResumeSessionRequest with correct session ID and sequence', () {
      fakeAsync((async) {
        pb.ResumeSessionRequest? capturedRequest;
        final resumeController = StreamController<pb.AgentEvent>();
        when(() => mockClient.resumeSession(any())).thenAnswer((inv) {
          capturedRequest =
              inv.positionalArguments[0] as pb.ResumeSessionRequest;
          return FakeResponseStream<pb.AgentEvent>(resumeController);
        });

        startActive(async, sessionId: 'sess-42', sequence: 7);
        injectError(async);

        async.elapse(const Duration(milliseconds: 600));

        expect(capturedRequest, isNotNull);
        expect(capturedRequest!.sessionId, 'sess-42');
        expect(capturedRequest!.fromSequence, Int64(7));

        resumeController.close();
      });
    });

    test('does not attempt reconnection when no session ID available', () {
      fakeAsync((async) {
        when(() => mockClient.resumeSession(any())).thenAnswer(
          (_) => FakeResponseStream<pb.AgentEvent>(
            StreamController<pb.AgentEvent>(),
          ),
        );

        final n = notifier();
        n.startConversation(workingDirectory: '/tmp');
        async.flushMicrotasks();

        // Error before SessionInfo -- no session to reconnect to.
        injectError(async);

        async.elapse(const Duration(seconds: 60));

        verifyNever(() => mockClient.resumeSession(any()));

        final s = stateVal();
        expect(s, isA<ConversationError>());
      });
    });

    test('does not attempt reconnection on fatal error (unauthenticated)', () {
      fakeAsync((async) {
        when(() => mockClient.resumeSession(any())).thenAnswer(
          (_) => FakeResponseStream<pb.AgentEvent>(
            StreamController<pb.AgentEvent>(),
          ),
        );

        startActive(async);
        injectError(async, GrpcError.unauthenticated('expired'));

        async.elapse(const Duration(seconds: 60));

        verifyNever(() => mockClient.resumeSession(any()));

        final s = stateVal();
        expect(s, isA<ConversationError>());
      });
    });

    test('transitions to error state after max reconnection attempts', () {
      fakeAsync((async) {
        when(
          () => mockClient.resumeSession(any()),
        ).thenThrow(GrpcError.unavailable('still down'));

        startActive(async);
        injectError(async);

        // Advance well past all backoff durations (500ms + 1s + 3s + 10s + 30s = 44.5s).
        async.elapse(const Duration(minutes: 2));

        final s = stateVal();
        expect(s, isA<ConversationError>());
        expect((s as ConversationError).message, contains('5'));
      });
    });

    test('successful reconnection resumes event processing', () {
      fakeAsync((async) {
        final resumeController = StreamController<pb.AgentEvent>();
        when(() => mockClient.resumeSession(any())).thenAnswer(
          (_) => FakeResponseStream<pb.AgentEvent>(resumeController),
        );

        startActive(async);
        injectError(async);

        async.elapse(const Duration(milliseconds: 600));

        resumeController.add(
          pb.AgentEvent(
            sequence: Int64(2),
            textDelta: pb.TextDelta(text: 'Hello again'),
          ),
        );
        async.flushMicrotasks();

        final a = stateVal() as ConversationActive;
        expect(a.messages, hasLength(1));
        expect((a.messages.first as AgentChatMessage).content, 'Hello again');
        expect(a.errorMessage, isNull);

        resumeController.close();
      });
    });

    test('resets reconnect counter on successful reconnection', () {
      fakeAsync((async) {
        var resumeCallCount = 0;
        StreamController<pb.AgentEvent>? activeResumeController;

        when(() => mockClient.resumeSession(any())).thenAnswer((_) {
          resumeCallCount++;
          activeResumeController = StreamController<pb.AgentEvent>();
          return FakeResponseStream<pb.AgentEvent>(activeResumeController!);
        });

        startActive(async);

        // First disconnect.
        injectError(async);
        async.elapse(const Duration(milliseconds: 600));
        expect(resumeCallCount, 1);

        // Send an event on the resumed stream so reconnect is considered successful.
        activeResumeController!.add(
          pb.AgentEvent(
            sequence: Int64(2),
            statusChange: pb.StatusChange(
              status: AgentStatus.AGENT_STATUS_IDLE,
            ),
          ),
        );
        async.flushMicrotasks();

        // Second disconnect on the resumed stream.
        activeResumeController!.addError(GrpcError.unavailable('lost again'));
        async.flushMicrotasks();

        // The second reconnection should use the first backoff delay (500ms),
        // proving the counter was reset.
        async.elapse(const Duration(milliseconds: 600));
        expect(resumeCallCount, 2);

        // State should still be active (not error), confirming counter reset.
        final s = stateVal();
        expect(s, isA<ConversationActive>());

        activeResumeController?.close();
      });
    });
  });
}
