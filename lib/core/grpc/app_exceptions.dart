/// Structured exceptions for gRPC and application-level errors.
///
/// [AppException] is a sealed class so that `switch` on its subtypes is
/// exhaustive, enabling the compiler to verify every error case is handled.
sealed class AppException implements Exception {
  /// Creates an [AppException] with the given [message] and optional [cause].
  const AppException({required this.message, this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// The underlying error that triggered this exception, if any.
  final Object? cause;

  @override
  String toString() => message;
}

/// A network-level failure (DNS, TCP, TLS, timeout).
final class NetworkError extends AppException {
  /// Creates a [NetworkError] with the given [message] and optional [cause].
  const NetworkError({required super.message, super.cause});
}

/// The relay server could not be reached.
final class RelayUnavailableError extends AppException {
  /// Creates a [RelayUnavailableError].
  const RelayUnavailableError({required super.message, super.cause});
}

/// The requested session does not exist on the daemon.
final class SessionNotFoundError extends AppException {
  /// Creates a [SessionNotFoundError] for the given [sessionId].
  const SessionNotFoundError({
    required super.message,
    required this.sessionId,
    super.cause,
  });

  /// The ID of the session that was not found.
  final String sessionId;
}

/// The session exists but is in an invalid state (e.g. corrupted, expired).
final class SessionInvalidError extends AppException {
  /// Creates a [SessionInvalidError].
  const SessionInvalidError({required super.message, super.cause});
}

/// The JWT has expired and the client must re-authenticate.
final class AuthExpiredError extends AppException {
  /// Creates an [AuthExpiredError].
  const AuthExpiredError({required super.message, super.cause});
}

/// The authenticated user lacks permission for the requested action.
final class PermissionDeniedError extends AppException {
  /// Creates a [PermissionDeniedError].
  const PermissionDeniedError({required super.message, super.cause});
}

/// An unexpected error on the daemon side (gRPC INTERNAL / UNKNOWN).
final class ServerError extends AppException {
  /// Creates a [ServerError].
  const ServerError({required super.message, super.cause});
}

/// The client has been rate-limited by the daemon or relay.
final class RateLimitError extends AppException {
  /// Creates a [RateLimitError].
  const RateLimitError({required super.message, super.cause});
}
