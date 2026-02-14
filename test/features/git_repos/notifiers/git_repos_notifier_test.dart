import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/git_repos/notifiers/git_repos_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockGitRepoServiceClient extends Mock implements GitRepoServiceClient {}

/// A fake client whose [listRepos] always throws [GrpcError].
class _FailingGitRepoClient extends Fake implements GitRepoServiceClient {
  _FailingGitRepoClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListReposResponse> listRepos(
    ListReposRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockGitRepoServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListReposRequest());
    registerFallbackValue(RegisterRepoRequest());
    registerFallbackValue(UnregisterRepoRequest());
  });

  setUp(() {
    mockClient = MockGitRepoServiceClient();

    container = ProviderContainer(
      overrides: [
        connectionStatusProvider.overrideWithValue(
          const AsyncData(GrpcConnectionStatus.connected),
        ),
        gitRepoServiceProvider.overrideWithValue(mockClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  GitRepoDetail makeRepo(
    String id, {
    String name = 'my-repo',
    String repoPath = '/home/user/projects/my-repo',
    WorktreeMode worktreeMode = WorktreeMode.WORKTREE_MODE_GLOBAL,
    int worktreeCount = 3,
  }) => GitRepoDetail(
    id: id,
    name: name,
    repoPath: repoPath,
    worktreeMode: worktreeMode,
    worktreeCount: worktreeCount,
  );

  group('GitReposNotifier - build', () {
    test('fetches repos from gRPC', () async {
      final repos = [makeRepo('repo-1'), makeRepo('repo-2')];
      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: repos),
        ),
      );

      final result = await container.read(gitReposProvider.future);

      expect(result, hasLength(2));
      expect(result[0].id, 'repo-1');
      expect(result[1].id, 'repo-2');
    });

    test('returns empty list when no repos exist', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));

      final result = await container.read(gitReposProvider.future);
      expect(result, isEmpty);
    });

    test('preserves repo fields from the response', () async {
      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(
            repos: [
              GitRepoDetail(
                id: 'repo-42',
                name: 'betcode',
                repoPath: '/home/user/projects/betcode',
                worktreeMode: WorktreeMode.WORKTREE_MODE_LOCAL,
                localSubfolder: '.worktrees',
                setupScript: 'npm install',
                autoGitignore: true,
                worktreeCount: 5,
              ),
            ],
          ),
        ),
      );

      final result = await container.read(gitReposProvider.future);

      expect(result, hasLength(1));
      final repo = result.first;
      expect(repo.id, 'repo-42');
      expect(repo.name, 'betcode');
      expect(repo.repoPath, '/home/user/projects/betcode');
      expect(repo.worktreeMode, WorktreeMode.WORKTREE_MODE_LOCAL);
      expect(repo.localSubfolder, '.worktrees');
      expect(repo.setupScript, 'npm install');
      expect(repo.autoGitignore, isTrue);
      expect(repo.worktreeCount, 5);
    });
  });

  group('GitReposNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = ProviderContainer(
        overrides: [
          gitRepoServiceProvider.overrideWithValue(mockClient),
          connectionStatusProvider.overrideWithValue(
            const AsyncData(GrpcConnectionStatus.disconnected),
          ),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(gitReposProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(gitReposProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      final disconnectedContainer = ProviderContainer(
        overrides: [
          gitRepoServiceProvider.overrideWithValue(mockClient),
          connectionStatusProvider.overrideWithValue(
            const AsyncData(GrpcConnectionStatus.disconnected),
          ),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(gitReposProvider);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockClient.listRepos(any()));
    });
  });

  group('GitReposNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = ProviderContainer(
        overrides: [
          connectionStatusProvider.overrideWithValue(
            const AsyncData(GrpcConnectionStatus.connected),
          ),
          gitRepoServiceProvider.overrideWithValue(
            _FailingGitRepoClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(gitReposProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(gitReposProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = ProviderContainer(
        overrides: [
          connectionStatusProvider.overrideWithValue(
            const AsyncData(GrpcConnectionStatus.connected),
          ),
          gitRepoServiceProvider.overrideWithValue(
            _FailingGitRepoClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(gitReposProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(gitReposProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('GitReposNotifier - registerRepo', () {
    test('calls gRPC registerRepo and refreshes', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      when(
        () => mockClient.registerRepo(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeRepo('repo-new')));
      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('repo-new')]),
        ),
      );

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.registerRepo(repoPath: '/home/user/projects/new-repo');

      final state = container.read(gitReposProvider);
      expect(state.value, hasLength(1));
      expect(state.value!.first.id, 'repo-new');
    });

    test('passes correct parameters to gRPC', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      when(
        () => mockClient.registerRepo(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeRepo('repo-1')));

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.registerRepo(
        repoPath: '/home/user/projects/betcode',
        name: 'betcode',
        worktreeMode: WorktreeMode.WORKTREE_MODE_LOCAL,
        localSubfolder: '.worktrees',
        setupScript: 'npm install',
        autoGitignore: false,
      );

      final captured =
          verify(() => mockClient.registerRepo(captureAny())).captured.single
              as RegisterRepoRequest;

      expect(captured.repoPath, '/home/user/projects/betcode');
      expect(captured.name, 'betcode');
      expect(captured.worktreeMode, WorktreeMode.WORKTREE_MODE_LOCAL);
      expect(captured.localSubfolder, '.worktrees');
      expect(captured.setupScript, 'npm install');
      expect(captured.autoGitignore, isFalse);
    });

    test('uses empty string for optional params when not provided', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      when(
        () => mockClient.registerRepo(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(makeRepo('repo-1')));

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.registerRepo(repoPath: '/home/user/projects/test');

      final captured =
          verify(() => mockClient.registerRepo(captureAny())).captured.single
              as RegisterRepoRequest;

      expect(captured.repoPath, '/home/user/projects/test');
      expect(captured.name, '');
      expect(captured.worktreeMode, WorktreeMode.WORKTREE_MODE_UNSPECIFIED);
      expect(captured.localSubfolder, '');
      expect(captured.customPath, '');
      expect(captured.setupScript, '');
      expect(captured.autoGitignore, isTrue);
    });
  });

  group('GitReposNotifier - unregisterRepo', () {
    test('calls gRPC unregisterRepo and refreshes', () async {
      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('repo-1')]),
        ),
      );
      await container.read(gitReposProvider.future);

      when(() => mockClient.unregisterRepo(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          UnregisterRepoResponse(removed: true),
        ),
      );
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.unregisterRepo('repo-1');

      final state = container.read(gitReposProvider);
      expect(state.value, isEmpty);
    });

    test('passes correct id to gRPC', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      when(() => mockClient.unregisterRepo(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          UnregisterRepoResponse(removed: true),
        ),
      );

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.unregisterRepo('repo-42');

      final captured =
          verify(() => mockClient.unregisterRepo(captureAny())).captured.single
              as UnregisterRepoRequest;

      expect(captured.id, 'repo-42');
    });

    test('passes removeWorktrees flag to gRPC', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      when(() => mockClient.unregisterRepo(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          UnregisterRepoResponse(removed: true),
        ),
      );

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.unregisterRepo('repo-42', removeWorktrees: true);

      final captured =
          verify(() => mockClient.unregisterRepo(captureAny())).captured.single
              as UnregisterRepoRequest;

      expect(captured.id, 'repo-42');
      expect(captured.removeWorktrees, isTrue);
    });
  });

  group('GitReposNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('repo-1')]),
        ),
      );
      await container.read(gitReposProvider.future);

      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(
            repos: [makeRepo('repo-1'), makeRepo('repo-new')],
          ),
        ),
      );

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.refresh();

      final state = container.read(gitReposProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].id, 'repo-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<GitRepoDetail>>>[];

      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('repo-1')]),
        ),
      );
      await container.read(gitReposProvider.future);

      container.listen(gitReposProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('repo-2')]),
        ),
      );

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.id, 'repo-2');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockGitRepoServiceClient();
      when(
        () => errClient.listRepos(any()),
      ).thenThrow(GrpcError.unavailable());

      final errContainer = ProviderContainer(
        overrides: [
          connectionStatusProvider.overrideWithValue(
            const AsyncData(GrpcConnectionStatus.connected),
          ),
          gitRepoServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(gitReposProvider);
      await Future<void>.delayed(Duration.zero);

      when(() => errClient.listRepos(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListReposResponse(repos: [makeRepo('recovered')]),
        ),
      );

      final notifier = errContainer.read(gitReposProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(gitReposProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.id, 'recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));
      await container.read(gitReposProvider.future);

      reset(mockClient);
      when(
        () => mockClient.listRepos(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListReposResponse()));

      final notifier = container.read(gitReposProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listRepos(any())).called(1);
    });
  });
}
