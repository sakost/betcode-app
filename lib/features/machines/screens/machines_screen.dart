import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_display.dart';
import '../notifiers/machines_providers.dart';
import '../widgets/machine_card.dart';

class MachinesScreen extends ConsumerWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machinesAsync = ref.watch(machinesProvider);

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
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(machinesProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: machines.length,
              itemBuilder: (context, index) =>
                  MachineCard(machine: machines[index]),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No machines connected',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register a machine to see it here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
