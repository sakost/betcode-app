import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the app-wide settings fetched from the daemon via gRPC.
///
/// On [build], fetches the current settings. Callers can pull-to-refresh
/// via [refresh] or push changes via [updateSettings].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class SettingsNotifier extends AsyncNotifier<Settings> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<Settings> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) {
      throw StateError('No machine selected');
    }
    return _fetchSettings();
  }

  Future<Settings> _fetchSettings() async {
    final client = ref.read(configServiceProvider);
    return client.getSettings(GetSettingsRequest()).timeout(_rpcTimeout);
  }

  /// Re-fetches the settings from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSettings);
  }

  /// Sends updated settings to the daemon and updates local state with the
  /// response.
  Future<void> updateSettings(Settings settings) async {
    final client = ref.read(configServiceProvider);
    final updated = await client.updateSettings(
      UpdateSettingsRequest(settings: settings),
    );
    state = AsyncData(updated);
  }
}
