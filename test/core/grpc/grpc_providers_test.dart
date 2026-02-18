import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('grpcClientManagerProvider', () {
    test('interceptor chain contains TokenRefreshInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.whereType<TokenRefreshInterceptor>(),
        hasLength(1),
        reason: 'TokenRefreshInterceptor should be present in the chain',
      );
    });

    test('interceptor chain contains AuthInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.whereType<AuthInterceptor>(),
        hasLength(1),
        reason: 'AuthInterceptor should be present in the chain',
      );
    });

    test('interceptor chain contains LoggingInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.whereType<LoggingInterceptor>(),
        hasLength(1),
        reason: 'LoggingInterceptor should be present in the chain',
      );
    });

    test('TokenRefreshInterceptor comes before AuthInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      final refreshIndex = interceptors.indexWhere(
        (i) => i is TokenRefreshInterceptor,
      );
      final authIndex = interceptors.indexWhere((i) => i is AuthInterceptor);

      expect(
        refreshIndex,
        lessThan(authIndex),
        reason:
            'TokenRefreshInterceptor must run before AuthInterceptor '
            'so the token is refreshed before the auth header is injected',
      );
    });

    test('interceptor chain contains MachineIdInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.whereType<MachineIdInterceptor>(),
        hasLength(1),
        reason: 'MachineIdInterceptor should be present in the chain',
      );
    });

    test('interceptor chain contains ErrorMappingInterceptor', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.whereType<ErrorMappingInterceptor>(),
        hasLength(1),
        reason: 'ErrorMappingInterceptor should be present in the chain',
      );
    });

    test('ErrorMappingInterceptor is last in the chain', () {
      final manager = container.read(grpcClientManagerProvider);
      final interceptors = manager.interceptors;

      expect(
        interceptors.last,
        isA<ErrorMappingInterceptor>(),
        reason:
            'ErrorMappingInterceptor must be last so it wraps errors from '
            'all preceding interceptors',
      );
    });

    test('has exactly five interceptors', () {
      final manager = container.read(grpcClientManagerProvider);
      expect(manager.interceptors, hasLength(5));
    });

    test('has a health check function configured', () {
      final manager = container.read(grpcClientManagerProvider);
      expect(
        manager.hasHealthCheck,
        isTrue,
        reason:
            'GrpcClientManager should have a health check function that '
            'calls HealthService.Check after channel creation',
      );
    });
  });
}
