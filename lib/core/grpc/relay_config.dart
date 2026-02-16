import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;

/// Configuration for connecting to a betcode-daemon relay server.
///
/// Stored in [FlutterSecureStorage] and loaded at app startup.
/// All fields are required; use [isValid] to check before connecting.
@immutable
class RelayConfig {
  /// Creates a [RelayConfig] with the given [host], [port], and TLS flag.
  const RelayConfig({
    required this.host,
    required this.port,
    this.useTls = true,
  });

  /// Creates a [RelayConfig] from `--dart-define` environment variables.
  ///
  /// Reads `RELAY_HOST`, `RELAY_PORT` (default 443), and `RELAY_USE_TLS`
  /// (default true).
  factory RelayConfig.fromEnvironment() {
    const host = String.fromEnvironment(
      'RELAY_HOST',
      defaultValue: 'relay.ai.sakost.dev',
    );
    const port = int.fromEnvironment('RELAY_PORT', defaultValue: 443);
    const useTlsStr = String.fromEnvironment(
      'RELAY_USE_TLS',
      defaultValue: 'true',
    );
    return RelayConfig(
      host: host,
      port: port,
      useTls: useTlsStr.toLowerCase() != 'false',
    );
  }

  /// The relay server hostname or IP address.
  final String host;

  /// The TCP port number for the relay connection.
  final int port;

  /// Whether to use TLS for the gRPC channel. Defaults to true.
  final bool useTls;

  /// Whether this configuration is valid for establishing a connection.
  bool get isValid => host.isNotEmpty && port > 0 && port <= 65535;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelayConfig &&
          runtimeType == other.runtimeType &&
          host == other.host &&
          port == other.port &&
          useTls == other.useTls;

  @override
  int get hashCode => Object.hash(host, port, useTls);

  @override
  String toString() => 'RelayConfig(host: $host, port: $port, useTls: $useTls)';
}
