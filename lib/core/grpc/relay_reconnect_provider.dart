import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sync/connectivity.dart';
import 'connection_state.dart';
import 'grpc_providers.dart';

/// Watches network status, gRPC connection status, and relay config.
/// When online, disconnected, and relay config exists, triggers reconnect.
final relayAutoReconnectProvider = Provider<void>((ref) {
  final networkAsync = ref.watch(networkStatusProvider);
  final connectionAsync = ref.watch(connectionStatusProvider);
  final relayConfig = ref.watch(relayConfigNotifierProvider);

  final network = networkAsync.value;
  final connection = connectionAsync.value;

  if (network == NetworkStatus.online &&
      connection == GrpcConnectionStatus.disconnected &&
      relayConfig != null) {
    final manager = ref.read(grpcClientManagerProvider);
    manager.reconnect();
  }
});
