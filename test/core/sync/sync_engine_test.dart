import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/core/sync/sync_engine.dart';

import 'sync_engine_helpers.dart';

void main() {
  late MockAppDatabase mockDb;
  late MockSyncQueueTable mockTable;
  late MockDeleteStatement mockDelete;
  late FakeConnectivityMonitor fakeConnectivity;
  late SyncEngine engine;

  setUp(() {
    mockDb = MockAppDatabase();
    mockTable = MockSyncQueueTable();
    mockDelete = MockDeleteStatement();
    fakeConnectivity = FakeConnectivityMonitor();

    wireUpDeleteChain(
      mockDb: mockDb,
      mockTable: mockTable,
      mockDelete: mockDelete,
    );

    engine = SyncEngine(database: mockDb, connectivity: fakeConnectivity);
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
      engine = SyncEngine(database: mockDb, connectivity: fakeConnectivity);
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
}
