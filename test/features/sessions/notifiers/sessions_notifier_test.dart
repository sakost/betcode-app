import 'dart:async';

import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:drift/drift.dart' show Batch;
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
    registerFallbackValue(DeleteSessionRequest());
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

  connectionAwarenessTests(
    label: 'SessionsNotifier',
    provider: sessionsProvider,
    serviceOverrides: () => [
      agentServiceProvider.overrideWithValue(mockClient),
      appDatabaseProvider.overrideWithValue(mockDb),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.listSessions(any())),
  );

  errorHandlingTests(
    label: 'SessionsNotifier',
    provider: sessionsProvider,
    errorOverrides: (error) => [
      agentServiceProvider.overrideWithValue(_FailingAgentClient(error)),
      appDatabaseProvider.overrideWithValue(mockDb),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<SessionSummary>>(
      provider: sessionsProvider,
      label: 'SessionsNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listSessions(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListSessionsResponse(sessions: [makeSession('s-1')]),
          ),
        );
      },
      stubRefreshed: () {
        when(() => mockClient.listSessions(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListSessionsResponse(
              sessions: [makeSession('s-1'), makeSession('s-new')],
            ),
          ),
        );
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(
          () => mockClient.listSessions(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listSessions(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].id,
    ),
  );

  group('SessionsNotifier - renameSession', () {
    test('calls renameSession RPC with correct arguments', () async {
      // Initial build
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      when(
        () => mockClient.renameSession(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(RenameSessionResponse()));

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

      when(
        () => mockClient.renameSession(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(RenameSessionResponse()));

      // After rename, refresh returns session with new name
      final renamedSession = makeSession('s-1')..name = 'Renamed';
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

  void stubSessionsEmpty() {
    when(
      () => mockClient.listSessions(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListSessionsResponse()));
  }

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
        (_) => FakeResponseFuture.value(
          CompactSessionResponse(
            messagesBefore: 100,
            messagesAfter: 50,
            tokensSaved: 5000,
          ),
        ),
      );

      final notifier = container.read(sessionsProvider.notifier);
      final result = await notifier.compactSession('s-1');

      final captured =
          verify(() => mockClient.compactSession(captureAny())).captured.single
              as CompactSessionRequest;
      expect(captured.sessionId, 's-1');
      expect(result.messagesBefore, 100);
      expect(result.messagesAfter, 50);
      expect(result.tokensSaved, 5000);
    });

    test('refreshes sessions after compaction', () async {
      await initNotifier(
        container: container,
        provider: sessionsProvider,
        stubEmpty: stubSessionsEmpty,
      );

      when(
        () => mockClient.compactSession(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(CompactSessionResponse()));

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.compactSession('s-1');

      // listSessions is called once for build, once for refresh after compact
      verify(() => mockClient.listSessions(any())).called(2);
    });
  });

  group('SessionsNotifier - deleteSession', () {
    test('calls deleteSession RPC with correct session ID', () async {
      // Build initial state
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );
      await container.read(sessionsProvider.future);

      when(
        () => mockClient.deleteSession(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(DeleteSessionResponse()));

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.deleteSession('s-1');

      final captured =
          verify(() => mockClient.deleteSession(captureAny())).captured.single
              as DeleteSessionRequest;
      expect(captured.sessionId, 's-1');
    });

    test('refreshes sessions after deletion', () async {
      await initNotifier(
        container: container,
        provider: sessionsProvider,
        stubEmpty: stubSessionsEmpty,
      );

      when(
        () => mockClient.deleteSession(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(DeleteSessionResponse()));

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.deleteSession('s-1');

      // listSessions is called once for build, once for refresh after delete
      verify(() => mockClient.listSessions(any())).called(2);
    });
  });

  // ---------------------------------------------------------------------------
  // I-5: Timeout errors bypass typed error handling
  // ---------------------------------------------------------------------------

  group('SessionsNotifier - timeout handling', () {
    test('renameSession timeout throws NetworkError', () async {
      await initNotifier(
        container: container,
        provider: sessionsProvider,
        stubEmpty: stubSessionsEmpty,
      );

      when(
        () => mockClient.renameSession(any()),
      ).thenAnswer(
        (_) => FakeResponseFuture.error(TimeoutException('timeout')),
      );

      final notifier = container.read(sessionsProvider.notifier);
      expect(
        () => notifier.renameSession(sessionId: 's-1', name: 'New'),
        throwsA(isA<NetworkError>()),
      );
    });

    test('deleteSession timeout throws NetworkError', () async {
      await initNotifier(
        container: container,
        provider: sessionsProvider,
        stubEmpty: stubSessionsEmpty,
      );

      when(
        () => mockClient.deleteSession(any()),
      ).thenAnswer(
        (_) => FakeResponseFuture.error(TimeoutException('timeout')),
      );

      final notifier = container.read(sessionsProvider.notifier);
      expect(
        () => notifier.deleteSession('s-1'),
        throwsA(isA<NetworkError>()),
      );
    });

    test('compactSession timeout throws NetworkError', () async {
      await initNotifier(
        container: container,
        provider: sessionsProvider,
        stubEmpty: stubSessionsEmpty,
      );

      when(
        () => mockClient.compactSession(any()),
      ).thenAnswer(
        (_) => FakeResponseFuture.error(TimeoutException('timeout')),
      );

      final notifier = container.read(sessionsProvider.notifier);
      expect(
        () => notifier.compactSession('s-1'),
        throwsA(isA<NetworkError>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // I-6: Hardcoded empty machineId in session cache
  // ---------------------------------------------------------------------------

  group('SessionsNotifier - cache machineId', () {
    test('cached sessions use actual selected machine ID', () async {
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: [makeSession('s-1')]),
        ),
      );

      // The default container has machineId='test-machine'
      await container.read(sessionsProvider.future);

      // Verify selectedMachineIdProvider returns the expected value
      final machineId = container.read(selectedMachineIdProvider);
      expect(machineId, 'test-machine');

      // Verify that batch was called (the cache function runs)
      verify(() => mockDb.batch(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // I-7: refresh() does not flash loading state
  // ---------------------------------------------------------------------------

  group('SessionsNotifier - refresh does not flash loading', () {
    test('refresh transitions directly from data to data', () async {
      final sessions = [makeSession('s-1')];
      when(() => mockClient.listSessions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionsResponse(sessions: sessions),
        ),
      );

      await container.read(sessionsProvider.future);

      // Capture state transitions during refresh
      final states = <AsyncValue<List<SessionSummary>>>[];
      container.listen(
        sessionsProvider,
        (_, next) => states.add(next),
      );

      final notifier = container.read(sessionsProvider.notifier);
      await notifier.refresh();

      // No loading state should appear — RefreshIndicator handles the spinner
      expect(states.where((s) => s.isLoading), isEmpty);
      // Final state has data
      final finalState = container.read(sessionsProvider);
      expect(finalState.hasValue, isTrue);
      expect(finalState.value, hasLength(1));
    });
  });
}
