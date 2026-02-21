import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:grpc/grpc.dart';

/// RPC method substrings that indicate session-related operations.
const _sessionMethods = [
  'Session', // DeleteSession, RenameSession, CompactSession, ResumeSession
  'Converse', // The bidi conversation stream
];

/// Maps a [GrpcError] to the appropriate [AppException] subclass.
///
/// The optional [method] parameter is the gRPC method path
/// (e.g. `/betcode.v1.AgentService/DeleteSession`) and is used to
/// distinguish session-specific NOT_FOUND from generic NOT_FOUND.
AppException mapGrpcError(GrpcError error, {String? method}) {
  return switch (error.code) {
    StatusCode.cancelled => NetworkError(
      message: 'Connection lost. Retrying...',
      cause: error,
    ),
    StatusCode.unavailable => _mapUnavailable(error),
    StatusCode.deadlineExceeded => NetworkError(
      message: 'Request timed out. Check your connection and try again.',
      cause: error,
    ),
    StatusCode.notFound =>
      _isSessionMethod(method)
          ? SessionNotFoundError(
              message: 'Session no longer exists.',
              cause: error,
            )
          : ServerError(
              message: 'The requested resource was not found.',
              cause: error,
            ),
    StatusCode.unauthenticated => AuthExpiredError(
      message: 'Your session has expired. Please log in again.',
      cause: error,
    ),
    StatusCode.permissionDenied => PermissionDeniedError(
      message: "You don't have permission for this action.",
      cause: error,
    ),
    StatusCode.resourceExhausted => RateLimitError(
      message: 'Too many requests. Please wait a moment and try again.',
      cause: error,
    ),
    StatusCode.invalidArgument ||
    StatusCode.failedPrecondition => SessionInvalidError(
      message: error.message ?? 'Invalid request.',
      cause: error,
    ),
    _ => ServerError(
      message: 'Something went wrong. Please try again.',
      cause: error,
    ),
  };
}

AppException _mapUnavailable(GrpcError error) {
  final msg = error.message ?? '';

  // "Channel shutting down" is a transient local error that occurs when the
  // ClientChannel is replaced during reconnection. It is NOT a TLS or relay
  // issue — the new channel may work fine. Treat it as a retryable network
  // error so callers don't display a scary "relay unreachable" banner.
  if (msg.contains('Channel shutting down')) {
    return NetworkError(
      message: 'Connection lost. Retrying...',
      cause: error,
    );
  }

  if (msg.contains('HandshakeException') ||
      msg.contains('WRONG_VERSION_NUMBER') ||
      msg.contains('TLS') ||
      msg.contains('CERTIFICATE')) {
    return RelayUnavailableError(
      message: 'Unable to reach the relay server.',
      cause: error,
    );
  }
  return NetworkError(
    message: 'Connection lost. Retrying...',
    cause: error,
  );
}

bool _isSessionMethod(String? method) {
  if (method == null) return false;
  return _sessionMethods.any(method.contains);
}
