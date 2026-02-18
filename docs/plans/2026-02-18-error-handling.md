# Error Handling Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace raw gRPC error display with typed exceptions, human-readable messages, and a global connectivity banner.

**Architecture:** A new `ErrorMappingInterceptor` at the end of the gRPC interceptor chain catches `GrpcError` and rethrows as typed `AppException` subclasses. A global `ConnectivityBanner` widget wraps the app for persistent network/relay status. Per-feature code catches typed exceptions for context-appropriate UI responses.

**Tech Stack:** Dart sealed classes, gRPC `ClientInterceptor`, Riverpod `StreamProvider`, Flutter `AnimatedSize`/`AnimatedOpacity`.

---

## Task 1: Exception Hierarchy

**Files:**
- Create: `lib/core/grpc/app_exceptions.dart`
- Modify: `lib/core/grpc/grpc.dart` (add barrel export)
- Create: `test/core/grpc/app_exceptions_test.dart`

### Step 1: Write the failing test

```dart
// test/core/grpc/app_exceptions_test.dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException hierarchy', () {
    test('NetworkError carries message and cause', () {
      final cause = Exception('timeout');
      final error = NetworkError('No internet connection', cause: cause);

      expect(error.message, 'No internet connection');
      expect(error.cause, cause);
      expect(error.toString(), contains('No internet connection'));
    });

    test('SessionNotFoundError includes sessionId', () {
      final error = SessionNotFoundError(
        'Session no longer exists',
        sessionId: 'abc-123',
      );
      expect(error.sessionId, 'abc-123');
    });

    test('all exception types are AppException', () {
      expect(NetworkError('msg'), isA<AppException>());
      expect(RelayUnavailableError('msg'), isA<AppException>());
      expect(
        SessionNotFoundError('msg', sessionId: 's'),
        isA<AppException>(),
      );
      expect(SessionInvalidError('msg'), isA<AppException>());
      expect(AuthExpiredError('msg'), isA<AppException>());
      expect(PermissionDeniedError('msg'), isA<AppException>());
      expect(ServerError('msg'), isA<AppException>());
      expect(RateLimitError('msg'), isA<AppException>());
    });

    test('AppException is sealed — switch is exhaustive', () {
      // This test verifies the sealed class is exhaustive at compile time.
      // If a new subclass is added without updating this switch, it will
      // fail to compile.
      AppException error = NetworkError('test');
      final result = switch (error) {
        NetworkError() => 'network',
        RelayUnavailableError() => 'relay',
        SessionNotFoundError() => 'session_not_found',
        SessionInvalidError() => 'session_invalid',
        AuthExpiredError() => 'auth',
        PermissionDeniedError() => 'denied',
        ServerError() => 'server',
        RateLimitError() => 'rate_limit',
      };
      expect(result, 'network');
    });
  });
}
```

### Step 2: Run test to verify it fails

Run: `flutter test test/core/grpc/app_exceptions_test.dart`
Expected: FAIL — cannot resolve `app_exceptions.dart`

### Step 3: Write the exception hierarchy

```dart
// lib/core/grpc/app_exceptions.dart

/// Typed exception hierarchy for gRPC and network errors.
///
/// Each subclass carries a user-facing [message] and an optional [cause]
/// (typically the original [GrpcError]) for debug logging.
///
/// Sealed so `switch` expressions are exhaustive — the compiler enforces
/// that every UI error handler covers all cases.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// Human-readable message safe to display in the UI.
  final String message;

  /// The underlying error (typically [GrpcError]) for debug logging.
  final Object? cause;

  @override
  String toString() => message;
}

/// Device has no network, DNS failure, connection refused, or timeout.
class NetworkError extends AppException {
  const NetworkError(super.message, {super.cause});
}

/// gRPC channel to relay is down (TLS handshake failure, channel shutting
/// down, relay process not running).
class RelayUnavailableError extends AppException {
  const RelayUnavailableError(super.message, {super.cause});
}

/// The requested session does not exist (deleted or never created).
class SessionNotFoundError extends AppException {
  const SessionNotFoundError(super.message, {super.cause, required this.sessionId});

  /// The session ID that was not found.
  final String sessionId;
}

/// Session operation failed due to invalid arguments or precondition
/// violation (e.g. empty name, session in wrong state).
class SessionInvalidError extends AppException {
  const SessionInvalidError(super.message, {super.cause});
}

/// Authentication token expired or was revoked. Must re-login.
class AuthExpiredError extends AppException {
  const AuthExpiredError(super.message, {super.cause});
}

/// The authenticated user does not have permission for this operation.
class PermissionDeniedError extends AppException {
  const PermissionDeniedError(super.message, {super.cause});
}

/// Unexpected server-side error (INTERNAL, UNKNOWN, DATA_LOSS, etc.).
class ServerError extends AppException {
  const ServerError(super.message, {super.cause});
}

/// Too many requests — back off and retry.
class RateLimitError extends AppException {
  const RateLimitError(super.message, {super.cause});
}
```

### Step 4: Add barrel export

In `lib/core/grpc/grpc.dart`, add:
```dart
export 'app_exceptions.dart';
```

### Step 5: Run test to verify it passes

Run: `flutter test test/core/grpc/app_exceptions_test.dart`
Expected: PASS (all 4 tests)

### Step 6: Commit

```bash
git add lib/core/grpc/app_exceptions.dart lib/core/grpc/grpc.dart test/core/grpc/app_exceptions_test.dart
git commit -m "feat: add sealed AppException hierarchy for typed gRPC error handling"
```

---

## Task 2: Error Mapping Function

**Files:**
- Create: `lib/core/grpc/error_mapping.dart`
- Modify: `lib/core/grpc/grpc.dart` (add barrel export)
- Create: `test/core/grpc/error_mapping_test.dart`

### Step 1: Write the failing tests

```dart
// test/core/grpc/error_mapping_test.dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/error_mapping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

void main() {
  group('mapGrpcError', () {
    test('UNAVAILABLE with handshake error → RelayUnavailableError', () {
      final grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Error connecting: HandshakeException: WRONG_VERSION_NUMBER',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<RelayUnavailableError>());
      expect(result.cause, grpcError);
    });

    test('UNAVAILABLE with channel shutting down → RelayUnavailableError', () {
      final grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Channel shutting down.',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<RelayUnavailableError>());
    });

    test('UNAVAILABLE generic → NetworkError', () {
      final grpcError = GrpcError.custom(
        StatusCode.unavailable,
        'Connection timed out',
      );
      final result = mapGrpcError(grpcError);
      expect(result, isA<NetworkError>());
    });

    test('NOT_FOUND on session RPC → SessionNotFoundError', () {
      final grpcError = const GrpcError.notFound('session not found');
      final result = mapGrpcError(
        grpcError,
        method: '/betcode.v1.AgentService/DeleteSession',
      );
      expect(result, isA<SessionNotFoundError>());
    });

    test('NOT_FOUND on non-session RPC → ServerError', () {
      final grpcError = const GrpcError.notFound('machine not found');
      final result = mapGrpcError(
        grpcError,
        method: '/betcode.v1.MachineService/ListMachines',
      );
      expect(result, isA<ServerError>());
    });

    test('UNAUTHENTICATED → AuthExpiredError', () {
      final result = mapGrpcError(const GrpcError.unauthenticated());
      expect(result, isA<AuthExpiredError>());
    });

    test('PERMISSION_DENIED → PermissionDeniedError', () {
      final result = mapGrpcError(
        GrpcError.custom(StatusCode.permissionDenied, 'not owner'),
      );
      expect(result, isA<PermissionDeniedError>());
    });

    test('RESOURCE_EXHAUSTED → RateLimitError', () {
      final result = mapGrpcError(const GrpcError.resourceExhausted());
      expect(result, isA<RateLimitError>());
    });

    test('INVALID_ARGUMENT → SessionInvalidError', () {
      final result = mapGrpcError(
        GrpcError.custom(StatusCode.invalidArgument, 'name too long'),
      );
      expect(result, isA<SessionInvalidError>());
    });

    test('FAILED_PRECONDITION → SessionInvalidError', () {
      final result = mapGrpcError(
        GrpcError.custom(StatusCode.failedPrecondition, 'session locked'),
      );
      expect(result, isA<SessionInvalidError>());
    });

    test('INTERNAL → ServerError', () {
      final result = mapGrpcError(const GrpcError.internal());
      expect(result, isA<ServerError>());
    });

    test('DEADLINE_EXCEEDED → NetworkError', () {
      final result = mapGrpcError(const GrpcError.deadlineExceeded());
      expect(result, isA<NetworkError>());
    });

    test('UNKNOWN → ServerError', () {
      final result = mapGrpcError(
        GrpcError.custom(StatusCode.unknown, 'something broke'),
      );
      expect(result, isA<ServerError>());
    });

    test('preserves original GrpcError as cause', () {
      final grpcError = const GrpcError.internal('db crashed');
      final result = mapGrpcError(grpcError);
      expect(result.cause, grpcError);
    });
  });
}
```

### Step 2: Run test to verify it fails

Run: `flutter test test/core/grpc/error_mapping_test.dart`
Expected: FAIL — cannot resolve `error_mapping.dart`

### Step 3: Write the mapping function

```dart
// lib/core/grpc/error_mapping.dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:grpc/grpc.dart';

/// RPC method substrings that indicate session-related operations.
const _sessionMethods = [
  'Session',   // DeleteSession, RenameSession, CompactSession, ResumeSession
  'Converse',  // The bidi conversation stream
];

/// Maps a [GrpcError] to the appropriate [AppException] subclass.
///
/// The optional [method] parameter is the gRPC method path
/// (e.g. `/betcode.v1.AgentService/DeleteSession`) and is used to
/// distinguish session-specific NOT_FOUND from generic NOT_FOUND.
AppException mapGrpcError(GrpcError error, {String? method}) {
  return switch (error.code) {
    StatusCode.unavailable => _mapUnavailable(error),
    StatusCode.deadlineExceeded => NetworkError(
      'Request timed out. Check your connection and try again.',
      cause: error,
    ),
    StatusCode.notFound => _isSessionMethod(method)
        ? SessionNotFoundError(
            'Session no longer exists.',
            cause: error,
            sessionId: '',
          )
        : ServerError(
            'The requested resource was not found.',
            cause: error,
          ),
    StatusCode.unauthenticated => AuthExpiredError(
      'Your session has expired. Please log in again.',
      cause: error,
    ),
    StatusCode.permissionDenied => PermissionDeniedError(
      'You don\'t have permission for this action.',
      cause: error,
    ),
    StatusCode.resourceExhausted => RateLimitError(
      'Too many requests. Please wait a moment and try again.',
      cause: error,
    ),
    StatusCode.invalidArgument || StatusCode.failedPrecondition =>
      SessionInvalidError(
        error.message ?? 'Invalid request.',
        cause: error,
      ),
    _ => ServerError(
      'Something went wrong. Please try again.',
      cause: error,
    ),
  };
}

AppException _mapUnavailable(GrpcError error) {
  final msg = error.message ?? '';
  if (msg.contains('HandshakeException') ||
      msg.contains('WRONG_VERSION_NUMBER') ||
      msg.contains('Channel shutting down') ||
      msg.contains('TLS') ||
      msg.contains('CERTIFICATE')) {
    return RelayUnavailableError(
      'Unable to reach the relay server.',
      cause: error,
    );
  }
  return NetworkError(
    'Connection lost. Retrying...',
    cause: error,
  );
}

bool _isSessionMethod(String? method) {
  if (method == null) return false;
  return _sessionMethods.any(method.contains);
}
```

### Step 4: Add barrel export

In `lib/core/grpc/grpc.dart`, add:
```dart
export 'error_mapping.dart';
```

### Step 5: Run test to verify it passes

Run: `flutter test test/core/grpc/error_mapping_test.dart`
Expected: PASS (all 14 tests)

### Step 6: Commit

```bash
git add lib/core/grpc/error_mapping.dart lib/core/grpc/grpc.dart test/core/grpc/error_mapping_test.dart
git commit -m "feat: add mapGrpcError function mapping status codes to typed AppExceptions"
```

---

## Task 3: Error Mapping Interceptor

**Files:**
- Modify: `lib/core/grpc/interceptors.dart` (add `ErrorMappingInterceptor`)
- Modify: `lib/core/grpc/grpc_providers.dart:27-37` (add interceptor to chain)
- Create: `test/core/grpc/error_mapping_interceptor_test.dart`

### Step 1: Write the failing tests

```dart
// test/core/grpc/error_mapping_interceptor_test.dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

import '../../core/interceptor_test_helpers.dart';

void main() {
  group('ErrorMappingInterceptor', () {
    late ErrorMappingInterceptor interceptor;

    setUp(() {
      interceptor = ErrorMappingInterceptor();
    });

    test('passes through successful unary responses unchanged', () async {
      final response = interceptor.interceptUnary<String, String>(
        FakeClientMethod('/test/Ok'),
        'request',
        CallOptions(),
        (method, request, options) => MockResponseFuture.value('success'),
      );
      expect(await response, 'success');
    });

    test('maps GrpcError to AppException on unary failure', () async {
      final response = interceptor.interceptUnary<String, String>(
        FakeClientMethod('/betcode.v1.AgentService/DeleteSession'),
        'request',
        CallOptions(),
        (method, request, options) =>
            MockResponseFuture.error(const GrpcError.notFound()),
      );
      expect(
        () => response,
        throwsA(isA<SessionNotFoundError>()),
      );
    });

    test('maps UNAVAILABLE to NetworkError on unary', () async {
      final response = interceptor.interceptUnary<String, String>(
        FakeClientMethod('/test/Rpc'),
        'request',
        CallOptions(),
        (method, request, options) =>
            MockResponseFuture.error(const GrpcError.unavailable()),
      );
      expect(
        () => response,
        throwsA(isA<NetworkError>()),
      );
    });

    test('non-GrpcError passes through unmapped', () async {
      final response = interceptor.interceptUnary<String, String>(
        FakeClientMethod('/test/Rpc'),
        'request',
        CallOptions(),
        (method, request, options) =>
            MockResponseFuture.error(Exception('not grpc')),
      );
      expect(
        () => response,
        throwsA(isA<Exception>()),
      );
    });
  });
}
```

Note: this test depends on `test/core/interceptor_test_helpers.dart` which should already contain `FakeClientMethod` and `MockResponseFuture` helpers. Check the existing file and add any missing helpers. If `MockResponseFuture.error` doesn't exist, add it following the existing pattern.

### Step 2: Run test to verify it fails

Run: `flutter test test/core/grpc/error_mapping_interceptor_test.dart`
Expected: FAIL — `ErrorMappingInterceptor` not found

### Step 3: Add the interceptor class

Append to `lib/core/grpc/interceptors.dart`:

```dart
/// Maps [GrpcError] responses to typed [AppException] subclasses.
///
/// Must be the **last** interceptor in the chain so it wraps errors from
/// all preceding interceptors (auth refresh, logging, etc.).
class ErrorMappingInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final response = invoker(method, request, options);
    return response.catchError(
      (Object error) => throw mapGrpcError(error as GrpcError, method: method.path),
      test: (error) => error is GrpcError,
    ) as ResponseFuture<R>;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final stream = invoker(method, requests, options);
    return stream.handleError(
      (Object error) => throw mapGrpcError(error as GrpcError, method: method.path),
      test: (error) => error is GrpcError,
    ) as ResponseStream<R>;
  }
}
```

Add import at top of `interceptors.dart`:
```dart
import 'package:betcode_app/core/grpc/error_mapping.dart';
```

### Step 4: Wire into interceptor chain

In `lib/core/grpc/grpc_providers.dart:27-37`, add `ErrorMappingInterceptor()` as the **last** item in the interceptors list:

```dart
interceptors: [
  TokenRefreshInterceptor(
    authNotifier: authNotifier,
    authClientFactory: () => AuthServiceClient(manager.channel),
  ),
  AuthInterceptor(tokenProvider: () async => authNotifier.accessToken),
  MachineIdInterceptor(
    machineIdProvider: () async => ref.read(selectedMachineIdProvider),
  ),
  LoggingInterceptor(),
  ErrorMappingInterceptor(),  // <-- ADD: must be last
],
```

### Step 5: Run test to verify it passes

Run: `flutter test test/core/grpc/error_mapping_interceptor_test.dart`
Expected: PASS

Also run existing interceptor tests to verify no regressions:
Run: `flutter test test/core/grpc/interceptors_test.dart test/core/grpc/token_refresh_interceptor_test.dart`
Expected: PASS

### Step 6: Commit

```bash
git add lib/core/grpc/interceptors.dart lib/core/grpc/grpc_providers.dart test/core/grpc/error_mapping_interceptor_test.dart
git commit -m "feat: add ErrorMappingInterceptor to convert GrpcError into typed AppExceptions"
```

---

## Task 4: Global Connectivity Banner

**Files:**
- Create: `lib/shared/widgets/connectivity_banner.dart`
- Modify: `lib/shared/widgets/widgets.dart` (add barrel export, if exists)
- Modify: `lib/app.dart:11-22` (wrap MaterialApp.router)
- Create: `test/shared/widgets/connectivity_banner_test.dart`

### Step 1: Write the failing test

```dart
// test/shared/widgets/connectivity_banner_test.dart
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/shared/widgets/connectivity_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityBanner', () {
    Widget buildApp({
      AsyncValue<GrpcConnectionStatus> connectionStatus =
          const AsyncData(GrpcConnectionStatus.connected),
      AsyncValue<NetworkStatus> networkStatus =
          const AsyncData(NetworkStatus.online),
    }) {
      return ProviderScope(
        overrides: [
          connectionStatusProvider.overrideWith((_) => connectionStatus.when(
                data: (d) => Stream.value(d),
                loading: () => const Stream.empty(),
                error: (e, s) => Stream.error(e, s),
              )),
          networkStatusProvider.overrideWith((_) => networkStatus.when(
                data: (d) => Stream.value(d),
                loading: () => const Stream.empty(),
                error: (e, s) => Stream.error(e, s),
              )),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ConnectivityBanner(),
                Expanded(child: Placeholder()),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('hidden when online and connected', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('No internet connection'), findsNothing);
      expect(find.text('Relay unreachable'), findsNothing);
    });

    testWidgets('shows offline banner when network is offline', (tester) async {
      await tester.pumpWidget(buildApp(
        networkStatus: const AsyncData(NetworkStatus.offline),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet'), findsOneWidget);
    });

    testWidgets('shows relay banner when disconnected but online',
        (tester) async {
      await tester.pumpWidget(buildApp(
        connectionStatus:
            const AsyncData(GrpcConnectionStatus.reconnecting),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('reconnecting'), findsOneWidget);
    });
  });
}
```

### Step 2: Run test to verify it fails

Run: `flutter test test/shared/widgets/connectivity_banner_test.dart`
Expected: FAIL — cannot resolve `connectivity_banner.dart`

### Step 3: Write the banner widget

```dart
// lib/shared/widgets/connectivity_banner.dart
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A persistent banner shown at the top of the app when there are
/// connectivity issues.
///
/// Watches [networkStatusProvider] and [connectionStatusProvider] to
/// determine what to display. Hidden (zero height) when everything is fine.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAsync = ref.watch(networkStatusProvider);
    final connectionAsync = ref.watch(connectionStatusProvider);

    final isOffline =
        networkAsync.valueOrNull == NetworkStatus.offline;
    final connectionStatus = connectionAsync.valueOrNull;
    final isRelayDown = !isOffline &&
        (connectionStatus == GrpcConnectionStatus.disconnected ||
            connectionStatus == GrpcConnectionStatus.reconnecting);

    final String? message;
    final Color? backgroundColor;
    final IconData? icon;

    if (isOffline) {
      message = 'No internet connection';
      backgroundColor = Theme.of(context).colorScheme.error;
      icon = Icons.wifi_off;
    } else if (isRelayDown) {
      message = connectionStatus == GrpcConnectionStatus.reconnecting
          ? 'Relay unreachable — reconnecting...'
          : 'Relay unreachable';
      backgroundColor = Theme.of(context).colorScheme.tertiary;
      icon = Icons.cloud_off;
    } else {
      message = null;
      backgroundColor = null;
      icon = null;
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: message != null
          ? MaterialBanner(
              content: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: backgroundColor,
              actions: const [SizedBox.shrink()],
            )
          : const SizedBox.shrink(),
    );
  }
}
```

### Step 4: Wrap `MaterialApp.router` in `app.dart`

Replace `lib/app.dart:11-22` build method:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.watch(relayAutoReconnectProvider);
  final router = ref.watch(routerProvider);

  return Column(
    children: [
      const ConnectivityBanner(),
      Expanded(
        child: MaterialApp.router(
          title: 'BetCode',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: router,
        ),
      ),
    ],
  );
}
```

Add import:
```dart
import 'package:betcode_app/shared/widgets/connectivity_banner.dart';
```

### Step 5: Run test to verify it passes

Run: `flutter test test/shared/widgets/connectivity_banner_test.dart`
Expected: PASS

### Step 6: Commit

```bash
git add lib/shared/widgets/connectivity_banner.dart lib/app.dart test/shared/widgets/connectivity_banner_test.dart
git commit -m "feat: add global ConnectivityBanner for persistent network/relay status"
```

---

## Task 5: Update Conversation Notifier Error Handling

**Files:**
- Modify: `lib/features/conversation/notifiers/conversation_notifier.dart`
  - `_isFatalError()` (lines 326-333)
  - `_handleStreamError()` (lines 290-324)
  - `startConversation()` (lines 141-143)
- Modify: `test/features/conversation/notifiers/conversation_notifier_test.dart` (add new test cases)

### Step 1: Write the failing tests

Add to `test/features/conversation/notifiers/conversation_notifier_test.dart` in an appropriate test group:

```dart
group('typed error handling', () {
  test('SessionNotFoundError transitions to error with sessionExpired', () async {
    // Setup: start a conversation, then simulate stream error with NOT_FOUND
    // The conversation state should transition to ConversationState.error()
    // and the error message should be human-readable.
  });

  test('NetworkError triggers reconnection, not fatal', () async {
    // Setup: start conversation, simulate NetworkError on stream
    // Should attempt reconnection, not go to error state.
  });

  test('AuthExpiredError is fatal, no reconnect', () async {
    // Setup: start conversation, simulate AuthExpiredError
    // Should go directly to error state, no reconnect attempt.
  });

  test('history load failure sets errorMessage on active state', () async {
    // Setup: start conversation with sessionId, mock resumeSession to throw
    // Conversation should be ConversationActive with
    // errorMessage = "Couldn't load message history"
  });
});
```

Note: follow the existing test patterns in `conversation_notifier_test.dart` and `conversation_notifier_helpers.dart` for mocking. These are skeleton tests — fill in based on the existing mock setup.

### Step 2: Run tests to verify they fail

Run: `flutter test test/features/conversation/notifiers/conversation_notifier_test.dart`
Expected: New tests FAIL

### Step 3: Update `_isFatalError` to use typed exceptions

Replace `_isFatalError` (lines 326-333):

```dart
bool _isFatalError(Object error) {
  return error is AuthExpiredError ||
      error is PermissionDeniedError ||
      error is SessionNotFoundError;
}
```

Add import:
```dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
```

### Step 4: Update `_handleStreamError` to use human-readable messages

In `_handleStreamError` (lines 290-324), replace the raw error string in `ConversationState.error(...)`:

```dart
void _handleStreamError(Object error) {
  debugPrint('[Conversation] Stream error: $error');
  unawaited(_eventSubscription?.cancel());
  _eventSubscription = null;

  if (_isFatalError(error)) {
    _isReconnecting = false;
    final message = error is AppException
        ? error.message
        : 'Stream error: $error';
    state = AsyncData(ConversationState.error(message));
    unawaited(_requestController?.close());
    _requestController = null;
    return;
  }

  // ... rest of reconnection logic stays the same, but update error messages:
  // Replace 'Stream error: $error' with human-readable message from AppException
}
```

### Step 5: Update `_loadHistory` to set `errorMessage`

Replace the catch block in `_loadHistory` (lines 171-174):

```dart
} on GrpcError catch (e) {
  debugPrint('[Conversation] History load failed: $e');
  final current = state.value;
  if (current is ConversationActive) {
    state = AsyncData(
      current.copyWith(
        errorMessage: "Couldn't load message history.",
      ),
    );
  }
}
```

### Step 6: Update `startConversation` catch block

Replace the catch block in `startConversation` (lines 141-143):

```dart
} on Exception catch (e) {
  final message = e is AppException ? e.message : 'Failed to start conversation: $e';
  state = AsyncData(ConversationState.error(message));
}
```

### Step 7: Run tests to verify they pass

Run: `flutter test test/features/conversation/notifiers/conversation_notifier_test.dart`
Expected: PASS (all tests including new ones)

### Step 8: Commit

```bash
git add lib/features/conversation/notifiers/conversation_notifier.dart test/features/conversation/notifiers/conversation_notifier_test.dart
git commit -m "feat: conversation notifier uses typed AppExceptions for error handling"
```

---

## Task 6: Update Sessions Screen Error Display

**Files:**
- Modify: `lib/features/sessions/screens/sessions_screen.dart:56-78`
- Modify: `lib/shared/widgets/error_display.dart:41-47`

### Step 1: Update SnackBar error messages in sessions screen

Replace `_onRename` catch block (lines 56-61):

```dart
} on AppException catch (e) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
} on Exception catch (e) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Rename failed: $e')),
  );
}
```

Replace `_onDelete` catch block (lines 73-78):

```dart
} on SessionNotFoundError catch (_) {
  // Session already gone — just refresh the list.
  ref.read(sessionsProvider.notifier).refresh();
} on AppException catch (e) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
} on Exception catch (e) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Delete failed: $e')),
  );
}
```

Add import:
```dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
```

### Step 2: Update `ErrorDisplay` to use `AppException.message`

In `lib/shared/widgets/error_display.dart:41-47`, replace:

```dart
Text(
  error.toString(),
```

with:

```dart
Text(
  error is AppException ? error.message : error.toString(),
```

Add import:
```dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
```

### Step 3: Run all tests

Run: `flutter test`
Expected: PASS — no regressions

### Step 4: Commit

```bash
git add lib/features/sessions/screens/sessions_screen.dart lib/shared/widgets/error_display.dart
git commit -m "feat: sessions screen and ErrorDisplay show human-readable AppException messages"
```

---

## Task 7: Update Auth Notifier Error Handling

**Files:**
- Modify: `lib/core/auth/auth_notifier.dart:114-120`

### Step 1: Update `_isAuthError` to use typed exceptions

Replace `_isAuthError` (lines 114-120):

```dart
static bool _isAuthError(Object error) {
  return error is AuthExpiredError || error is PermissionDeniedError;
}
```

This is a simplification — the `ErrorMappingInterceptor` now converts `GrpcError` with `unauthenticated`/`permissionDenied` codes into these typed exceptions before they reach the auth notifier.

However, we must also keep the old `GrpcError` check as a fallback since `_isAuthError` may be called from code paths where the interceptor hasn't run (e.g. direct `GrpcError` from health check or token refresh):

```dart
static bool _isAuthError(Object error) {
  if (error is AuthExpiredError || error is PermissionDeniedError) {
    return true;
  }
  if (error is GrpcError) {
    return error.code == StatusCode.unauthenticated ||
        error.code == StatusCode.permissionDenied;
  }
  return false;
}
```

Add import:
```dart
import 'package:betcode_app/core/grpc/app_exceptions.dart';
```

### Step 2: Run auth tests

Run: `flutter test test/core/auth/`
Expected: PASS

### Step 3: Commit

```bash
git add lib/core/auth/auth_notifier.dart
git commit -m "feat: auth notifier recognizes typed AppExceptions for auth error detection"
```

---

## Task 8: Final Integration Test

**Files:**
- No new files — verification only

### Step 1: Run `dart analyze`

Run: `dart analyze lib/ test/`
Expected: Zero issues

### Step 2: Run full test suite

Run: `flutter test`
Expected: All tests pass

### Step 3: Check lint

Run: `dart format --set-exit-if-changed lib/ test/`
Expected: No formatting changes needed (or fix any issues)

### Step 4: Manual testing checklist

On a device or emulator, verify:
- [ ] Kill the relay → orange "Relay unreachable" banner appears, app does NOT logout
- [ ] Turn on airplane mode → red "No internet" banner appears
- [ ] Restore network → banner disappears smoothly
- [ ] Open a deleted session via deep link → redirects to sessions list with "Session no longer exists" toast
- [ ] Rename with empty name → SnackBar shows human message, not raw GrpcError
- [ ] Normal operations (list sessions, start conversation, send message) work unchanged

### Step 5: Final commit (if any fixups needed)

```bash
git add -A
git commit -m "fix: integration fixups for error handling"
```
