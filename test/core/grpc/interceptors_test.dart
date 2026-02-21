import 'dart:async';

import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

import '../../helpers/fake_response_future.dart';
import '../interceptor_test_helpers.dart';

// ---------------------------------------------------------------------------
// Intercept helpers - capture CallOptions from unary/streaming calls
// ---------------------------------------------------------------------------

/// Calls `interceptor.interceptUnary` with boilerplate args,
/// captures and returns the [CallOptions] passed to the
/// invoker.
CallOptions captureUnaryOptions(
  ClientInterceptor interceptor, {
  String request = 'req',
  CallOptions? options,
  ClientMethod<String, String>? method,
}) {
  late CallOptions captured;
  unawaited(
    interceptor.interceptUnary<String, String>(
      method ?? testMethod(),
      request,
      options ?? CallOptions(),
      (m, r, o) {
        captured = o;
        return FakeResponseFuture.value('ok');
      },
    ),
  );
  return captured;
}

/// Calls `interceptor.interceptStreaming` with boilerplate
/// args, captures and returns the [CallOptions] passed to
/// the invoker.
CallOptions captureStreamingOptions(
  ClientInterceptor interceptor, {
  CallOptions? options,
}) {
  late CallOptions captured;
  interceptor.interceptStreaming<String, String>(
    testMethod(),
    const Stream.empty(),
    options ?? CallOptions(),
    (m, r, o) {
      captured = o;
      return FakeInterceptorResponseStream(const Stream.empty());
    },
  );
  return captured;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AuthInterceptor - unary', () {
    test('adds Bearer token when token is available', () async {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'my-jwt');
      final md = await resolveMetadata(captureUnaryOptions(interceptor));
      expect(md['authorization'], 'Bearer my-jwt');
    });

    test('omits authorization when token is null', () async {
      final interceptor = AuthInterceptor(tokenProvider: () async => null);
      final md = await resolveMetadata(captureUnaryOptions(interceptor));
      expect(md.containsKey('authorization'), isFalse);
    });

    test('preserves existing metadata', () async {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'tok');
      final md = await resolveMetadata(
        captureUnaryOptions(
          interceptor,
          options: CallOptions(metadata: {'x-custom': 'v'}),
        ),
      );
      expect(md['authorization'], 'Bearer tok');
      expect(md['x-custom'], 'v');
    });

    test('forwards method and request to invoker', () {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'tok');
      late String capturedPath;
      late String capturedReq;
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod('/svc/Do'),
          'hello',
          CallOptions(),
          (m, r, o) {
            capturedPath = m.path;
            capturedReq = r;
            return FakeResponseFuture.value('ok');
          },
        ),
      );
      expect(capturedPath, '/svc/Do');
      expect(capturedReq, 'hello');
    });

    test('returns invoker response', () async {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'tok');
      final resp = interceptor.interceptUnary<String, String>(
        testMethod(),
        'req',
        CallOptions(),
        (m, r, o) => FakeResponseFuture.value('result'),
      );
      expect(await resp, 'result');
    });

    test('fetches token lazily per call', () async {
      var n = 0;
      final interceptor = AuthInterceptor(
        tokenProvider: () async => 'tok-${++n}',
      );
      late CallOptions o1;
      late CallOptions o2;
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod(),
          'r',
          CallOptions(),
          (m, r, o) {
            o1 = o;
            return FakeResponseFuture.value('');
          },
        ),
      );
      unawaited(
        interceptor.interceptUnary<String, String>(
          testMethod(),
          'r',
          CallOptions(),
          (m, r, o) {
            o2 = o;
            return FakeResponseFuture.value('');
          },
        ),
      );
      expect((await resolveMetadata(o1))['authorization'], 'Bearer tok-1');
      expect((await resolveMetadata(o2))['authorization'], 'Bearer tok-2');
    });
  });

  group('AuthInterceptor - streaming', () {
    test('adds Bearer token for streaming calls', () async {
      final interceptor = AuthInterceptor(
        tokenProvider: () async => 'stream-tok',
      );
      final md = await resolveMetadata(captureStreamingOptions(interceptor));
      expect(md['authorization'], 'Bearer stream-tok');
    });

    test('omits authorization when token is null', () async {
      final interceptor = AuthInterceptor(tokenProvider: () async => null);
      final md = await resolveMetadata(captureStreamingOptions(interceptor));
      expect(md.containsKey('authorization'), isFalse);
    });

    test('forwards request stream unchanged', () {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'tok');
      final input = Stream<String>.fromIterable(['a']);
      late Stream<String> captured;
      interceptor.interceptStreaming<String, String>(
        testMethod(),
        input,
        CallOptions(),
        (m, r, o) {
          captured = r;
          return FakeInterceptorResponseStream(const Stream.empty());
        },
      );
      expect(captured, same(input));
    });

    test('returns invoker response stream', () {
      final interceptor = AuthInterceptor(tokenProvider: () async => 'tok');
      final expected = FakeInterceptorResponseStream(
        Stream<String>.fromIterable(['x']),
      );
      final result = interceptor.interceptStreaming<String, String>(
        testMethod(),
        const Stream.empty(),
        CallOptions(),
        (m, r, o) => expected,
      );
      expect(result, same(expected));
    });
  });

  group('LoggingInterceptor - unary', () {
    test('passes options through unmodified', () {
      final interceptor = LoggingInterceptor();
      final opts = CallOptions(metadata: {'k': 'v'});
      final captured = captureUnaryOptions(interceptor, options: opts);
      expect(captured, same(opts));
    });

    test('returns invoker response', () async {
      final interceptor = LoggingInterceptor();
      final resp = interceptor.interceptUnary<String, String>(
        testMethod(),
        'req',
        CallOptions(),
        (m, r, o) => FakeResponseFuture.value('result'),
      );
      expect(await resp, 'result');
    });

    test('does not swallow errors from invoker', () async {
      final interceptor = LoggingInterceptor();
      final resp = interceptor.interceptUnary<String, String>(
        testMethod(),
        'req',
        CallOptions(),
        (m, r, o) =>
            FakeResponseFuture.error(const GrpcError.unavailable('down')),
      );
      await expectLater(resp, throwsA(isA<GrpcError>()));
    });

    test('successful response completes without error', () async {
      final interceptor = LoggingInterceptor();
      final resp = interceptor.interceptUnary<String, String>(
        testMethod('/svc/Ok'),
        'req',
        CallOptions(),
        (m, r, o) => FakeResponseFuture.value('ok'),
      );
      expect(await resp, 'ok');
    });
  });

  group('LoggingInterceptor - streaming', () {
    test('passes options through unmodified', () {
      final interceptor = LoggingInterceptor();
      final opts = CallOptions(metadata: {'k': 'v'});
      final captured = captureStreamingOptions(interceptor, options: opts);
      expect(captured, same(opts));
    });

    test('returns invoker response stream wrapped for logging', () async {
      final interceptor = LoggingInterceptor();
      final expected = FakeInterceptorResponseStream(
        Stream<String>.fromIterable(['d']),
      );
      final result = interceptor.interceptStreaming<String, String>(
        testMethod(),
        const Stream.empty(),
        CallOptions(),
        (m, r, o) => expected,
      );
      expect(result, isA<ResponseStream<String>>());
      expect(result, isNot(same(expected)));
      expect(await result.toList(), ['d']);
    });
  });

  group('MachineIdInterceptor - unary', () {
    test('injects x-machine-id when machine ID is present', () async {
      final interceptor = MachineIdInterceptor(
        machineIdProvider: () async => 'mach-42',
      );
      final md = await resolveMetadata(captureUnaryOptions(interceptor));
      expect(md['x-machine-id'], 'mach-42');
    });

    test('omits x-machine-id when machine ID is null', () async {
      final interceptor = MachineIdInterceptor(
        machineIdProvider: () async => null,
      );
      final md = await resolveMetadata(captureUnaryOptions(interceptor));
      expect(md.containsKey('x-machine-id'), isFalse);
    });

    test('preserves existing metadata', () async {
      final interceptor = MachineIdInterceptor(
        machineIdProvider: () async => 'mach-1',
      );
      final md = await resolveMetadata(
        captureUnaryOptions(
          interceptor,
          options: CallOptions(metadata: {'x-custom': 'v'}),
        ),
      );
      expect(md['x-machine-id'], 'mach-1');
      expect(md['x-custom'], 'v');
    });
  });

  group('MachineIdInterceptor - streaming', () {
    test('injects x-machine-id for streaming calls', () async {
      final interceptor = MachineIdInterceptor(
        machineIdProvider: () async => 'stream-mach',
      );
      final md = await resolveMetadata(captureStreamingOptions(interceptor));
      expect(md['x-machine-id'], 'stream-mach');
    });

    test('omits x-machine-id when null for streaming calls', () async {
      final interceptor = MachineIdInterceptor(
        machineIdProvider: () async => null,
      );
      final md = await resolveMetadata(captureStreamingOptions(interceptor));
      expect(md.containsKey('x-machine-id'), isFalse);
    });
  });

  group('TokenProvider typedef', () {
    test('accepts async function returning token', () async {
      Future<String?> p() async => 'abc';
      expect(await p(), 'abc');
    });

    test('accepts function returning null', () async {
      Future<String?> p() async => null;
      expect(await p(), isNull);
    });
  });
}
