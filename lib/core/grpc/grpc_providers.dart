import 'package:betcode_app/core/auth/auth.dart';
import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:betcode_app/core/grpc/lifecycle_bridge.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/core/lifecycle/lifecycle.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/health.pbgrpc.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

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
      MachineIdInterceptor(
        machineIdProvider: () async => ref.read(selectedMachineIdProvider),
      ),
      LoggingInterceptor(),
      ErrorMappingInterceptor(),
    ],
    healthCheckFn: (channel) async {
      final client = HealthClient(channel);
      try {
        await client.check(
          HealthCheckRequest(),
          options: CallOptions(timeout: const Duration(seconds: 5)),
        );
      } on GrpcError catch (e) {
        if (e.code == StatusCode.unimplemented) {
          // Server responded — connection is alive, just no Health service.
          return;
        }
        rethrow;
      }
    },
  );

  final bridge = GrpcLifecycleBridge(manager);

  ref
    ..listen(appLifecycleProvider, (prev, next) {
      if (next == AppLifecycleState.paused ||
          next == AppLifecycleState.hidden) {
        bridge.onPaused();
      } else if (next == AppLifecycleState.resumed) {
        bridge.onResumed();
      }
    })
    ..onDispose(() async {
      bridge.dispose();
      await manager.dispose();
    });

  return manager;
});

/// Streams connection status changes for widgets and other providers to watch.
///
/// The stream is seeded with the manager's current status so the provider
/// resolves immediately to `AsyncData` instead of staying in `AsyncLoading`
/// until the first event is emitted (which only happens on `connect`).
final connectionStatusProvider = StreamProvider<GrpcConnectionStatus>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  return _seededStatusStream(manager);
});

/// Yields the manager's current status immediately, then forwards all
/// subsequent stream events.
Stream<GrpcConnectionStatus> _seededStatusStream(
  GrpcClientManager manager,
) async* {
  yield manager.status;
  yield* manager.statusStream;
}

/// Streams full [ConnectionInfo] snapshots including error messages and
/// reconnect attempt counts.
///
/// Seeded with the manager's current info for the same reason as
/// [connectionStatusProvider].
final connectionInfoProvider = StreamProvider<ConnectionInfo>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  return _seededInfoStream(manager);
});

/// Yields the manager's current connection info immediately, then forwards
/// all subsequent stream events.
Stream<ConnectionInfo> _seededInfoStream(GrpcClientManager manager) async* {
  yield manager.currentInfo;
  yield* manager.connectionInfoStream;
}

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
