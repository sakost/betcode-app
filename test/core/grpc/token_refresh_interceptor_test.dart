import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';

import '../../helpers/fake_response_future.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class FakeResponseStream<T> extends Fake implements ResponseStream<T> {
  FakeResponseStream(this._s);
  final Stream<T> _s;

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => _s.listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
}

ClientMethod<String, String> _method([String path = '/test/M']) =>
    ClientMethod<String, String>(
      path,
      (s) => s.codeUnits,
      (b) => String.fromCharCodes(b),
    );

/// Resolves all metadata providers on a [CallOptions], simulating what the
/// real gRPC transport does before sending the request.
Future<void> _resolveMetadata(CallOptions options) async {
  final md = Map<String, String>.of(options.metadata);
  for (final p in options.metadataProviders) {
    await p(md, '');
  }
}

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
    test('passes through when token is not expiring soon', () async {
      await authenticateWithExpiry(3600); // 1 hour - plenty of time

      var refreshCalled = false;
      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () {
          refreshCalled = true;
          return mockAuthClient;
        },
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      interceptor.interceptUnary<String, String>(
        _method(),
        'req',
        CallOptions(),
        (m, r, o) {
          invokerCalled = true;
          capturedOptions = o;
          return FakeResponseFuture.value('ok');
        },
      );

      // Resolve metadata providers (simulates real gRPC transport)
      await _resolveMetadata(capturedOptions);

      expect(refreshCalled, isFalse);
      expect(invokerCalled, isTrue);
    });

    test('refreshes token before RPC when expiring soon', () async {
      await authenticateWithExpiry(30); // 30 seconds - expiring soon

      when(() => mockAuthClient.refreshToken(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          RefreshTokenResponse(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
            expiresInSecs: Int64(7200),
          ),
        ),
      );

      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () => mockAuthClient,
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      interceptor.interceptUnary<String, String>(
        _method(),
        'req',
        CallOptions(),
        (m, r, o) {
          invokerCalled = true;
          capturedOptions = o;
          return FakeResponseFuture.value('ok');
        },
      );

      // Resolve metadata providers to trigger the refresh
      await _resolveMetadata(capturedOptions);

      verify(() => mockAuthClient.refreshToken(any())).called(1);
      expect(invokerCalled, isTrue);
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
      late CallOptions opts1, opts2;
      interceptor.interceptUnary<String, String>(
        _method(),
        'req1',
        CallOptions(),
        (m, r, o) {
          opts1 = o;
          return FakeResponseFuture.value('ok1');
        },
      );
      interceptor.interceptUnary<String, String>(
        _method(),
        'req2',
        CallOptions(),
        (m, r, o) {
          opts2 = o;
          return FakeResponseFuture.value('ok2');
        },
      );

      // Resolve both metadata providers concurrently
      await Future.wait([_resolveMetadata(opts1), _resolveMetadata(opts2)]);

      // Refresh should only be called once despite two concurrent RPCs
      expect(refreshCallCount, 1);
    });

    test('proceeds with current token if refresh fails', () async {
      await authenticateWithExpiry(30); // expiring soon
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      when(
        () => mockAuthClient.refreshToken(any()),
      ).thenThrow(GrpcError.internal('refresh failed'));

      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () => mockAuthClient,
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      interceptor.interceptUnary<String, String>(
        _method(),
        'req',
        CallOptions(),
        (m, r, o) {
          invokerCalled = true;
          capturedOptions = o;
          return FakeResponseFuture.value('ok');
        },
      );

      // Resolve metadata providers to trigger the refresh attempt
      await _resolveMetadata(capturedOptions);

      // Invoker should still have been called even though refresh failed
      expect(invokerCalled, isTrue);
    });

    test('refreshes token before streaming RPC when expiring soon', () async {
      await authenticateWithExpiry(30); // expiring soon

      when(() => mockAuthClient.refreshToken(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          RefreshTokenResponse(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
            expiresInSecs: Int64(7200),
          ),
        ),
      );

      interceptor = TokenRefreshInterceptor(
        authNotifier: readNotifier(),
        authClientFactory: () => mockAuthClient,
      );

      var invokerCalled = false;
      late CallOptions capturedOptions;
      interceptor.interceptStreaming<String, String>(
        _method(),
        const Stream.empty(),
        CallOptions(),
        (m, r, o) {
          invokerCalled = true;
          capturedOptions = o;
          return FakeResponseStream(const Stream.empty());
        },
      );

      // Resolve metadata providers to trigger the refresh
      await _resolveMetadata(capturedOptions);

      verify(() => mockAuthClient.refreshToken(any())).called(1);
      expect(invokerCalled, isTrue);
    });
  });
}
