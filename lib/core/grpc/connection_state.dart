import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

/// Status of the gRPC connection to the betcode-daemon.
enum GrpcConnectionStatus {
  disconnected,
  connecting,
  authenticating,
  connected,
  reconnecting,
}

/// Immutable snapshot of the current connection state.
@freezed
abstract class ConnectionInfo with _$ConnectionInfo {
  const factory ConnectionInfo({
    @Default(GrpcConnectionStatus.disconnected) GrpcConnectionStatus status,
    String? errorMessage,
    @Default(0) int reconnectAttempt,
  }) = _ConnectionInfo;
}
