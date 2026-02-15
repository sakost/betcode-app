import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/commands/notifiers/commands_providers.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/fake_response_stream.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockCommandServiceClient extends Mock implements CommandServiceClient {}

/// A fake client whose [getCommandRegistry] always throws [GrpcError].
class _FailingCommandClient extends Fake implements CommandServiceClient {
  _FailingCommandClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<GetCommandRegistryResponse> getCommandRegistry(
    GetCommandRegistryRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockCommandServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(GetCommandRegistryRequest());
    registerFallbackValue(ListAgentsRequest());
    registerFallbackValue(ListPathRequest());
    registerFallbackValue(ExecuteServiceCommandRequest());
  });

  setUp(() {
    mockClient = MockCommandServiceClient();

    container = createTestContainer(
      overrides: [commandServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  CommandEntry makeCommand(
    String name, {
    String description = 'A test command',
    CommandCategory category = CommandCategory.COMMAND_CATEGORY_SERVICE,
    ExecutionMode executionMode = ExecutionMode.EXECUTION_MODE_LOCAL,
  }) => CommandEntry(
    name: name,
    description: description,
    category: category,
    executionMode: executionMode,
  );

  group('CommandsNotifier - build', () {
    test('fetches command registry from gRPC', () async {
      final commands = [makeCommand('cmd-1'), makeCommand('cmd-2')];
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(commands: commands),
        ),
      );

      final result = await container.read(commandsProvider.future);

      expect(result, hasLength(2));
      expect(result[0].name, 'cmd-1');
      expect(result[1].name, 'cmd-2');
    });

    test('returns empty list when no commands exist', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );

      final result = await container.read(commandsProvider.future);
      expect(result, isEmpty);
    });

    test('preserves command fields from the response', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(
            commands: [
              CommandEntry(
                name: 'deploy',
                description: 'Deploy to production',
                category: CommandCategory.COMMAND_CATEGORY_PLUGIN,
                executionMode: ExecutionMode.EXECUTION_MODE_PLUGIN,
                source: 'deploy-plugin',
                argsSchema: '{"type":"object"}',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(commandsProvider.future);

      expect(result, hasLength(1));
      final cmd = result.first;
      expect(cmd.name, 'deploy');
      expect(cmd.description, 'Deploy to production');
      expect(cmd.category, CommandCategory.COMMAND_CATEGORY_PLUGIN);
      expect(cmd.executionMode, ExecutionMode.EXECUTION_MODE_PLUGIN);
      expect(cmd.source, 'deploy-plugin');
      expect(cmd.argsSchema, '{"type":"object"}');
    });
  });

  group('CommandsNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final dc = await createDisconnectedContainer(
        provider: commandsProvider,
        overrides: [commandServiceProvider.overrideWithValue(mockClient)],
      );
      final state = dc.read(commandsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      await createDisconnectedContainer(
        provider: commandsProvider,
        overrides: [commandServiceProvider.overrideWithValue(mockClient)],
      );
      verifyNever(() => mockClient.getCommandRegistry(any()));
    });
  });

  group('CommandsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final ec = await createErrorContainer(
        provider: commandsProvider,
        overrides: [
          commandServiceProvider.overrideWithValue(
            _FailingCommandClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      final state = ec.read(commandsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final ec = await createErrorContainer(
        provider: commandsProvider,
        overrides: [
          commandServiceProvider.overrideWithValue(
            _FailingCommandClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      final state = ec.read(commandsProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('CommandsNotifier - listAgents', () {
    test('returns AgentInfo list', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final agents = [
        AgentInfo(name: 'agent-1', kind: AgentKind.AGENT_KIND_CLAUDE_INTERNAL),
        AgentInfo(name: 'agent-2', kind: AgentKind.AGENT_KIND_TEAM_MEMBER),
      ];
      when(() => mockClient.listAgents(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListAgentsResponse(agents: agents)),
      );

      final notifier = container.read(commandsProvider.notifier);
      final result = await notifier.listAgents(query: 'test', maxResults: 10);

      expect(result, hasLength(2));
      expect(result[0].name, 'agent-1');
      expect(result[1].name, 'agent-2');
    });

    test('passes correct query and maxResults to gRPC', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      when(
        () => mockClient.listAgents(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListAgentsResponse()));

      final notifier = container.read(commandsProvider.notifier);
      await notifier.listAgents(query: 'claude', maxResults: 5);

      final captured =
          verify(() => mockClient.listAgents(captureAny())).captured.single
              as ListAgentsRequest;

      expect(captured.query, 'claude');
      expect(captured.maxResults, 5);
    });

    test('preserves AgentInfo fields from response', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      when(() => mockClient.listAgents(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListAgentsResponse(
            agents: [
              AgentInfo(
                name: 'my-agent',
                kind: AgentKind.AGENT_KIND_DAEMON_ORCHESTRATED,
                status: CommandAgentStatus.COMMAND_AGENT_STATUS_WORKING,
                source: 'daemon',
                sessionId: 'sess-123',
              ),
            ],
          ),
        ),
      );

      final notifier = container.read(commandsProvider.notifier);
      final result = await notifier.listAgents();

      expect(result, hasLength(1));
      final agent = result.first;
      expect(agent.name, 'my-agent');
      expect(agent.kind, AgentKind.AGENT_KIND_DAEMON_ORCHESTRATED);
      expect(agent.status, CommandAgentStatus.COMMAND_AGENT_STATUS_WORKING);
      expect(agent.source, 'daemon');
      expect(agent.sessionId, 'sess-123');
    });
  });

  group('CommandsNotifier - listPath', () {
    test('returns PathEntry list', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final entries = [
        PathEntry(
          path: '/home/user/project',
          kind: PathKind.PATH_KIND_DIRECTORY,
        ),
        PathEntry(path: '/home/user/file.txt', kind: PathKind.PATH_KIND_FILE),
      ];
      when(() => mockClient.listPath(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListPathResponse(entries: entries)),
      );

      final notifier = container.read(commandsProvider.notifier);
      final result = await notifier.listPath(query: '/home', maxResults: 10);

      expect(result, hasLength(2));
      expect(result[0].path, '/home/user/project');
      expect(result[0].kind, PathKind.PATH_KIND_DIRECTORY);
      expect(result[1].path, '/home/user/file.txt');
      expect(result[1].kind, PathKind.PATH_KIND_FILE);
    });

    test('passes correct query and maxResults to gRPC', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      when(
        () => mockClient.listPath(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPathResponse()));

      final notifier = container.read(commandsProvider.notifier);
      await notifier.listPath(query: '/tmp', maxResults: 15);

      final captured =
          verify(() => mockClient.listPath(captureAny())).captured.single
              as ListPathRequest;

      expect(captured.query, '/tmp');
      expect(captured.maxResults, 15);
    });
  });

  group('CommandsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(commands: [makeCommand('cmd-1')]),
        ),
      );
      await container.read(commandsProvider.future);

      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(
            commands: [makeCommand('cmd-1'), makeCommand('cmd-new')],
          ),
        ),
      );

      final notifier = container.read(commandsProvider.notifier);
      await notifier.refresh();

      final state = container.read(commandsProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].name, 'cmd-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<CommandEntry>>>[];

      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(commands: [makeCommand('cmd-1')]),
        ),
      );
      await container.read(commandsProvider.future);

      container.listen(commandsProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetCommandRegistryResponse(commands: [makeCommand('cmd-2')]),
        ),
      );

      final notifier = container.read(commandsProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.name, 'cmd-2');
    });

    test('refresh calls gRPC exactly once', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      reset(mockClient);
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );

      final notifier = container.read(commandsProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.getCommandRegistry(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // CommandsNotifier - executeServiceCommand (server-streaming)
  // ---------------------------------------------------------------------------

  group('CommandsNotifier - executeServiceCommand', () {
    test('returns stream of ServiceCommandOutput', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      final stream = notifier.executeServiceCommand(
        command: 'deploy',
        args: ['--prod'],
      );

      // Subscribe first via toList(), then add events and close.
      final eventsFuture = stream.toList();

      controller.add(ServiceCommandOutput(stdoutLine: 'Deploying...'));
      controller.add(ServiceCommandOutput(stdoutLine: 'Done.'));
      controller.add(ServiceCommandOutput(exitCode: 0));
      unawaited(controller.close());

      final events = await eventsFuture;

      expect(events, hasLength(3));
      expect(events[0].stdoutLine, 'Deploying...');
      expect(events[1].stdoutLine, 'Done.');
      expect(events[2].exitCode, 0);
    });

    test('passes correct command and args to gRPC', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      addTearDown(() { controller.close(); });
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      notifier.executeServiceCommand(
        command: 'test-cmd',
        args: ['--flag', 'value'],
      );

      final captured =
          verify(() => mockClient.executeServiceCommand(captureAny()))
              .captured
              .single as ExecuteServiceCommandRequest;
      expect(captured.command, 'test-cmd');
      expect(captured.args, ['--flag', 'value']);
    });

    test('defaults to empty args', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      addTearDown(() { controller.close(); });
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      notifier.executeServiceCommand(command: 'simple');

      final captured =
          verify(() => mockClient.executeServiceCommand(captureAny()))
              .captured
              .single as ExecuteServiceCommandRequest;
      expect(captured.command, 'simple');
      expect(captured.args, isEmpty);
    });

    test('emits stderr lines', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      final stream = notifier.executeServiceCommand(command: 'fail');

      final eventsFuture = stream.toList();

      controller.add(ServiceCommandOutput(stderrLine: 'Error occurred'));
      controller.add(ServiceCommandOutput(exitCode: 1));
      unawaited(controller.close());

      final events = await eventsFuture;

      expect(events, hasLength(2));
      expect(events[0].stderrLine, 'Error occurred');
      expect(events[1].exitCode, 1);
    });

    test('emits error output variant', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      final stream = notifier.executeServiceCommand(command: 'bad');

      final eventsFuture = stream.toList();

      controller.add(ServiceCommandOutput(error: 'command not found'));
      unawaited(controller.close());

      final events = await eventsFuture;

      expect(events, hasLength(1));
      expect(events.first.error, 'command not found');
      expect(
        events.first.whichOutput(),
        ServiceCommandOutput_Output.error,
      );
    });

    test('propagates stream errors', () async {
      when(() => mockClient.getCommandRegistry(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
      );
      await container.read(commandsProvider.future);

      final controller = StreamController<ServiceCommandOutput>();
      when(() => mockClient.executeServiceCommand(any())).thenAnswer(
        (_) => FakeResponseStream(controller),
      );

      final notifier = container.read(commandsProvider.notifier);
      final stream = notifier.executeServiceCommand(command: 'err');

      controller.addError(GrpcError.unavailable('stream broken'));
      unawaited(controller.close());

      await expectLater(stream, emitsError(isA<GrpcError>()));
    });
  });
}
