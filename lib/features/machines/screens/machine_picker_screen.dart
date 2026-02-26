import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/machines/widgets/machine_card.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/shared/widgets/async_list_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full-screen machine selection gate.
///
/// Shown when no machine is selected. The user must pick a machine
/// before accessing the rest of the app. There is no back button.
class MachinePickerScreen extends ConsumerWidget {
  const MachinePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machinesAsync = ref.watch(machinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a machine'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Choose a machine to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: AsyncListScaffold<MachineInfo>(
              asyncValue: machinesAsync,
              onRefresh: () => ref.read(machinesProvider.notifier).refresh(),
              emptyIcon: Icons.dns_outlined,
              emptyTitle: 'No machines available',
              emptySubtitle: 'Register a machine first.',
              itemBuilder: (context, machine) => MachineCard(
                machine: machine,
                onTap: () => ref
                    .read(selectedMachineIdProvider.notifier)
                    .select(machine.machineId),
                onLongPress: () =>
                    _confirmDelete(context, ref, machine),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    MachineInfo machine,
  ) async {
    final name = machine.name.isNotEmpty ? machine.name : machine.machineId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Machine'),
        content: Text('Remove "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(machinesProvider.notifier).removeMachine(machine.machineId);
  }
}
