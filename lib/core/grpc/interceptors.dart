import 'dart:developer' as developer;

import 'package:grpc/grpc.dart';

/// A function that returns the current JWT token, or null if unauthenticated.
typedef TokenProvider = Future<String?> Function();

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

/// Logs every gRPC method invocation for debugging purposes.
///
/// Emits entries via [developer.log] under the name `gRPC` so they appear
/// in DevTools and can be filtered easily. Logs the method path on request
/// and the outcome (success or error) on response.
class LoggingInterceptor extends ClientInterceptor {
  static const _logName = 'gRPC';

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final stopwatch = Stopwatch()..start();
    developer.log('-> ${method.path}', name: _logName);

    final response = invoker(method, request, options);

    response.then(
      (_) {
        stopwatch.stop();
        developer.log(
          '<- ${method.path} OK (${stopwatch.elapsedMilliseconds}ms)',
          name: _logName,
        );
      },
      onError: (Object error) {
        stopwatch.stop();
        developer.log(
          '<- ${method.path} ERROR (${stopwatch.elapsedMilliseconds}ms): $error',
          name: _logName,
          level: 900,
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
    developer.log('-> ${method.path} (stream)', name: _logName);
    return invoker(method, requests, options);
  }
}
