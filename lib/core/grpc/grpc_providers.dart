import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

import '../../generated/betcode/v1/auth.pbgrpc.dart';
import '../../generated/betcode/v1/health.pbgrpc.dart';
import '../auth/auth.dart';
import 'client_manager.dart';
import 'connection_state.dart';
import 'interceptors.dart';
import 'relay_config.dart';
import 'relay_notifier.dart';

/// Provides the singleton [GrpcClientManager] instance.
///
/// The [TokenRefreshInterceptor] checks token expiry before each RPC and
/// triggers a refresh if the token expires within 2 minutes.
/// The [AuthInterceptor] then reads the (possibly refreshed) JWT so every
/// outgoing RPC carries a valid token.
final grpcClientManagerProvider = Provider<GrpcClientManager>((ref) {
  final authNotifier = ref.read(authNotifierProvider.notifier);

  late final GrpcClientManager manager;
  manager = GrpcClientManager(
    interceptors: [
      TokenRefreshInterceptor(
        authNotifier: authNotifier,
        authClientFactory: () => AuthServiceClient(manager.channel),
      ),
      AuthInterceptor(tokenProvider: () async => authNotifier.accessToken),
      LoggingInterceptor(),
    ],
    healthCheckFn: (channel) async {
      final client = HealthClient(channel);
      await client.check(
        HealthCheckRequest(),
        options: CallOptions(timeout: const Duration(seconds: 5)),
      );
    },
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
