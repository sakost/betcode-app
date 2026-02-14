import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_display.dart';
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
      body: machinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(machinesProvider.notifier).refresh(),
        ),
        data: (machines) {
          if (machines.isEmpty) {
            return const EmptyState(
              icon: Icons.dns_outlined,
              title: 'No machines connected',
              subtitle: 'Register a machine to see it here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(machinesProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: machines.length,
              itemBuilder: (context, index) {
                final machine = machines[index];
                return MachineCard(
                  machine: machine,
                  isSelected: machine.machineId == selectedId,
                  onTap: () => ref
                      .read(selectedMachineIdProvider.notifier)
                      .select(machine.machineId),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
