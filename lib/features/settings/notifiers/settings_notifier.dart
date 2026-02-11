import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/config.pb.dart';

/// Manages the app-wide settings fetched from the daemon via gRPC.
///
/// On [build], fetches the current settings. Callers can pull-to-refresh
/// via [refresh] or push changes via [updateSettings].
class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() async {
    return _fetchSettings();
  }

  Future<Settings> _fetchSettings() async {
    final client = ref.read(configServiceProvider);
    return await client.getSettings(GetSettingsRequest());
  }

  /// Re-fetches the settings from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchSettings());
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
