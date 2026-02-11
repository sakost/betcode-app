import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockGrpcClientManager extends Mock implements GrpcClientManager {}

void main() {
  late MockSecureStorageService mockStorage;
  late MockGrpcClientManager mockManager;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const RelayConfig(host: '', port: 0));
  });

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockManager = MockGrpcClientManager();

    // Default stubs so tests that don't explicitly mock these won't fail
    // with type errors.
    when(
      () => mockManager.connect(any(), any(), useTls: any(named: 'useTls')),
    ).thenAnswer((_) async {});
    when(() => mockManager.disconnect()).thenAnswer((_) async {});
    when(() => mockStorage.writeRelayConfig(any())).thenAnswer((_) async {});
    when(() => mockStorage.deleteRelayConfig()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(mockStorage),
        grpcClientManagerProvider.overrideWithValue(mockManager),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('RelayConfigNotifier', () {
    test('initial state is null', () {
      final state = container.read(relayConfigNotifierProvider);
      expect(state, isNull);
    });

    test('initialize with stored config connects and sets state', () async {
      const config = RelayConfig(host: 'relay.test', port: 443, useTls: true);
      when(() => mockStorage.readRelayConfig()).thenAnswer((_) async => config);
      when(
        () => mockManager.connect('relay.test', 443, useTls: true),
      ).thenAnswer((_) async {});

      await container.read(relayConfigNotifierProvider.notifier).initialize();

      expect(container.read(relayConfigNotifierProvider), equals(config));
      verify(
        () => mockManager.connect('relay.test', 443, useTls: true),
      ).called(1);
    });

    test('initialize with no stored config leaves state null', () async {
      when(() => mockStorage.readRelayConfig()).thenAnswer((_) async => null);

      await container.read(relayConfigNotifierProvider.notifier).initialize();

      expect(container.read(relayConfigNotifierProvider), isNull);
      verifyNever(
        () => mockManager.connect(any(), any(), useTls: any(named: 'useTls')),
      );
    });

    test(
      'initialize with stored config but connect failure leaves state null',
      () async {
        const config = RelayConfig(host: 'relay.test', port: 443, useTls: true);
        when(
          () => mockStorage.readRelayConfig(),
        ).thenAnswer((_) async => config);
        when(
          () => mockManager.connect('relay.test', 443, useTls: true),
        ).thenThrow(Exception('connection refused'));

        await container.read(relayConfigNotifierProvider.notifier).initialize();

        expect(container.read(relayConfigNotifierProvider), isNull);
      },
    );

    test(
      'connectTo calls connect with correct params and sets state',
      () async {
        const config = RelayConfig(
          host: 'relay.new',
          port: 8443,
          useTls: false,
        );
        when(
          () => mockManager.connect('relay.new', 8443, useTls: false),
        ).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRelayConfig(config),
        ).thenAnswer((_) async {});

        await container
            .read(relayConfigNotifierProvider.notifier)
            .connectTo(config);

        expect(container.read(relayConfigNotifierProvider), equals(config));
        verify(
          () => mockManager.connect('relay.new', 8443, useTls: false),
        ).called(1);
      },
    );

    test('connectTo persists to storage on success', () async {
      const config = RelayConfig(host: 'relay.new', port: 443);
      when(
        () => mockManager.connect('relay.new', 443, useTls: true),
      ).thenAnswer((_) async {});
      when(() => mockStorage.writeRelayConfig(config)).thenAnswer((_) async {});

      await container
          .read(relayConfigNotifierProvider.notifier)
          .connectTo(config);

      verify(() => mockStorage.writeRelayConfig(config)).called(1);
    });

    test('connectTo rethrows on failure and does not persist', () async {
      const config = RelayConfig(host: 'relay.bad', port: 443);
      when(
        () => mockManager.connect('relay.bad', 443, useTls: true),
      ).thenThrow(Exception('refused'));

      await expectLater(
        container.read(relayConfigNotifierProvider.notifier).connectTo(config),
        throwsA(isA<Exception>()),
      );

      verifyNever(() => mockStorage.writeRelayConfig(any()));
      expect(container.read(relayConfigNotifierProvider), isNull);
    });

    test('disconnect calls manager.disconnect', () async {
      when(() => mockManager.disconnect()).thenAnswer((_) async {});
      when(() => mockStorage.deleteRelayConfig()).thenAnswer((_) async {});

      await container.read(relayConfigNotifierProvider.notifier).disconnect();

      verify(() => mockManager.disconnect()).called(1);
    });

    test('disconnect clears storage', () async {
      when(() => mockManager.disconnect()).thenAnswer((_) async {});
      when(() => mockStorage.deleteRelayConfig()).thenAnswer((_) async {});

      await container.read(relayConfigNotifierProvider.notifier).disconnect();

      verify(() => mockStorage.deleteRelayConfig()).called(1);
    });

    test('disconnect sets state to null', () async {
      // First connect
      const config = RelayConfig(host: 'relay.test', port: 443);
      when(
        () => mockManager.connect('relay.test', 443, useTls: true),
      ).thenAnswer((_) async {});
      when(() => mockStorage.writeRelayConfig(config)).thenAnswer((_) async {});
      await container
          .read(relayConfigNotifierProvider.notifier)
          .connectTo(config);
      expect(container.read(relayConfigNotifierProvider), isNotNull);

      // Then disconnect
      when(() => mockManager.disconnect()).thenAnswer((_) async {});
      when(() => mockStorage.deleteRelayConfig()).thenAnswer((_) async {});
      await container.read(relayConfigNotifierProvider.notifier).disconnect();

      expect(container.read(relayConfigNotifierProvider), isNull);
    });
  });
}
