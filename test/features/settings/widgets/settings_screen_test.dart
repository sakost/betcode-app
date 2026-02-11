import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/settings/notifiers/settings_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/mcp_servers_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/features/settings/screens/settings_screen.dart';
import 'package:betcode_app/features/settings/widgets/mcp_server_card.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbenum.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

Settings _makeSettings({
  String defaultModel = 'opus',
  bool autoCompact = true,
  int autoCompactThreshold = 100,
  int maxMessagesPerSession = 500,
  int connectedTimeoutSecs = 30,
  int disconnectedTimeoutSecs = 120,
  bool enableAutoApprove = false,
  bool activityRefreshEnabled = true,
}) =>
    Settings(
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

McpServerInfo _makeServer({
  String name = 'context7',
  String serverType = 'stdio',
  String endpoint = '/usr/bin/context7',
  McpServerStatus status = McpServerStatus.MCP_SERVER_STATUS_RUNNING,
  List<String> tools = const ['query-docs'],
  String errorMessage = '',
}) =>
    McpServerInfo(
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
      data: (d) => Future.value(d),
      loading: () => Completer<Settings>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

class _FakeMcpServersNotifier extends McpServersNotifier {
  _FakeMcpServersNotifier(this._value);
  final AsyncValue<List<McpServerInfo>> _value;

  @override
  Future<List<McpServerInfo>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<McpServerInfo>>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

// ---------------------------------------------------------------------------
// SettingsScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('SettingsScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(const AsyncLoading()),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncLoading()),
            ),
          ],
          child: _app(const SettingsScreen()),
        ),
      );
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(
                AsyncError(Exception('connection refused'), StackTrace.empty),
              ),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SettingsScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('displays session settings section', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(AsyncData(_makeSettings(
                defaultModel: 'claude-opus-4',
                autoCompact: true,
                autoCompactThreshold: 150,
                maxMessagesPerSession: 1000,
              ))),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SettingsScreen()),
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
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(AsyncData(_makeSettings(
                connectedTimeoutSecs: 45,
                disconnectedTimeoutSecs: 180,
                enableAutoApprove: true,
                activityRefreshEnabled: false,
              ))),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SettingsScreen()),
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
          name: 'context7',
          serverType: 'stdio',
          status: McpServerStatus.MCP_SERVER_STATUS_RUNNING,
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

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(AsyncData(_makeSettings())),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(AsyncData(servers)),
            ),
          ],
          child: _app(const SettingsScreen()),
        ),
      );
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
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(AsyncData(_makeSettings())),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SettingsScreen()),
        ),
      );
      await t.pumpAndSettle();

      // Scroll down to reveal About section
      await t.scrollUntilVisible(find.text('About'), 200);
      await t.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('shows auto-compact as Disabled when off', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => _FakeSettingsNotifier(AsyncData(_makeSettings(
                autoCompact: false,
              ))),
            ),
            mcpServersProvider.overrideWith(
              () => _FakeMcpServersNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const SettingsScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Disabled'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // McpServerCard tests
  // ---------------------------------------------------------------------------

  group('McpServerCard', () {
    testWidgets('displays server name and type', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          name: 'my-server',
          serverType: 'stdio',
          endpoint: '/usr/bin/mcp',
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('my-server'), findsOneWidget);
      expect(find.text('stdio'), findsOneWidget);
    });

    testWidgets('displays tools count', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          tools: ['tool-a', 'tool-b', 'tool-c'],
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('3 tools'), findsOneWidget);
    });

    testWidgets('displays 1 tool (singular)', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          tools: ['only-tool'],
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('1 tool'), findsOneWidget);
    });

    testWidgets('shows Running status with green color', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_RUNNING,
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('Running'), findsOneWidget);
    });

    testWidgets('shows Stopped status with grey color', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_STOPPED,
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('Stopped'), findsOneWidget);
    });

    testWidgets('shows Starting status with amber color', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_STARTING,
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('Starting'), findsOneWidget);
    });

    testWidgets('shows Error status with red color and error message', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_ERROR,
          errorMessage: 'Failed to connect to server',
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Failed to connect to server'), findsOneWidget);
    });

    testWidgets('hides error message when not in error state', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(
          status: McpServerStatus.MCP_SERVER_STATUS_RUNNING,
          errorMessage: '',
        ))),
      );
      await t.pumpAndSettle();

      expect(find.text('Running'), findsOneWidget);
      // No error message text should appear
      expect(find.text('Failed to connect to server'), findsNothing);
    });

    testWidgets('shows 0 tools when none configured', (t) async {
      await t.pumpWidget(
        _app(McpServerCard(server: _makeServer(tools: []))),
      );
      await t.pumpAndSettle();

      expect(find.text('0 tools'), findsOneWidget);
    });
  });
}
