import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';
import 'grpc_providers.dart';
import 'relay_config.dart';

/// Manages the active relay configuration and its connection lifecycle.
///
/// On [initialize], loads the persisted config from secure storage and
/// attempts to connect. On [connectTo], connects and persists on success.
/// On [disconnect], tears down the connection and clears persisted config.
class RelayConfigNotifier extends Notifier<RelayConfig?> {
  @override
  RelayConfig? build() => null;

  /// Loads persisted relay config and connects if valid.
  ///
  /// Failures are non-fatal — the user retries from the login screen.
  Future<void> initialize() async {
    final storage = ref.read(secureStorageProvider);
    final config = await storage.readRelayConfig();
    if (config == null || !config.isValid) return;

    final manager = ref.read(grpcClientManagerProvider);
    try {
      await manager.connect(config.host, config.port, useTls: config.useTls);
      state = config;
    } catch (e) {
      debugPrint(
        '[RelayConfigNotifier] Failed to connect to relay on init: $e',
      );
      state = null;
    }
  }

  /// Connects to the given relay, persists on success, rethrows on failure.
  Future<void> connectTo(RelayConfig config) async {
    final manager = ref.read(grpcClientManagerProvider);
    await manager.connect(config.host, config.port, useTls: config.useTls);
    final storage = ref.read(secureStorageProvider);
    await storage.writeRelayConfig(config);
    state = config;
  }

  /// Disconnects from the relay and clears persisted config.
  Future<void> disconnect() async {
    final manager = ref.read(grpcClientManagerProvider);
    await manager.disconnect();
    final storage = ref.read(secureStorageProvider);
    await storage.deleteRelayConfig();
    state = null;
  }
}
