import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

/// Wraps a pre-computed value (or error) as a [ResponseFuture] so that
/// mocked gRPC calls can be awaited in production code.
class FakeResponseFuture<T> extends Fake implements ResponseFuture<T> {
  FakeResponseFuture.value(T value) : _future = Future.value(value);
  FakeResponseFuture.error(Object error) : _future = Future.error(error);

  final Future<T> _future;

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      _future.then(onValue, onError: onError);

  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _future.whenComplete(action);

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<void> cancel() async {}

  bool get isCancelled => false;
}
