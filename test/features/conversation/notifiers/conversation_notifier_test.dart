import 'dart:async';

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
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    eventController = StreamController<pb.AgentEvent>();
    capturedRequests = [];

    when(() => mockClient.converse(any())).thenAnswer((inv) {
      final reqStream =
          inv.positionalArguments[0] as Stream<pb.AgentRequest>;
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
  Future<void> goActive(ConversationNotifier n,
      {String sessionId = 'sess-1'}) async {
    await n.startConversation();
    eventController.add(pb.AgentEvent(
      sequence: Int64(1),
      sessionInfo: pb.SessionInfo(sessionId: sessionId),
    ));
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

      await n.startConversation();

      expect(states.any((s) => s.value is ConversationConnecting), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(capturedRequests, hasLength(1));
      expect(capturedRequests.first.hasStart(), isTrue);
      expect(capturedRequests.first.start.sessionId, '');
    });

    test('sends existing sessionId for resume', () async {
      await notifier('sess-resume').startConversation();
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
      final fc = ProviderContainer(overrides: [
        agentServiceProvider.overrideWithValue(
          FailingConverseClient(GrpcError.unavailable('no conn')),
        ),
      ]);
      addTearDown(fc.dispose);

      fc.read(conversationProvider(null));
      final n = fc.read(conversationProvider(null).notifier);
      await n.startConversation();

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
      expect(
          (active.messages.first as UserChatMessage).content, 'Hello agent');
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

      eventController.add(pb.AgentEvent(
        sequence: Int64(2),
        permissionRequest: pb.PermissionRequest(
          requestId: 'perm-1',
          toolName: 'Bash',
          description: 'Run ls',
        ),
      ));
      await Future<void>.delayed(Duration.zero);

      n.respondToPermission(
          'perm-1', PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE);
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
          'x', PermissionDecision.PERMISSION_DECISION_DENY);
      expect(stateVal(), isA<ConversationInitial>());
    });
  });

  group('respondToQuestion', () {
    test('updates message and sends response', () async {
      final n = notifier();
      await goActive(n);

      eventController.add(pb.AgentEvent(
        sequence: Int64(2),
        userQuestion: pb.UserQuestion(
          questionId: 'q-1',
          question: 'Which?',
          multiSelect: false,
        ),
      ));
      await Future<void>.delayed(Duration.zero);

      n.respondToQuestion('q-1', {'choice': 'A'});
      await Future<void>.delayed(Duration.zero);

      final qm =
          (stateVal() as ConversationActive)
              .messages
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
    test('stream error transitions to ConversationError', () async {
      final n = notifier();
      await goActive(n);

      eventController.addError(GrpcError.unavailable('lost'));
      await Future<void>.delayed(Duration.zero);

      final s = stateVal();
      expect(s, isA<ConversationError>());
      expect((s as ConversationError).message, contains('lost'));
    });

    test('stream done sets idle status on active state', () async {
      final n = notifier();
      await goActive(n);

      eventController.add(pb.AgentEvent(
        sequence: Int64(2),
        statusChange:
            pb.StatusChange(status: AgentStatus.AGENT_STATUS_THINKING),
      ));
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
        (inv.positionalArguments[0] as Stream<pb.AgentRequest>)
            .listen((_) {});
        return FakeResponseStream<pb.AgentEvent>(lc);
      });

      final lCont = ProviderContainer(
        overrides: [agentServiceProvider.overrideWithValue(lm)],
      );
      lCont.read(conversationProvider(null));
      final n = lCont.read(conversationProvider(null).notifier);
      await n.startConversation();

      lCont.dispose();

      // Adding events after dispose should not throw.
      lc.add(pb.AgentEvent(
        sequence: Int64(99),
        sessionInfo: pb.SessionInfo(sessionId: 'ghost'),
      ));
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
        ..add(pb.AgentEvent(
          sequence: Int64(2),
          statusChange:
              pb.StatusChange(status: AgentStatus.AGENT_STATUS_THINKING),
        ))
        ..add(pb.AgentEvent(
          sequence: Int64(3),
          textDelta: pb.TextDelta(text: '4'),
        ))
        ..add(pb.AgentEvent(
          sequence: Int64(4),
          turnComplete: pb.TurnComplete(stopReason: 'end_turn'),
        ));
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
}
