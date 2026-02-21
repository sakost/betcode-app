import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/git_repos/notifiers/repo_worktrees_provider.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/notifier_test_helpers.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockWorktreeServiceClient extends Mock implements WorktreeServiceClient {}

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
    registerFallbackValue(GetWorktreeRequest());
  });

  setUp(() {
    mockClient = MockWorktreeServiceClient();

    container = createTestContainer(
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
  }) => WorktreeDetail(
    id: id,
    name: name,
    branch: branch,
    path: path,
    existsOnDisk: existsOnDisk,
    sessionCount: sessionCount,
  );

  void stubListEmpty() {
    when(
      () => mockClient.listWorktrees(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));
  }

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
      stubListEmpty();

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
                repoId: 'repo-1',
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
      expect(wt.repoId, 'repo-1');
      expect(wt.existsOnDisk, isTrue);
      expect(wt.sessionCount, 5);
    });
  });

  connectionAwarenessTests(
    label: 'WorktreesNotifier',
    provider: worktreesProvider,
    serviceOverrides: () => [
      worktreeServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.listWorktrees(any())),
  );

  errorHandlingTests(
    label: 'WorktreesNotifier',
    provider: worktreesProvider,
    errorOverrides: (error) => [
      worktreeServiceProvider.overrideWithValue(_FailingWorktreeClient(error)),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<WorktreeDetail>>(
      provider: worktreesProvider,
      label: 'WorktreesNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listWorktrees(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
          ),
        );
      },
      stubRefreshed: () {
        when(() => mockClient.listWorktrees(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListWorktreesResponse(
              worktrees: [makeWorktree('wt-1'), makeWorktree('wt-new')],
            ),
          ),
        );
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(
          () => mockClient.listWorktrees(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listWorktrees(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].id,
    ),
  );

  group('WorktreesNotifier - createWorktree', () {
    test('calls gRPC createWorktree and refreshes', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(
        () => mockClient.createWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeWorktree('wt-new')));
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-new')]),
        ),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'feat-login',
        repoId: 'repo-1',
        branch: 'feat/login',
      );

      final state = container.read(worktreesProvider);
      expect(state.value, hasLength(1));
      expect(state.value!.first.id, 'wt-new');
    });

    test('passes correct parameters to gRPC', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(
        () => mockClient.createWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeWorktree('wt-1')));

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'feat-auth',
        repoId: 'repo-1',
        branch: 'feat/auth',
        setupScript: 'npm install',
      );

      final captured =
          verify(() => mockClient.createWorktree(captureAny())).captured.single
              as CreateWorktreeRequest;

      expect(captured.name, 'feat-auth');
      expect(captured.repoId, 'repo-1');
      expect(captured.branch, 'feat/auth');
      expect(captured.setupScript, 'npm install');
    });

    test('uses empty string for setupScript when not provided', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(
        () => mockClient.createWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeWorktree('wt-1')));

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.createWorktree(
        name: 'test',
        repoId: 'repo-1',
        branch: 'main',
      );

      final captured =
          verify(() => mockClient.createWorktree(captureAny())).captured.single
              as CreateWorktreeRequest;

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
        (_) => FakeResponseFuture.value(RemoveWorktreeResponse(removed: true)),
      );
      stubListEmpty();

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.removeWorktree('wt-1');

      final state = container.read(worktreesProvider);
      expect(state.value, isEmpty);
    });

    test('passes correct id to gRPC', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(() => mockClient.removeWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RemoveWorktreeResponse(removed: true)),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.removeWorktree('wt-42');

      final captured =
          verify(() => mockClient.removeWorktree(captureAny())).captured.single
              as RemoveWorktreeRequest;

      expect(captured.id, 'wt-42');
    });
  });

  group('WorktreesNotifier - getWorktree', () {
    test('returns WorktreeDetail for given id', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      final detail = WorktreeDetail(
        id: 'wt-42',
        name: 'feature-branch',
        path: '/home/user/worktrees/feature-branch',
        branch: 'feature/new-thing',
        repoId: 'repo-1',
      );
      when(
        () => mockClient.getWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(detail));

      final notifier = container.read(worktreesProvider.notifier);
      final result = await notifier.getWorktree('wt-42');

      expect(result.id, 'wt-42');
      expect(result.name, 'feature-branch');
      expect(result.path, '/home/user/worktrees/feature-branch');
      expect(result.branch, 'feature/new-thing');
      expect(result.repoId, 'repo-1');
    });

    test('passes correct id to gRPC', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(() => mockClient.getWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(WorktreeDetail(id: 'wt-99')),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.getWorktree('wt-99');

      final captured =
          verify(() => mockClient.getWorktree(captureAny())).captured.single
              as GetWorktreeRequest;
      expect(captured.id, 'wt-99');
    });
  });

  // ---------------------------------------------------------------------------
  // I-7: refresh() does not flash loading state
  // ---------------------------------------------------------------------------

  group('WorktreesNotifier - refresh does not flash loading', () {
    test('refresh transitions directly from data to data', () async {
      final worktrees = [makeWorktree('wt-1')];
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: worktrees),
        ),
      );

      await container.read(worktreesProvider.future);

      // Capture state transitions during refresh
      final states = <AsyncValue<List<WorktreeDetail>>>[];
      container.listen(
        worktreesProvider,
        (_, next) => states.add(next),
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.refresh();

      // No loading state should appear — RefreshIndicator handles the spinner
      expect(states.where((s) => s.isLoading), isEmpty);
      // Final state has data
      final finalState = container.read(worktreesProvider);
      expect(finalState.hasValue, isTrue);
      expect(finalState.value, hasLength(1));
    });
  });

  // ---------------------------------------------------------------------------
  // I-8: Cross-provider invalidation gap
  // ---------------------------------------------------------------------------

  group('WorktreesNotifier - cross-provider invalidation', () {
    test('refresh invalidates repoWorktreesProvider', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );

      await container.read(worktreesProvider.future);

      // Read the repo worktrees provider so it is initialized
      await container.read(repoWorktreesProvider('repo-1').future);

      // Track if repoWorktreesProvider gets invalidated (re-created)
      var repoWorktreesRebuilt = false;
      container.listen(
        repoWorktreesProvider('repo-1'),
        (_, _) => repoWorktreesRebuilt = true,
      );

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.refresh();

      // Allow the invalidated provider to rebuild asynchronously
      await container.read(repoWorktreesProvider('repo-1').future);

      expect(repoWorktreesRebuilt, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // I-9: RemoveWorktreeResponse.removed not checked
  // ---------------------------------------------------------------------------

  group('WorktreesNotifier - removeWorktree response check', () {
    test('throws StateError when removed is false', () async {
      await initNotifier(
        container: container,
        provider: worktreesProvider,
        stubEmpty: stubListEmpty,
      );

      when(() => mockClient.removeWorktree(any())).thenAnswer(
        (_) =>
            FakeResponseFuture.value(RemoveWorktreeResponse(removed: false)),
      );

      final notifier = container.read(worktreesProvider.notifier);
      expect(
        () => notifier.removeWorktree('wt-1'),
        throwsStateError,
      );
    });

    test('succeeds and refreshes when removed is true', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );
      await container.read(worktreesProvider.future);

      when(() => mockClient.removeWorktree(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RemoveWorktreeResponse(removed: true)),
      );
      stubListEmpty();

      final notifier = container.read(worktreesProvider.notifier);
      await notifier.removeWorktree('wt-1');

      final state = container.read(worktreesProvider);
      expect(state.value, isEmpty);
    });
  });
}
