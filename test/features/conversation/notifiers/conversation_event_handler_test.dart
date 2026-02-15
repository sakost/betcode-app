import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_event_handler.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/common.pbenum.dart';
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart'
    as wkt;

/// A minimal AsyncNotifier that mixes in ConversationEventHandler for testing.
class _TestNotifier extends AsyncNotifier<ConversationState>
    with ConversationEventHandler {
  @override
  FutureOr<ConversationState> build() => const ConversationState.initial();
}

final _testProvider = AsyncNotifierProvider<_TestNotifier, ConversationState>(
  _TestNotifier.new,
);

void main() {
  late ProviderContainer container;
  late _TestNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    // Force the provider to initialise.
    container.read(_testProvider);
    notifier = container.read(_testProvider.notifier);
  });

  tearDown(() => container.dispose());

  /// Helper: put the notifier into an active state.
  void seedActive({int lastSequence = 0}) {
    notifier.state = AsyncData(
      ConversationState.active(
        sessionId: 'sess-1',
        messages: [],
        agentStatus: AgentStatus.AGENT_STATUS_IDLE,
        lastSequence: lastSequence,
      ),
    );
  }

  group('handleEvent - sessionInfo', () {
    test('transitions from initial to active', () {
      final event = pb.AgentEvent(
        sequence: Int64(1),
        sessionInfo: pb.SessionInfo(sessionId: 'sess-new'),
      );

      notifier.handleEvent(event);

      final state = notifier.state.value;
      expect(state, isA<ConversationActive>());
      final active = state as ConversationActive;
      expect(active.sessionId, 'sess-new');
      expect(active.lastSequence, 1);
    });

    test('updates existing active state sessionId', () {
      seedActive();

      final event = pb.AgentEvent(
        sequence: Int64(2),
        sessionInfo: pb.SessionInfo(sessionId: 'sess-updated'),
      );
      notifier.handleEvent(event);

      final active = notifier.state.value as ConversationActive;
      expect(active.sessionId, 'sess-updated');
      expect(active.lastSequence, 2);
    });
  });

  group('handleEvent - textDelta', () {
    test('creates new agent message on first delta', () {
      seedActive();

      final event = pb.AgentEvent(
        sequence: Int64(1),
        textDelta: pb.TextDelta(text: 'Hello'),
      );
      notifier.handleEvent(event);

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, hasLength(1));
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.content, 'Hello');
      expect(msg.isComplete, false);
    });

    test('appends to existing incomplete agent message', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          textDelta: pb.TextDelta(text: 'Hello '),
        ),
      );
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          textDelta: pb.TextDelta(text: 'world', isComplete: true),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, hasLength(1));
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.content, 'Hello world');
      expect(msg.isComplete, true);
    });
  });

  group('handleEvent - toolCallStart / toolCallResult', () {
    test('adds tool call message on start', () {
      seedActive();

      final event = pb.AgentEvent(
        sequence: Int64(1),
        toolCallStart: pb.ToolCallStart(
          toolId: 't-1',
          toolName: 'Read',
          description: 'Read a file',
        ),
      );
      notifier.handleEvent(event);

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, hasLength(1));
      final msg = active.messages.first as ToolCallMessage;
      expect(msg.toolName, 'Read');
      expect(msg.isComplete, false);
    });

    test('completes tool call on result', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 't-1',
            toolName: 'Read',
            description: 'Read a file',
          ),
        ),
      );

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          toolCallResult: pb.ToolCallResult(
            toolId: 't-1',
            output: 'file contents here',
            isError: false,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as ToolCallMessage;
      expect(msg.isComplete, true);
      expect(msg.output, 'file contents here');
      expect(msg.isError, false);
    });
  });

  group('handleEvent - statusChange', () {
    test('updates agent status', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          statusChange: pb.StatusChange(
            status: AgentStatus.AGENT_STATUS_THINKING,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agentStatus, AgentStatus.AGENT_STATUS_THINKING);
    });
  });

  group('handleEvent - turnComplete', () {
    test('marks incomplete agent messages as complete and sets idle', () {
      seedActive();

      // Add an incomplete agent message
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          textDelta: pb.TextDelta(text: 'partial'),
        ),
      );

      // Turn complete
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          turnComplete: pb.TurnComplete(stopReason: 'end_turn'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agentStatus, AgentStatus.AGENT_STATUS_IDLE);
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.isComplete, true);
    });
  });

  group('handleEvent - usageReport', () {
    test('updates usage info', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          usage: pb.UsageReport(
            inputTokens: 500,
            outputTokens: 200,
            model: 'opus-4',
            costUsd: 0.015,
            durationMs: 3200,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.usage, isNotNull);
      expect(active.usage!.inputTokens, 500);
      expect(active.usage!.outputTokens, 200);
      expect(active.usage!.model, 'opus-4');
    });
  });

  group('handleEvent - error', () {
    test('fatal error transitions to ConversationError', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          error: pb.ErrorEvent(
            code: 'FATAL',
            message: 'session expired',
            isFatal: true,
          ),
        ),
      );

      final state = notifier.state.value;
      expect(state, isA<ConversationError>());
      expect((state as ConversationError).message, '[FATAL] session expired');
    });

    test('non-fatal error sets errorMessage on active state', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          error: pb.ErrorEvent(
            code: 'WARN',
            message: 'rate limited',
            isFatal: false,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.errorMessage, '[WARN] rate limited');
    });
  });

  group('handleEvent - deduplication', () {
    test('skips events with sequence <= lastSequence', () {
      seedActive(lastSequence: 5);

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(3),
          textDelta: pb.TextDelta(text: 'old'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, isEmpty);
      expect(active.lastSequence, 5);
    });

    test('processes events with sequence > lastSequence', () {
      seedActive(lastSequence: 5);

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(6),
          textDelta: pb.TextDelta(text: 'new'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, hasLength(1));
      expect(active.lastSequence, 6);
    });
  });

  group('handleEvent - agent tracking', () {
    test('Task tool call registers an agent', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Launch agent: researcher',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents, hasLength(1));
      expect(active.agents['agent-1'], isNotNull);
      expect(active.agents['agent-1']!.name, 'researcher');
      expect(
        active.agents['agent-1']!.status,
        AgentStatus.AGENT_STATUS_EXECUTING_TOOL,
      );
    });

    test('Task tool result marks agent as complete', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Launch agent: researcher',
          ),
        ),
      );

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          toolCallResult: pb.ToolCallResult(toolId: 'agent-1', output: 'done'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.isComplete, true);
      expect(active.agents['agent-1']!.status, AgentStatus.AGENT_STATUS_IDLE);
    });

    test('status change with parentToolUseId updates agent status', () {
      seedActive();

      // Register an agent first
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Launch agent: builder',
          ),
        ),
      );

      // Status change for the agent
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          parentToolUseId: 'agent-1',
          statusChange: pb.StatusChange(
            status: AgentStatus.AGENT_STATUS_THINKING,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(
        active.agents['agent-1']!.status,
        AgentStatus.AGENT_STATUS_THINKING,
      );
    });

    test('events with parentToolUseId increment agent message count', () {
      seedActive();

      // Register an agent
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Launch agent: worker',
          ),
        ),
      );

      // Send events from the agent
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          parentToolUseId: 'agent-1',
          textDelta: pb.TextDelta(text: 'hello'),
        ),
      );
      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(3),
          parentToolUseId: 'agent-1',
          textDelta: pb.TextDelta(text: ' world'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.messageCount, 2);
      expect(active.agents['agent-1']!.lastActivity, isNotNull);
    });

    test('agent name falls back to "Agent N" when no match in description', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Some generic task',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.name, 'Agent 1');
    });

    test('agent name extracted from input JSON name field', () {
      seedActive();

      final input = wkt.Struct()
        ..fields['name'] = wkt.Value(stringValue: 'json-worker')
        ..fields['prompt'] = wkt.Value(stringValue: 'do stuff');

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Some generic task',
            input: input,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.name, 'json-worker');
    });

    test('agent name extracted from input JSON description field', () {
      seedActive();

      final input = wkt.Struct()
        ..fields['description'] = wkt.Value(stringValue: 'code reviewer');

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Some generic task',
            input: input,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.name, 'code reviewer');
    });

    test('agent name prefers description regex over input JSON', () {
      seedActive();

      final input = wkt.Struct()
        ..fields['name'] = wkt.Value(stringValue: 'json-name');

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 'agent-1',
            toolName: 'Task',
            description: 'Launch agent: regex-name',
            input: input,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents['agent-1']!.name, 'regex-name');
    });

    test('non-Task tool call does not register an agent', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 't-1',
            toolName: 'Read',
            description: 'Read a file',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents, isEmpty);
    });

    test('tool named TaskManager does not register an agent', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          toolCallStart: pb.ToolCallStart(
            toolId: 't-1',
            toolName: 'TaskManager',
            description: 'Manage tasks',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.agents, isEmpty);
    });
  });

  group('handleEvent - parentToolUseId propagation', () {
    test('textDelta carries parentToolUseId on agent messages', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          textDelta: pb.TextDelta(text: 'hello'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.parentToolUseId, 'agent-1');
    });

    test('textDelta without parentToolUseId has null parentToolUseId', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          textDelta: pb.TextDelta(text: 'hello'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.parentToolUseId, isNull);
    });

    test('toolCallStart carries parentToolUseId', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          toolCallStart: pb.ToolCallStart(
            toolId: 't-1',
            toolName: 'Read',
            description: 'Read file',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as ToolCallMessage;
      expect(msg.parentToolUseId, 'agent-1');
    });

    test('toolCallResult preserves parentToolUseId from start', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          toolCallStart: pb.ToolCallStart(
            toolId: 't-1',
            toolName: 'Read',
            description: 'Read file',
          ),
        ),
      );

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          toolCallResult: pb.ToolCallResult(toolId: 't-1', output: 'contents'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as ToolCallMessage;
      expect(msg.parentToolUseId, 'agent-1');
      expect(msg.isComplete, true);
    });

    test('permissionRequest carries parentToolUseId', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          permissionRequest: pb.PermissionRequest(
            requestId: 'perm-1',
            toolName: 'Bash',
            description: 'Run ls',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as PermissionRequestMessage;
      expect(msg.parentToolUseId, 'agent-1');
    });

    test('userQuestion carries parentToolUseId', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          userQuestion: pb.UserQuestion(
            questionId: 'q-1',
            question: 'Pick one',
            multiSelect: false,
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as UserQuestionMessage;
      expect(msg.parentToolUseId, 'agent-1');
    });

    test('turnComplete preserves parentToolUseId on agent messages', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          parentToolUseId: 'agent-1',
          textDelta: pb.TextDelta(text: 'partial'),
        ),
      );

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(2),
          turnComplete: pb.TurnComplete(stopReason: 'end_turn'),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      final msg = active.messages.first as AgentChatMessage;
      expect(msg.isComplete, true);
      expect(msg.parentToolUseId, 'agent-1');
    });
  });

  group('handleEvent - permissionRequest', () {
    test('adds permission message and sets waiting status', () {
      seedActive();

      notifier.handleEvent(
        pb.AgentEvent(
          sequence: Int64(1),
          permissionRequest: pb.PermissionRequest(
            requestId: 'perm-1',
            toolName: 'Bash',
            description: 'Run ls',
          ),
        ),
      );

      final active = notifier.state.value as ConversationActive;
      expect(active.messages, hasLength(1));
      expect(active.messages.first, isA<PermissionRequestMessage>());
      expect(active.agentStatus, AgentStatus.AGENT_STATUS_WAITING_FOR_USER);
    });
  });
}
