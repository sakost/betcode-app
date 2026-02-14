import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '../../generated/betcode/v1/auth.pbgrpc.dart';
import '../auth/auth_notifier.dart';

/// A function that returns the current JWT token, or null if unauthenticated.
typedef TokenProvider = Future<String?> Function();

/// A function that returns the currently selected machine ID, or null.
typedef MachineIdProvider = Future<String?> Function();

/// Injects a JWT bearer token into every outgoing gRPC call's metadata.
///
/// The token is fetched lazily via [tokenProvider] so it always reflects
/// the latest value (e.g. after a refresh). If the provider returns null
/// the authorization header is omitted and the call proceeds unauthenticated.
class AuthInterceptor extends ClientInterceptor {
  AuthInterceptor({required this.tokenProvider});

  final TokenProvider tokenProvider;

  static const _authHeader = 'authorization';

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(method, request, _withAuth(options));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(method, requests, _withAuth(options));
  }

  CallOptions _withAuth(CallOptions options) {
    return options.mergedWith(
      CallOptions(
        providers: [
          (metadata, uri) async {
            final token = await tokenProvider();
            if (token != null) {
              metadata[_authHeader] = 'Bearer $token';
            }
          },
        ],
      ),
    );
  }
}

/// Injects the `x-machine-id` header into every outgoing gRPC call's metadata.
///
/// The machine ID is fetched lazily via [machineIdProvider] so it always
/// reflects the latest selection. If the provider returns null the header is
/// omitted.
class MachineIdInterceptor extends ClientInterceptor {
  MachineIdInterceptor({required this.machineIdProvider});

  final MachineIdProvider machineIdProvider;

  static const _machineIdHeader = 'x-machine-id';

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(method, request, _withMachineId(options));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(method, requests, _withMachineId(options));
  }

  CallOptions _withMachineId(CallOptions options) {
    return options.mergedWith(
      CallOptions(
        providers: [
          (metadata, uri) async {
            final machineId = await machineIdProvider();
            if (machineId != null) {
              metadata[_machineIdHeader] = machineId;
            }
          },
        ],
      ),
    );
  }
}

/// Logs every gRPC method invocation for debugging purposes.
///
/// Uses [debugPrint] so entries appear in both Flutter DevTools and Android
/// logcat (as `I/flutter` tag). Logs the method path on request and the
/// outcome (success or error) on response.
class LoggingInterceptor extends ClientInterceptor {
  static const _tag = '[gRPC]';

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final stopwatch = Stopwatch()..start();
    debugPrint('$_tag -> ${method.path}');

    final response = invoker(method, request, options);

    response.then(
      (_) {
        stopwatch.stop();
        debugPrint(
          '$_tag <- ${method.path} OK (${stopwatch.elapsedMilliseconds}ms)',
        );
      },
      onError: (Object error) {
        stopwatch.stop();
        debugPrint(
          '$_tag <- ${method.path} ERROR (${stopwatch.elapsedMilliseconds}ms): $error',
        );
      },
    );

    return response;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    debugPrint('$_tag -> ${method.path} (stream)');
    return invoker(method, requests, options);
  }
}

/// Checks token expiry before each RPC and triggers a refresh if needed.
///
/// Uses a [Completer] to coalesce concurrent refresh attempts so only one
/// refresh RPC is in flight at a time.
class TokenRefreshInterceptor extends ClientInterceptor {
  TokenRefreshInterceptor({
    required this.authNotifier,
    required this.authClientFactory,
  });

  final AuthNotifier authNotifier;
  final AuthServiceClient Function() authClientFactory;
  Completer<void>? _refreshing;

  Future<void> _ensureValidToken() async {
    if (!authNotifier.isTokenExpiringSoon) return;
    if (_refreshing != null) {
      await _refreshing!.future;
      return;
    }
    _refreshing = Completer<void>();
    try {
      await authNotifier.refreshTokens(authClientFactory());
      _refreshing!.complete();
    } on Exception catch (e) {
      _refreshing!.completeError(e);
      rethrow;
    } finally {
      _refreshing = null;
    }
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // Kick off the refresh check, then delegate to the invoker.
    // We schedule via metadata provider so the refresh completes before
    // the call actually goes out.
    final opts = options.mergedWith(
      CallOptions(
        providers: [
          (metadata, uri) async {
            await _ensureValidToken();
          },
        ],
      ),
    );
    return invoker(method, request, opts);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final opts = options.mergedWith(
      CallOptions(
        providers: [
          (metadata, uri) async {
            await _ensureValidToken();
          },
        ],
      ),
    );
    return invoker(method, requests, opts);
  }
}
