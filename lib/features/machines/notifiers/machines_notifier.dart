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
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

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
    final response = await client
        .listMachines(ListMachinesRequest())
        .timeout(_rpcTimeout);
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

  /// Registers a new machine via gRPC and refreshes the list.
  Future<void> registerMachine({
    required String machineId,
    required String name,
    Map<String, String>? metadata,
  }) async {
    final client = ref.read(machineServiceProvider);
    final request = RegisterMachineRequest(machineId: machineId, name: name);
    if (metadata != null) {
      request.metadata.addAll(metadata);
    }
    await client.registerMachine(request).timeout(_mutationTimeout);
    await refresh();
  }

  /// Removes a machine registration via gRPC and refreshes the list.
  Future<void> removeMachine(String machineId) async {
    final client = ref.read(machineServiceProvider);
    await client
        .removeMachine(RemoveMachineRequest(machineId: machineId))
        .timeout(_mutationTimeout);
    await refresh();
  }

  /// Gets details for a specific machine via gRPC.
  Future<MachineInfo> getMachine(String machineId) async {
    final client = ref.read(machineServiceProvider);
    final response = await client
        .getMachine(GetMachineRequest(machineId: machineId))
        .timeout(_rpcTimeout);
    return response.machine;
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
