import 'dart:async';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/error_mapping.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

/// A function that returns the current JWT token, or null if unauthenticated.
typedef TokenProvider = Future<String?> Function();

/// A function that returns the currently selected machine ID, or null.
typedef MachineIdProvider = Future<String?> Function();

/// Base class for interceptors that inject a single header into
/// every gRPC call.
abstract class HeaderInterceptor extends ClientInterceptor {
  /// Returns the [CallOptions] with the header added.
  CallOptions _addHeader(CallOptions options);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(method, request, _addHeader(options));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(method, requests, _addHeader(options));
  }
}

/// Injects a JWT bearer token into every outgoing gRPC call's metadata.
///
/// The token is fetched lazily via [tokenProvider] so it always reflects
/// the latest value (e.g. after a refresh). If the provider returns null
/// the authorization header is omitted and the call proceeds unauthenticated.
class AuthInterceptor extends HeaderInterceptor {
  /// Creates an [AuthInterceptor] that reads tokens from [tokenProvider].
  AuthInterceptor({required this.tokenProvider});

  /// Callback that supplies the current JWT, or null if unauthenticated.
  final TokenProvider tokenProvider;

  static const _authHeader = 'authorization';

  @override
  CallOptions _addHeader(CallOptions options) {
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
class MachineIdInterceptor extends HeaderInterceptor {
  /// Creates a [MachineIdInterceptor] that reads the machine ID from
  /// [machineIdProvider].
  MachineIdInterceptor({required this.machineIdProvider});

  /// Callback that supplies the currently selected machine ID, or null.
  final MachineIdProvider machineIdProvider;

  static const _machineIdHeader = 'x-machine-id';

  @override
  CallOptions _addHeader(CallOptions options) {
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

    unawaited(
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
            '$_tag <- ${method.path} ERROR '
            '(${stopwatch.elapsedMilliseconds}ms): '
            '$error',
          );
        },
      ),
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
    final stopwatch = Stopwatch()..start();
    debugPrint('$_tag -> ${method.path} (stream)');
    return _LoggingResponseStream(
      invoker(method, requests, options),
      method.path,
      stopwatch,
    );
  }
}

/// Base class that delegates [ResponseStream] members (`single`, `headers`,
/// `trailers`, `cancel`) to an inner [_delegate].
///
/// Subclasses only need to override [listen] to add their own behaviour.
abstract class _ResponseStreamWrapper<R> extends StreamView<R>
    implements ResponseStream<R> {
  _ResponseStreamWrapper(this._delegate) : super(_delegate);

  final ResponseStream<R> _delegate;

  @override
  ResponseFuture<R> get single => _delegate.single;

  @override
  Future<Map<String, String>> get headers => _delegate.headers;

  @override
  Future<Map<String, String>> get trailers => _delegate.trailers;

  @override
  Future<void> cancel() => _delegate.cancel();
}

/// Dispatches an error to an [onError] callback whose exact arity is unknown.
///
/// Both [_LoggingResponseStream] and [_ErrorMappingResponseStream] need to
/// relay errors through a caller-supplied [Function?] that may accept one
/// argument `(Object)` or two `(Object, StackTrace)`. This helper
/// consolidates that three-way type check.
void _dispatchError(Function? onError, Object error, StackTrace stackTrace) {
  if (onError != null) {
    if (onError is void Function(Object, StackTrace)) {
      onError(error, stackTrace);
    } else if (onError is void Function(Object)) {
      onError(error);
    } else {
      (onError as dynamic)(error, stackTrace);
    }
  } else {
    Error.throwWithStackTrace(error, stackTrace);
  }
}

/// Wraps a [ResponseStream] to log errors and completion.
class _LoggingResponseStream<R> extends _ResponseStreamWrapper<R> {
  _LoggingResponseStream(super._delegate, this._method, this._stopwatch);

  final String _method;
  final Stopwatch _stopwatch;

  @override
  StreamSubscription<R> listen(
    void Function(R)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return super.listen(
      onData,
      onError: (Object error, StackTrace stackTrace) {
        _stopwatch.stop();
        debugPrint(
          '[gRPC] <- $_method stream ERROR '
          '(${_stopwatch.elapsedMilliseconds}ms): $error',
        );
        _dispatchError(onError, error, stackTrace);
      },
      onDone: () {
        _stopwatch.stop();
        debugPrint(
          '[gRPC] <- $_method stream DONE '
          '(${_stopwatch.elapsedMilliseconds}ms)',
        );
        onDone?.call();
      },
      cancelOnError: cancelOnError,
    );
  }
}

/// Checks token expiry before each RPC and triggers a refresh if needed.
///
/// Uses a [Completer] to coalesce concurrent refresh attempts so only one
/// refresh RPC is in flight at a time.
class TokenRefreshInterceptor extends ClientInterceptor {
  /// Creates a [TokenRefreshInterceptor] with the given [authNotifier] and
  /// a factory that creates an [AuthServiceClient] for the refresh RPC.
  TokenRefreshInterceptor({
    required this.authNotifier,
    required this.authClientFactory,
  });

  /// The notifier used to check expiry and perform the token refresh.
  final AuthNotifier authNotifier;

  /// Factory that creates a fresh [AuthServiceClient] for the refresh call.
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
    return _ErrorMappingResponseFuture<R>(response, method.path);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final response = invoker(method, requests, options);
    return _ErrorMappingResponseStream<R>(response, method.path);
  }
}

/// Wraps a [ResponseFuture] and maps [GrpcError]s to [AppException]s.
///
/// Delegates all [Future] and [Response] methods to the underlying
/// [_delegate], intercepting errors in [then] and [catchError] so that
/// any [GrpcError] is replaced with the typed exception from
/// [mapGrpcError].
class _ErrorMappingResponseFuture<R> implements ResponseFuture<R> {
  _ErrorMappingResponseFuture(this._delegate, this._method);

  final ResponseFuture<R> _delegate;
  final String _method;

  /// Transforms a [GrpcError] into an [AppException]. Non-[GrpcError]
  /// exceptions pass through unchanged.
  Object _mapError(Object error) {
    if (error is GrpcError) return mapGrpcError(error, method: _method);
    return error;
  }

  /// The mapped future: maps errors once, then reuses the result.
  late final Future<R> _mapped = _delegate.then<R>(
    (v) => v,
    onError: (Object error, StackTrace stack) =>
        Error.throwWithStackTrace(_mapError(error), stack),
  );

  @override
  Future<S> then<S>(
    FutureOr<S> Function(R) onValue, {
    Function? onError,
  }) => _mapped.then(onValue, onError: onError);

  @override
  Future<R> catchError(Function onError, {bool Function(Object)? test}) =>
      _mapped.catchError(onError, test: test);

  @override
  Future<R> whenComplete(FutureOr<void> Function() action) =>
      _mapped.whenComplete(action);

  @override
  Future<R> timeout(
    Duration timeLimit, {
    FutureOr<R> Function()? onTimeout,
  }) => _mapped.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Stream<R> asStream() => _mapped.asStream();

  @override
  Future<Map<String, String>> get headers => _delegate.headers;

  @override
  Future<Map<String, String>> get trailers => _delegate.trailers;

  @override
  Future<void> cancel() => _delegate.cancel();
}

/// Wraps a [ResponseStream] and maps [GrpcError]s to [AppException]s.
///
/// Overrides [listen] to intercept errors from the underlying stream,
/// mapping [GrpcError]s to typed [AppException]s. All other [Stream]
/// methods (e.g. [map], [where], [toList]) ultimately go through
/// [listen], so they also benefit from the mapping.
class _ErrorMappingResponseStream<R> extends _ResponseStreamWrapper<R> {
  _ErrorMappingResponseStream(super._delegate, this._method);

  final String _method;

  @override
  StreamSubscription<R> listen(
    void Function(R)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return super.listen(
      onData,
      onError: (Object error, StackTrace stackTrace) {
        final mapped = error is GrpcError
            ? mapGrpcError(error, method: _method)
            : error;
        _dispatchError(onError, mapped, stackTrace);
      },
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
