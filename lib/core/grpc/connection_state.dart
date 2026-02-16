import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

/// Status of the gRPC connection to the betcode-daemon.
enum GrpcConnectionStatus {
  /// No active connection to the daemon.
  disconnected,

  /// TCP/TLS handshake in progress.
  connecting,

  /// Connected, performing JWT authentication.
  authenticating,

  /// Fully connected and authenticated.
  connected,

  /// Lost connection, attempting to re-establish.
  reconnecting,
}

/// Immutable snapshot of the current gRPC connection state.
@freezed
abstract class ConnectionInfo with _$ConnectionInfo {
  /// Creates a [ConnectionInfo] with the given [status], optional
  /// [errorMessage], and [reconnectAttempt] counter.
  const factory ConnectionInfo({
    @Default(GrpcConnectionStatus.disconnected) GrpcConnectionStatus status,
    String? errorMessage,
    @Default(0) int reconnectAttempt,
  }) = _ConnectionInfo;
}
