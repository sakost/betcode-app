import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockWorktreeServiceClient extends Mock
    implements WorktreeServiceClient {}

/// A fake client whose [listWorktrees] always throws [GrpcError].
class _FailingWorktreeClient extends Fake implements WorktreeServiceClient {
  _FailingWorktreeClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListWorktreesResponse> listWorktrees(
    ListWorktreesRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

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

  @override
  bool get isCancelled => false;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockWorktreeServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListWorktreesRequest());
    registerFallbackValue(CreateWorktreeRequest());
    registerFallbackValue(RemoveWorktreeRequest());
  });

  setUp(() {
    mockClient = MockWorktreeServiceClient();

    container = ProviderContainer(
      overrides: [
        worktreeServiceProvider.overrideWithValue(mockClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  WorktreeDetail makeWorktree(
    String id, {
    String name = 'feat-login',
    String branch = 'feat/login',
    String path = '/home/user/worktrees/feat-login',
    bool existsOnDisk = true,
    int sessionCount = 2,
  }) =>
      WorktreeDetail(
        id: id,
        name: name,
        branch: branch,
        path: path,
        existsOnDisk: existsOnDisk,
        sessionCount: sessionCount,
      );

  group('WorktreesNotifier - build', () {
    test('fetches worktrees from gRPC', () async {
      final worktrees = [makeWorktree('wt-1'), makeWorktree('wt-2')];
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: worktrees),
        ),
      );

      final result = await container.read(worktreesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].id, 'wt-1');
      expect(result[1].id, 'wt-2');
    });

    test('returns empty list when no worktrees exist', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );

      final result = await container.read(worktreesProvider.future);
      expect(result, isEmpty);
    });

    test('preserves worktree fields from the response', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(
            worktrees: [
              WorktreeDetail(
                id: 'wt-42',
                name: 'feat-auth',
                branch: 'feat/auth',
                path: '/home/user/worktrees/feat-auth',
                repoPath: '/home/user/repo',
                existsOnDisk: true,
                sessionCount: 5,
              ),
            ],
          ),
        ),
      );

      final result = await container.read(worktreesProvider.future);

      expect(result, hasLength(1));
      final wt = result.first;
      expect(wt.id, 'wt-42');
      expect(wt.name, 'feat-auth');
      expect(wt.branch, 'feat/auth');
      expect(wt.path, '/home/user/worktrees/feat-auth');
      expect(wt.repoPath, '/home/user/repo');
      expect(wt.existsOnDisk, isTrue);
      expect(wt.sessionCount, 5);
    });
  });

  group('WorktreesNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = ProviderContainer(
        overrides: [
          worktreeServiceProvider.overrideWithValue(
            _FailingWorktreeClient(
                GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(worktreesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(worktreesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = ProviderContainer(
        overrides: [
          worktreeServiceProvider.overrideWithValue(
            _FailingWorktreeClient(
                GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(worktreesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(worktreesProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('WorktreesNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(
            worktrees: [makeWorktree('wt-1'), makeWorktree('wt-new')],
          ),
        ),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.refresh();

      final state = container.read(worktreesProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].id, 'wt-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<WorktreeDetail>>>[];

      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );
      await container.read(worktreesProvider.future);

      container.listen(worktreesProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-2')]),
        ),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.id, 'wt-2');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockWorktreeServiceClient();
      when(() => errClient.listWorktrees(any())).thenThrow(
        GrpcError.unavailable(),
      );

      final errContainer = ProviderContainer(
        overrides: [
          worktreeServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(worktreesProvider);
      await Future<void>.delayed(Duration.zero);

      when(() => errClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('recovered')]),
        ),
      );

      final notifier = errContainer.read(worktreesProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(worktreesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.id, 'recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );
      await container.read(worktreesProvider.future);

      reset(mockClient);
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listWorktrees(any())).called(1);
    });
  });

  group('WorktreesNotifier - createWorktree', () {
    test('calls gRPC createWorktree and refreshes', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.createWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(makeWorktree('wt-new')),
      );
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-new')]),
        ),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'feat-login',
        repoPath: '/home/user/repo',
        branch: 'feat/login',
      );

      final state = container.read(worktreesProvider);
      expect(state.value, hasLength(1));
      expect(state.value!.first.id, 'wt-new');
    });

    test('passes correct parameters to gRPC', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.createWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(makeWorktree('wt-1')),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'feat-auth',
        repoPath: '/repo',
        branch: 'feat/auth',
        setupScript: 'npm install',
      );

      final captured = verify(
        () => mockClient.createWorktree(captureAny()),
      ).captured.single as CreateWorktreeRequest;

      expect(captured.name, 'feat-auth');
      expect(captured.repoPath, '/repo');
      expect(captured.branch, 'feat/auth');
      expect(captured.setupScript, 'npm install');
    });

    test('uses empty string for setupScript when not provided', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.createWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(makeWorktree('wt-1')),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'test',
        repoPath: '/repo',
        branch: 'main',
      );

      final captured = verify(
        () => mockClient.createWorktree(captureAny()),
      ).captured.single as CreateWorktreeRequest;

      expect(captured.setupScript, '');
    });
  });

  group('WorktreesNotifier - removeWorktree', () {
    test('calls gRPC removeWorktree and refreshes', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.removeWorktree(any())).thenAnswer(
        (_) =>
            FakeResponseFuture.value(RemoveWorktreeResponse(removed: true)),
      );
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.removeWorktree('wt-1');

      final state = container.read(worktreesProvider);
      expect(state.value, isEmpty);
    });

    test('passes correct id to gRPC', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListWorktreesResponse()),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.removeWorktree(any())).thenAnswer(
        (_) =>
            FakeResponseFuture.value(RemoveWorktreeResponse(removed: true)),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.removeWorktree('wt-42');

      final captured = verify(
        () => mockClient.removeWorktree(captureAny()),
      ).captured.single as RemoveWorktreeRequest;

      expect(captured.id, 'wt-42');
    });
  });
}
