import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage.dart';

/// Tracks the currently selected machine ID.
///
/// The selection is persisted to secure storage so it survives app restarts.
/// Call [initialize] at startup to restore the previous selection.
class SelectedMachineNotifier extends Notifier<String?> {
  late final SecureStorageService _storage;

  @override
  String? build() {
    _storage = ref.watch(secureStorageProvider);
    return null;
  }

  /// Loads the previously persisted machine ID from secure storage.
  Future<void> initialize() async {
    state = await _storage.readSelectedMachineId();
  }

  /// Selects a machine and persists the choice.
  Future<void> select(String machineId) async {
    await _storage.writeSelectedMachineId(machineId);
    state = machineId;
  }

  /// Clears the selection and removes it from storage.
  Future<void> clear() async {
    await _storage.deleteSelectedMachineId();
    state = null;
  }
}
