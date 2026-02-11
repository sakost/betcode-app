import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

/// Wraps a [StreamController] as a [ResponseStream] for bidi stream tests.
class FakeResponseStream<T> extends Fake implements ResponseStream<T> {
  FakeResponseStream(this.controller);

  final StreamController<T> controller;

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

/// A fake client whose [converse] always throws [GrpcError].
class FailingConverseClient extends Fake implements AgentServiceClient {
  FailingConverseClient(this.error);
  final GrpcError error;

  @override
  ResponseStream<pb.AgentEvent> converse(
    Stream<pb.AgentRequest> request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

/// A [ResponseStream] that immediately emits an error.
class ErrorResponseStream<T> extends Fake implements ResponseStream<T> {
  ErrorResponseStream(this.error);
  final Object error;

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final controller = StreamController<T>();
    controller.addError(error);
    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
