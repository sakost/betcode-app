import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/sync/sync_dispatcher.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

class MockWorktreeServiceClient extends Mock implements WorktreeServiceClient {}

class _MockResponseStream extends Mock implements ResponseStream<AgentEvent> {}

// ---------------------------------------------------------------------------
// Fallback values
// ---------------------------------------------------------------------------

class _FakeCallOptions extends Fake implements CallOptions {}

class _FakeCreateWorktreeRequest extends Fake
    implements CreateWorktreeRequest {}

class _FakeRemoveWorktreeRequest extends Fake
    implements RemoveWorktreeRequest {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SyncQueueData makeQueueItem({
  int id = 1,
  String requestType = 'user_message',
  Uint8List? payload,
  String idempotencyKey = 'idem-key-1',
  String machineId = 'machine-1',
  String? sessionId,
  int priority = 4,
  int sequence = 0,
}) {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return SyncQueueData(
    id: id,
    machineId: machineId,
    sessionId: sessionId,
    requestType: requestType,
    payload: payload ?? Uint8List.fromList([]),
    idempotencyKey: idempotencyKey,
    priority: priority,
    sequence: sequence,
    status: 'pending',
    retryCount: 0,
    createdAt: now,
    expiresAt: now + 604800,
  );
}

/// A fake WorktreeServiceClient that records calls for verification.
///
/// We avoid mocking ResponseFuture (which extends Future) because it
/// corrupts mocktail's global state. Instead, this fake captures calls
/// and returns real completed Futures wrapped in a Completer.
class FakeWorktreeServiceClient extends Fake implements WorktreeServiceClient {
  CreateWorktreeRequest? lastCreateRequest;
  CallOptions? lastCreateOptions;
  RemoveWorktreeRequest? lastRemoveRequest;
  CallOptions? lastRemoveOptions;

  @override
  ResponseFuture<WorktreeDetail> createWorktree(
    CreateWorktreeRequest request, {
    CallOptions? options,
  }) {
    lastCreateRequest = request;
    lastCreateOptions = options;
    // Return a mock that resolves when awaited.
    return _FakeResponseFuture<WorktreeDetail>(WorktreeDetail());
  }

  @override
  ResponseFuture<RemoveWorktreeResponse> removeWorktree(
    RemoveWorktreeRequest request, {
    CallOptions? options,
  }) {
    lastRemoveRequest = request;
    lastRemoveOptions = options;
    return _FakeResponseFuture<RemoveWorktreeResponse>(
      RemoveWorktreeResponse(),
    );
  }
}

/// A fake ResponseFuture that wraps a completed value.
///
/// ResponseFuture extends Future, so we implement it as a delegating
/// Future that immediately completes with the given value.
class _FakeResponseFuture<T> implements ResponseFuture<T> {
  _FakeResponseFuture(this._value);

  final T _value;

  @override
  Future<S> then<S>(
    FutureOr<S> Function(T value) onValue, {
    Function? onError,
  }) {
    return Future.value(_value).then(onValue, onError: onError);
  }

  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      Future.value(_value).catchError(onError, test: test);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      Future.value(_value).whenComplete(action);

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      Future.value(_value).timeout(timeLimit, onTimeout: onTimeout);

  @override
  Stream<T> asStream() => Stream.value(_value);

  @override
  Future<Map<String, String>> get headers async => {};

  @override
  Future<Map<String, String>> get trailers async => {};

  @override
  Future<void> cancel() async {}

  // Dart 3.3+ requires this
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockAgentServiceClient mockAgentClient;
  late FakeWorktreeServiceClient fakeWorktreeClient;
  late SyncDispatcher dispatcher;
  late _MockResponseStream mockResponseStream;

  setUpAll(() {
    registerFallbackValue(_FakeCallOptions());
    registerFallbackValue(_FakeCreateWorktreeRequest());
    registerFallbackValue(_FakeRemoveWorktreeRequest());
    registerFallbackValue(Stream<AgentRequest>.empty());
  });

  setUp(() {
    mockAgentClient = MockAgentServiceClient();
    fakeWorktreeClient = FakeWorktreeServiceClient();
    mockResponseStream = _MockResponseStream();

    // Set up converse mock and response stream cancel.
    when(
      () => mockAgentClient.converse(any(), options: any(named: 'options')),
    ).thenAnswer((_) => mockResponseStream);
    when(() => mockResponseStream.cancel()).thenAnswer((_) async {});

    dispatcher = SyncDispatcher(
      agentClient: mockAgentClient,
      worktreeClient: fakeWorktreeClient,
    );
  });

  // -----------------------------------------------------------------------
  // Agent service dispatch tests
  // -----------------------------------------------------------------------

  group('dispatch user_message', () {
    test('calls converse() with stream containing AgentRequest', () async {
      final msg = UserMessage(content: 'hello');
      final payload = msg.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'user_message',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'key-user-msg',
      );

      await dispatcher.dispatch(item);

      final captured = verify(
        () => mockAgentClient.converse(
          captureAny(),
          options: captureAny(named: 'options'),
        ),
      ).captured;

      final stream = captured[0] as Stream<AgentRequest>;
      final requests = await stream.toList();
      expect(requests, hasLength(1));
      expect(requests[0].hasMessage(), isTrue);
      expect(requests[0].message.content, 'hello');

      final options = captured[1] as CallOptions;
      expect(
        options.metadata,
        containsPair('x-idempotency-key', 'key-user-msg'),
      );
    });
  });

  group('dispatch permission_response', () {
    test('calls converse() with AgentRequest containing permission', () async {
      final perm = PermissionResponse(requestId: 'perm-42');
      final payload = perm.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'permission_response',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'key-perm',
      );

      await dispatcher.dispatch(item);

      final captured = verify(
        () => mockAgentClient.converse(
          captureAny(),
          options: captureAny(named: 'options'),
        ),
      ).captured;

      final stream = captured[0] as Stream<AgentRequest>;
      final requests = await stream.toList();
      expect(requests, hasLength(1));
      expect(requests[0].hasPermission(), isTrue);
      expect(requests[0].permission.requestId, 'perm-42');
    });
  });

  group('dispatch question_response', () {
    test(
      'calls converse() with AgentRequest containing questionResponse',
      () async {
        final qr = UserQuestionResponse(questionId: 'q-7');
        final payload = qr.writeToBuffer();

        final item = makeQueueItem(
          requestType: 'question_response',
          payload: Uint8List.fromList(payload),
          idempotencyKey: 'key-question',
        );

        await dispatcher.dispatch(item);

        final captured = verify(
          () => mockAgentClient.converse(
            captureAny(),
            options: captureAny(named: 'options'),
          ),
        ).captured;

        final stream = captured[0] as Stream<AgentRequest>;
        final requests = await stream.toList();
        expect(requests, hasLength(1));
        expect(requests[0].hasQuestionResponse(), isTrue);
        expect(requests[0].questionResponse.questionId, 'q-7');
      },
    );
  });

  group('dispatch cancel_request', () {
    test('calls converse() with AgentRequest containing cancel', () async {
      final cancel = CancelRequest(reason: 'user pressed cancel');
      final payload = cancel.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'cancel_request',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'key-cancel',
      );

      await dispatcher.dispatch(item);

      final captured = verify(
        () => mockAgentClient.converse(
          captureAny(),
          options: captureAny(named: 'options'),
        ),
      ).captured;

      final stream = captured[0] as Stream<AgentRequest>;
      final requests = await stream.toList();
      expect(requests, hasLength(1));
      expect(requests[0].hasCancel(), isTrue);
      expect(requests[0].cancel.reason, 'user pressed cancel');
    });
  });

  // -----------------------------------------------------------------------
  // Worktree service dispatch tests
  // -----------------------------------------------------------------------

  group('dispatch create_worktree', () {
    test('calls createWorktree() with correct request', () async {
      final req = CreateWorktreeRequest(
        name: 'feature-branch',
        repoPath: '/repo',
        branch: 'feature',
      );
      final payload = req.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'create_worktree',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'key-create-wt',
      );

      await dispatcher.dispatch(item);

      expect(fakeWorktreeClient.lastCreateRequest, isNotNull);
      expect(fakeWorktreeClient.lastCreateRequest!.name, 'feature-branch');
      expect(fakeWorktreeClient.lastCreateRequest!.repoPath, '/repo');
      expect(fakeWorktreeClient.lastCreateRequest!.branch, 'feature');

      expect(
        fakeWorktreeClient.lastCreateOptions?.metadata,
        containsPair('x-idempotency-key', 'key-create-wt'),
      );
    });
  });

  group('dispatch delete_worktree', () {
    test('calls removeWorktree() with correct request', () async {
      final req = RemoveWorktreeRequest(id: 'wt-99');
      final payload = req.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'delete_worktree',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'key-delete-wt',
      );

      await dispatcher.dispatch(item);

      expect(fakeWorktreeClient.lastRemoveRequest, isNotNull);
      expect(fakeWorktreeClient.lastRemoveRequest!.id, 'wt-99');

      expect(
        fakeWorktreeClient.lastRemoveOptions?.metadata,
        containsPair('x-idempotency-key', 'key-delete-wt'),
      );
    });
  });

  // -----------------------------------------------------------------------
  // Unknown requestType
  // -----------------------------------------------------------------------

  group('unknown requestType', () {
    test('throws ArgumentError on unknown requestType', () async {
      final item = makeQueueItem(requestType: 'totally_unknown');

      expect(() => dispatcher.dispatch(item), throwsA(isA<ArgumentError>()));
    });
  });

  // -----------------------------------------------------------------------
  // Idempotency key in metadata
  // -----------------------------------------------------------------------

  group('idempotency key', () {
    test('includes x-idempotency-key in metadata for agent requests', () async {
      final msg = UserMessage(content: 'test');
      final payload = msg.writeToBuffer();

      final item = makeQueueItem(
        requestType: 'user_message',
        payload: Uint8List.fromList(payload),
        idempotencyKey: 'unique-idem-key-42',
      );

      await dispatcher.dispatch(item);

      final captured = verify(
        () => mockAgentClient.converse(
          any(),
          options: captureAny(named: 'options'),
        ),
      ).captured;

      final options = captured[0] as CallOptions;
      expect(
        options.metadata,
        containsPair('x-idempotency-key', 'unique-idem-key-42'),
      );
    });

    test(
      'includes x-idempotency-key in metadata for worktree requests',
      () async {
        final req = CreateWorktreeRequest(name: 'test');
        final payload = req.writeToBuffer();

        final item = makeQueueItem(
          requestType: 'create_worktree',
          payload: Uint8List.fromList(payload),
          idempotencyKey: 'wt-idem-key-99',
        );

        await dispatcher.dispatch(item);

        expect(
          fakeWorktreeClient.lastCreateOptions?.metadata,
          containsPair('x-idempotency-key', 'wt-idem-key-99'),
        );
      },
    );
  });
}
