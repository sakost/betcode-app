import 'dart:async';
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

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class MockResponseFuture<T> extends Fake implements ResponseFuture<T> {
  MockResponseFuture.value(T v) : _f = Future.value(v);
  MockResponseFuture.error(Object e) : _f = Future.error(e);
  final Future<T> _f;

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      _f.then(onValue, onError: onError);
  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      _f.catchError(onError, test: test);
  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _f.whenComplete(action);
  @override
  Stream<T> asStream() => _f.asStream();
  @override
  Future<T> timeout(Duration t, {FutureOr<T> Function()? onTimeout}) =>
      _f.timeout(t, onTimeout: onTimeout);
  @override
  Future<void> cancel() async {}
  @override
  bool get isCancelled => false;
}

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
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

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
        final diff = auth.expiresAt.difference(DateTime.now()).inSeconds;
        expect(diff, closeTo(3600, 5));
      });
    });

    group('logout', () {
      test('clears storage and transitions to AuthUnauthenticated', () async {
        // First authenticate
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});
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
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );

        expect(readNotifier().isAuthenticated, isTrue);
      });

      test('returns false after logout', () async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});
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
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'my-jwt',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 600,
        );

        expect(readNotifier().accessToken, 'my-jwt');
      });

      test('returns null after logout', () async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});
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
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 3600, // 1 hour
        );

        expect(readNotifier().isTokenExpiringSoon, isFalse);
      });

      test('returns true when less than 2 minutes remaining', () async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 60, // 1 minute - less than 2 min threshold
        );

        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true when token is already expired', () async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

        await readNotifier().setTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'uid',
          expiresInSecs: 0, // expires now
        );

        expect(readNotifier().isTokenExpiringSoon, isTrue);
      });

      test('returns true at exactly 1 minute remaining', () async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

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
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});

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

    group('refreshTokens', () {
      late MockAuthServiceClient mockAuthClient;

      setUp(() {
        mockAuthClient = MockAuthServiceClient();
      });

      Future<void> authenticateNotifier() async {
        when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.writeRefreshToken(any()),
        ).thenAnswer((_) async {});
        await readNotifier().setTokens(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
          userId: 'user-1',
          expiresInSecs: 3600,
        );
      }

      test('updates state with new tokens', () async {
        await authenticateNotifier();

        when(() => mockAuthClient.refreshToken(any())).thenAnswer(
          (_) => MockResponseFuture.value(
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
        await authenticateNotifier();

        when(() => mockAuthClient.refreshToken(any())).thenAnswer(
          (_) => MockResponseFuture.value(
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
        await authenticateNotifier();
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
