import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/git_repos/notifiers/branches_provider.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockGitRepoServiceClient extends Mock implements GitRepoServiceClient {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockGitRepoServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListBranchesRequest());
  });

  setUp(() {
    mockClient = MockGitRepoServiceClient();
    container = createTestContainer(
      overrides: [gitRepoServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  test('returns branches from gRPC listBranches', () async {
    final branches = [
      BranchInfo(name: 'main', isHead: true, commitSha: 'abc123'),
      BranchInfo(name: 'develop', commitSha: 'def456'),
    ];

    when(() => mockClient.listBranches(any())).thenAnswer(
      (_) => FakeResponseFuture.value(
        ListBranchesResponse(branches: branches),
      ),
    );

    final result = await container.read(branchesProvider('repo-1').future);

    expect(result, hasLength(2));
    expect(result[0].name, 'main');
    expect(result[0].isHead, isTrue);
    expect(result[1].name, 'develop');

    verify(
      () => mockClient.listBranches(
        any(that: isA<ListBranchesRequest>()),
      ),
    ).called(1);
  });

  test('passes repoId to the request', () async {
    when(() => mockClient.listBranches(any())).thenAnswer(
      (_) => FakeResponseFuture.value(ListBranchesResponse()),
    );

    await container.read(branchesProvider('my-repo-42').future);

    final captured = verify(
      () => mockClient.listBranches(captureAny()),
    ).captured.single as ListBranchesRequest;

    expect(captured.repoId, 'my-repo-42');
  });

  test('propagates gRPC errors', () async {
    when(() => mockClient.listBranches(any())).thenThrow(
      Exception('connection refused'),
    );

    container.read(branchesProvider('repo-1'));

    // Allow multiple microtasks for the error to propagate through riverpod.
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(branchesProvider('repo-1'));
    expect(state.hasError, isTrue);
    expect(state.error, isA<Exception>());
  });
}
