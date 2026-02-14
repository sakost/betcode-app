import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';

import '../../helpers/fake_response_future.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

/// Creates a test JWT with the given claims.
String createTestJwt({required String sub, int? exp}) {
  final header = base64Url
      .encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'))
      .replaceAll('=', '');
  final claims = <String, dynamic>{'sub': sub};
  if (exp != null) claims['exp'] = exp;
  final payload = base64Url
      .encode(utf8.encode(jsonEncode(claims)))
      .replaceAll('=', '');
  final signature = base64Url
      .encode(utf8.encode('fake-signature'))
      .replaceAll('=', '');
  return '$header.$payload.$signature';
}

void main() {
  late MockSecureStorageService mockStorage;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(RefreshTokenRequest());
  });

  setUp(() {
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  AuthNotifier readNotifier() => container.read(authNotifierProvider.notifier);
  AuthState readState() => container.read(authNotifierProvider);

  /// Stubs storage to accept token writes (used by most setTokens tests).
  void stubStorageWrites() {
    when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
    when(() => mockStorage.writeRefreshToken(any())).thenAnswer((_) async {});
  }

  /// Stubs storage writes and calls setTokens with given (or default) values.
  Future<void> authenticateNotifier({
    String accessToken = 'token',
    String refreshToken = 'refresh',
    String userId = 'uid',
    int expiresInSecs = 3600,
  }) async {
    stubStorageWrites();
    await readNotifier().setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      expiresInSecs: expiresInSecs,
    );
  }

  group('AuthNotifier', () {
    test('initial state is AuthUnauthenticated', () {
      expect(readState(), isA<AuthUnauthenticated>());
    });

    group('initialize', () {
      test(
        'transitions to AuthAuthenticated when tokens exist in storage',
        () async {
          when(
            () => mockStorage.readToken(),
          ).thenAnswer((_) async => 'stored-access-token');
          when(
            () => mockStorage.readRefreshToken(),
          ).thenAnswer((_) async => 'stored-refresh-token');

          await readNotifier().initialize();

          final s = readState();
          expect(s, isA<AuthAuthenticated>());
          final auth = s as AuthAuthenticated;
          expect(auth.accessToken, 'stored-access-token');
          expect(auth.refreshToken, 'stored-refresh-token');
          expect(auth.userId, '');
        },
      );

      test(
        'transitions to AuthUnauthenticated when no tokens in storage',
        () async {
          when(() => mockStorage.readToken()).thenAnswer((_) async => null);
          when(
            () => mockStorage.readRefreshToken(),
          ).thenAnswer((_) async => null);

          await readNotifier().initialize();

          expect(readState(), isA<AuthUnauthenticated>());
        },
      );

      test(
        'transitions to AuthUnauthenticated when only access token exists',
        () async {
          when(
            () => mockStorage.readToken(),
          ).thenAnswer((_) async => 'access-only');
          when(
            () => mockStorage.readRefreshToken(),
          ).thenAnswer((_) async => null);

          await readNotifier().initialize();

          expect(readState(), isA<AuthUnauthenticated>());
        },
      );

      test(
        'transitions to AuthUnauthenticated when only refresh token exists',
        () async {
          when(() => mockStorage.readToken()).thenAnswer((_) async => null);
          when(
            () => mockStorage.readRefreshToken(),
          ).thenAnswer((_) async => 'refresh-only');

          await readNotifier().initialize();

          expect(readState(), isA<AuthUnauthenticated>());
        },
      );

      test('transitions to AuthError when storage throws', () async {
        when(
          () => mockStorage.readToken(),
        ).thenThrow(Exception('storage corrupt'));

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthError>());
        expect((s as AuthError).message, contains('storage corrupt'));
      });

      test('decodes userId from JWT sub claim', () async {
        final jwt = createTestJwt(
          sub: 'user-42',
          exp:
              DateTime.now()
                  .add(const Duration(hours: 1))
                  .millisecondsSinceEpoch ~/
              1000,
        );
        when(() => mockStorage.readToken()).thenAnswer((_) async => jwt);
        when(
          () => mockStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'refresh');

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        expect((s as AuthAuthenticated).userId, 'user-42');
      });

      test('decodes expiresAt from JWT exp claim', () async {
        final futureTime = DateTime.now().add(const Duration(hours: 2));
        final exp = futureTime.millisecondsSinceEpoch ~/ 1000;
        final jwt = createTestJwt(sub: 'user-1', exp: exp);
        when(() => mockStorage.readToken()).thenAnswer((_) async => jwt);
        when(
          () => mockStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'refresh');

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        final auth = s as AuthAuthenticated;
        // Should be within 2 seconds of the expected time
        final diff = auth.expiresAt.difference(futureTime).inSeconds.abs();
        expect(diff, lessThanOrEqualTo(2));
      });

      test('uses empty userId for malformed JWT', () async {
        when(
          () => mockStorage.readToken(),
        ).thenAnswer((_) async => 'not-a-jwt');
        when(
          () => mockStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'refresh');

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        expect((s as AuthAuthenticated).userId, '');
      });

      test('uses default expiry for JWT without exp claim', () async {
        final jwt = createTestJwt(sub: 'user-1');
        when(() => mockStorage.readToken()).thenAnswer((_) async => jwt);
        when(
          () => mockStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'refresh');

        await readNotifier().initialize();

        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        final auth = s as AuthAuthenticated;
        // Default expiry should be roughly 15 minutes from now
        final diff = auth.expiresAt.difference(DateTime.now()).inMinutes;
        expect(diff, closeTo(15, 1));
      });
    });

    group('setTokens', () {
      test('stores tokens and transitions to AuthAuthenticated', () async {
        await authenticateNotifier(
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
        final diff = auth.expiresAt.difference(DateTime.now()).inSeconds;
        expect(diff, closeTo(3600, 5));
      });
    });

    group('logout', () {
      test('clears storage and transitions to AuthUnauthenticated', () async {
        await authenticateNotifier(expiresInSecs: 300);
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});
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
        await authenticateNotifier(expiresInSecs: 600);
        expect(readNotifier().isAuthenticated, isTrue);
      });

      test('returns false after logout', () async {
        await authenticateNotifier(expiresInSecs: 600);
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});
        await readNotifier().logout();

        expect(readNotifier().isAuthenticated, isFalse);
      });
    });

    group('accessToken', () {
      test('returns null when unauthenticated', () {
        expect(readNotifier().accessToken, isNull);
      });

      test('returns token when authenticated', () async {
        await authenticateNotifier(accessToken: 'my-jwt', expiresInSecs: 600);
        expect(readNotifier().accessToken, 'my-jwt');
      });

      test('returns null after logout', () async {
        await authenticateNotifier(accessToken: 'my-jwt', expiresInSecs: 600);
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});
        await readNotifier().logout();

        expect(readNotifier().accessToken, isNull);
      });
    });

    group('isTokenExpiringSoon', () {
      test('returns false when unauthenticated', () {
        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });

      test('returns false when token has plenty of time remaining', () async {
        await authenticateNotifier(expiresInSecs: 3600); // 1 hour
        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });

      test('returns true when less than 2 minutes remaining', () async {
        await authenticateNotifier(expiresInSecs: 60); // 1 minute
        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true when token is already expired', () async {
        await authenticateNotifier(expiresInSecs: 0);
        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true at exactly 1 minute remaining', () async {
        // 119 seconds is less than 2 minutes (inMinutes truncates, so 119s = 1 minute)
        await authenticateNotifier(expiresInSecs: 119);
        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns false at exactly 2 minutes remaining', () async {
        // 120 seconds = 2 minutes exactly, inMinutes truncates so 120s = 2 min
        // The check is `< 2`, so 2 is NOT expiring soon
        await authenticateNotifier(expiresInSecs: 125); // small buffer
        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });
    });

    group('refreshTokens', () {
      late MockAuthServiceClient mockAuthClient;

      setUp(() {
        mockAuthClient = MockAuthServiceClient();
      });

      test('updates state with new tokens', () async {
        await authenticateNotifier(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
          userId: 'user-1',
        );

        when(() => mockAuthClient.refreshToken(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            RefreshTokenResponse(
              accessToken: 'new-access',
              refreshToken: 'new-refresh',
              expiresInSecs: Int64(7200),
            ),
          ),
        );

        final result = await readNotifier().refreshTokens(mockAuthClient);

        expect(result, isTrue);
        final s = readState();
        expect(s, isA<AuthAuthenticated>());
        final auth = s as AuthAuthenticated;
        expect(auth.accessToken, 'new-access');
        expect(auth.refreshToken, 'new-refresh');
      });

      test('stores new tokens to secure storage', () async {
        await authenticateNotifier(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
          userId: 'user-1',
        );

        when(() => mockAuthClient.refreshToken(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            RefreshTokenResponse(
              accessToken: 'new-access',
              refreshToken: 'new-refresh',
              expiresInSecs: Int64(7200),
            ),
          ),
        );

        await readNotifier().refreshTokens(mockAuthClient);

        verify(() => mockStorage.writeToken('new-access')).called(1);
        verify(() => mockStorage.writeRefreshToken('new-refresh')).called(1);
      });

      test('logs out on refresh failure', () async {
        await authenticateNotifier(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
          userId: 'user-1',
        );
        when(() => mockStorage.clearAll()).thenAnswer((_) async {});

        when(
          () => mockAuthClient.refreshToken(any()),
        ).thenThrow(GrpcError.unauthenticated('expired'));

        final result = await readNotifier().refreshTokens(mockAuthClient);

        expect(result, isFalse);
        expect(readState(), isA<AuthUnauthenticated>());
      });

      test('returns false when not authenticated', () async {
        final result = await readNotifier().refreshTokens(mockAuthClient);
        expect(result, isFalse);
        verifyNever(() => mockAuthClient.refreshToken(any()));
      });
    });
  });
}
