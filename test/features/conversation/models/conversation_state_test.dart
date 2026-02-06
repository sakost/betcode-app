import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/generated/betcode/v1/common.pbenum.dart';

void main() {
  group('ConversationState', () {
    test('initial creates ConversationInitial', () {
      const state = ConversationState.initial();
      expect(state, isA<ConversationInitial>());
    });

    test('connecting creates ConversationConnecting', () {
      const state = ConversationState.connecting();
      expect(state, isA<ConversationConnecting>());
    });

    test('active creates ConversationActive with correct fields', () {
      final state = ConversationState.active(
        sessionId: 'sess-1',
        messages: [],
        agentStatus: AgentStatus.AGENT_STATUS_IDLE,
        lastSequence: 5,
      );

      expect(state, isA<ConversationActive>());
      final active = state as ConversationActive;
      expect(active.sessionId, 'sess-1');
      expect(active.messages, isEmpty);
      expect(active.agentStatus, AgentStatus.AGENT_STATUS_IDLE);
      expect(active.lastSequence, 5);
      expect(active.todos, isEmpty);
      expect(active.planModeActive, false);
      expect(active.planContent, isNull);
      expect(active.usage, isNull);
      expect(active.errorMessage, isNull);
    });

    test('error creates ConversationError with message', () {
      const state = ConversationState.error('something failed');
      expect(state, isA<ConversationError>());
      expect((state as ConversationError).message, 'something failed');
    });

    test('active copyWith updates fields correctly', () {
      final original = ConversationState.active(
        sessionId: 'sess-1',
        messages: [],
        agentStatus: AgentStatus.AGENT_STATUS_IDLE,
        lastSequence: 0,
      ) as ConversationActive;

      final updated = original.copyWith(
        sessionId: 'sess-2',
        lastSequence: 10,
        agentStatus: AgentStatus.AGENT_STATUS_THINKING,
      );

      expect(updated.sessionId, 'sess-2');
      expect(updated.lastSequence, 10);
      expect(updated.agentStatus, AgentStatus.AGENT_STATUS_THINKING);
      expect(updated.messages, isEmpty); // unchanged
    });

    test('equality works for same constructors', () {
      const a = ConversationState.initial();
      const b = ConversationState.initial();
      expect(a, equals(b));

      const c = ConversationState.error('x');
      const d = ConversationState.error('x');
      expect(c, equals(d));

      const e = ConversationState.error('x');
      const f = ConversationState.error('y');
      expect(e, isNot(equals(f)));
    });
  });

  group('ChatMessage', () {
    test('user creates UserChatMessage', () {
      final msg = ChatMessage.user(
        content: 'hello',
        timestamp: DateTime(2026),
      );
      expect(msg, isA<UserChatMessage>());
      expect((msg as UserChatMessage).content, 'hello');
    });

    test('agent creates AgentChatMessage with defaults', () {
      final msg = ChatMessage.agent(
        content: 'response',
        timestamp: DateTime(2026),
      );
      expect(msg, isA<AgentChatMessage>());
      final agent = msg as AgentChatMessage;
      expect(agent.content, 'response');
      expect(agent.isComplete, false);
    });

    test('toolCall creates ToolCallMessage with defaults', () {
      final msg = ChatMessage.toolCall(
        toolId: 'tool-1',
        toolName: 'Read',
        description: 'Read file',
      );
      expect(msg, isA<ToolCallMessage>());
      final tool = msg as ToolCallMessage;
      expect(tool.toolId, 'tool-1');
      expect(tool.toolName, 'Read');
      expect(tool.isComplete, false);
      expect(tool.isError, false);
      expect(tool.output, isNull);
    });

    test('permissionRequest creates PermissionRequestMessage', () {
      final msg = ChatMessage.permissionRequest(
        requestId: 'perm-1',
        toolName: 'Bash',
        description: 'Run command',
      );
      expect(msg, isA<PermissionRequestMessage>());
      final perm = msg as PermissionRequestMessage;
      expect(perm.requestId, 'perm-1');
      expect(perm.decision, isNull);
    });

    test('userQuestion creates UserQuestionMessage', () {
      final msg = ChatMessage.userQuestion(
        questionId: 'q-1',
        question: 'Which option?',
        options: [],
        multiSelect: false,
      );
      expect(msg, isA<UserQuestionMessage>());
      final q = msg as UserQuestionMessage;
      expect(q.questionId, 'q-1');
      expect(q.multiSelect, false);
      expect(q.answers, isNull);
    });
  });

  group('UsageInfo', () {
    test('default values', () {
      const info = UsageInfo();
      expect(info.inputTokens, 0);
      expect(info.outputTokens, 0);
      expect(info.cacheReadTokens, 0);
      expect(info.cacheCreationTokens, 0);
      expect(info.model, '');
      expect(info.costUsd, 0.0);
      expect(info.durationMs, 0);
    });

    test('custom values', () {
      const info = UsageInfo(
        inputTokens: 100,
        outputTokens: 200,
        model: 'opus',
        costUsd: 0.05,
      );
      expect(info.inputTokens, 100);
      expect(info.outputTokens, 200);
      expect(info.model, 'opus');
      expect(info.costUsd, 0.05);
    });

    test('equality', () {
      const a = UsageInfo(inputTokens: 100);
      const b = UsageInfo(inputTokens: 100);
      const c = UsageInfo(inputTokens: 200);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
