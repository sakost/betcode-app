import 'dart:async';

import 'package:grpc/grpc.dart';

/// Wraps a [StreamController] as a [ResponseStream] for server-streaming
/// RPC tests.
///
/// Extends [StreamView] (not [Fake]) so that standard Stream methods
/// like [toList], [map], [forEach], etc. work correctly through [listen].
class FakeResponseStream<T> extends StreamView<T>
    implements ResponseStream<T> {
  FakeResponseStream(StreamController<T> controller)
      : super(controller.stream);

  @override
  ResponseFuture<T> get single =>
      throw UnsupportedError('single not supported on FakeResponseStream');

  @override
  Future<void> cancel() async {}

  @override
  Future<Map<String, String>> get headers async => {};

  @override
  Future<Map<String, String>> get trailers async => {};
}
