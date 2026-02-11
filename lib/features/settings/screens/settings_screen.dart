import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth.dart';
import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../generated/betcode/v1/config.pb.dart';
import '../../../shared/widgets/connection_indicator.dart';
import '../../../shared/widgets/error_display.dart';
import '../notifiers/settings_providers.dart';
import '../widgets/mcp_server_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(settingsProvider.notifier).refresh(),
        ),
        data: (settings) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(settingsProvider.notifier).refresh();
            await ref.read(mcpServersProvider.notifier).refresh();
          },
          child: ListView(
            children: [
              const _RelayConnectionSection(),
              _SessionSettingsSection(settings: settings),
              _PermissionSettingsSection(settings: settings),
              _McpServersSection(),
              const _AboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelayConnectionSection extends ConsumerWidget {
  const _RelayConnectionSection();

  ConnectionStatus _mapStatus(GrpcConnectionStatus grpcStatus) {
    return switch (grpcStatus) {
      GrpcConnectionStatus.connected => ConnectionStatus.connected,
      GrpcConnectionStatus.connecting => ConnectionStatus.connecting,
      GrpcConnectionStatus.reconnecting => ConnectionStatus.reconnecting,
      GrpcConnectionStatus.disconnected => ConnectionStatus.disconnected,
      GrpcConnectionStatus.authenticating => ConnectionStatus.disconnected,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relayConfig = ref.watch(relayConfigNotifierProvider);
    final connectionStatusAsync = ref.watch(connectionStatusProvider);

    final serverText = relayConfig != null
        ? '${relayConfig.host}:${relayConfig.port}'
        : 'Not configured';

    final connectionStatus = connectionStatusAsync.when(
      data: _mapStatus,
      loading: () => ConnectionStatus.disconnected,
      error: (_, _) => ConnectionStatus.disconnected,
    );

    return ExpansionTile(
      title: const Text('Relay Connection'),
      leading: const Icon(Icons.dns),
      initiallyExpanded: true,
      children: [
        ListTile(title: const Text('Server'), trailing: Text(serverText)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConnectionIndicator(status: connectionStatus),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OutlinedButton(
            onPressed: () async {
              await ref.read(relayConfigNotifierProvider.notifier).disconnect();
              await ref.read(authNotifierProvider.notifier).logout();
            },
            child: const Text('Disconnect'),
          ),
        ),
      ],
    );
  }
}

class _SessionSettingsSection extends StatelessWidget {
  const _SessionSettingsSection({required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final session = settings.sessions;

    return ExpansionTile(
      title: const Text('Session Settings'),
      leading: const Icon(Icons.chat),
      initiallyExpanded: true,
      children: [
        ListTile(
          title: const Text('Default Model'),
          trailing: Text(
            session.defaultModel.isNotEmpty ? session.defaultModel : 'Not set',
          ),
        ),
        ListTile(
          title: const Text('Auto-Compact'),
          trailing: Text(session.autoCompact ? 'Enabled' : 'Disabled'),
        ),
        if (session.autoCompact)
          ListTile(
            title: const Text('Auto-Compact Threshold'),
            trailing: Text('${session.autoCompactThreshold}'),
          ),
        ListTile(
          title: const Text('Max Messages per Session'),
          trailing: Text('${session.maxMessagesPerSession}'),
        ),
      ],
    );
  }
}

class _PermissionSettingsSection extends StatelessWidget {
  const _PermissionSettingsSection({required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final perms = settings.permissions;

    return ExpansionTile(
      title: const Text('Permission Settings'),
      leading: const Icon(Icons.security),
      initiallyExpanded: true,
      children: [
        ListTile(
          title: const Text('Connected Timeout'),
          trailing: Text('${perms.connectedTimeoutSecs}s'),
        ),
        ListTile(
          title: const Text('Disconnected Timeout'),
          trailing: Text('${perms.disconnectedTimeoutSecs}s'),
        ),
        ListTile(
          title: const Text('Auto-Approve'),
          trailing: Text(perms.enableAutoApprove ? 'Enabled' : 'Disabled'),
        ),
        ListTile(
          title: const Text('Activity Refresh'),
          trailing: Text(perms.activityRefreshEnabled ? 'Enabled' : 'Disabled'),
        ),
      ],
    );
  }
}

class _McpServersSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(mcpServersProvider);

    return ExpansionTile(
      title: const Text('MCP Servers'),
      leading: const Icon(Icons.dns),
      initiallyExpanded: true,
      children: [
        serversAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              error.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          data: (servers) {
            if (servers.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No MCP servers configured'),
              );
            }
            return Column(
              children: servers
                  .map((server) => McpServerCard(server: server))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      title: Text('About'),
      leading: Icon(Icons.info),
      children: [
        ListTile(title: Text('App Version'), trailing: Text('1.0.0-dev')),
      ],
    );
  }
}
