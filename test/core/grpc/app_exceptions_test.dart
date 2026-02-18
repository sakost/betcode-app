import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    test('NetworkError carries message and cause', () {
      final cause = Exception('socket closed');
      const message = 'connection lost';
      final error = NetworkError(message: message, cause: cause);

      expect(error.message, message);
      expect(error.cause, cause);
      expect(error.toString(), message);
    });

    test('NetworkError works without cause', () {
      const error = NetworkError(message: 'timeout');

      expect(error.message, 'timeout');
      expect(error.cause, isNull);
    });

    test('SessionNotFoundError includes sessionId', () {
      const error = SessionNotFoundError(
        message: 'not found',
        sessionId: 'sess-42',
      );

      expect(error.sessionId, 'sess-42');
      expect(error.message, 'not found');
      expect(error.cause, isNull);
    });

    test('all subtypes are AppException', () {
      const exceptions = <AppException>[
        NetworkError(message: 'a'),
        RelayUnavailableError(message: 'b'),
        SessionNotFoundError(message: 'c', sessionId: 's'),
        SessionInvalidError(message: 'd'),
        AuthExpiredError(message: 'e'),
        PermissionDeniedError(message: 'f'),
        ServerError(message: 'g'),
        RateLimitError(message: 'h'),
      ];

      for (final e in exceptions) {
        expect(e, isA<AppException>());
        expect(e, isA<Exception>());
      }
    });

    test('sealed switch is exhaustive', () {
      const AppException error = NetworkError(message: 'test');

      // If a subtype is added to the sealed class without updating this
      // switch, the analyzer will report a missing-case warning, proving
      // exhaustiveness.
      final label = switch (error) {
        NetworkError() => 'network',
        RelayUnavailableError() => 'relay',
        SessionNotFoundError() => 'session_not_found',
        SessionInvalidError() => 'session_invalid',
        AuthExpiredError() => 'auth',
        PermissionDeniedError() => 'permission',
        ServerError() => 'server',
        RateLimitError() => 'rate_limit',
      };

      expect(label, 'network');
    });

    test('toString returns message', () {
      const error = ServerError(message: 'internal error');
      expect('$error', 'internal error');
    });
  });
}
