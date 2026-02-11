import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/core/grpc/relay_reconnect_provider.dart';
import 'package:betcode_app/core/sync/connectivity.dart';

class MockGrpcClientManager extends Mock implements GrpcClientManager {}

void main() {
  late MockGrpcClientManager mockManager;

  setUp(() {
    mockManager = MockGrpcClientManager();
    when(() => mockManager.reconnect()).thenReturn(null);
  });

  ProviderContainer createContainer({
    required NetworkStatus networkStatus,
    required GrpcConnectionStatus connectionStatus,
    required RelayConfig? relayConfig,
  }) {
    return ProviderContainer(
      overrides: [
        networkStatusProvider.overrideWithValue(AsyncData(networkStatus)),
        connectionStatusProvider.overrideWithValue(AsyncData(connectionStatus)),
        relayConfigNotifierProvider.overrideWith(
          () => _FixedRelayConfigNotifier(relayConfig),
        ),
        grpcClientManagerProvider.overrideWithValue(mockManager),
      ],
    );
  }

  group('relayAutoReconnectProvider', () {
    test('no reconnect when offline', () {
      final container = createContainer(
        networkStatus: NetworkStatus.offline,
        connectionStatus: GrpcConnectionStatus.disconnected,
        relayConfig: const RelayConfig(host: 'relay.test', port: 443),
      );
      addTearDown(container.dispose);

      container.read(relayAutoReconnectProvider);

      verifyNever(() => mockManager.reconnect());
    });

    test('no reconnect when already connected', () {
      final container = createContainer(
        networkStatus: NetworkStatus.online,
        connectionStatus: GrpcConnectionStatus.connected,
        relayConfig: const RelayConfig(host: 'relay.test', port: 443),
      );
      addTearDown(container.dispose);

      container.read(relayAutoReconnectProvider);

      verifyNever(() => mockManager.reconnect());
    });

    test('no reconnect without relay config', () {
      final container = createContainer(
        networkStatus: NetworkStatus.online,
        connectionStatus: GrpcConnectionStatus.disconnected,
        relayConfig: null,
      );
      addTearDown(container.dispose);

      container.read(relayAutoReconnectProvider);

      verifyNever(() => mockManager.reconnect());
    });

    test('triggers reconnect when online, disconnected, and config exists', () {
      final container = createContainer(
        networkStatus: NetworkStatus.online,
        connectionStatus: GrpcConnectionStatus.disconnected,
        relayConfig: const RelayConfig(host: 'relay.test', port: 443),
      );
      addTearDown(container.dispose);

      container.read(relayAutoReconnectProvider);

      verify(() => mockManager.reconnect()).called(1);
    });

    test('no double reconnect when already reconnecting', () {
      final container = createContainer(
        networkStatus: NetworkStatus.online,
        connectionStatus: GrpcConnectionStatus.reconnecting,
        relayConfig: const RelayConfig(host: 'relay.test', port: 443),
      );
      addTearDown(container.dispose);

      container.read(relayAutoReconnectProvider);

      verifyNever(() => mockManager.reconnect());
    });
  });
}

/// A test [RelayConfigNotifier] that returns a fixed value.
class _FixedRelayConfigNotifier extends RelayConfigNotifier {
  _FixedRelayConfigNotifier(this._fixedConfig);

  final RelayConfig? _fixedConfig;

  @override
  RelayConfig? build() => _fixedConfig;
}
