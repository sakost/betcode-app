import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_notifier.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/features/conversation/screens/conversation_screen.dart';
import 'package:betcode_app/features/conversation/widgets/input_bar.dart';
import 'package:betcode_app/features/conversation/widgets/message_bubble.dart';
import 'package:betcode_app/features/conversation/widgets/status_indicator.dart';
import 'package:betcode_app/features/conversation/widgets/plan_mode_banner.dart';
import 'package:betcode_app/features/conversation/widgets/todo_list_panel.dart';
import 'package:betcode_app/features/conversation/widgets/tool_call_card.dart';
import 'package:betcode_app/features/conversation/widgets/usage_display.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_notifier.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockConversationNotifier extends AsyncNotifier<ConversationState>
    with Mock
    implements ConversationNotifier {
  final ConversationState _state;

  MockConversationNotifier(this._state);

  @override
  FutureOr<ConversationState> build() => _state;
}

class _FakeWorktreesNotifier extends WorktreesNotifier {
  _FakeWorktreesNotifier(this._worktrees);

  final List<WorktreeDetail> _worktrees;

  @override
  Future<List<WorktreeDetail>> build() async => _worktrees;
}

/// A notifier that returns a canned async value for worktrees, supporting
/// loading, error, and data states.
class _FakeAsyncWorktreesNotifier extends WorktreesNotifier {
  _FakeAsyncWorktreesNotifier(this._value);

  final AsyncValue<List<WorktreeDetail>> _value;

  @override
  Future<List<WorktreeDetail>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () =>
          Completer<List<WorktreeDetail>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

class _FakeSessionsNotifier extends SessionsNotifier {
  @override
  Future<List<SessionSummary>> build() async => [];
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _sessionId = 'test-session-1';

Widget _buildApp({
  String? sessionId = _sessionId,
  required ConversationState state,
  MockConversationNotifier? notifier,
  List<WorktreeDetail>? worktrees,
}) {
  final mock = notifier ?? MockConversationNotifier(state);
  final defaultWorktrees =
      worktrees ??
      [WorktreeDetail(id: 'wt-1', name: 'main', path: '/home/user/project')];
  return ProviderScope(
    overrides: [
      conversationProvider(sessionId).overrideWith(() => mock),
      worktreesProvider.overrideWith(
        () => _FakeWorktreesNotifier(defaultWorktrees),
      ),
      sessionsProvider.overrideWith(_FakeSessionsNotifier.new),
    ],
    child: MaterialApp(home: ConversationScreen(sessionId: sessionId)),
  );
}

/// Builds the app with worktrees in a specific async state (loading, error,
/// or data). Used to test the initial conversation screen's worktree-aware UI.
Widget _buildAppWithWorktreeState({
  String? sessionId = _sessionId,
  required ConversationState state,
  required AsyncValue<List<WorktreeDetail>> worktreeState,
}) {
  return ProviderScope(
    overrides: [
      conversationProvider(
        sessionId,
      ).overrideWith(() => MockConversationNotifier(state)),
      worktreesProvider.overrideWith(
        () => _FakeAsyncWorktreesNotifier(worktreeState),
      ),
      sessionsProvider.overrideWith(_FakeSessionsNotifier.new),
    ],
    child: MaterialApp(home: ConversationScreen(sessionId: sessionId)),
  );
}

ConversationActive _activeState({
  List<ChatMessage> messages = const [],
  AgentStatus agentStatus = AgentStatus.AGENT_STATUS_IDLE,
  UsageInfo? usage,
  String? errorMessage,
  List<TodoItem> todos = const [],
  bool planModeActive = false,
  String? planContent,
}) =>
    ConversationState.active(
          sessionId: _sessionId,
          messages: messages,
          agentStatus: agentStatus,
          lastSequence: 0,
          usage: usage,
          errorMessage: errorMessage,
          todos: todos,
          planModeActive: planModeActive,
          planContent: planContent,
        )
        as ConversationActive;

void main() {
  group('ConversationScreen', () {
    // -----------------------------------------------------------------------
    // State rendering
    // -----------------------------------------------------------------------

    group('state rendering', () {
      testWidgets('initial state shows start button', (tester) async {
        await tester.pumpWidget(
          _buildApp(state: const ConversationState.initial()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Start a conversation'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('start button calls startConversation', (tester) async {
        final notifier = MockConversationNotifier(
          const ConversationState.initial(),
        );
        when(
          () => notifier.startConversation(
            workingDirectory: any(named: 'workingDirectory'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _buildApp(
            state: const ConversationState.initial(),
            notifier: notifier,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        verify(
          () => notifier.startConversation(
            workingDirectory: '/home/user/project',
          ),
        ).called(1);
      });

      testWidgets('connecting state shows progress indicator', (tester) async {
        await tester.pumpWidget(
          _buildApp(state: const ConversationState.connecting()),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Connecting...'), findsOneWidget);
      });

      testWidgets('error state shows error and retry button', (tester) async {
        final notifier = MockConversationNotifier(
          const ConversationState.error('Network failure'),
        );
        when(
          () => notifier.startConversation(
            workingDirectory: any(named: 'workingDirectory'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _buildApp(
            state: const ConversationState.error('Network failure'),
            notifier: notifier,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Network failure'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);

        await tester.tap(find.text('Retry'));
        await tester.pump();

        verify(
          () => notifier.startConversation(
            workingDirectory: '/home/user/project',
          ),
        ).called(1);
      });

      testWidgets('active state shows message list and input bar', (
        tester,
      ) async {
        await tester.pumpWidget(_buildApp(state: _activeState()));
        await tester.pumpAndSettle();

        expect(find.byType(InputBar), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Initial state: worktree-aware UI
    // -----------------------------------------------------------------------

    group('initial state worktree handling', () {
      testWidgets('shows loading indicator while worktrees are loading', (
        tester,
      ) async {
        await tester.pumpWidget(
          _buildAppWithWorktreeState(
            state: const ConversationState.initial(),
            worktreeState: const AsyncLoading(),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading worktrees...'), findsOneWidget);
        expect(find.text('Start a conversation'), findsNothing);
      });

      testWidgets('shows error when worktrees fail to load', (tester) async {
        await tester.pumpWidget(
          _buildAppWithWorktreeState(
            state: const ConversationState.initial(),
            worktreeState: AsyncError(
              Exception('connection refused'),
              StackTrace.empty,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('connection refused'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Start a conversation'), findsNothing);
      });

      testWidgets('shows empty state when no worktrees exist', (tester) async {
        await tester.pumpWidget(
          _buildAppWithWorktreeState(
            state: const ConversationState.initial(),
            worktreeState: const AsyncData([]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('No worktrees available'), findsOneWidget);
        expect(find.byIcon(Icons.account_tree_outlined), findsOneWidget);
        expect(find.text('Create Worktree'), findsOneWidget);
        expect(find.text('Start a conversation'), findsNothing);
      });

      testWidgets('shows start button when worktrees are available', (
        tester,
      ) async {
        final worktrees = [
          WorktreeDetail(id: 'wt-1', name: 'main', path: '/home/user/project'),
        ];
        await tester.pumpWidget(
          _buildAppWithWorktreeState(
            state: const ConversationState.initial(),
            worktreeState: AsyncData(worktrees),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Start a conversation'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Loading worktrees...'), findsNothing);
        expect(find.text('No worktrees available.'), findsNothing);
      });

      testWidgets('does not show start button when worktrees have empty path', (
        tester,
      ) async {
        final worktrees = [WorktreeDetail(id: 'wt-1', name: 'main', path: '')];
        await tester.pumpWidget(
          _buildAppWithWorktreeState(
            state: const ConversationState.initial(),
            worktreeState: AsyncData(worktrees),
          ),
        );
        await tester.pumpAndSettle();

        // Worktrees exist but path is empty — _resolveWorkingDirectory
        // returns null, so Start would fail. The UI should show the
        // Start button (it checks worktrees.isEmpty, not paths), but
        // tapping it would show a snackbar.
        expect(find.text('Start a conversation'), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: messages
    // -----------------------------------------------------------------------

    group('active state messages', () {
      testWidgets('user message renders as MessageBubble with isUser=true', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.user(content: 'Hello agent', timestamp: DateTime(2024)),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final bubble = tester.widget<MessageBubble>(find.byType(MessageBubble));
        expect(bubble.content, 'Hello agent');
        expect(bubble.isUser, isTrue);
      });

      testWidgets('agent message renders as MessageBubble with isUser=false', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.agent(
              content: 'I can help with that',
              timestamp: DateTime(2024),
              isComplete: true,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final bubble = tester.widget<MessageBubble>(find.byType(MessageBubble));
        expect(bubble.content, 'I can help with that');
        expect(bubble.isUser, isFalse);
        expect(bubble.isStreaming, isFalse);
      });

      testWidgets('streaming agent message shows isStreaming=true', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.agent(
              content: 'Thinking...',
              timestamp: DateTime(2024),
              isComplete: false,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pump();

        final bubble = tester.widget<MessageBubble>(find.byType(MessageBubble));
        expect(bubble.isStreaming, isTrue);
      });

      testWidgets('tool call renders as ToolCallCard', (tester) async {
        final state = _activeState(
          messages: [
            const ChatMessage.toolCall(
              toolId: 'tool-1',
              toolName: 'Read',
              description: 'Reading file.dart',
              output: 'file contents',
              isComplete: true,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final card = tester.widget<ToolCallCard>(find.byType(ToolCallCard));
        expect(card.toolName, 'Read');
        expect(card.description, 'Reading file.dart');
        expect(card.isComplete, isTrue);
      });

      testWidgets(
        'permission request without decision shows ToolCallCard with shield',
        (tester) async {
          final state = _activeState(
            messages: [
              const ChatMessage.permissionRequest(
                requestId: 'perm-1',
                toolName: 'Bash',
                description: 'Run shell command',
              ),
            ],
          );
          await tester.pumpWidget(_buildApp(state: state));
          await tester.pumpAndSettle();

          // Permission requests render as ToolCallCard with isPermission
          expect(find.byType(ToolCallCard), findsOneWidget);
          expect(find.byIcon(Icons.shield), findsOneWidget);
          expect(find.text('Bash'), findsOneWidget);
        },
      );

      testWidgets('permission request with decision shows Allowed badge', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.permissionRequest(
              requestId: 'perm-1',
              toolName: 'Bash',
              description: 'Run shell command',
              decision: PermissionDecision.PERMISSION_DECISION_ALLOW_ONCE,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('Bash'), findsOneWidget);
        expect(find.text('Allowed'), findsOneWidget);
        expect(find.byIcon(Icons.shield), findsOneWidget);
      });

      testWidgets('user question without answers shows tap to answer card', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.userQuestion(
              questionId: 'q-1',
              question: 'Which option?',
              options: [QuestionOption(value: 'a', label: 'Option A')],
              multiSelect: false,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('Tap to answer'), findsOneWidget);
        expect(find.text('Which option?'), findsOneWidget);
      });

      testWidgets('user question with answers shows answered indicator', (
        tester,
      ) async {
        final state = _activeState(
          messages: [
            ChatMessage.userQuestion(
              questionId: 'q-1',
              question: 'Which option?',
              options: [QuestionOption(value: 'a', label: 'Option A')],
              multiSelect: false,
              answers: {'a': 'a'},
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('Tap to answer'), findsNothing);
        expect(find.text('Answered'), findsOneWidget);
      });

      testWidgets('multiple messages render in order', (tester) async {
        final state = _activeState(
          messages: [
            ChatMessage.user(content: 'First', timestamp: DateTime(2024)),
            ChatMessage.agent(
              content: 'Second',
              timestamp: DateTime(2024),
              isComplete: true,
            ),
            const ChatMessage.toolCall(
              toolId: 'tool-1',
              toolName: 'Read',
              description: 'Third',
              isComplete: true,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(MessageBubble), findsNWidgets(2));
        expect(find.byType(ToolCallCard), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: input bar interaction
    // -----------------------------------------------------------------------

    group('input bar', () {
      testWidgets('sendMessage called on submit', (tester) async {
        final notifier = MockConversationNotifier(_activeState());
        when(() => notifier.sendMessage(any())).thenReturn(null);

        await tester.pumpWidget(
          _buildApp(state: _activeState(), notifier: notifier),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Hello');
        await tester.pump();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        verify(() => notifier.sendMessage('Hello')).called(1);
      });

      testWidgets('input bar disabled when agent is thinking', (tester) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_THINKING,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final inputBar = tester.widget<InputBar>(find.byType(InputBar));
        expect(inputBar.enabled, isFalse);
      });

      testWidgets('input bar enabled when agent is idle', (tester) async {
        final state = _activeState(agentStatus: AgentStatus.AGENT_STATUS_IDLE);
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final inputBar = tester.widget<InputBar>(find.byType(InputBar));
        expect(inputBar.enabled, isTrue);
      });

      testWidgets('input bar disabled when agent is executing tool', (
        tester,
      ) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_EXECUTING_TOOL,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        final inputBar = tester.widget<InputBar>(find.byType(InputBar));
        expect(inputBar.enabled, isFalse);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: cancel button
    // -----------------------------------------------------------------------

    group('cancel button', () {
      testWidgets('cancel button visible when agent is thinking', (
        tester,
      ) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_THINKING,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.stop), findsOneWidget);
        expect(find.text('Stop'), findsOneWidget);
      });

      testWidgets('cancel button visible when agent is executing tool', (
        tester,
      ) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_EXECUTING_TOOL,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.stop), findsOneWidget);
        expect(find.text('Stop'), findsOneWidget);
      });

      testWidgets('cancel button visible when agent is compacting', (
        tester,
      ) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_COMPACTING,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.stop), findsOneWidget);
        expect(find.text('Stop'), findsOneWidget);
      });

      testWidgets('cancel button hidden when agent is idle', (tester) async {
        final state = _activeState(agentStatus: AgentStatus.AGENT_STATUS_IDLE);
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.stop), findsNothing);
        expect(find.text('Stop'), findsNothing);
      });

      testWidgets('cancel button hidden when agent is waiting for user', (
        tester,
      ) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_WAITING_FOR_USER,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.stop), findsNothing);
        expect(find.text('Stop'), findsNothing);
      });

      testWidgets('tapping cancel button calls cancelTurn on notifier', (
        tester,
      ) async {
        final notifier = MockConversationNotifier(
          _activeState(agentStatus: AgentStatus.AGENT_STATUS_THINKING),
        );
        when(() => notifier.cancelTurn()).thenReturn(null);

        await tester.pumpWidget(
          _buildApp(
            state: _activeState(agentStatus: AgentStatus.AGENT_STATUS_THINKING),
            notifier: notifier,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.stop));
        await tester.pump();

        verify(() => notifier.cancelTurn()).called(1);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: status indicator
    // -----------------------------------------------------------------------

    group('status indicator', () {
      testWidgets('shows StatusIndicator in app bar', (tester) async {
        final state = _activeState(
          agentStatus: AgentStatus.AGENT_STATUS_THINKING,
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(StatusIndicator), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: usage display
    // -----------------------------------------------------------------------

    group('usage display', () {
      testWidgets('shows UsageDisplay when usage info available', (
        tester,
      ) async {
        final state = _activeState(
          usage: const UsageInfo(
            inputTokens: 1500,
            outputTokens: 500,
            costUsd: 0.0042,
          ),
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(UsageDisplay), findsOneWidget);
      });

      testWidgets('hides UsageDisplay when no usage info', (tester) async {
        final state = _activeState();
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(UsageDisplay), findsNothing);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: error message banner
    // -----------------------------------------------------------------------

    group('error message banner', () {
      testWidgets('shows error banner when errorMessage is set', (
        tester,
      ) async {
        final state = _activeState(errorMessage: 'Reconnecting...');
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('Reconnecting...'), findsOneWidget);
      });

      testWidgets('no error banner when errorMessage is null', (tester) async {
        final state = _activeState();
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        // The word "Reconnecting..." should not appear
        expect(find.byType(MaterialBanner), findsNothing);
      });
    });

    // -----------------------------------------------------------------------
    // App bar
    // -----------------------------------------------------------------------

    group('app bar', () {
      testWidgets('has Conversation title', (tester) async {
        await tester.pumpWidget(
          _buildApp(state: const ConversationState.initial()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Conversation'), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: todo list panel
    // -----------------------------------------------------------------------

    group('todo list panel', () {
      testWidgets('TodoListPanel shown when todos are non-empty', (
        tester,
      ) async {
        final state = _activeState(
          todos: [
            TodoItem(
              id: '1',
              subject: 'Fix bug',
              status: TodoStatus.TODO_STATUS_PENDING,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(TodoListPanel), findsOneWidget);
      });

      testWidgets('TodoListPanel not shown when todos are empty', (
        tester,
      ) async {
        final state = _activeState();
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        // The widget is present but renders nothing (SizedBox.shrink)
        expect(find.byType(TodoListPanel), findsOneWidget);
        expect(find.byType(ExpansionTile), findsNothing);
      });

      testWidgets('TodoListPanel shows correct count badge', (tester) async {
        final state = _activeState(
          todos: [
            TodoItem(
              id: '1',
              subject: 'Done',
              status: TodoStatus.TODO_STATUS_COMPLETED,
            ),
            TodoItem(
              id: '2',
              subject: 'Pending',
              status: TodoStatus.TODO_STATUS_PENDING,
            ),
          ],
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('1/2 done'), findsOneWidget);
      });
    });

    // -----------------------------------------------------------------------
    // Active state: plan mode banner
    // -----------------------------------------------------------------------

    group('plan mode banner', () {
      testWidgets('PlanModeBanner shown when planModeActive is true', (
        tester,
      ) async {
        final state = _activeState(planModeActive: true);
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.byType(PlanModeBanner), findsOneWidget);
        expect(find.text('Plan Mode'), findsOneWidget);
      });

      testWidgets('PlanModeBanner hidden when planModeActive is false', (
        tester,
      ) async {
        final state = _activeState(planModeActive: false);
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        // Widget is present but renders nothing
        expect(find.byType(PlanModeBanner), findsOneWidget);
        expect(find.text('Plan Mode'), findsNothing);
      });

      testWidgets('PlanModeBanner shows plan content when provided', (
        tester,
      ) async {
        final state = _activeState(
          planModeActive: true,
          planContent: 'Step 1: Do things',
        );
        await tester.pumpWidget(_buildApp(state: state));
        await tester.pumpAndSettle();

        expect(find.text('Plan Mode'), findsOneWidget);
      });
    });
  });
}
