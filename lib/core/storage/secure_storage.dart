import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../grpc/relay_config.dart';

/// Wrapper around [FlutterSecureStorage] for JWT token and relay config
/// management.
///
/// Provides typed accessors for the tokens and relay configuration the app
/// needs, keeping the raw storage keys private so callers never deal with
/// string literals.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyRelayHost = 'relay_host';
  static const _keyRelayPort = 'relay_port';
  static const _keyRelayUseTls = 'relay_use_tls';
  static const _keySelectedMachineId = 'selected_machine_id';

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

  // -- Relay config --------------------------------------------------------

  /// Reads the stored relay configuration, or null if not persisted.
  Future<RelayConfig?> readRelayConfig() async {
    final host = await _storage.read(key: _keyRelayHost);
    if (host == null) return null;
    final portStr = await _storage.read(key: _keyRelayPort);
    final useTlsStr = await _storage.read(key: _keyRelayUseTls);
    return RelayConfig(
      host: host,
      port: int.tryParse(portStr ?? '') ?? 443,
      useTls: useTlsStr != 'false',
    );
  }

  /// Persists the relay configuration to secure storage.
  Future<void> writeRelayConfig(RelayConfig config) async {
    await _storage.write(key: _keyRelayHost, value: config.host);
    await _storage.write(key: _keyRelayPort, value: config.port.toString());
    await _storage.write(key: _keyRelayUseTls, value: config.useTls.toString());
  }

  /// Removes the stored relay configuration.
  Future<void> deleteRelayConfig() async {
    await _storage.delete(key: _keyRelayHost);
    await _storage.delete(key: _keyRelayPort);
    await _storage.delete(key: _keyRelayUseTls);
  }

  // -- Selected machine ID -------------------------------------------------

  Future<String?> readSelectedMachineId() =>
      _storage.read(key: _keySelectedMachineId);

  Future<void> writeSelectedMachineId(String machineId) =>
      _storage.write(key: _keySelectedMachineId, value: machineId);

  Future<void> deleteSelectedMachineId() =>
      _storage.delete(key: _keySelectedMachineId);

  // -- Bulk operations -----------------------------------------------------

  Future<void> clearAll() => _storage.deleteAll();
}
