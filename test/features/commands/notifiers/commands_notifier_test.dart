import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/commands/notifiers/commands_notifier.dart';
import 'package:betcode_app/features/commands/notifiers/commands_providers.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/fake_response_stream.dart';
import '../../../helpers/notifier_test_helpers.dart';
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

  connectionAwarenessTests(
    label: 'CommandsNotifier',
    provider: commandsProvider,
    serviceOverrides: () => [
      commandServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () =>
        verifyNever(() => mockClient.getCommandRegistry(any())),
  );

  errorHandlingTests(
    label: 'CommandsNotifier',
    provider: commandsProvider,
    errorOverrides: (error) => [
      commandServiceProvider.overrideWithValue(_FailingCommandClient(error)),
    ],
  );

  void stubRegistryEmpty() {
    when(
      () => mockClient.getCommandRegistry(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(GetCommandRegistryResponse()));
  }

  /// Returns an initialized notifier ready for method calls.
  Future<CommandsNotifier> initCommandsNotifier() async {
    await initNotifier(
      container: container,
      provider: commandsProvider,
      stubEmpty: stubRegistryEmpty,
    );
    return container.read(commandsProvider.notifier);
  }

  group('CommandsNotifier - listAgents', () {
    test('returns AgentInfo list', () async {
      final notifier = await initCommandsNotifier();

      final agents = [
        AgentInfo(name: 'agent-1', kind: AgentKind.AGENT_KIND_CLAUDE_INTERNAL),
        AgentInfo(name: 'agent-2', kind: AgentKind.AGENT_KIND_TEAM_MEMBER),
      ];
      when(() => mockClient.listAgents(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListAgentsResponse(agents: agents)),
      );

      final result = await notifier.listAgents(query: 'test', maxResults: 10);

      expect(result, hasLength(2));
      expect(result[0].name, 'agent-1');
      expect(result[1].name, 'agent-2');
    });

    test('passes correct query and maxResults to gRPC', () async {
      final notifier = await initCommandsNotifier();

      when(
        () => mockClient.listAgents(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListAgentsResponse()));

      await notifier.listAgents(query: 'claude', maxResults: 5);

      final captured =
          verify(() => mockClient.listAgents(captureAny())).captured.single
              as ListAgentsRequest;

      expect(captured.query, 'claude');
      expect(captured.maxResults, 5);
    });

    test('preserves AgentInfo fields from response', () async {
      final notifier = await initCommandsNotifier();

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
      final notifier = await initCommandsNotifier();

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

      final result = await notifier.listPath(query: '/home', maxResults: 10);

      expect(result, hasLength(2));
      expect(result[0].path, '/home/user/project');
      expect(result[0].kind, PathKind.PATH_KIND_DIRECTORY);
      expect(result[1].path, '/home/user/file.txt');
      expect(result[1].kind, PathKind.PATH_KIND_FILE);
    });

    test('passes correct query and maxResults to gRPC', () async {
      final notifier = await initCommandsNotifier();

      when(
        () => mockClient.listPath(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPathResponse()));

      await notifier.listPath(query: '/tmp', maxResults: 15);

      final captured =
          verify(() => mockClient.listPath(captureAny())).captured.single
              as ListPathRequest;

      expect(captured.query, '/tmp');
      expect(captured.maxResults, 15);
    });
  });

  refreshTests(
    RefreshTestConfig<List<CommandEntry>>(
      provider: commandsProvider,
      label: 'CommandsNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.getCommandRegistry(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            GetCommandRegistryResponse(commands: [makeCommand('cmd-1')]),
          ),
        );
      },
      stubRefreshed: () {
        when(() => mockClient.getCommandRegistry(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            GetCommandRegistryResponse(
              commands: [makeCommand('cmd-1'), makeCommand('cmd-new')],
            ),
          ),
        );
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(() => mockClient.getCommandRegistry(any())).thenAnswer(
          (_) => FakeResponseFuture.value(GetCommandRegistryResponse()),
        );
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.getCommandRegistry(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].name,
    ),
  );

  // ---------------------------------------------------------------------------
  // CommandsNotifier - executeServiceCommand (server-streaming)
  // ---------------------------------------------------------------------------

  group('CommandsNotifier - executeServiceCommand', () {
    /// Initializes notifier and stubs executeServiceCommand to use the returned
    /// controller.
    Future<
      ({
        CommandsNotifier notifier,
        StreamController<ServiceCommandOutput> controller,
      })
    >
    initForExec() async {
      await initNotifier(
        container: container,
        provider: commandsProvider,
        stubEmpty: stubRegistryEmpty,
      );
      final controller = StreamController<ServiceCommandOutput>();
      when(
        () => mockClient.executeServiceCommand(any()),
      ).thenAnswer((_) => FakeResponseStream(controller));
      final notifier = container.read(commandsProvider.notifier);
      return (notifier: notifier, controller: controller);
    }

    test('returns stream of ServiceCommandOutput', () async {
      final (:notifier, :controller) = await initForExec();
      final stream = notifier.executeServiceCommand(
        command: 'deploy',
        args: ['--prod'],
      );
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
      final (:notifier, :controller) = await initForExec();
      addTearDown(() {
        controller.close();
      });
      notifier.executeServiceCommand(
        command: 'test-cmd',
        args: ['--flag', 'value'],
      );

      final captured =
          verify(
                () => mockClient.executeServiceCommand(captureAny()),
              ).captured.single
              as ExecuteServiceCommandRequest;
      expect(captured.command, 'test-cmd');
      expect(captured.args, ['--flag', 'value']);
    });

    test('defaults to empty args', () async {
      final (:notifier, :controller) = await initForExec();
      addTearDown(() {
        controller.close();
      });
      notifier.executeServiceCommand(command: 'simple');

      final captured =
          verify(
                () => mockClient.executeServiceCommand(captureAny()),
              ).captured.single
              as ExecuteServiceCommandRequest;
      expect(captured.command, 'simple');
      expect(captured.args, isEmpty);
    });

    test('emits stderr lines', () async {
      final (:notifier, :controller) = await initForExec();
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
      final (:notifier, :controller) = await initForExec();
      final stream = notifier.executeServiceCommand(command: 'bad');
      final eventsFuture = stream.toList();

      controller.add(ServiceCommandOutput(error: 'command not found'));
      unawaited(controller.close());

      final events = await eventsFuture;
      expect(events, hasLength(1));
      expect(events.first.error, 'command not found');
      expect(events.first.whichOutput(), ServiceCommandOutput_Output.error);
    });

    test('propagates stream errors', () async {
      final (:notifier, :controller) = await initForExec();
      final stream = notifier.executeServiceCommand(command: 'err');

      controller.addError(GrpcError.unavailable('stream broken'));
      unawaited(controller.close());

      await expectLater(stream, emitsError(isA<GrpcError>()));
    });
  });
}
