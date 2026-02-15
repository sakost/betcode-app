import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

/// A fake [ResponseStream] that delegates to a regular [Stream].
class FakeInterceptorResponseStream<T> extends Fake
    implements ResponseStream<T> {
  FakeInterceptorResponseStream(this._s);
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

/// Creates a test [ClientMethod] for interceptor tests.
ClientMethod<String, String> testMethod([String path = '/test/M']) =>
    ClientMethod<String, String>(
      path,
      (s) => s.codeUnits,
      (b) => String.fromCharCodes(b),
    );

/// Resolves all metadata providers on a [CallOptions], simulating what the
/// real gRPC transport does before sending the request.
Future<Map<String, String>> resolveMetadata(CallOptions options) async {
  final md = Map<String, String>.of(options.metadata);
  for (final p in options.metadataProviders) {
    await p(md, '');
  }
  return md;
}
