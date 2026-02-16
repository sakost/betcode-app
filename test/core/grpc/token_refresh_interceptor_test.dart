import 'dart:async';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fake_response_future.dart';
import '../interceptor_test_helpers.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

void main() {
  late MockSecureStorageService mockStorage;
  late ProviderContainer container;
  late MockAuthServiceClient mockAuthClient;
  late TokenRefreshInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RefreshTokenRequest());
  });

  setUp(() {
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
    );
    mockAuthClient = MockAuthServiceClient();
  });

  tearDown(() {
    container.dispose();
  });

  AuthNotifier readNotifier() => container.read(authNotifierProvider.notifier);

  Future<void> authenticateWithExpiry(int expiresInSecs) async {
    when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
    when(() => mockStorage.writeRefreshToken(any())).thenAnswer((_) async {});
    await readNotifier().setTokens(
      accessToken: 'access-tok',
      refreshToken: 'refresh-tok',
      userId: 'user-1',
      expiresInSecs: expiresInSecs,
    );
  }

  group('TokenRefreshInterceptor', () {
    /// Stubs a successful refresh response on [mockAuthClient].
    void stubRefreshSuccess() {
      when(() => mockAuthClient.refreshToken(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          RefreshTokenResponse(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
            expiresInSecs: Int64(7200),
          ),
        ),
      );
    }

    /// Creates the interceptor and fires a single interceptUnary call,
    /// resolves metadata, and returns whether the invoker was called.
    Future<bool> interceptAndResolve({
      AuthServiceClient Function()? clientFactory,
    }) async {
      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: clientFactory ?? () => mockAuthClient,
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod(),
          'req',
          CallOptions(),
          (m, r, o) {
            invokerCalled = true;
            capturedOptions = o;
            return FakeResponseFuture.value('ok');
          },
        ),
      );
      await resolveMetadata(capturedOptions);
      return invokerCalled;
    }

    test('passes through when token is not expiring soon', () async {
      await authenticateWithExpiry(3600); // 1 hour - plenty of time

      var refreshCalled = false;
      final invoked = await interceptAndResolve(
        clientFactory: () {
          refreshCalled = true;
          return mockAuthClient;
        },
      );

      expect(refreshCalled, isFalse);
      expect(invoked, isTrue);
    });

    test('refreshes token before RPC when expiring soon', () async {
      await authenticateWithExpiry(30); // 30 seconds - expiring soon
      stubRefreshSuccess();

      final invoked = await interceptAndResolve();

      verify(() => mockAuthClient.refreshToken(any())).called(1);
      expect(invoked, isTrue);
    });

    test('prevents concurrent refreshes for parallel RPCs', () async {
      await authenticateWithExpiry(30); // expiring soon

      var refreshCallCount = 0;
      when(() => mockAuthClient.refreshToken(any())).thenAnswer((_) {
        refreshCallCount++;
        return FakeResponseFuture.value(
          RefreshTokenResponse(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
            expiresInSecs: Int64(7200),
          ),
        );
      });

      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () => mockAuthClient,
      );

      // Fire two RPCs concurrently
      late CallOptions opts1;
      late CallOptions opts2;
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod(),
          'req1',
          CallOptions(),
          (m, r, o) {
            opts1 = o;
            return FakeResponseFuture.value('ok1');
          },
        ),
      );
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod(),
          'req2',
          CallOptions(),
          (m, r, o) {
            opts2 = o;
            return FakeResponseFuture.value('ok2');
          },
        ),
      );

      await Future.wait([resolveMetadata(opts1), resolveMetadata(opts2)]);
      expect(refreshCallCount, 1);
    });

    test('proceeds with current token if refresh fails', () async {
      await authenticateWithExpiry(30); // expiring soon
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});
      when(
        () => mockAuthClient.refreshToken(any()),
      ).thenThrow(const GrpcError.internal('refresh failed'));

      final invoked = await interceptAndResolve();
      expect(invoked, isTrue);
    });

    test('refreshes token before streaming RPC when expiring soon', () async {
      await authenticateWithExpiry(30); // expiring soon
      stubRefreshSuccess();

      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () => mockAuthClient,
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      interceptor.interceptStreaming<String, String>(
        testMethod(),
        const Stream.empty(),
        CallOptions(),
        (m, r, o) {
          invokerCalled = true;
          capturedOptions = o;
          return FakeInterceptorResponseStream(const Stream.empty());
        },
      );
      await resolveMetadata(capturedOptions);

      verify(() => mockAuthClient.refreshToken(any())).called(1);
      expect(invokerCalled, isTrue);
    });
  });
}
