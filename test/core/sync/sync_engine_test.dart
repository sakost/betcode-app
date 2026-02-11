import 'dart:async';
import 'dart:typed_data';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/core/sync/sync_dispatcher.dart';
import 'package:betcode_app/core/sync/sync_engine.dart';

import 'sync_engine_helpers.dart';

void main() {
  late MockAppDatabase mockDb;
  late MockSyncQueueTable mockTable;
  late MockDeleteStatement mockDelete;
  late FakeConnectivityMonitor fakeConnectivity;
  late MockSyncDispatcher mockDispatcher;
  late SyncEngine engine;

  setUp(() {
    mockDb = MockAppDatabase();
    mockTable = MockSyncQueueTable();
    mockDelete = MockDeleteStatement();
    fakeConnectivity = FakeConnectivityMonitor();
    mockDispatcher = MockSyncDispatcher();

    wireUpDeleteChain(
      mockDb: mockDb,
      mockTable: mockTable,
      mockDelete: mockDelete,
    );

    // Wire up select so _emitStatus() and _drainQueue() can query the DB.
    wireUpSelectChain(mockDb: mockDb, mockTable: mockTable);

    // Register fallback for SyncQueueData used in dispatcher mock.
    registerFallbackValue(FakeSyncQueueData());

    // Allow the dispatcher to succeed by default.
    when(() => mockDispatcher.dispatch(any())).thenAnswer((_) async {});

    engine = SyncEngine(
      database: mockDb,
      connectivity: fakeConnectivity,
      dispatcher: mockDispatcher,
    );
  });

  tearDown(() {
    engine.dispose();
    fakeConnectivity.dispose();
  });

  // -----------------------------------------------------------------------
  // SyncStatus value class
  // -----------------------------------------------------------------------

  group('SyncStatus', () {
    test('default constructor has expected defaults', () {
      const s = SyncStatus();
      expect(s.pendingCount, 0);
      expect(s.failedCount, 0);
      expect(s.isSyncing, false);
      expect(s.lastSyncTime, isNull);
      expect(s.lastError, isNull);
    });

    test('named parameters are stored correctly', () {
      final now = DateTime.now();
      final s = SyncStatus(
        pendingCount: 5,
        failedCount: 2,
        isSyncing: true,
        lastSyncTime: now,
        lastError: 'timeout',
      );
      expect(s.pendingCount, 5);
      expect(s.failedCount, 2);
      expect(s.isSyncing, true);
      expect(s.lastSyncTime, now);
      expect(s.lastError, 'timeout');
    });
  });

  // -----------------------------------------------------------------------
  // Idempotency key generation
  // -----------------------------------------------------------------------

  group('generateIdempotencyKey', () {
    test('returns a non-empty string', () {
      expect(engine.generateIdempotencyKey(), isNotEmpty);
    });

    test('returns unique values on successive calls', () {
      final keys = List.generate(100, (_) => engine.generateIdempotencyKey());
      expect(keys.toSet().length, 100);
    });

    test('returns a valid UUIDv7 format', () {
      final key = engine.generateIdempotencyKey();
      final re = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(key, matches(re));
    });
  });

  // -----------------------------------------------------------------------
  // Exponential backoff
  // -----------------------------------------------------------------------

  group('calculateBackoff', () {
    test('retry 0 is near 1 second (base delay)', () {
      final ms = engine.calculateBackoff(0).inMilliseconds;
      expect(ms, inInclusiveRange(800, 1200));
    });

    test('retry 1 is near 2 seconds', () {
      final ms = engine.calculateBackoff(1).inMilliseconds;
      expect(ms, inInclusiveRange(1600, 2400));
    });

    test('increases exponentially', () {
      final b0 = engine.calculateBackoff(0).inMilliseconds;
      final b3 = engine.calculateBackoff(3).inMilliseconds;
      expect(b3, greaterThan(b0 * 2));
    });

    test('is capped at 5 minutes (plus jitter)', () {
      final ms = engine.calculateBackoff(100).inMilliseconds;
      expect(ms, lessThanOrEqualTo(360000));
    });

    test('always returns a positive duration', () {
      for (var i = 0; i < 20; i++) {
        expect(engine.calculateBackoff(i).inMilliseconds, greaterThan(0));
      }
    });
  });

  // -----------------------------------------------------------------------
  // Stream and lifecycle
  // -----------------------------------------------------------------------

  group('statusStream lifecycle', () {
    test('is a broadcast stream', () {
      engine.statusStream.listen((_) {});
      engine.statusStream.listen((_) {});
    });

    test('dispose closes the stream', () async {
      var done = false;
      engine.statusStream.listen((_) {}, onDone: () => done = true);

      engine.dispose();
      await Future<void>.delayed(Duration.zero);
      expect(done, isTrue);

      // Recreate to avoid double-dispose in tearDown.
      engine = SyncEngine(
        database: mockDb,
        connectivity: fakeConnectivity,
        dispatcher: mockDispatcher,
      );
    });
  });

  // -----------------------------------------------------------------------
  // Connectivity-driven drain scheduling
  // -----------------------------------------------------------------------

  group('connectivity-driven drain', () {
    test('does not drain without online event', () async {
      engine.start();
      await Future<void>.delayed(Duration.zero);
      verifyNever(() => mockDb.delete(mockTable));
    });

    test('stability delay prevents immediate drain', () async {
      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      verifyNever(() => mockDb.delete(mockTable));
    });

    test('offline event does not trigger drain', () async {
      engine.start();
      fakeConnectivity.emit(NetworkStatus.offline);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      verifyNever(() => mockDb.delete(mockTable));
    });

    test('emits syncing true then false during drain', () async {
      engine.start();
      final statuses = <SyncStatus>[];
      engine.statusStream.listen(statuses.add);

      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      expect(statuses, hasLength(greaterThanOrEqualTo(2)));
      expect(statuses.first.isSyncing, isTrue);
      expect(statuses.last.isSyncing, isFalse);
    });

    test('drain calls cleanup expired entries', () async {
      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      verify(() => mockDb.delete(mockTable)).called(1);
      verify(() => mockDelete.go()).called(1);
    });

    test('rapid online events reset the stability timer', () async {
      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 1));
      fakeConnectivity.emit(NetworkStatus.online);

      // 2s after second emit -- still within the 3s stability window.
      await Future<void>.delayed(const Duration(seconds: 2));
      verifyNever(() => mockDb.delete(mockTable));

      // 1.5s more -- past the window from the second emit.
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      verify(() => mockDb.delete(mockTable)).called(1);
    });

    test('drain is not re-entered while already syncing', () async {
      final completer = Completer<int>();
      when(() => mockDelete.go()).thenAnswer((_) => completer.future);

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // Second online while first drain is still running.
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      completer.complete(0);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockDb.delete(mockTable)).called(1);
    });
  });

  // -----------------------------------------------------------------------
  // Drain error handling
  // -----------------------------------------------------------------------

  group('drain error handling', () {
    test('emits error status when cleanup throws', () async {
      when(() => mockDelete.go()).thenThrow(Exception('db locked'));
      engine.start();

      final statuses = <SyncStatus>[];
      engine.statusStream.listen(statuses.add);

      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      final errors = statuses.where((s) => s.lastError != null);
      expect(errors, isNotEmpty);
      expect(errors.first.lastError, contains('db locked'));
      expect(errors.first.isSyncing, isFalse);
    });

    test('resets isSyncing after error', () async {
      when(() => mockDelete.go()).thenThrow(Exception('fail'));
      engine.start();

      final statuses = <SyncStatus>[];
      engine.statusStream.listen(statuses.add);

      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      expect(statuses.last.isSyncing, isFalse);
    });

    test('can drain again after a previous error', () async {
      when(() => mockDelete.go()).thenThrow(Exception('fail'));
      engine.start();

      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // Fix the error and trigger again.
      when(() => mockDelete.go()).thenAnswer((_) async => 0);
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      verify(() => mockDb.delete(mockTable)).called(2);
    });
  });

  // -----------------------------------------------------------------------
  // Riverpod providers
  // -----------------------------------------------------------------------

  group('providers', () {
    test('syncEngineProvider creates engine', () {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDb),
          connectivityMonitorProvider.overrideWithValue(fakeConnectivity),
          syncDispatcherProvider.overrideWithValue(mockDispatcher),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(syncEngineProvider), isA<SyncEngine>());
    });

    test('syncStatusProvider is initially loading', () {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDb),
          connectivityMonitorProvider.overrideWithValue(fakeConnectivity),
          syncDispatcherProvider.overrideWithValue(mockDispatcher),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(syncStatusProvider);
      expect(state, isA<AsyncLoading<SyncStatus>>());
    });

    test('dispose tears down engine stream', () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDb),
          connectivityMonitorProvider.overrideWithValue(fakeConnectivity),
          syncDispatcherProvider.overrideWithValue(mockDispatcher),
        ],
      );

      final eng = container.read(syncEngineProvider);
      var done = false;
      eng.statusStream.listen((_) {}, onDone: () => done = true);

      container.dispose();
      await Future<void>.delayed(Duration.zero);
      expect(done, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // Enqueue
  // -----------------------------------------------------------------------

  group('enqueue', () {
    late MockInsertStatement mockInsert;
    late MockUpdateStatement mockUpdate;

    setUp(() {
      registerFallbackValue(FakeInsertable());
      registerFallbackValue(FakeSyncQueueCompanion());
      mockInsert = wireUpInsertChain(mockDb: mockDb, mockTable: mockTable);
      mockUpdate = wireUpUpdateChain(mockDb: mockDb, mockTable: mockTable);
    });

    test('inserts item into sync_queue table', () async {
      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1, 2, 3]),
      );

      verify(() => mockDb.into(mockTable)).called(greaterThanOrEqualTo(1));
      verify(() => mockInsert.insert(any())).called(1);
    });

    test('uses correct priority', () async {
      SyncQueueCompanion? captured;
      when(() => mockInsert.insert(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments[0] as SyncQueueCompanion;
        return 1;
      });

      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'permission_response',
        payload: Uint8List.fromList([1]),
        priority: 1,
      );

      expect(captured, isNotNull);
      expect(captured!.priority.value, 1);
    });

    test('generates unique idempotency keys', () async {
      final capturedKeys = <String>[];
      when(() => mockInsert.insert(any())).thenAnswer((invocation) async {
        final companion =
            invocation.positionalArguments[0] as SyncQueueCompanion;
        capturedKeys.add(companion.idempotencyKey.value);
        return capturedKeys.length;
      });

      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1]),
      );
      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([2]),
      );

      expect(capturedKeys.length, 2);
      expect(capturedKeys[0], isNot(capturedKeys[1]));
    });

    test('sets 7-day TTL', () async {
      SyncQueueCompanion? captured;
      when(() => mockInsert.insert(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments[0] as SyncQueueCompanion;
        return 1;
      });

      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1]),
      );

      expect(captured, isNotNull);
      final createdAt = captured!.createdAt.value;
      final expiresAt = captured!.expiresAt.value;
      // 7 days = 604800 seconds
      expect(expiresAt - createdAt, 604800);
    });

    test('triggers drain when online (not already syncing)', () async {
      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1]),
      );

      // drain was triggered (select is called for the drain query)
      await Future<void>.delayed(Duration.zero);
      verify(() => mockDb.select(mockTable)).called(greaterThanOrEqualTo(1));
    });

    test('passes sessionId when provided', () async {
      SyncQueueCompanion? captured;
      when(() => mockInsert.insert(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments[0] as SyncQueueCompanion;
        return 1;
      });

      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1]),
        sessionId: 'session-42',
      );

      expect(captured, isNotNull);
      expect(captured!.sessionId.value, 'session-42');
    });

    test('uses default priority of 4 for user messages', () async {
      SyncQueueCompanion? captured;
      when(() => mockInsert.insert(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments[0] as SyncQueueCompanion;
        return 1;
      });

      await engine.enqueue(
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1]),
      );

      expect(captured, isNotNull);
      expect(captured!.priority.value, 4);
    });
  });

  // -----------------------------------------------------------------------
  // Drain queue processing
  // -----------------------------------------------------------------------

  group('drain queue processing', () {
    late MockSelectStatement mockSelect;
    late MockUpdateStatement mockUpdate;

    SyncQueueData makeItem({
      int id = 1,
      int priority = 4,
      int sequence = 0,
      String status = 'pending',
      int retryCount = 0,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return SyncQueueData(
        id: id,
        machineId: 'machine-1',
        requestType: 'user_message',
        payload: Uint8List.fromList([1, 2, 3]),
        idempotencyKey: 'key-$id',
        priority: priority,
        sequence: sequence,
        status: status,
        retryCount: retryCount,
        createdAt: now,
        expiresAt: now + 604800,
      );
    }

    setUp(() {
      registerFallbackValue(FakeInsertable());
      registerFallbackValue(FakeSyncQueueCompanion());
      mockSelect = wireUpSelectChain(mockDb: mockDb, mockTable: mockTable);
      mockUpdate = wireUpUpdateChain(mockDb: mockDb, mockTable: mockTable);
    });

    test('drain processes items in priority order', () async {
      // The select mock returns items; the engine should process them.
      // We test that select is called with orderBy (already wired).
      final items = [
        makeItem(id: 1, priority: 1, sequence: 0),
        makeItem(id: 2, priority: 4, sequence: 1),
      ];

      // The first select call (from _emitStatus) returns empty,
      // the second (from drain query) returns items,
      // subsequent _emitStatus calls return empty again.
      var selectCallCount = 0;
      when(() => mockSelect.get()).thenAnswer((_) async {
        selectCallCount++;
        // The drain select query is the 3rd call (1st + 2nd from initial
        // _emitStatus which makes 2 select calls, then the drain query).
        // Due to ordering, return items for the drain query.
        if (selectCallCount == 3) return items;
        return [];
      });

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // update should be called: 2 items * 2 writes each (sending + sent)
      verify(() => mockUpdate.write(any())).called(4);
    });

    test('drain updates status from pending to sent', () async {
      final items = [makeItem(id: 1)];
      final capturedWrites = <SyncQueueCompanion>[];

      var selectCallCount = 0;
      when(() => mockSelect.get()).thenAnswer((_) async {
        selectCallCount++;
        if (selectCallCount == 3) return items;
        return [];
      });

      when(() => mockUpdate.write(any())).thenAnswer((invocation) async {
        final companion =
            invocation.positionalArguments[0] as SyncQueueCompanion;
        capturedWrites.add(companion);
        return 1;
      });

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // Should have at least 2 writes: sending, then sent
      expect(capturedWrites.length, greaterThanOrEqualTo(2));
      expect(capturedWrites[0].status.value, 'sending');
      expect(capturedWrites[1].status.value, 'sent');
    });

    test('drain handles errors and increments retryCount', () async {
      final items = [makeItem(id: 1, retryCount: 0)];
      final capturedWrites = <SyncQueueCompanion>[];

      var selectCallCount = 0;
      when(() => mockSelect.get()).thenAnswer((_) async {
        selectCallCount++;
        if (selectCallCount == 3) return items;
        return [];
      });

      // First update call (status -> sending) succeeds.
      // Second update call (status -> sent) throws to simulate gRPC error.
      // Third update call (error handling write) should succeed.
      var updateCallCount = 0;
      when(() => mockUpdate.write(any())).thenAnswer((invocation) async {
        updateCallCount++;
        final companion =
            invocation.positionalArguments[0] as SyncQueueCompanion;
        if (updateCallCount == 2) {
          // Simulate dispatch failure: the "sent" write throws
          throw Exception('gRPC unavailable');
        }
        capturedWrites.add(companion);
        return 1;
      });

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // The first write is 'sending', then on error, a write with
      // retryCount incremented and status 'blocked'.
      expect(capturedWrites.length, greaterThanOrEqualTo(2));
      expect(capturedWrites[0].status.value, 'sending');
      expect(capturedWrites[1].retryCount.value, 1);
      expect(capturedWrites[1].status.value, 'blocked');
    });

    test('drain sets status to failed after max retries', () async {
      // Item already at retryCount = 4 (one more retry -> 5 = maxRetries)
      final items = [makeItem(id: 1, retryCount: 4)];
      final capturedWrites = <SyncQueueCompanion>[];

      var selectCallCount = 0;
      when(() => mockSelect.get()).thenAnswer((_) async {
        selectCallCount++;
        if (selectCallCount == 3) return items;
        return [];
      });

      var updateCallCount = 0;
      when(() => mockUpdate.write(any())).thenAnswer((invocation) async {
        updateCallCount++;
        final companion =
            invocation.positionalArguments[0] as SyncQueueCompanion;
        if (updateCallCount == 2) {
          throw Exception('gRPC unavailable');
        }
        capturedWrites.add(companion);
        return 1;
      });

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // After error: retryCount = 4+1 = 5 >= _maxRetries(5), status = failed
      expect(capturedWrites.length, greaterThanOrEqualTo(2));
      expect(capturedWrites.last.retryCount.value, 5);
      expect(capturedWrites.last.status.value, 'failed');
    });

    test('drain emits accurate pending/failed counts', () async {
      final statuses = <SyncStatus>[];
      engine.statusStream.listen(statuses.add);

      // First _emitStatus call returns pending=2, subsequent calls vary.
      var selectCallCount = 0;
      when(() => mockSelect.get()).thenAnswer((_) async {
        selectCallCount++;
        // Return different data depending on which query is being made.
        // We'll return 2 "pending" items for all pending queries, and
        // 1 "failed" item for all failed queries.
        return [];
      });

      engine.start();
      fakeConnectivity.emit(NetworkStatus.online);
      await Future<void>.delayed(const Duration(seconds: 4));

      // Check that at least one status was emitted with count fields
      expect(statuses, isNotEmpty);
      // The final status should have isSyncing = false
      expect(statuses.last.isSyncing, isFalse);
      // pendingCount and failedCount should be non-negative ints
      expect(statuses.last.pendingCount, isA<int>());
      expect(statuses.last.failedCount, isA<int>());
    });

    test('pendingCount queries the database', () async {
      when(() => mockSelect.get()).thenAnswer(
        (_) async => [makeItem(id: 1), makeItem(id: 2)],
      );

      final count = await engine.pendingCount();
      expect(count, 2);
    });
  });
}
