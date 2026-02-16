import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.read(grpcClientManagerProvider).reconnect();
  }
});
