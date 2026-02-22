import 'package:betcode_app/core/app_version.dart';
import 'package:betcode_app/core/auth/auth.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:betcode_app/shared/widgets/connection_indicator.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(settingsProvider.notifier).refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const _MachineRow(),
            const Divider(),
            const _RelayConnectionSection(),
            ...settingsAsync.when(
              loading: () => [
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (error, _) => [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daemon settings unavailable',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connect to a relay to view permission settings.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () =>
                            ref.read(settingsProvider.notifier).refresh(),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],
              data: (settings) => [
                _PermissionSettingsSection(settings: settings),
              ],
            ),
            const _AboutSection(),
          ],
        ),
      ),
    );
  }
}

/// Tappable row showing selected machine name and status, navigates to detail.
class _MachineRow extends ConsumerWidget {
  const _MachineRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedMachineIdProvider);
    final machinesAsync = ref.watch(machinesProvider);
    final machine = machinesAsync.value?.cast<MachineInfo?>().firstWhere(
      (m) => m?.machineId == selectedId,
      orElse: () => null,
    );

    final machineName = machine?.name.isNotEmpty ?? false
        ? machine!.name
        : selectedId ?? 'No machine';

    return ListTile(
      leading: const Icon(Icons.computer),
      title: const Text('Machine'),
      subtitle: Row(
        children: [
          Flexible(child: Text(machineName, overflow: TextOverflow.ellipsis)),
          if (machine != null) ...[
            const SizedBox(width: 8),
            _buildStatusBadge(machine.status),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/settings/machine'),
    );
  }

  StatusBadge _buildStatusBadge(MachineStatus status) {
    final (color, label) = switch (status) {
      MachineStatus.MACHINE_STATUS_ONLINE => (AppColors.online, 'Online'),
      MachineStatus.MACHINE_STATUS_OFFLINE => (AppColors.offline, 'Offline'),
      _ => (AppColors.agentIdle, 'Unknown'),
    };
    return StatusBadge(color: color, label: label);
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

class _AboutSection extends ConsumerWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(appVersionProvider);
    final versionText = versionAsync.when(
      data: (v) => v,
      loading: () => '...',
      error: (_, _) => 'Unknown',
    );

    return ExpansionTile(
      title: const Text('About'),
      leading: const Icon(Icons.info),
      children: [
        ListTile(title: const Text('App Version'), trailing: Text(versionText)),
      ],
    );
  }
}
