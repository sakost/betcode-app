import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/gitlab/notifiers/gitlab_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockGitLabServiceClient extends Mock implements GitLabServiceClient {}

/// A fake client whose list methods always throw [GrpcError].
class _FailingGitLabClient extends Fake implements GitLabServiceClient {
  _FailingGitLabClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListPipelinesResponse> listPipelines(
    ListPipelinesRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }

  @override
  ResponseFuture<ListMergeRequestsResponse> listMergeRequests(
    ListMergeRequestsRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }

  @override
  ResponseFuture<ListIssuesResponse> listIssues(
    ListIssuesRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockGitLabServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListPipelinesRequest());
    registerFallbackValue(ListMergeRequestsRequest());
    registerFallbackValue(ListIssuesRequest());
  });

  setUp(() {
    mockClient = MockGitLabServiceClient();

    container = createTestContainer(
      overrides: [
        gitlabServiceProvider.overrideWithValue(mockClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  // -------------------------------------------------------------------------
  // PipelinesNotifier
  // -------------------------------------------------------------------------

  group('PipelinesNotifier - build', () {
    test('fetches pipelines from gRPC', () async {
      final pipelines = [
        PipelineInfo(id: Int64(1), refName: 'main', sha: 'abc123'),
        PipelineInfo(id: Int64(2), refName: 'develop', sha: 'def456'),
      ];
      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(pipelines: pipelines, total: 2),
        ),
      );

      final result = await container.read(pipelinesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].refName, 'main');
      expect(result[1].refName, 'develop');
    });

    test('returns empty list when no pipelines exist', () async {
      when(
        () => mockClient.listPipelines(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPipelinesResponse()));

      final result = await container.read(pipelinesProvider.future);
      expect(result, isEmpty);
    });

    test('preserves pipeline fields from the response', () async {
      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [
              PipelineInfo(
                id: Int64(42),
                status: PipelineStatus.PIPELINE_STATUS_SUCCESS,
                refName: 'feature/auth',
                sha: 'deadbeef1234567890',
                source: 'push',
                webUrl: 'https://gitlab.com/p/42',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(pipelinesProvider.future);

      expect(result, hasLength(1));
      final pipeline = result.first;
      expect(pipeline.id, Int64(42));
      expect(pipeline.status, PipelineStatus.PIPELINE_STATUS_SUCCESS);
      expect(pipeline.refName, 'feature/auth');
      expect(pipeline.sha, 'deadbeef1234567890');
      expect(pipeline.source, 'push');
      expect(pipeline.webUrl, 'https://gitlab.com/p/42');
    });
  });

  group('PipelinesNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(pipelinesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(pipelinesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(pipelinesProvider);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockClient.listPipelines(any()));
    });
  });

  group('PipelinesNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(
            _FailingGitLabClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(pipelinesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(pipelinesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(
            _FailingGitLabClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(pipelinesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(pipelinesProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('PipelinesNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [PipelineInfo(id: Int64(1), refName: 'main')],
          ),
        ),
      );
      await container.read(pipelinesProvider.future);

      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [
              PipelineInfo(id: Int64(1), refName: 'main'),
              PipelineInfo(id: Int64(2), refName: 'new-branch'),
            ],
          ),
        ),
      );

      final notifier = container.read(pipelinesProvider.notifier);
      await notifier.refresh();

      final state = container.read(pipelinesProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].refName, 'new-branch');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<PipelineInfo>>>[];

      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [PipelineInfo(id: Int64(1), refName: 'main')],
          ),
        ),
      );
      await container.read(pipelinesProvider.future);

      container.listen(pipelinesProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [PipelineInfo(id: Int64(2), refName: 'develop')],
          ),
        ),
      );

      final notifier = container.read(pipelinesProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.refName, 'develop');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockGitLabServiceClient();
      when(
        () => errClient.listPipelines(any()),
      ).thenThrow(GrpcError.unavailable());

      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(pipelinesProvider);
      await Future<void>.delayed(Duration.zero);

      when(() => errClient.listPipelines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListPipelinesResponse(
            pipelines: [PipelineInfo(id: Int64(1), refName: 'recovered')],
          ),
        ),
      );

      final notifier = errContainer.read(pipelinesProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(pipelinesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.refName, 'recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.listPipelines(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPipelinesResponse()));
      await container.read(pipelinesProvider.future);

      reset(mockClient);
      when(
        () => mockClient.listPipelines(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListPipelinesResponse()));

      final notifier = container.read(pipelinesProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listPipelines(any())).called(1);
    });
  });

  // -------------------------------------------------------------------------
  // MergeRequestsNotifier
  // -------------------------------------------------------------------------

  group('MergeRequestsNotifier - build', () {
    test('fetches merge requests from gRPC', () async {
      final mrs = [
        MergeRequestInfo(
          id: Int64(1),
          iid: Int64(10),
          title: 'Fix auth',
          state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
        ),
        MergeRequestInfo(
          id: Int64(2),
          iid: Int64(11),
          title: 'Add tests',
          state: MergeRequestState.MERGE_REQUEST_STATE_MERGED,
        ),
      ];
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(mergeRequests: mrs, total: 2),
        ),
      );

      final result = await container.read(mergeRequestsProvider.future);

      expect(result, hasLength(2));
      expect(result[0].title, 'Fix auth');
      expect(result[1].title, 'Add tests');
    });

    test('returns empty list when no merge requests exist', () async {
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMergeRequestsResponse()),
      );

      final result = await container.read(mergeRequestsProvider.future);
      expect(result, isEmpty);
    });

    test('preserves merge request fields from the response', () async {
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [
              MergeRequestInfo(
                id: Int64(42),
                iid: Int64(123),
                title: 'Refactor DB layer',
                state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
                sourceBranch: 'feature/db',
                targetBranch: 'main',
                author: 'alice',
                labels: ['backend', 'urgent'],
                draft: true,
                webUrl: 'https://gitlab.com/mr/123',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(mergeRequestsProvider.future);

      expect(result, hasLength(1));
      final mr = result.first;
      expect(mr.id, Int64(42));
      expect(mr.iid, Int64(123));
      expect(mr.title, 'Refactor DB layer');
      expect(mr.state, MergeRequestState.MERGE_REQUEST_STATE_OPENED);
      expect(mr.sourceBranch, 'feature/db');
      expect(mr.targetBranch, 'main');
      expect(mr.author, 'alice');
      expect(mr.labels, ['backend', 'urgent']);
      expect(mr.draft, isTrue);
      expect(mr.webUrl, 'https://gitlab.com/mr/123');
    });
  });

  group('MergeRequestsNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(mergeRequestsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(mergeRequestsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(mergeRequestsProvider);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockClient.listMergeRequests(any()));
    });
  });

  group('MergeRequestsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(
            _FailingGitLabClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(mergeRequestsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(mergeRequestsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });
  });

  group('MergeRequestsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [MergeRequestInfo(id: Int64(1), title: 'First')],
          ),
        ),
      );
      await container.read(mergeRequestsProvider.future);

      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [
              MergeRequestInfo(id: Int64(1), title: 'First'),
              MergeRequestInfo(id: Int64(2), title: 'Second'),
            ],
          ),
        ),
      );

      final notifier = container.read(mergeRequestsProvider.notifier);
      await notifier.refresh();

      final state = container.read(mergeRequestsProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].title, 'Second');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<MergeRequestInfo>>>[];

      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [MergeRequestInfo(id: Int64(1), title: 'First')],
          ),
        ),
      );
      await container.read(mergeRequestsProvider.future);

      container.listen(mergeRequestsProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [MergeRequestInfo(id: Int64(2), title: 'Updated')],
          ),
        ),
      );

      final notifier = container.read(mergeRequestsProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.title, 'Updated');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockGitLabServiceClient();
      when(
        () => errClient.listMergeRequests(any()),
      ).thenThrow(GrpcError.unavailable());

      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(mergeRequestsProvider);
      await Future<void>.delayed(Duration.zero);

      when(() => errClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMergeRequestsResponse(
            mergeRequests: [MergeRequestInfo(id: Int64(1), title: 'Recovered')],
          ),
        ),
      );

      final notifier = errContainer.read(mergeRequestsProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(mergeRequestsProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.title, 'Recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMergeRequestsResponse()),
      );
      await container.read(mergeRequestsProvider.future);

      reset(mockClient);
      when(() => mockClient.listMergeRequests(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMergeRequestsResponse()),
      );

      final notifier = container.read(mergeRequestsProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listMergeRequests(any())).called(1);
    });
  });

  // -------------------------------------------------------------------------
  // IssuesNotifier
  // -------------------------------------------------------------------------

  group('IssuesNotifier - build', () {
    test('fetches issues from gRPC', () async {
      final issues = [
        IssueInfo(
          id: Int64(1),
          iid: Int64(5),
          title: 'Fix login bug',
          state: IssueState.ISSUE_STATE_OPENED,
        ),
        IssueInfo(
          id: Int64(2),
          iid: Int64(6),
          title: 'Add dark mode',
          state: IssueState.ISSUE_STATE_CLOSED,
        ),
      ];
      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(issues: issues, total: 2),
        ),
      );

      final result = await container.read(issuesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].title, 'Fix login bug');
      expect(result[1].title, 'Add dark mode');
    });

    test('returns empty list when no issues exist', () async {
      when(
        () => mockClient.listIssues(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListIssuesResponse()));

      final result = await container.read(issuesProvider.future);
      expect(result, isEmpty);
    });

    test('preserves issue fields from the response', () async {
      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [
              IssueInfo(
                id: Int64(42),
                iid: Int64(99),
                title: 'Security vulnerability',
                state: IssueState.ISSUE_STATE_OPENED,
                author: 'bob',
                labels: ['security', 'critical'],
                confidential: true,
                webUrl: 'https://gitlab.com/issues/99',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(issuesProvider.future);

      expect(result, hasLength(1));
      final issue = result.first;
      expect(issue.id, Int64(42));
      expect(issue.iid, Int64(99));
      expect(issue.title, 'Security vulnerability');
      expect(issue.state, IssueState.ISSUE_STATE_OPENED);
      expect(issue.author, 'bob');
      expect(issue.labels, ['security', 'critical']);
      expect(issue.confidential, isTrue);
      expect(issue.webUrl, 'https://gitlab.com/issues/99');
    });
  });

  group('IssuesNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(issuesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(issuesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          gitlabServiceProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(issuesProvider);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockClient.listIssues(any()));
    });
  });

  group('IssuesNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(
            _FailingGitLabClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(issuesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(issuesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });
  });

  group('IssuesNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [IssueInfo(id: Int64(1), title: 'First')],
          ),
        ),
      );
      await container.read(issuesProvider.future);

      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [
              IssueInfo(id: Int64(1), title: 'First'),
              IssueInfo(id: Int64(2), title: 'Second'),
            ],
          ),
        ),
      );

      final notifier = container.read(issuesProvider.notifier);
      await notifier.refresh();

      final state = container.read(issuesProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].title, 'Second');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<IssueInfo>>>[];

      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [IssueInfo(id: Int64(1), title: 'First')],
          ),
        ),
      );
      await container.read(issuesProvider.future);

      container.listen(issuesProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [IssueInfo(id: Int64(2), title: 'Updated')],
          ),
        ),
      );

      final notifier = container.read(issuesProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.title, 'Updated');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockGitLabServiceClient();
      when(
        () => errClient.listIssues(any()),
      ).thenThrow(GrpcError.unavailable());

      final errContainer = createTestContainer(
        overrides: [
          gitlabServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(issuesProvider);
      await Future<void>.delayed(Duration.zero);

      when(() => errClient.listIssues(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListIssuesResponse(
            issues: [IssueInfo(id: Int64(1), title: 'Recovered')],
          ),
        ),
      );

      final notifier = errContainer.read(issuesProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(issuesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.title, 'Recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.listIssues(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListIssuesResponse()));
      await container.read(issuesProvider.future);

      reset(mockClient);
      when(
        () => mockClient.listIssues(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListIssuesResponse()));

      final notifier = container.read(issuesProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listIssues(any())).called(1);
    });
  });
}
