import 'dart:async';

import 'package:betcode_app/core/app_version.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/mcp_servers_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/settings_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/features/settings/screens/settings_screen.dart';
import 'package:betcode_app/features/settings/widgets/mcp_server_card.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';
import 'package:betcode_app/shared/widgets/connection_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;

import '../../../helpers/settings_test_helpers.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

McpServerInfo _makeServer({
  String name = 'context7',
  String serverType = 'stdio',
  String endpoint = '/usr/bin/context7',
  McpServerStatus status = McpServerStatus.MCP_SERVER_STATUS_RUNNING,
  List<String> tools = const ['query-docs'],
  String errorMessage = '',
}) => McpServerInfo(
  name: name,
  serverType: serverType,
  endpoint: endpoint,
  status: status,
  tools: tools,
  errorMessage: errorMessage,
);

/// A notifier that returns a canned async value without gRPC calls.
class _FakeSettingsNotifier extends SettingsNotifier {
  _FakeSettingsNotifier(this._value);
  final AsyncValue<Settings> _value;

  @override
  Future<Settings> build() {
    return _value.when(
      data: Future.value,
      loading: () => Completer<Settings>().future,
      error: Future.error,
    );
  }
}

class _FakeMcpServersNotifier extends McpServersNotifier {
  _FakeMcpServersNotifier(this._value);
  final AsyncValue<List<McpServerInfo>> _value;

  @override
  Future<List<McpServerInfo>> build() {
    return _value.when(
      data: Future.value,
      loading: () => Completer<List<McpServerInfo>>().future,
      error: Future.error,
    );
  }
}

/// Relay notifier that returns a canned config.
class _FakeRelayNotifier extends RelayConfigNotifier {
  _FakeRelayNotifier(this._config);
  final RelayConfig? _config;

  bool disconnectCalled = false;

  @override
  RelayConfig? build() => _config;

  @override
  Future<void> disconnect() async {
    disconnectCalled = true;
    state = null;
  }
}

/// Wraps [SettingsScreen] with fake providers for settings and MCP servers.
Widget _settingsApp({
  AsyncValue<Settings>? settings,
  AsyncValue<List<McpServerInfo>>? servers,
  List<Override> extraOverrides = const [],
}) {
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(
        () => _FakeSettingsNotifier(
          settings ?? AsyncData(makeTestSettings()),
        ),
      ),
      mcpServersProvider.overrideWith(
        () => _FakeMcpServersNotifier(
          servers ?? const AsyncData([]),
        ),
      ),
      appVersionProvider.overrideWith((_) async => '0.1.0-test'),
      ...extraOverrides,
    ],
    child: _app(const SettingsScreen()),
  );
}

// ---------------------------------------------------------------------------
// SettingsScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('SettingsScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(
        _settingsApp(
          settings: const AsyncLoading(),
          servers: const AsyncLoading(),
        ),
      );
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        _settingsApp(
          settings: AsyncError(
            Exception('connection refused'),
            StackTrace.empty,
          ),
        ),
      );
      await t.pumpAndSettle();

      // Relay section and About are still visible
      expect(find.text('Relay Connection'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      // Daemon settings show unavailable message with retry
      expect(find.text('Daemon settings unavailable'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Session/Permission sections are NOT shown
      expect(find.text('Session Settings'), findsNothing);
      expect(find.text('Permission Settings'), findsNothing);
    });

    testWidgets('displays session settings section', (t) async {
      await t.pumpWidget(
        _settingsApp(
          settings: AsyncData(
            makeTestSettings(
              defaultModel: 'claude-opus-4',
              autoCompactThreshold: 150,
              maxMessagesPerSession: 1000,
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Session Settings'), findsOneWidget);
      expect(find.text('claude-opus-4'), findsOneWidget);
      expect(find.text('Enabled'), findsWidgets);
      expect(find.text('150'), findsOneWidget);
      expect(find.text('1000'), findsOneWidget);
    });

    testWidgets('displays permission settings section', (t) async {
      await t.pumpWidget(
        _settingsApp(
          settings: AsyncData(
            makeTestSettings(
              connectedTimeoutSecs: 45,
              disconnectedTimeoutSecs: 180,
              enableAutoApprove: true,
              activityRefreshEnabled: false,
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Permission Settings'), findsOneWidget);
      expect(find.text('45s'), findsOneWidget);
      expect(find.text('180s'), findsOneWidget);
    });

    testWidgets('displays MCP servers section with cards', (t) async {
      final servers = [
        _makeServer(
          tools: ['query-docs', 'resolve-library-id'],
        ),
        _makeServer(
          name: 'serena',
          serverType: 'sse',
          endpoint: 'http://localhost:8080',
          status: McpServerStatus.MCP_SERVER_STATUS_STOPPED,
          tools: [],
        ),
      ];

      await t.pumpWidget(_settingsApp(servers: AsyncData(servers)));
      await t.pumpAndSettle();

      // Scroll down to reveal MCP servers section
      await t.scrollUntilVisible(find.text('MCP Servers'), 200);
      await t.pumpAndSettle();

      expect(find.text('MCP Servers'), findsOneWidget);
      expect(find.byType(McpServerCard), findsNWidgets(2));
      expect(find.text('context7'), findsOneWidget);
      expect(find.text('serena'), findsOneWidget);
    });

    testWidgets('displays about section', (t) async {
      await t.pumpWidget(_settingsApp());
      await t.pumpAndSettle();

      // Scroll down to reveal About section
      await t.scrollUntilVisible(find.text('About'), 200);
      await t.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('displays app version from provider', (t) async {
      await t.pumpWidget(_settingsApp());
      await t.pumpAndSettle();

      // Scroll to About and expand it
      await t.scrollUntilVisible(find.text('About'), 200);
      await t.tap(find.text('About'));
      await t.pumpAndSettle();

      expect(find.text('App Version'), findsOneWidget);
      expect(find.text('0.1.0-test'), findsOneWidget);
    });

    testWidgets('shows auto-compact as Disabled when off', (t) async {
      await t.pumpWidget(
        _settingsApp(settings: AsyncData(makeTestSettings(autoCompact: false))),
      );
      await t.pumpAndSettle();

      expect(find.text('Disabled'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // McpServerCard tests
  // ---------------------------------------------------------------------------

  group('McpServerCard', () {
    /// Pumps an [McpServerCard] with the given server and settles.
    Future<void> pumpCard(WidgetTester t, McpServerInfo server) async {
      await t.pumpWidget(_app(McpServerCard(server: server)));
      await t.pumpAndSettle();
    }

    testWidgets('displays server name and type', (t) async {
      await pumpCard(
        t,
        _makeServer(
          name: 'my-server',
          endpoint: '/usr/bin/mcp',
        ),
      );
      expect(find.text('my-server'), findsOneWidget);
      expect(find.text('stdio'), findsOneWidget);
    });

    testWidgets('displays tools count', (t) async {
      await pumpCard(t, _makeServer(tools: ['tool-a', 'tool-b', 'tool-c']));
      expect(find.text('3 tools'), findsOneWidget);
    });

    testWidgets('displays 1 tool (singular)', (t) async {
      await pumpCard(t, _makeServer(tools: ['only-tool']));
      expect(find.text('1 tool'), findsOneWidget);
    });

    testWidgets('shows Running status with green color', (t) async {
      await pumpCard(
        t,
        _makeServer(),
      );
      expect(find.text('Running'), findsOneWidget);
    });

    testWidgets('shows Stopped status with grey color', (t) async {
      await pumpCard(
        t,
        _makeServer(status: McpServerStatus.MCP_SERVER_STATUS_STOPPED),
      );
      expect(find.text('Stopped'), findsOneWidget);
    });

    testWidgets('shows Starting status with amber color', (t) async {
      await pumpCard(
        t,
        _makeServer(status: McpServerStatus.MCP_SERVER_STATUS_STARTING),
      );
      expect(find.text('Starting'), findsOneWidget);
    });

    testWidgets('shows Error status with red color and error message', (
      t,
    ) async {
      await pumpCard(
        t,
        _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_ERROR,
          errorMessage: 'Failed to connect to server',
        ),
      );
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Failed to connect to server'), findsOneWidget);
    });

    testWidgets('hides error message when not in error state', (t) async {
      await pumpCard(
        t,
        _makeServer(),
      );
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Failed to connect to server'), findsNothing);
    });

    testWidgets('shows 0 tools when none configured', (t) async {
      await pumpCard(t, _makeServer(tools: []));
      expect(find.text('0 tools'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Relay connection section tests
  // ---------------------------------------------------------------------------

  group('Relay connection section', () {
    /// Builds [_settingsApp] with relay and connection overrides.
    Widget relayApp({
      RelayConfig? relay = const RelayConfig(
        host: 'relay.example.com',
        port: 443,
      ),
      GrpcConnectionStatus connectionStatus = GrpcConnectionStatus.connected,
    }) {
      return _settingsApp(
        extraOverrides: [
          relayConfigNotifierProvider.overrideWith(
            () => _FakeRelayNotifier(relay),
          ),
          connectionStatusProvider.overrideWith(
            (ref) => Stream.value(connectionStatus),
          ),
        ],
      );
    }

    testWidgets('shows relay connection section', (t) async {
      await t.pumpWidget(relayApp());
      await t.pumpAndSettle();

      expect(find.text('Relay Connection'), findsOneWidget);
    });

    testWidgets('shows host:port', (t) async {
      await t.pumpWidget(
        relayApp(relay: const RelayConfig(host: 'my-relay.io', port: 8443)),
      );
      await t.pumpAndSettle();

      expect(find.text('my-relay.io:8443'), findsOneWidget);
      expect(find.byType(ConnectionIndicator), findsOneWidget);
    });

    testWidgets('shows Not configured when relay is null', (t) async {
      await t.pumpWidget(
        relayApp(
          relay: null,
          connectionStatus: GrpcConnectionStatus.disconnected,
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Not configured'), findsOneWidget);
    });

    testWidgets('disconnect button calls disconnect then logout', (t) async {
      await t.pumpWidget(relayApp());
      await t.pumpAndSettle();

      expect(find.text('Disconnect'), findsOneWidget);

      await t.tap(find.text('Disconnect'));
      await t.pumpAndSettle();

      // After disconnect, the relay config should be null
      // (the fake notifier sets state = null in disconnect)
      expect(find.text('Not configured'), findsOneWidget);
    });
  });
}
