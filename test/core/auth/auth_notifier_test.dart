import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(mockStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  AuthNotifier readNotifier() =>
      container.read(authNotifierProvider.notifier);
  AuthState readState() => container.read(authNotifierProvider);

  group('AuthNotifier', () {
    test('initial state is AuthUnauthenticated', () {
      expect(readState(), isA<AuthUnauthenticated>());
    });

    group('initialize', () {
      test('transitions to AuthAuthenticated when tokens exist in storage',
          () async {
        when(() => mockStorage.readToken())
            .thenAnswer((_) async => 'stored-access-token');
        when(() => mockStorage.readRefreshToken())
            .thenAnswer((_) async => 'stored-refresh-token');

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        final auth = s as AuthAuthenticated;
        expect(auth.accessToken, 'stored-access-token');
        expect(auth.refreshToken, 'stored-refresh-token');
        expect(auth.userId, '');
      });

      test('transitions to AuthUnauthenticated when no tokens in storage',
          () async {
        when(() => mockStorage.readToken()).thenAnswer((_) async => null);
        when(() => mockStorage.readRefreshToken())
            .thenAnswer((_) async => null);

        await readNotifier().initialize();

        expect(readState(), isA<AuthUnauthenticated>());
      });

      test(
          'transitions to AuthUnauthenticated when only access token exists',
          () async {
        when(() => mockStorage.readToken())
            .thenAnswer((_) async => 'access-only');
        when(() => mockStorage.readRefreshToken())
            .thenAnswer((_) async => null);

        await readNotifier().initialize();

        expect(readState(), isA<AuthUnauthenticated>());
      });

      test(
          'transitions to AuthUnauthenticated when only refresh token exists',
          () async {
        when(() => mockStorage.readToken()).thenAnswer((_) async => null);
        when(() => mockStorage.readRefreshToken())
            .thenAnswer((_) async => 'refresh-only');

        await readNotifier().initialize();

        expect(readState(), isA<AuthUnauthenticated>());
      });

      test('transitions to AuthError when storage throws', () async {
        when(() => mockStorage.readToken())
            .thenThrow(Exception('storage corrupt'));

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthError>());
        expect(
          (s as AuthError).message,
          contains('storage corrupt'),
        );
      });
    });

    group('setTokens', () {
      test('stores tokens and transitions to AuthAuthenticated', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
          userId: 'user-42',
          expiresInSecs: 3600,
        );

        verify(() => mockStorage.writeToken('new-access')).called(1);
        verify(() => mockStorage.writeRefreshToken('new-refresh')).called(1);

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        final auth = s as AuthAuthenticated;
        expect(auth.accessToken, 'new-access');
        expect(auth.refreshToken, 'new-refresh');
        expect(auth.userId, 'user-42');
        // expiresAt should be roughly now + 3600 seconds
        final diff =
            auth.expiresAt.difference(DateTime.now()).inSeconds;
        expect(diff, closeTo(3600, 5));
      });
    });

    group('logout', () {
      test('clears storage and transitions to AuthUnauthenticated', () async {
        // First authenticate
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 300,
        );
        expect(readState(), isA<AuthAuthenticated>());

        await readNotifier().logout();

        verify(() => mockStorage.clearAll()).called(1);
        expect(readState(), isA<AuthUnauthenticated>());
      });
    });

    group('isAuthenticated', () {
      test('returns false when unauthenticated', () {
        expect(readNotifier().isAuthenticated, isFalse);
      });

      test('returns true when authenticated', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );

        expect(readNotifier().isAuthenticated, isTrue);
      });

      test('returns false after logout', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );
        await readNotifier().logout();

        expect(readNotifier().isAuthenticated, isFalse);
      });
    });

    group('accessToken', () {
      test('returns null when unauthenticated', () {
        expect(readNotifier().accessToken, isNull);
      });

      test('returns token when authenticated', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'my-jwt',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );

        expect(readNotifier().accessToken, 'my-jwt');
      });

      test('returns null after logout', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'my-jwt',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );
        await readNotifier().logout();

        expect(readNotifier().accessToken, isNull);
      });
    });

    group('isTokenExpiringSoon', () {
      test('returns false when unauthenticated', () {
        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });

      test('returns false when token has plenty of time remaining', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 3600, // 1 hour
        );

        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });

      test('returns true when less than 2 minutes remaining', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 60, // 1 minute - less than 2 min threshold
        );

        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true when token is already expired', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 0, // expires now
        );

        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true at exactly 1 minute remaining', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        // 119 seconds is less than 2 minutes (inMinutes truncates, so 119s = 1 minute)
        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 119,
        );

        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns false at exactly 2 minutes remaining', () async {
        when(() => mockStorage.writeToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorage.writeRefreshToken(any()))
            .thenAnswer((_) async {});

        // 120 seconds = 2 minutes exactly, inMinutes truncates so 120s = 2 min
        // The check is `< 2`, so 2 is NOT expiring soon
        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 125, // small buffer to account for test execution time
        );

        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });
    });
  });
}
