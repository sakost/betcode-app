import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for JWT token management.
///
/// Provides typed accessors for the tokens the app needs, keeping the
/// raw storage keys private so callers never deal with string literals.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // -- Access token --------------------------------------------------------

  Future<String?> readToken() => _storage.read(key: _keyAccessToken);

  Future<void> writeToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  Future<void> deleteToken() => _storage.delete(key: _keyAccessToken);

  // -- Refresh token -------------------------------------------------------

  Future<String?> readRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  Future<void> deleteRefreshToken() => _storage.delete(key: _keyRefreshToken);

  // -- Bulk operations -----------------------------------------------------

  Future<void> clearAll() => _storage.deleteAll();
}
