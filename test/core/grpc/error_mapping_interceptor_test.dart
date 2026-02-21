import 'dart:async';

import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/interceptors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

import '../../helpers/fake_response_future.dart';
import '../interceptor_test_helpers.dart';

void main() {
  group('ErrorMappingInterceptor', () {
    late ErrorMappingInterceptor interceptor;

    setUp(() {
      interceptor = ErrorMappingInterceptor();
    });

    // ---- Unary tests ----

    test('passes through successful unary responses unchanged', () async {
      final response = interceptor.interceptUnary<String, String>(
        testMethod('/test/Ok'),
        'request',
        CallOptions(),
        (method, request, options) => FakeResponseFuture.value('success'),
      );
      expect(await response, 'success');
    });

    test('maps GrpcError to AppException on unary failure', () async {
      final response = interceptor.interceptUnary<String, String>(
        testMethod('/betcode.v1.AgentService/DeleteSession'),
        'request',
        CallOptions(),
        (method, request, options) =>
            FakeResponseFuture.error(const GrpcError.notFound()),
      );
      await expectLater(
        response,
        throwsA(isA<SessionNotFoundError>()),
      );
    });

    test('maps UNAVAILABLE to NetworkError on unary', () async {
      final response = interceptor.interceptUnary<String, String>(
        testMethod('/test/Rpc'),
        'request',
        CallOptions(),
        (method, request, options) =>
            FakeResponseFuture.error(const GrpcError.unavailable()),
      );
      await expectLater(
        response,
        throwsA(isA<NetworkError>()),
      );
    });

    test('non-GrpcError passes through unmapped', () async {
      final response = interceptor.interceptUnary<String, String>(
        testMethod('/test/Rpc'),
        'request',
        CallOptions(),
        (method, request, options) =>
            FakeResponseFuture.error(Exception('not grpc')),
      );
      await expectLater(
        response,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'toString',
            contains('not grpc'),
          ),
        ),
      );
    });

    test('maps UNAUTHENTICATED to AuthExpiredError on unary', () async {
      final response = interceptor.interceptUnary<String, String>(
        testMethod('/test/Rpc'),
        'request',
        CallOptions(),
        (method, request, options) =>
            FakeResponseFuture.error(const GrpcError.unauthenticated()),
      );
      await expectLater(
        response,
        throwsA(isA<AuthExpiredError>()),
      );
    });

    // ---- Streaming tests ----

    test('streaming: maps GrpcError to AppException', () async {
      final response = interceptor.interceptStreaming<String, String>(
        testMethod('/betcode.v1.AgentService/Converse'),
        const Stream.empty(),
        CallOptions(),
        (method, requests, options) => FakeInterceptorResponseStream(
          Stream<String>.error(const GrpcError.notFound()),
        ),
      );

      final completer = Completer<Object>();
      response.listen(
        (_) {},
        onError: (Object error) {
          if (!completer.isCompleted) completer.complete(error);
        },
      );
      final error = await completer.future;
      expect(error, isA<SessionNotFoundError>());
    });

    test('streaming: non-GrpcError passes through unmapped', () async {
      final response = interceptor.interceptStreaming<String, String>(
        testMethod('/test/Rpc'),
        const Stream.empty(),
        CallOptions(),
        (method, requests, options) => FakeInterceptorResponseStream(
          Stream<String>.error(Exception('not grpc')),
        ),
      );

      final completer = Completer<Object>();
      response.listen(
        (_) {},
        onError: (Object error) {
          if (!completer.isCompleted) completer.complete(error);
        },
      );
      final error = await completer.future;
      expect(error, isA<Exception>());
      expect(error.toString(), contains('not grpc'));
    });

    test('streaming: successful values pass through unchanged', () async {
      final response = interceptor.interceptStreaming<String, String>(
        testMethod('/test/Rpc'),
        const Stream.empty(),
        CallOptions(),
        (method, requests, options) => FakeInterceptorResponseStream(
          Stream.fromIterable(['a', 'b', 'c']),
        ),
      );

      final values = <String>[];
      final completer = Completer<void>();
      response.listen(
        values.add,
        onDone: completer.complete,
      );
      await completer.future;
      expect(values, ['a', 'b', 'c']);
    });
  });
}
