import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/error_mapping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

void main() {
  group('mapGrpcError', () {
    test('UNAVAILABLE with handshake error -> RelayUnavailableError', () {
      const grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Error connecting: HandshakeException: WRONG_VERSION_NUMBER',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<RelayUnavailableError>());
      expect(result.cause, grpcError);
    });

    test('UNAVAILABLE with channel shutting down -> NetworkError', () {
      const grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Channel shutting down.',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<NetworkError>());
    });

    test('UNAVAILABLE with TLS keyword -> RelayUnavailableError', () {
      const grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'TLS handshake failed',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<RelayUnavailableError>());
    });

    test('UNAVAILABLE with CERTIFICATE keyword -> RelayUnavailableError', () {
      const grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'CERTIFICATE_VERIFY_FAILED',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<RelayUnavailableError>());
    });

    test('UNAVAILABLE generic -> NetworkError', () {
      const grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Connection timed out',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<NetworkError>());
    });

    test('NOT_FOUND on session RPC -> SessionNotFoundError', () {
      const grpcError = GrpcError.notFound('session not found');
      final result = mapGrpcError(
        grpcError,
        method: '/betcode.v1.AgentService/DeleteSession',
      );
      expect(result, isA<SessionNotFoundError>());
    });

    test('NOT_FOUND on Converse RPC -> SessionNotFoundError', () {
      const grpcError = GrpcError.notFound('session not found');
      final result = mapGrpcError(
        grpcError,
        method: '/betcode.v1.AgentService/Converse',
      );
      expect(result, isA<SessionNotFoundError>());
    });

    test('NOT_FOUND on non-session RPC -> ServerError', () {
      const grpcError = GrpcError.notFound('machine not found');
      final result = mapGrpcError(
        grpcError,
        method: '/betcode.v1.MachineService/ListMachines',
      );
      expect(result, isA<ServerError>());
    });

    test('NOT_FOUND with no method -> ServerError', () {
      const grpcError = GrpcError.notFound('not found');
      final result = mapGrpcError(grpcError);
      expect(result, isA<ServerError>());
    });

    test('UNAUTHENTICATED -> AuthExpiredError', () {
      final result = mapGrpcError(const GrpcError.unauthenticated());
      expect(result, isA<AuthExpiredError>());
    });

    test('PERMISSION_DENIED -> PermissionDeniedError', () {
      final result = mapGrpcError(
        const GrpcError.custom(StatusCode.permissionDenied, 'not owner'),
      );
      expect(result, isA<PermissionDeniedError>());
    });

    test('RESOURCE_EXHAUSTED -> RateLimitError', () {
      final result = mapGrpcError(const GrpcError.resourceExhausted());
      expect(result, isA<RateLimitError>());
    });

    test('INVALID_ARGUMENT -> SessionInvalidError', () {
      final result = mapGrpcError(
        const GrpcError.custom(StatusCode.invalidArgument, 'name too long'),
      );
      expect(result, isA<SessionInvalidError>());
      expect(result.message, 'name too long');
    });

    test('FAILED_PRECONDITION -> SessionInvalidError', () {
      final result = mapGrpcError(
        const GrpcError.custom(StatusCode.failedPrecondition, 'session locked'),
      );
      expect(result, isA<SessionInvalidError>());
      expect(result.message, 'session locked');
    });

    test('INTERNAL -> ServerError', () {
      final result = mapGrpcError(const GrpcError.internal());
      expect(result, isA<ServerError>());
    });

    test('DEADLINE_EXCEEDED -> NetworkError', () {
      final result = mapGrpcError(const GrpcError.deadlineExceeded());
      expect(result, isA<NetworkError>());
    });

    test('UNKNOWN -> ServerError', () {
      final result = mapGrpcError(
        const GrpcError.custom(StatusCode.unknown, 'something broke'),
      );
      expect(result, isA<ServerError>());
    });

    test('preserves original GrpcError as cause', () {
      const grpcError = GrpcError.internal('db crashed');
      final result = mapGrpcError(grpcError);
      expect(result.cause, grpcError);
    });
  });
}
