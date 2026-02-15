import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/plugins/notifiers/plugins_providers.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockCommandServiceClient extends Mock implements CommandServiceClient {}

/// A fake client whose [listPlugins] always throws [GrpcError].
class _FailingPluginClient extends Fake implements CommandServiceClient {
  _FailingPluginClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListPluginsResponse> listPlugins(
    ListPluginsRequest request, {
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
    registerFallbackValue(ListPluginsRequest());
    registerFallbackValue(GetPluginStatusRequest());
    registerFallbackValue(AddPluginRequest());
    registerFallbackValue(RemovePluginRequest());
    registerFallbackValue(EnablePluginRequest());
    registerFallbackValue(DisablePluginRequest());
  });

  setUp(() {
    mockClient = MockCommandServiceClient();

    container = createTestContainer(
      overrides: [commandServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  PluginInfo makePlugin(
    String name, {
    String socketPath = '/tmp/plugin.sock',
    bool enabled = true,
    String status = 'running',
    bool healthy = true,
  }) => PluginInfo(
    name: name,
    socketPath: socketPath,
    enabled: enabled,
    status: status,
    healthy: healthy,
  );

  group('PluginsNotifier - build', () {
    test('fetches plugin list from gRPC', () async {
      final plugins = [makePlugin('plugin-1'), makePlugin('plugin-2')];
      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListPluginsResponse(plugins: plugins)),
      );

      final result = await container.read(pluginsProvider.future);

      expect(result, hasLength(2));
      expect(result[0].name, 'plugin-1');
      expect(result[1].name, 'plugin-2');
    });

    test('returns empty list when no plugins exist', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final result = await container.read(pluginsProvider.future);
      expect(result, isEmpty);
    });

    test('preserves plugin fields from the response', () async {
      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPluginsResponse(
            plugins: [
              PluginInfo(
                name: 'my-plugin',
                socketPath: '/var/run/plugin.sock',
                enabled: true,
                status: 'healthy',
                commandCount: 5,
                healthMessage: 'All good',
                healthy: true,
              ),
            ],
          ),
        ),
      );

      final result = await container.read(pluginsProvider.future);

      expect(result, hasLength(1));
      final plugin = result.first;
      expect(plugin.name, 'my-plugin');
      expect(plugin.socketPath, '/var/run/plugin.sock');
      expect(plugin.enabled, isTrue);
      expect(plugin.status, 'healthy');
      expect(plugin.commandCount, 5);
      expect(plugin.healthMessage, 'All good');
      expect(plugin.healthy, isTrue);
    });
  });

  group('PluginsNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final dc = await createDisconnectedContainer(
        provider: pluginsProvider,
        overrides: [commandServiceProvider.overrideWithValue(mockClient)],
      );
      final state = dc.read(pluginsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      await createDisconnectedContainer(
        provider: pluginsProvider,
        overrides: [commandServiceProvider.overrideWithValue(mockClient)],
      );
      verifyNever(() => mockClient.listPlugins(any()));
    });
  });

  group('PluginsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final ec = await createErrorContainer(
        provider: pluginsProvider,
        overrides: [
          commandServiceProvider.overrideWithValue(
            _FailingPluginClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      final state = ec.read(pluginsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final ec = await createErrorContainer(
        provider: pluginsProvider,
        overrides: [
          commandServiceProvider.overrideWithValue(
            _FailingPluginClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      final state = ec.read(pluginsProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('PluginsNotifier - getPluginStatus', () {
    test('returns PluginInfo for given name', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      final expectedPlugin = makePlugin('my-plugin', status: 'healthy');
      when(() => mockClient.getPluginStatus(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetPluginStatusResponse(plugin: expectedPlugin),
        ),
      );

      final notifier = container.read(pluginsProvider.notifier);
      final result = await notifier.getPluginStatus('my-plugin');

      expect(result.name, 'my-plugin');
      expect(result.status, 'healthy');
    });

    test('passes correct name to gRPC', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      when(() => mockClient.getPluginStatus(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetPluginStatusResponse(plugin: makePlugin('test-plugin')),
        ),
      );

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.getPluginStatus('test-plugin');

      final captured =
          verify(() => mockClient.getPluginStatus(captureAny())).captured.single
              as GetPluginStatusRequest;

      expect(captured.name, 'test-plugin');
    });
  });

  group('PluginsNotifier - addPlugin', () {
    test(
      'calls gRPC addPlugin, refreshes list, and returns PluginInfo',
      () async {
        when(
          () => mockClient.listPlugins(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
        await container.read(pluginsProvider.future);

        final newPlugin = makePlugin('new-plugin');
        when(() => mockClient.addPlugin(any())).thenAnswer(
          (_) => FakeResponseFuture.value(AddPluginResponse(plugin: newPlugin)),
        );
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [newPlugin]),
          ),
        );

        final notifier = container.read(pluginsProvider.notifier);
        final result = await notifier.addPlugin(
          name: 'new-plugin',
          socketPath: '/tmp/plugin.sock',
        );

        expect(result.name, 'new-plugin');

        final state = container.read(pluginsProvider);
        expect(state.value, hasLength(1));
        expect(state.value!.first.name, 'new-plugin');
      },
    );

    test('passes correct parameters to gRPC', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      when(() => mockClient.addPlugin(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          AddPluginResponse(plugin: makePlugin('test')),
        ),
      );
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.addPlugin(
        name: 'my-plugin',
        socketPath: '/var/run/my-plugin.sock',
      );

      final captured =
          verify(() => mockClient.addPlugin(captureAny())).captured.single
              as AddPluginRequest;

      expect(captured.name, 'my-plugin');
      expect(captured.socketPath, '/var/run/my-plugin.sock');
    });
  });

  group('PluginsNotifier - removePlugin', () {
    test(
      'calls gRPC removePlugin, refreshes list, and returns removed bool',
      () async {
        final existingPlugin = makePlugin('old-plugin');
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [existingPlugin]),
          ),
        );
        await container.read(pluginsProvider.future);

        when(() => mockClient.removePlugin(any())).thenAnswer(
          (_) => FakeResponseFuture.value(RemovePluginResponse(removed: true)),
        );
        when(
          () => mockClient.listPlugins(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

        final notifier = container.read(pluginsProvider.notifier);
        final result = await notifier.removePlugin('old-plugin');

        expect(result, isTrue);

        final state = container.read(pluginsProvider);
        expect(state.value, isEmpty);
      },
    );

    test('passes correct name to gRPC', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      when(() => mockClient.removePlugin(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RemovePluginResponse(removed: true)),
      );
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.removePlugin('target-plugin');

      final captured =
          verify(() => mockClient.removePlugin(captureAny())).captured.single
              as RemovePluginRequest;

      expect(captured.name, 'target-plugin');
    });
  });

  group('PluginsNotifier - enablePlugin', () {
    test(
      'calls gRPC enablePlugin, refreshes list, and returns updated PluginInfo',
      () async {
        final disabledPlugin = makePlugin('my-plugin', enabled: false);
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [disabledPlugin]),
          ),
        );
        await container.read(pluginsProvider.future);

        final enabledPlugin = makePlugin('my-plugin', enabled: true);
        when(() => mockClient.enablePlugin(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            EnablePluginResponse(plugin: enabledPlugin),
          ),
        );
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [enabledPlugin]),
          ),
        );

        final notifier = container.read(pluginsProvider.notifier);
        final result = await notifier.enablePlugin('my-plugin');

        expect(result.name, 'my-plugin');
        expect(result.enabled, isTrue);

        final state = container.read(pluginsProvider);
        expect(state.value, hasLength(1));
        expect(state.value!.first.enabled, isTrue);
      },
    );

    test('passes correct name to gRPC', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      when(() => mockClient.enablePlugin(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          EnablePluginResponse(plugin: makePlugin('test')),
        ),
      );
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.enablePlugin('target-plugin');

      final captured =
          verify(() => mockClient.enablePlugin(captureAny())).captured.single
              as EnablePluginRequest;

      expect(captured.name, 'target-plugin');
    });
  });

  group('PluginsNotifier - disablePlugin', () {
    test(
      'calls gRPC disablePlugin, refreshes list, and returns updated PluginInfo',
      () async {
        final enabledPlugin = makePlugin('my-plugin', enabled: true);
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [enabledPlugin]),
          ),
        );
        await container.read(pluginsProvider.future);

        final disabledPlugin = makePlugin('my-plugin', enabled: false);
        when(() => mockClient.disablePlugin(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            DisablePluginResponse(plugin: disabledPlugin),
          ),
        );
        when(() => mockClient.listPlugins(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPluginsResponse(plugins: [disabledPlugin]),
          ),
        );

        final notifier = container.read(pluginsProvider.notifier);
        final result = await notifier.disablePlugin('my-plugin');

        expect(result.name, 'my-plugin');
        expect(result.enabled, isFalse);

        final state = container.read(pluginsProvider);
        expect(state.value, hasLength(1));
        expect(state.value!.first.enabled, isFalse);
      },
    );

    test('passes correct name to gRPC', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      when(() => mockClient.disablePlugin(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          DisablePluginResponse(plugin: makePlugin('test')),
        ),
      );
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.disablePlugin('target-plugin');

      final captured =
          verify(() => mockClient.disablePlugin(captureAny())).captured.single
              as DisablePluginRequest;

      expect(captured.name, 'target-plugin');
    });
  });

  group('PluginsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPluginsResponse(plugins: [makePlugin('plugin-1')]),
        ),
      );
      await container.read(pluginsProvider.future);

      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPluginsResponse(
            plugins: [makePlugin('plugin-1'), makePlugin('plugin-new')],
          ),
        ),
      );

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.refresh();

      final state = container.read(pluginsProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].name, 'plugin-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<PluginInfo>>>[];

      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPluginsResponse(plugins: [makePlugin('plugin-1')]),
        ),
      );
      await container.read(pluginsProvider.future);

      container.listen(pluginsProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listPlugins(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPluginsResponse(plugins: [makePlugin('plugin-2')]),
        ),
      );

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.name, 'plugin-2');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));
      await container.read(pluginsProvider.future);

      reset(mockClient);
      when(
        () => mockClient.listPlugins(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPluginsResponse()));

      final notifier = container.read(pluginsProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listPlugins(any())).called(1);
    });
  });
}
