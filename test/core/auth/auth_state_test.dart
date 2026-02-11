import 'package:flutter_test/flutter_test.dart';
import 'package:betcode_app/core/auth/auth_state.dart';

void main() {
  group('AuthState', () {
    group('unauthenticated', () {
      test('creates AuthUnauthenticated instance', () {
        const state = AuthState.unauthenticated();
        expect(state, isA<AuthUnauthenticated>());
      });

      test('two instances are equal', () {
        const a = AuthState.unauthenticated();
        const b = AuthState.unauthenticated();
        expect(a, equals(b));
      });
    });

    group('loading', () {
      test('creates AuthLoading instance', () {
        const state = AuthState.loading();
        expect(state, isA<AuthLoading>());
      });

      test('two instances are equal', () {
        const a = AuthState.loading();
        const b = AuthState.loading();
        expect(a, equals(b));
      });
    });

    group('authenticated', () {
      late DateTime expiresAt;
      late AuthState state;

      setUp(() {
        expiresAt = DateTime(2026, 3, 1, 12, 0, 0);
        state = AuthState.authenticated(
          accessToken: 'access-123',
          refreshToken: 'refresh-456',
          userId: 'user-789',
          expiresAt: expiresAt,
        );
      });

      test('creates AuthAuthenticated instance', () {
        expect(state, isA<AuthAuthenticated>());
      });

      test('stores all fields correctly', () {
        final auth = state as AuthAuthenticated;
        expect(auth.accessToken, 'access-123');
        expect(auth.refreshToken, 'refresh-456');
        expect(auth.userId, 'user-789');
        expect(auth.expiresAt, expiresAt);
      });

      test('two instances with same args are equal', () {
        final a = AuthState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresAt: expiresAt,
        );
        final b = AuthState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresAt: expiresAt,
        );
        expect(a, equals(b));
      });

      test('two instances with different args are not equal', () {
        final a = AuthState.authenticated(
          accessToken: 'token-a',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresAt: expiresAt,
        );
        final b = AuthState.authenticated(
          accessToken: 'token-b',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresAt: expiresAt,
        );
        expect(a, isNot(equals(b)));
      });

      test('copyWith replaces specified fields', () {
        final auth = state as AuthAuthenticated;
        final copied = auth.copyWith(accessToken: 'new-token');
        expect(copied.accessToken, 'new-token');
        expect(copied.refreshToken, 'refresh-456');
        expect(copied.userId, 'user-789');
        expect(copied.expiresAt, expiresAt);
      });

      test('copyWith with no arguments returns equal instance', () {
        final auth = state as AuthAuthenticated;
        final copied = auth.copyWith();
        expect(copied, equals(auth));
      });

      test('copyWith can replace multiple fields', () {
        final auth = state as AuthAuthenticated;
        final newExpiry = DateTime(2026, 6, 1);
        final copied = auth.copyWith(userId: 'new-user', expiresAt: newExpiry);
        expect(copied.accessToken, 'access-123');
        expect(copied.refreshToken, 'refresh-456');
        expect(copied.userId, 'new-user');
        expect(copied.expiresAt, newExpiry);
      });
    });

    group('error', () {
      test('creates AuthError instance', () {
        const state = AuthState.error('something went wrong');
        expect(state, isA<AuthError>());
      });

      test('stores message correctly', () {
        const state = AuthState.error('network failure');
        final error = state as AuthError;
        expect(error.message, 'network failure');
      });

      test('two instances with same message are equal', () {
        const a = AuthState.error('fail');
        const b = AuthState.error('fail');
        expect(a, equals(b));
      });

      test('two instances with different messages are not equal', () {
        const a = AuthState.error('fail-a');
        const b = AuthState.error('fail-b');
        expect(a, isNot(equals(b)));
      });
    });

    group('cross-variant inequality', () {
      test('unauthenticated is not equal to loading', () {
        const a = AuthState.unauthenticated();
        const b = AuthState.loading();
        expect(a, isNot(equals(b)));
      });

      test('unauthenticated is not equal to error', () {
        const a = AuthState.unauthenticated();
        const b = AuthState.error('err');
        expect(a, isNot(equals(b)));
      });

      test('loading is not equal to authenticated', () {
        const a = AuthState.loading();
        final b = AuthState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresAt: DateTime(2026, 1, 1),
        );
        expect(a, isNot(equals(b)));
      });
    });
  });
}
