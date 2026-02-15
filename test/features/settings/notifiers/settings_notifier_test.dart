import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/notifier_test_helpers.dart';
import '../../../helpers/settings_test_helpers.dart';
import '../../../helpers/test_container.dart';

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
    container = createTestContainer(
      overrides: [configServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------------------------
  // SettingsNotifier
  // ---------------------------------------------------------------------------

  group('SettingsNotifier - build', () {
    test('fetches settings from gRPC', () async {
      final settings = makeTestSettings();
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
      ).thenAnswer((_) => FakeResponseFuture.value(makeTestSettings()));

      await container.read(settingsProvider.future);

      verify(() => mockClient.getSettings(any())).called(1);
    });

    test('preserves all session settings fields', () async {
      when(() => mockClient.getSettings(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          makeTestSettings(
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
          makeTestSettings(
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

  connectionAwarenessTests(
    label: 'SettingsNotifier',
    provider: settingsProvider,
    serviceOverrides: () => [
      configServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.getSettings(any())),
  );

  errorHandlingTests(
    label: 'SettingsNotifier',
    provider: settingsProvider,
    errorOverrides: (error) => [
      configServiceProvider.overrideWithValue(_FailingConfigClient(error)),
    ],
  );

  group('SettingsNotifier - updateSettings', () {
    test('sends updated settings to gRPC and updates state', () async {
      when(
        () => mockClient.getSettings(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeTestSettings()));
      await container.read(settingsProvider.future);

      final updated = makeTestSettings(defaultModel: 'haiku');
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
      ).thenAnswer((_) => FakeResponseFuture.value(makeTestSettings()));
      await container.read(settingsProvider.future);

      final updated = makeTestSettings(defaultModel: 'sonnet');
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

  connectionAwarenessTests(
    label: 'McpServersNotifier',
    provider: mcpServersProvider,
    serviceOverrides: () => [
      configServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () =>
        verifyNever(() => mockClient.listMcpServers(any())),
  );

  errorHandlingTests(
    label: 'McpServersNotifier',
    provider: mcpServersProvider,
    errorOverrides: (error) => [
      configServiceProvider.overrideWithValue(_FailingConfigClient(error)),
    ],
  );

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
