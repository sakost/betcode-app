import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import 'connection_state.dart';

/// Manages a single [ClientChannel] lifecycle with automatic reconnection.
///
/// Exposes connection status as a stream so Riverpod providers and widgets
/// can react to connectivity changes. Reconnection uses exponential backoff
/// capped at 30 seconds (100ms -> 1s -> 5s -> 30s).
class GrpcClientManager {
  /// Creates a [GrpcClientManager].
  ///
  /// An optional [healthCheckFn] callback can be provided to verify
  /// connectivity after channel creation. It receives the newly created
  /// [ClientChannel] and should throw if the connection is unhealthy.
  /// If null, no health check is performed (backward compatible).
  GrpcClientManager({
    List<ClientInterceptor>? interceptors,
    Future<void> Function(ClientChannel channel)? healthCheckFn,
  }) : _interceptors = interceptors ?? const [],
       _healthCheckFn = healthCheckFn;

  final List<ClientInterceptor> _interceptors;
  final Future<void> Function(ClientChannel channel)? _healthCheckFn;

  final _statusController = StreamController<GrpcConnectionStatus>.broadcast();
  final _connectionInfoController =
      StreamController<ConnectionInfo>.broadcast();

  ClientChannel? _channel;
  ConnectionInfo _currentInfo = const ConnectionInfo();
  Timer? _reconnectTimer;
  bool _disposed = false;

  // Stored connection parameters for auto-reconnect.
  String? _host;
  int? _port;
  bool _useTls = false;

  /// The backoff durations for reconnection attempts, indexed by attempt number.
  /// Capped at 30 seconds.
  static const _backoffDurations = [
    Duration(milliseconds: 100),
    Duration(seconds: 1),
    Duration(seconds: 5),
    Duration(seconds: 30),
  ];

  // -- Public API --

  /// Stream of connection status changes.
  Stream<GrpcConnectionStatus> get statusStream => _statusController.stream;

  /// Stream of full connection info (status + error + attempt count).
  Stream<ConnectionInfo> get connectionInfoStream =>
      _connectionInfoController.stream;

  /// Current connection info snapshot.
  ConnectionInfo get currentInfo => _currentInfo;

  /// Current connection status shorthand.
  GrpcConnectionStatus get status => _currentInfo.status;

  /// The active [ClientChannel]. Throws [StateError] if not connected.
  ClientChannel get channel {
    final ch = _channel;
    if (ch == null) {
      throw StateError(
        'gRPC channel is not available. '
        'Call connect() first. Current status: ${_currentInfo.status}',
      );
    }
    return ch;
  }

  /// The active channel, or null if not connected.
  ClientChannel? get channelOrNull => _channel;

  /// The interceptors configured for this manager.
  List<ClientInterceptor> get interceptors => List.unmodifiable(_interceptors);

  /// Whether a health check function has been configured.
  bool get hasHealthCheck => _healthCheckFn != null;

  /// The host from the last [connect] call, or null if never connected.
  String? get host => _host;

  /// The port from the last [connect] call, or null if never connected.
  int? get port => _port;

  /// Whether TLS was enabled in the last [connect] call.
  bool get useTls => _useTls;

  /// Establish a gRPC connection to the given [host] and [port].
  ///
  /// If a connection already exists it will be shut down first.
  /// Set [useTls] to true when connecting through the relay.
  Future<void> connect(String host, int port, {bool useTls = false}) async {
    _cancelReconnect();
    await _shutdownChannel();

    _host = host;
    _port = port;
    _useTls = useTls;

    _emitStatus(GrpcConnectionStatus.connecting);

    try {
      _channel = ClientChannel(
        host,
        port: port,
        options: ChannelOptions(
          credentials: useTls
              ? ChannelCredentials.secure(
                  onBadCertificate: kDebugMode
                      ? (X509Certificate cert, String host) {
                          developer.log(
                            'Accepting self-signed cert for $host '
                            '(debug mode)',
                            name: 'GrpcClientManager',
                          );
                          return true;
                        }
                      : null,
                )
              : const ChannelCredentials.insecure(),
          connectionTimeout: const Duration(seconds: 10),
        ),
      );

      if (_healthCheckFn != null) {
        try {
          await _healthCheckFn(_channel!);
        } on Object catch (e) {
          developer.log(
            'Health check failed (connecting anyway): $e',
            name: 'GrpcClientManager',
          );
        }
      }

      _emitStatus(GrpcConnectionStatus.connected);
    } on Object catch (e) {
      _emitStatus(
        GrpcConnectionStatus.disconnected,
        errorMessage: 'Connection failed: $e',
      );
      rethrow;
    }
  }

  /// Gracefully shut down the channel and stop any reconnection attempts.
  Future<void> disconnect() async {
    _cancelReconnect();
    await _shutdownChannel();
    _emitStatus(GrpcConnectionStatus.disconnected);
  }

  /// Trigger a reconnection attempt using exponential backoff.
  ///
  /// Call this when an RPC fails with a transient error and you want the
  /// manager to re-establish the connection automatically. If [host] and
  /// [port] are omitted, the values from the last [connect] call are used.
  /// Throws [StateError] if no stored parameters are available and none
  /// are supplied.
  void reconnect({String? host, int? port, bool? useTls}) {
    if (_disposed) return;

    final resolvedHost = host ?? _host;
    final resolvedPort = port ?? _port;
    final resolvedUseTls = useTls ?? _useTls;

    if (resolvedHost == null || resolvedPort == null) {
      throw StateError(
        'Cannot reconnect: no stored connection parameters. '
        'Call connect() first or supply host and port explicitly.',
      );
    }

    _cancelReconnect();
    _reconnectLoop(resolvedHost, resolvedPort, useTls: resolvedUseTls);
  }

  /// Release all resources. The manager cannot be used after this.
  Future<void> dispose() async {
    _disposed = true;
    _cancelReconnect();
    await _shutdownChannel();
    _emitStatus(GrpcConnectionStatus.disconnected);
    await _statusController.close();
    await _connectionInfoController.close();
  }

  // -- Internal --

  void _reconnectLoop(
    String host,
    int port, {
    required bool useTls,
    int attempt = 0,
  }) {
    if (_disposed) return;

    final delay = _backoffDurations[min(attempt, _backoffDurations.length - 1)];

    _emitStatus(
      GrpcConnectionStatus.reconnecting,
      reconnectAttempt: attempt + 1,
    );

    developer.log(
      'Reconnecting in ${delay.inMilliseconds}ms (attempt ${attempt + 1})',
      name: 'GrpcClientManager',
    );

    _reconnectTimer = Timer(delay, () async {
      if (_disposed) return;
      try {
        await connect(host, port, useTls: useTls);
      } on Object catch (e) {
        developer.log(
          'Reconnect attempt ${attempt + 1} failed: $e',
          name: 'GrpcClientManager',
        );
        _reconnectLoop(host, port, useTls: useTls, attempt: attempt + 1);
      }
    });
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> _shutdownChannel() async {
    final ch = _channel;
    _channel = null;
    if (ch != null) {
      try {
        await ch.shutdown();
      } on Object catch (e) {
        developer.log(
          'Error shutting down channel: $e',
          name: 'GrpcClientManager',
        );
      }
    }
  }

  void _emitStatus(
    GrpcConnectionStatus status, {
    String? errorMessage,
    int reconnectAttempt = 0,
  }) {
    _currentInfo = ConnectionInfo(
      status: status,
      errorMessage: errorMessage,
      reconnectAttempt: reconnectAttempt,
    );
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
    if (!_connectionInfoController.isClosed) {
      _connectionInfoController.add(_currentInfo);
    }
  }
}
