import 'package:betcode_app/features/machines/notifiers/machines_notifier.dart';
import 'package:betcode_app/features/machines/notifiers/selected_machine_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [MachineInfo] objects fetched from the daemon.
///
/// Use `ref.watch(machinesProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final machinesProvider =
    AsyncNotifierProvider<MachinesNotifier, List<MachineInfo>>(
      MachinesNotifier.new,
    );

/// Tracks the currently selected machine ID, persisted across restarts.
final selectedMachineIdProvider =
    NotifierProvider<SelectedMachineNotifier, String?>(
      SelectedMachineNotifier.new,
    );
