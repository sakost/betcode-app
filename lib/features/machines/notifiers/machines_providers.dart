import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/machine.pb.dart';
import 'machines_notifier.dart';

/// Provides the list of [MachineInfo] objects fetched from the daemon.
///
/// Use `ref.watch(machinesProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final machinesProvider =
    AsyncNotifierProvider<MachinesNotifier, List<MachineInfo>>(
      MachinesNotifier.new,
    );
