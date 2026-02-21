import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockWorktreeServiceClient extends Mock implements WorktreeServiceClient {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockWorktreeServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListWorktreesRequest());
    registerFallbackValue(CreateWorktreeRequest());
  });

  setUp(() {
    mockClient = MockWorktreeServiceClient();
  });

  tearDown(() => container.dispose());

  WorktreeDetail makeWorktree(
    String id, {
    String name = 'wt',
    String path = '/tmp/wt',
    String branch = 'main',
    String repoId = 'repo-1',
    bool existsOnDisk = true,
    int sessionCount = 0,
  }) => WorktreeDetail(
    id: id,
    name: name,
    path: path,
    branch: branch,
    repoId: repoId,
    existsOnDisk: existsOnDisk,
    sessionCount: sessionCount,
  );

  group('RepoWorktreesNotifier - connected', () {
    test('fetches worktrees from gRPC when connected', () async {
      final worktrees = [makeWorktree('wt-1'), makeWorktree('wt-2')];
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: worktrees),
        ),
      );

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      final result = await container.read(
        repoWorktreesProvider('repo-1').future,
      );

      expect(result, hasLength(2));
      expect(result[0].id, 'wt-1');
      expect(result[1].id, 'wt-2');
    });

    test('passes repoId to gRPC request', () async {
      when(
        () => mockClient.listWorktrees(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      await container.read(repoWorktreesProvider('repo-42').future);

      final captured =
          verify(() => mockClient.listWorktrees(captureAny())).captured.single
              as ListWorktreesRequest;

      expect(captured.repoId, 'repo-42');
    });

    test('returns empty list when no worktrees exist', () async {
      when(
        () => mockClient.listWorktrees(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      final result = await container.read(
        repoWorktreesProvider('repo-1').future,
      );
      expect(result, isEmpty);
    });
  });

  group('RepoWorktreesNotifier - disconnected', () {
    test('stays in loading state when disconnected', () async {
      container = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          worktreeServiceProvider.overrideWithValue(
            mockClient,
          ),
        ],
      )..read(repoWorktreesProvider('repo-1'));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(
        repoWorktreesProvider('repo-1'),
      );
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      container = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          worktreeServiceProvider.overrideWithValue(
            mockClient,
          ),
        ],
      )..read(repoWorktreesProvider('repo-1'));
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockClient.listWorktrees(any()),
      );
    });
  });

  group('RepoWorktreesNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.error(
          const GrpcError.unavailable(
            'connection refused',
          ),
        ),
      );

      container = createTestContainer(
        overrides: [
          worktreeServiceProvider.overrideWithValue(
            mockClient,
          ),
        ],
      )..read(repoWorktreesProvider('repo-1'));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(repoWorktreesProvider('repo-1'));
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });
  });

  group('RepoWorktreesNotifier - createWorktree', () {
    test('calls gRPC createWorktree and refreshes list', () async {
      // Initial list fetch
      when(
        () => mockClient.listWorktrees(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));

      // createWorktree response
      when(
        () => mockClient.createWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeWorktree('wt-new')));

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      // Wait for initial fetch
      await container.read(repoWorktreesProvider('repo-1').future);

      // After create, the refresh will re-fetch
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-new')]),
        ),
      );

      final notifier = container.read(repoWorktreesProvider('repo-1').notifier);
      await notifier.createWorktree(
        name: 'new-wt',
        repoId: 'repo-1',
        branch: 'feature-x',
        setupScript: 'echo hi',
      );

      // Verify createWorktree was called with correct args
      final captured =
          verify(() => mockClient.createWorktree(captureAny())).captured.single
              as CreateWorktreeRequest;
      expect(captured.name, 'new-wt');
      expect(captured.repoId, 'repo-1');
      expect(captured.branch, 'feature-x');
      expect(captured.setupScript, 'echo hi');

      // Verify list was refreshed
      final state = container.read(repoWorktreesProvider('repo-1'));
      expect(state.value, hasLength(1));
      expect(state.value!.first.id, 'wt-new');
    });

    test('passes empty string for null setupScript', () async {
      when(
        () => mockClient.listWorktrees(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListWorktreesResponse()));
      when(
        () => mockClient.createWorktree(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeWorktree('wt-1')));

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      await container.read(repoWorktreesProvider('repo-1').future);

      final notifier = container.read(repoWorktreesProvider('repo-1').notifier);
      await notifier.createWorktree(
        name: 'wt',
        repoId: 'repo-1',
        branch: 'main',
      );

      final captured =
          verify(() => mockClient.createWorktree(captureAny())).captured.single
              as CreateWorktreeRequest;
      expect(captured.setupScript, '');
    });
  });

  group('RepoWorktreesNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(worktrees: [makeWorktree('wt-1')]),
        ),
      );

      container = createTestContainer(
        overrides: [worktreeServiceProvider.overrideWithValue(mockClient)],
      );

      await container.read(repoWorktreesProvider('repo-1').future);

      when(() => mockClient.listWorktrees(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListWorktreesResponse(
            worktrees: [makeWorktree('wt-1'), makeWorktree('wt-new')],
          ),
        ),
      );

      final notifier = container.read(repoWorktreesProvider('repo-1').notifier);
      await notifier.refresh();

      final state = container.read(repoWorktreesProvider('repo-1'));
      expect(state.value, hasLength(2));
      expect(state.value![1].id, 'wt-new');
    });
  });
}
