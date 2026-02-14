import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/machine.pb.dart';
import '../../../shared/widgets/async_list_scaffold.dart';
import '../notifiers/machines_providers.dart';
import '../widgets/machine_card.dart';

class MachinesScreen extends ConsumerWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machinesAsync = ref.watch(machinesProvider);
    final selectedId = ref.watch(selectedMachineIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Machines')),
      body: AsyncListScaffold<MachineInfo>(
        asyncValue: machinesAsync,
        onRefresh: () => ref.read(machinesProvider.notifier).refresh(),
        emptyIcon: Icons.dns_outlined,
        emptyTitle: 'No machines connected',
        emptySubtitle: 'Register a machine to see it here.',
        itemBuilder: (context, machine) => MachineCard(
          machine: machine,
          isSelected: machine.machineId == selectedId,
          onTap: () => ref
              .read(selectedMachineIdProvider.notifier)
              .select(machine.machineId),
        ),
      ),
    );
  }
}
