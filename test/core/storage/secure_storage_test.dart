import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageService(storage: mockStorage);
  });

  group('SecureStorageService - access token', () {
    test('readToken delegates to storage with correct key', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => 'my-jwt');

      final result = await service.readToken();

      expect(result, 'my-jwt');
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });

    test('readToken returns null when no token stored', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => null);

      final result = await service.readToken();

      expect(result, isNull);
    });

    test('writeToken persists with correct key', () async {
      when(() => mockStorage.write(key: 'access_token', value: 'tok-123'))
          .thenAnswer((_) async {});

      await service.writeToken('tok-123');

      verify(() => mockStorage.write(key: 'access_token', value: 'tok-123'))
          .called(1);
    });

    test('deleteToken removes correct key', () async {
      when(() => mockStorage.delete(key: 'access_token'))
          .thenAnswer((_) async {});

      await service.deleteToken();

      verify(() => mockStorage.delete(key: 'access_token')).called(1);
    });
  });

  group('SecureStorageService - refresh token', () {
    test('readRefreshToken delegates to storage with correct key', () async {
      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'refresh-jwt');

      final result = await service.readRefreshToken();

      expect(result, 'refresh-jwt');
      verify(() => mockStorage.read(key: 'refresh_token')).called(1);
    });

    test('readRefreshToken returns null when no token stored', () async {
      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => null);

      final result = await service.readRefreshToken();

      expect(result, isNull);
    });

    test('writeRefreshToken persists with correct key', () async {
      when(() => mockStorage.write(key: 'refresh_token', value: 'ref-456'))
          .thenAnswer((_) async {});

      await service.writeRefreshToken('ref-456');

      verify(() => mockStorage.write(key: 'refresh_token', value: 'ref-456'))
          .called(1);
    });

    test('deleteRefreshToken removes correct key', () async {
      when(() => mockStorage.delete(key: 'refresh_token'))
          .thenAnswer((_) async {});

      await service.deleteRefreshToken();

      verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
    });
  });

  group('SecureStorageService - bulk operations', () {
    test('clearAll delegates to deleteAll', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      await service.clearAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });
  });

  group('SecureStorageService - default construction', () {
    test('creates instance without explicit storage', () {
      // Should not throw when constructed without passing storage.
      final defaultService = SecureStorageService();
      expect(defaultService, isNotNull);
    });
  });
}
