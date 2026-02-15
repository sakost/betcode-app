
import 'package:drift/drift.dart' show Batch;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

class MockAppDatabase extends Mock implements AppDatabase {}

/// A fake client whose [listSessions] always throws [GrpcError].
class _FailingAgentClient extends Fake implements AgentServiceClient {
  _FailingAgentClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListSessionsResponse> listSessions(
    ListSessionsRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockAgentServiceClient mockClient;
  late MockAppDatabase mockDb;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListSessionsRequest());
    registerFallbackValue(RenameSessionRequest());
    registerFallbackValue(CompactSessionRequest());
    registerFallbackValue((Batch _) async {});
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    mockDb = MockAppDatabase();

    // Database batch is a no-op in tests.
    when(() => mockDb.batch(any())).thenAnswer((_) async {});

    container = createTestContainer(
      overrides: [
        agentServiceProvider.overrideWithValue(mockClient),
        appDatabaseProvider.overrideWithValue(mockDb),
      ],
    );
  });

  tearDown(() => container.dispose());

  SessionSummary makeSession(String id, {String model = 'opus'}) =>
      SessionSummary(id: id, model: model, status: 'active');

  group('SessionsNotifier - build', () {
    test('fetches first page of sessions', () async {
      final sessions = [makeSession('s-1'), makeSession('s-2')];
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: sessions, total: 2),
        ),
      );

      final result = await container.read(sessionsProvider.future);

      expect(result, hasLength(2));
      expect(result[0].id, 's-1');
      expect(result[1].id, 's-2');
    });

    test('passes correct page size to gRPC', () async {
      when(
        () => mockClient.listSessions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));

      await container.read(sessionsProvider.future);

      final captured =
          verify(() => mockClient.listSessions(captureAny())).captured.single
              as ListSessionsRequest;

      expect(captured.limit, 20);
      expect(captured.offset, 0);
    });

    test('returns empty list when no sessions exist', () async {
      when(
        () => mockClient.listSessions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));

      final result = await container.read(sessionsProvider.future);
      expect(result, isEmpty);
    });

    test('caches sessions to the local database', () async {
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );

      await container.read(sessionsProvider.future);

      verify(() => mockDb.batch(any())).called(1);
    });

    test('preserves session fields from the response', () async {
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(
            sessions: [
              SessionSummary(
                id: 'sess-42',
                model: 'sonnet',
                workingDirectory: '/home/user/project',
                status: 'idle',
                messageCount: 15,
                totalCostUsd: 0.03,
                lastMessagePreview: 'Hello world',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(sessionsProvider.future);

      expect(result, hasLength(1));
      final session = result.first;
      expect(session.id, 'sess-42');
      expect(session.model, 'sonnet');
      expect(session.workingDirectory, '/home/user/project');
      expect(session.status, 'idle');
      expect(session.messageCount, 15);
      expect(session.totalCostUsd, 0.03);
      expect(session.lastMessagePreview, 'Hello world');
    });
  });

  group('SessionsNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          agentServiceProvider.overrideWithValue(mockClient),
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(sessionsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(sessionsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [
          agentServiceProvider.overrideWithValue(mockClient),
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(sessionsProvider);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockClient.listSessions(any()));
    });
  });

  group('SessionsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = createTestContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(
            _FailingAgentClient(GrpcError.unavailable('connection refused')),
          ),
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
      addTearDown(errContainer.dispose);

      // Trigger build and let microtasks settle.
      errContainer.read(sessionsProvider);
      await Future<void>.delayed(Duration.zero);

      // Riverpod 3.x retries failed builds so the state is
      // AsyncLoading(error: ..., retrying) rather than AsyncError.
      final state = errContainer.read(sessionsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = createTestContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(
            _FailingAgentClient(GrpcError.unavailable('daemon unreachable')),
          ),
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(sessionsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(sessionsProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('SessionsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      // Initial fetch
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      // Refresh with updated data
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(
            sessions: [makeSession('s-1'), makeSession('s-new')],
          ),
        ),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.refresh();

      final state = container.read(sessionsProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].id, 's-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<SessionSummary>>>[];

      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      container.listen(sessionsProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-2')]),
        ),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.id, 's-2');
    });

    test('recovers from error state on refresh', () async {
      // Use a mock that we can re-stub after the initial error.
      final errClient = MockAgentServiceClient();
      when(
        () => errClient.listSessions(any()),
      ).thenThrow(GrpcError.unavailable());

      final errContainer = createTestContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(errClient),
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
      addTearDown(errContainer.dispose);

      // Trigger build and let error settle.
      errContainer.read(sessionsProvider);
      await Future<void>.delayed(Duration.zero);

      // Now re-stub to succeed.
      when(() => errClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('recovered')]),
        ),
      );

      final notifier = errContainer.read(sessionsProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(sessionsProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.id, 'recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.listSessions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));
      await container.read(sessionsProvider.future);

      // Reset call count
      reset(mockClient);
      when(
        () => mockClient.listSessions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listSessions(any())).called(1);
    });
  });

  group('SessionsNotifier - renameSession', () {
    test('calls renameSession RPC with correct arguments', () async {
      // Initial build
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      when(() => mockClient.renameSession(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RenameSessionResponse()),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.renameSession(sessionId: 's-1', name: 'My Session');

      final captured =
          verify(() => mockClient.renameSession(captureAny())).captured.single
              as RenameSessionRequest;
      expect(captured.sessionId, 's-1');
      expect(captured.name, 'My Session');
    });

    test('refreshes sessions after rename', () async {
      // Initial build
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      when(() => mockClient.renameSession(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RenameSessionResponse()),
      );

      // After rename, refresh returns session with new name
      final renamedSession = makeSession('s-1');
      renamedSession.name = 'Renamed';
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [renamedSession]),
        ),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.renameSession(sessionId: 's-1', name: 'Renamed');

      final state = container.read(sessionsProvider);
      expect(state.value!.first.name, 'Renamed');
    });
  });

  group('SessionsNotifier - compactSession', () {
    test('calls compactSession RPC with correct session ID', () async {
      // Build initial state
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      when(() => mockClient.compactSession(any())).thenAnswer(
        (_) => FakeResponseFuture.value(CompactSessionResponse(
          messagesBefore: 100,
          messagesAfter: 50,
          tokensSaved: 5000,
        )),
      );

      final notifier = container.read(sessionsProvider.notifier);
      final result = await notifier.compactSession('s-1');

      final captured = verify(() => mockClient.compactSession(captureAny()))
          .captured
          .single as CompactSessionRequest;
      expect(captured.sessionId, 's-1');
      expect(result.messagesBefore, 100);
      expect(result.messagesAfter, 50);
      expect(result.tokensSaved, 5000);
    });

    test('refreshes sessions after compaction', () async {
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListSessionsResponse()),
      );
      await container.read(sessionsProvider.future);

      when(() => mockClient.compactSession(any())).thenAnswer(
        (_) => FakeResponseFuture.value(CompactSessionResponse()),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.compactSession('s-1');

      // listSessions is called once for build, once for refresh after compact
      verify(() => mockClient.listSessions(any())).called(2);
    });
  });
}
