import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/machine.pb.dart';
import 'machines_providers.dart';

/// Manages the list of machines fetched from the daemon via gRPC.
///
/// On [build], fetches all machines and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [authNotifierProvider] so the provider auto-refreshes when
/// the user logs in or out. When the fetched list contains exactly one
/// machine and no machine is currently selected, auto-selects it.
class MachinesNotifier extends AsyncNotifier<List<MachineInfo>> {
  @override
  Future<List<MachineInfo>> build() async {
    final auth = ref.watch(authNotifierProvider);
    if (auth is! AuthAuthenticated) return [];

    final machines = await _fetchMachines();
    await _autoSelectIfSingle(machines);
    return machines;
  }

  Future<List<MachineInfo>> _fetchMachines() async {
    final client = ref.read(machineServiceProvider);
    final response = await client.listMachines(ListMachinesRequest());
    return response.machines.toList();
  }

  /// Re-fetches machines from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final machines = await _fetchMachines();
      await _autoSelectIfSingle(machines);
      return machines;
    });
  }

  Future<void> _autoSelectIfSingle(List<MachineInfo> machines) async {
    final selectedId = ref.read(selectedMachineIdProvider);
    if (selectedId == null && machines.length == 1) {
      await ref
          .read(selectedMachineIdProvider.notifier)
          .select(machines.first.machineId);
    }
  }
}
