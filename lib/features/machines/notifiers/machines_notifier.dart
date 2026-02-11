import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/machine.pb.dart';

/// Manages the list of machines fetched from the daemon via gRPC.
///
/// On [build], fetches all machines and returns them. Callers can
/// pull-to-refresh via [refresh].
class MachinesNotifier extends AsyncNotifier<List<MachineInfo>> {
  @override
  Future<List<MachineInfo>> build() async {
    return _fetchMachines();
  }

  Future<List<MachineInfo>> _fetchMachines() async {
    final client = ref.read(machineServiceProvider);
    final response = await client.listMachines(ListMachinesRequest());
    return response.machines.toList();
  }

  /// Re-fetches machines from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMachines());
  }
}
