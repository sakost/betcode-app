import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/features/settings/widgets/mcp_server_card.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Machine detail subpage shown from Settings.
///
/// Displays selected machine info, MCP servers, worktrees, and a delete action.
class MachineDetailScreen extends ConsumerWidget {
  const MachineDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedMachineIdProvider);
    final machinesAsync = ref.watch(machinesProvider);
    final machine = machinesAsync.value?.cast<MachineInfo?>().firstWhere(
      (m) => m?.machineId == selectedId,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Machine')),
      body: ListView(
        children: [
          _MachineInfoSection(machine: machine, machineId: selectedId),
          const Divider(),
          _McpServersSection(),
          const Divider(),
          _WorktreesSection(),
          const Divider(),
          _DeleteMachineAction(machineId: selectedId),
        ],
      ),
    );
  }
}

class _MachineInfoSection extends StatelessWidget {
  const _MachineInfoSection({this.machine, this.machineId});

  final MachineInfo? machine;
  final String? machineId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  machine?.name.isNotEmpty ?? false
                      ? machine!.name
                      : machineId ?? 'Unknown',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              if (machine != null) _buildStatusBadge(machine!.status),
            ],
          ),
          if (machineId != null) ...[
            const SizedBox(height: 4),
            Text(
              machineId!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.go('/machine-picker'),
            child: const Text('Change Machine'),
          ),
        ],
      ),
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

class _McpServersSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(mcpServersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'MCP Servers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
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
              children:
                  servers
                      .map((server) => McpServerCard(server: server))
                      .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _WorktreesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worktreesAsync = ref.watch(worktreesProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Worktrees', style: theme.textTheme.titleMedium),
        ),
        worktreesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              error.toString(),
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          data: (worktrees) {
            if (worktrees.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No worktrees'),
              );
            }
            return Column(
              children: worktrees
                  .map(
                    (wt) => ListTile(
                      leading: const Icon(Icons.account_tree_outlined),
                      title: Text(wt.name),
                      subtitle: Text(
                        wt.branch.isNotEmpty
                            ? '${wt.branch} \u2022 ${wt.path}'
                            : wt.path,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _DeleteMachineAction extends ConsumerWidget {
  const _DeleteMachineAction({this.machineId});

  final String? machineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (machineId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton.icon(
        onPressed: () => _confirmDelete(context, ref),
        icon: const Icon(Icons.delete_outline),
        label: const Text('Remove Machine'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Machine'),
        content: const Text(
          'Are you sure you want to remove this machine? '
          'This will clear the selection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(machinesProvider.notifier).removeMachine(machineId!);
    await ref.read(selectedMachineIdProvider.notifier).clear();

    if (!context.mounted) return;
    context.go('/machine-picker');
  }
}
