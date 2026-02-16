import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/gitlab/notifiers/gitlab_providers.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
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
    registerFallbackValue(GetMergeRequestRequest());
    registerFallbackValue(GetPipelineRequest());
    registerFallbackValue(GetIssueRequest());
  });

  setUp(() {
    mockClient = MockGitLabServiceClient();

    container = createTestContainer(
      overrides: [gitlabServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  void stubPipelinesEmpty() {
    when(
      () => mockClient.listPipelines(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListPipelinesResponse()));
  }

  void stubMergeRequestsEmpty() {
    when(
      () => mockClient.listMergeRequests(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListMergeRequestsResponse()));
  }

  void stubIssuesEmpty() {
    when(
      () => mockClient.listIssues(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListIssuesResponse()));
  }

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

  connectionAwarenessTests(
    label: 'PipelinesNotifier',
    provider: pipelinesProvider,
    serviceOverrides: () => [
      gitlabServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.listPipelines(any())),
  );

  errorHandlingTests(
    label: 'PipelinesNotifier',
    provider: pipelinesProvider,
    errorOverrides: (error) => [
      gitlabServiceProvider.overrideWithValue(_FailingGitLabClient(error)),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<PipelineInfo>>(
      provider: pipelinesProvider,
      label: 'PipelinesNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listPipelines(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListPipelinesResponse(
              pipelines: [PipelineInfo(id: Int64(1), refName: 'main')],
            ),
          ),
        );
      },
      stubRefreshed: () {
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
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(
          () => mockClient.listPipelines(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListPipelinesResponse()));
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listPipelines(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].refName,
    ),
  );

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

  connectionAwarenessTests(
    label: 'MergeRequestsNotifier',
    provider: mergeRequestsProvider,
    serviceOverrides: () => [
      gitlabServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () =>
        verifyNever(() => mockClient.listMergeRequests(any())),
  );

  errorHandlingTests(
    label: 'MergeRequestsNotifier',
    provider: mergeRequestsProvider,
    errorOverrides: (error) => [
      gitlabServiceProvider.overrideWithValue(_FailingGitLabClient(error)),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<MergeRequestInfo>>(
      provider: mergeRequestsProvider,
      label: 'MergeRequestsNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listMergeRequests(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListMergeRequestsResponse(
              mergeRequests: [MergeRequestInfo(id: Int64(1), title: 'First')],
            ),
          ),
        );
      },
      stubRefreshed: () {
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
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(() => mockClient.listMergeRequests(any())).thenAnswer(
          (_) => FakeResponseFuture.value(ListMergeRequestsResponse()),
        );
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listMergeRequests(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].title,
    ),
  );

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

  connectionAwarenessTests(
    label: 'IssuesNotifier',
    provider: issuesProvider,
    serviceOverrides: () => [
      gitlabServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.listIssues(any())),
  );

  errorHandlingTests(
    label: 'IssuesNotifier',
    provider: issuesProvider,
    errorOverrides: (error) => [
      gitlabServiceProvider.overrideWithValue(_FailingGitLabClient(error)),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<IssueInfo>>(
      provider: issuesProvider,
      label: 'IssuesNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listIssues(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListIssuesResponse(
              issues: [IssueInfo(id: Int64(1), title: 'First')],
            ),
          ),
        );
      },
      stubRefreshed: () {
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
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(
          () => mockClient.listIssues(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListIssuesResponse()));
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listIssues(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].title,
    ),
  );

  // -------------------------------------------------------------------------
  // MergeRequestsNotifier - getMergeRequest
  // -------------------------------------------------------------------------

  group('MergeRequestsNotifier - getMergeRequest', () {
    test('returns merge request info on success', () async {
      await initNotifier(
        container: container,
        provider: mergeRequestsProvider,
        stubEmpty: stubMergeRequestsEmpty,
      );

      final expectedMr = MergeRequestInfo(
        id: Int64(42),
        iid: Int64(123),
        title: 'Refactor DB layer',
        state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
        sourceBranch: 'feature/db',
        targetBranch: 'main',
      );
      when(() => mockClient.getMergeRequest(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetMergeRequestResponse(mergeRequest: expectedMr),
        ),
      );

      final notifier = container.read(mergeRequestsProvider.notifier);
      final result = await notifier.getMergeRequest(
        project: 'my-group/my-project',
        iid: Int64(123),
      );

      expect(result.id, Int64(42));
      expect(result.iid, Int64(123));
      expect(result.title, 'Refactor DB layer');
      expect(result.state, MergeRequestState.MERGE_REQUEST_STATE_OPENED);
      expect(result.sourceBranch, 'feature/db');
      expect(result.targetBranch, 'main');
    });

    test('sends correct project and iid in request', () async {
      await initNotifier(
        container: container,
        provider: mergeRequestsProvider,
        stubEmpty: stubMergeRequestsEmpty,
      );

      when(() => mockClient.getMergeRequest(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetMergeRequestResponse(
            mergeRequest: MergeRequestInfo(iid: Int64(55)),
          ),
        ),
      );

      final notifier = container.read(mergeRequestsProvider.notifier);
      await notifier.getMergeRequest(project: 'org/repo', iid: Int64(55));

      final captured =
          verify(() => mockClient.getMergeRequest(captureAny())).captured.single
              as GetMergeRequestRequest;

      expect(captured.project, 'org/repo');
      expect(captured.iid, Int64(55));
    });
  });

  // -------------------------------------------------------------------------
  // PipelinesNotifier - getPipeline
  // -------------------------------------------------------------------------

  group('PipelinesNotifier - getPipeline', () {
    test('returns pipeline info on success', () async {
      await initNotifier(
        container: container,
        provider: pipelinesProvider,
        stubEmpty: stubPipelinesEmpty,
      );

      final expectedPipeline = PipelineInfo(
        id: Int64(99),
        status: PipelineStatus.PIPELINE_STATUS_SUCCESS,
        refName: 'main',
        sha: 'abc123deadbeef',
        source: 'push',
        webUrl: 'https://gitlab.com/p/99',
      );
      when(() => mockClient.getPipeline(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetPipelineResponse(pipeline: expectedPipeline),
        ),
      );

      final notifier = container.read(pipelinesProvider.notifier);
      final result = await notifier.getPipeline(
        project: 'my-group/my-project',
        pipelineId: Int64(99),
      );

      expect(result.id, Int64(99));
      expect(result.status, PipelineStatus.PIPELINE_STATUS_SUCCESS);
      expect(result.refName, 'main');
      expect(result.sha, 'abc123deadbeef');
      expect(result.source, 'push');
      expect(result.webUrl, 'https://gitlab.com/p/99');
    });

    test('sends correct project and pipelineId in request', () async {
      await initNotifier(
        container: container,
        provider: pipelinesProvider,
        stubEmpty: stubPipelinesEmpty,
      );

      when(() => mockClient.getPipeline(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetPipelineResponse(pipeline: PipelineInfo(id: Int64(77))),
        ),
      );

      final notifier = container.read(pipelinesProvider.notifier);
      await notifier.getPipeline(project: 'org/repo', pipelineId: Int64(77));

      final captured =
          verify(() => mockClient.getPipeline(captureAny())).captured.single
              as GetPipelineRequest;

      expect(captured.project, 'org/repo');
      expect(captured.pipelineId, Int64(77));
    });
  });

  // -------------------------------------------------------------------------
  // IssuesNotifier - getIssue
  // -------------------------------------------------------------------------

  group('IssuesNotifier - getIssue', () {
    test('returns issue info on success', () async {
      await initNotifier(
        container: container,
        provider: issuesProvider,
        stubEmpty: stubIssuesEmpty,
      );

      final expectedIssue = IssueInfo(
        id: Int64(42),
        iid: Int64(15),
        title: 'Fix login bug',
        state: IssueState.ISSUE_STATE_OPENED,
        author: 'alice',
        labels: ['bug', 'urgent'],
        confidential: false,
        webUrl: 'https://gitlab.com/issues/15',
      );
      when(() => mockClient.getIssue(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetIssueResponse(issue: expectedIssue)),
      );

      final notifier = container.read(issuesProvider.notifier);
      final result = await notifier.getIssue(
        project: 'my-group/my-project',
        iid: Int64(15),
      );

      expect(result.id, Int64(42));
      expect(result.iid, Int64(15));
      expect(result.title, 'Fix login bug');
      expect(result.state, IssueState.ISSUE_STATE_OPENED);
      expect(result.author, 'alice');
      expect(result.labels, ['bug', 'urgent']);
      expect(result.confidential, isFalse);
      expect(result.webUrl, 'https://gitlab.com/issues/15');
    });

    test('sends correct project and iid in request', () async {
      await initNotifier(
        container: container,
        provider: issuesProvider,
        stubEmpty: stubIssuesEmpty,
      );

      when(() => mockClient.getIssue(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetIssueResponse(issue: IssueInfo(iid: Int64(33))),
        ),
      );

      final notifier = container.read(issuesProvider.notifier);
      await notifier.getIssue(project: 'org/repo', iid: Int64(33));

      final captured =
          verify(() => mockClient.getIssue(captureAny())).captured.single
              as GetIssueRequest;

      expect(captured.project, 'org/repo');
      expect(captured.iid, Int64(33));
    });
  });
}
