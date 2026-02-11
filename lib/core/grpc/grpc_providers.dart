import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth.dart';
import 'client_manager.dart';
import 'connection_state.dart';
import 'interceptors.dart';
import 'relay_config.dart';
import 'relay_notifier.dart';

/// Provides the singleton [GrpcClientManager] instance.
///
/// The [AuthInterceptor] reads the current JWT from the auth notifier so
/// every outgoing RPC carries a fresh token.
final grpcClientManagerProvider = Provider<GrpcClientManager>((ref) {
  final authNotifier = ref.read(authNotifierProvider.notifier);

  final manager = GrpcClientManager(
    interceptors: [
      AuthInterceptor(tokenProvider: () async => authNotifier.accessToken),
      LoggingInterceptor(),
    ],
  );

  ref.onDispose(() async {
    await manager.dispose();
  });

  return manager;
});

/// Streams connection status changes for widgets and other providers to watch.
final connectionStatusProvider = StreamProvider<GrpcConnectionStatus>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  return manager.statusStream;
});

/// Streams full [ConnectionInfo] snapshots including error messages and
/// reconnect attempt counts.
final connectionInfoProvider = StreamProvider<ConnectionInfo>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  return manager.connectionInfoStream;
});

/// Manages the active relay configuration and connection lifecycle.
final relayConfigNotifierProvider =
    NotifierProvider<RelayConfigNotifier, RelayConfig?>(
      RelayConfigNotifier.new,
    );

/// Provides the default relay config from `--dart-define` environment
/// variables, useful for pre-filling login form fields.
final relayDefaultsProvider = Provider<RelayConfig>(
  (ref) => RelayConfig.fromEnvironment(),
);
