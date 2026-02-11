import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbenum.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockConfigServiceClient extends Mock implements ConfigServiceClient {}

class _FailingConfigClient extends Fake implements ConfigServiceClient {
  _FailingConfigClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<Settings> getSettings(
    GetSettingsRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }

  @override
  ResponseFuture<ListMcpServersResponse> listMcpServers(
    ListMcpServersRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

/// Wraps a pre-computed value (or error) as a [ResponseFuture] so that
/// mocked gRPC calls can be awaited in production code.
class FakeResponseFuture<T> extends Fake implements ResponseFuture<T> {
  FakeResponseFuture.value(T value) : _future = Future.value(value);
  FakeResponseFuture.error(Object error) : _future = Future.error(error);

  final Future<T> _future;

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      _future.then(onValue, onError: onError);

  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _future.whenComplete(action);

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<void> cancel() async {}

  @override
  bool get isCancelled => false;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockConfigServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(GetSettingsRequest());
    registerFallbackValue(UpdateSettingsRequest());
    registerFallbackValue(ListMcpServersRequest());
  });

  setUp(() {
    mockClient = MockConfigServiceClient();
    container = ProviderContainer(
      overrides: [configServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  Settings makeSettings({
    String defaultModel = 'opus',
    bool autoCompact = true,
    int autoCompactThreshold = 100,
    int maxMessagesPerSession = 500,
    int connectedTimeoutSecs = 30,
    int disconnectedTimeoutSecs = 120,
    bool enableAutoApprove = false,
    bool activityRefreshEnabled = true,
  }) => Settings(
    sessions: SessionSettings(
      defaultModel: defaultModel,
      autoCompact: autoCompact,
      autoCompactThreshold: autoCompactThreshold,
      maxMessagesPerSession: maxMessagesPerSession,
    ),
    permissions: PermissionSettings(
      connectedTimeoutSecs: connectedTimeoutSecs,
      disconnectedTimeoutSecs: disconnectedTimeoutSecs,
      enableAutoApprove: enableAutoApprove,
      activityRefreshEnabled: activityRefreshEnabled,
    ),
  );

  // ---------------------------------------------------------------------------
  // SettingsNotifier
  // ---------------------------------------------------------------------------

  group('SettingsNotifier - build', () {
    test('fetches settings from gRPC', () async {
      final settings = makeSettings();
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(settings));

      final result = await container.read(settingsProvider.future);

      expect(result.sessions.defaultModel, 'opus');
      expect(result.sessions.autoCompact, isTrue);
      expect(result.permissions.connectedTimeoutSecs, 30);
    });

    test('calls getSettings exactly once on build', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));

      await container.read(settingsProvider.future);

      verify(() => mockClient.getSettings(any())).called(1);
    });

    test('preserves all session settings fields', () async {
      when(() => mockClient.getSettings(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          makeSettings(
            defaultModel: 'sonnet',
            autoCompact: false,
            autoCompactThreshold: 200,
            maxMessagesPerSession: 1000,
          ),
        ),
      );

      final result = await container.read(settingsProvider.future);

      expect(result.sessions.defaultModel, 'sonnet');
      expect(result.sessions.autoCompact, isFalse);
      expect(result.sessions.autoCompactThreshold, 200);
      expect(result.sessions.maxMessagesPerSession, 1000);
    });

    test('preserves all permission settings fields', () async {
      when(() => mockClient.getSettings(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          makeSettings(
            connectedTimeoutSecs: 60,
            disconnectedTimeoutSecs: 300,
            enableAutoApprove: true,
            activityRefreshEnabled: false,
          ),
        ),
      );

      final result = await container.read(settingsProvider.future);

      expect(result.permissions.connectedTimeoutSecs, 60);
      expect(result.permissions.disconnectedTimeoutSecs, 300);
      expect(result.permissions.enableAutoApprove, isTrue);
      expect(result.permissions.activityRefreshEnabled, isFalse);
    });
  });

  group('SettingsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = ProviderContainer(
        overrides: [
          configServiceProvider.overrideWithValue(
            _FailingConfigClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(settingsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(settingsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = ProviderContainer(
        overrides: [
          configServiceProvider.overrideWithValue(
            _FailingConfigClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(settingsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(settingsProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('SettingsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));
      await container.read(settingsProvider.future);

      when(() => mockClient.getSettings(any())).thenAnswer(
        (_) => FakeResponseFuture.value(makeSettings(defaultModel: 'haiku')),
      );

      final notifier = container.read(settingsProvider.notifier);
      await notifier.refresh();

      final state = container.read(settingsProvider);
      expect(state.value!.sessions.defaultModel, 'haiku');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<Settings>>[];

      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));
      await container.read(settingsProvider.future);

      container.listen(settingsProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.getSettings(any())).thenAnswer(
        (_) => FakeResponseFuture.value(makeSettings(defaultModel: 'sonnet')),
      );

      final notifier = container.read(settingsProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value!.sessions.defaultModel, 'sonnet');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));
      await container.read(settingsProvider.future);

      reset(mockClient);
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));

      final notifier = container.read(settingsProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.getSettings(any())).called(1);
    });
  });

  group('SettingsNotifier - updateSettings', () {
    test('sends updated settings to gRPC and updates state', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));
      await container.read(settingsProvider.future);

      final updated = makeSettings(defaultModel: 'haiku');
      when(
        () => mockClient.updateSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(updated));

      final notifier = container.read(settingsProvider.notifier);
      await notifier.updateSettings(updated);

      final state = container.read(settingsProvider);
      expect(state.value!.sessions.defaultModel, 'haiku');
    });

    test('passes settings in UpdateSettingsRequest', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeSettings()));
      await container.read(settingsProvider.future);

      final updated = makeSettings(defaultModel: 'sonnet');
      when(
        () => mockClient.updateSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(updated));

      final notifier = container.read(settingsProvider.notifier);
      await notifier.updateSettings(updated);

      final captured =
          verify(() => mockClient.updateSettings(captureAny())).captured.single
              as UpdateSettingsRequest;

      expect(captured.settings.sessions.defaultModel, 'sonnet');
    });
  });

  // ---------------------------------------------------------------------------
  // McpServersNotifier
  // ---------------------------------------------------------------------------

  group('McpServersNotifier - build', () {
    test('fetches MCP servers list from gRPC', () async {
      when(() => mockClient.listMcpServers(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMcpServersResponse(
            servers: [
              McpServerInfo(
                name: 'context7',
                serverType: 'stdio',
                endpoint: '/usr/bin/context7',
                status: McpServerStatus.MCP_SERVER_STATUS_RUNNING,
                tools: ['query-docs', 'resolve-library-id'],
              ),
            ],
          ),
        ),
      );

      final result = await container.read(mcpServersProvider.future);

      expect(result, hasLength(1));
      expect(result.first.name, 'context7');
      expect(result.first.tools, hasLength(2));
      expect(result.first.status, McpServerStatus.MCP_SERVER_STATUS_RUNNING);
    });

    test('returns empty list when no servers configured', () async {
      when(
        () => mockClient.listMcpServers(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListMcpServersResponse()));

      final result = await container.read(mcpServersProvider.future);
      expect(result, isEmpty);
    });

    test('returns multiple servers', () async {
      when(() => mockClient.listMcpServers(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMcpServersResponse(
            servers: [
              McpServerInfo(name: 'server-a'),
              McpServerInfo(name: 'server-b'),
              McpServerInfo(name: 'server-c'),
            ],
          ),
        ),
      );

      final result = await container.read(mcpServersProvider.future);
      expect(result, hasLength(3));
    });
  });

  group('McpServersNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = ProviderContainer(
        overrides: [
          configServiceProvider.overrideWithValue(
            _FailingConfigClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(mcpServersProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(mcpServersProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });
  });

  group('McpServersNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listMcpServers(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMcpServersResponse(servers: [McpServerInfo(name: 'server-a')]),
        ),
      );
      await container.read(mcpServersProvider.future);

      when(() => mockClient.listMcpServers(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMcpServersResponse(
            servers: [
              McpServerInfo(name: 'server-a'),
              McpServerInfo(name: 'server-b'),
            ],
          ),
        ),
      );

      final notifier = container.read(mcpServersProvider.notifier);
      await notifier.refresh();

      final state = container.read(mcpServersProvider);
      expect(state.value, hasLength(2));
    });
  });
}
