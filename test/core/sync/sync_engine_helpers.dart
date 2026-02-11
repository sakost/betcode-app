import 'dart:async';

import 'package:drift/drift.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/core/sync/sync_dispatcher.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAppDatabase extends Mock implements AppDatabase {}

class MockSyncDispatcher extends Mock implements SyncDispatcher {}

class MockSyncQueueTable extends Mock implements $SyncQueueTable {}

class MockDeleteStatement extends Mock
    implements DeleteStatement<$SyncQueueTable, SyncQueueData> {}

class MockSelectStatement extends Mock
    implements SimpleSelectStatement<$SyncQueueTable, SyncQueueData> {}

class MockUpdateStatement extends Mock
    implements UpdateStatement<$SyncQueueTable, SyncQueueData> {}

class MockInsertStatement extends Mock
    implements InsertStatement<$SyncQueueTable, SyncQueueData> {}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// Fallback value for [SyncQueueCompanion] so mocktail can match `any()`.
class FakeSyncQueueCompanion extends Fake implements SyncQueueCompanion {}

/// Fallback value for [SyncQueueData] so mocktail can match `any()`.
class FakeSyncQueueData extends Fake implements SyncQueueData {}

/// Fallback value for [Insertable<SyncQueueData>] so mocktail can match `any()`.
class FakeInsertable extends Fake implements Insertable<SyncQueueData> {}

/// A controllable connectivity monitor for tests.
///
/// Instead of relying on the real [Connectivity] plugin, this exposes
/// a [StreamController] so tests can push [NetworkStatus] events at will.
class FakeConnectivityMonitor extends ConnectivityMonitor {
  FakeConnectivityMonitor({this.initialStatus = NetworkStatus.online})
    : _controller = StreamController<NetworkStatus>.broadcast();

  final StreamController<NetworkStatus> _controller;
  NetworkStatus _currentStatus = NetworkStatus.online;

  final NetworkStatus initialStatus;

  @override
  Stream<NetworkStatus> get statusStream => _controller.stream;

  @override
  Future<NetworkStatus> get currentStatus async => _currentStatus;

  /// Push a status event into the stream.
  void emit(NetworkStatus status) {
    _currentStatus = status;
    _controller.add(status);
  }

  @override
  void start() {
    // No-op: tests drive events via [emit].
  }

  @override
  void dispose() {
    _controller.close();
  }
}

// ---------------------------------------------------------------------------
// Setup helpers
// ---------------------------------------------------------------------------

/// Wires up the standard mock chain:
///   database.syncQueue -> mockTable
///   database.delete(table) -> mockDeleteStatement
///   deleteStatement.where(...) -> self
///   deleteStatement.go() -> completes with 0
void wireUpDeleteChain({
  required MockAppDatabase mockDb,
  required MockSyncQueueTable mockTable,
  required MockDeleteStatement mockDelete,
}) {
  when(() => mockDb.syncQueue).thenReturn(mockTable);
  when(() => mockDb.delete(mockTable)).thenReturn(mockDelete);
  when(() => mockDelete.where(any())).thenReturn(mockDelete);
  when(() => mockDelete.go()).thenAnswer((_) async => 0);
}

/// Wires up select mock chain so that `_emitStatus()` and `_drainQueue()`
/// can query the database without throwing. Returns the mock select
/// statement for further customisation.
///
/// By default, all selects return an empty list.
MockSelectStatement wireUpSelectChain({
  required MockAppDatabase mockDb,
  required MockSyncQueueTable mockTable,
  List<SyncQueueData> results = const [],
}) {
  final mockSelect = MockSelectStatement();
  when(() => mockDb.select(mockTable)).thenReturn(mockSelect);
  when(() => mockSelect.where(any())).thenReturn(mockSelect);
  when(() => mockSelect.orderBy(any())).thenReturn(mockSelect);
  when(() => mockSelect.get()).thenAnswer((_) async => results);
  return mockSelect;
}

/// Wires up update mock chain so that `_drainQueue()` can update item
/// statuses without throwing.
MockUpdateStatement wireUpUpdateChain({
  required MockAppDatabase mockDb,
  required MockSyncQueueTable mockTable,
}) {
  final mockUpdate = MockUpdateStatement();
  when(() => mockDb.update(mockTable)).thenReturn(mockUpdate);
  when(() => mockUpdate.where(any())).thenReturn(mockUpdate);
  when(() => mockUpdate.write(any())).thenAnswer((_) async => 0);
  return mockUpdate;
}

/// Wires up insert mock chain so that `enqueue()` can insert items.
MockInsertStatement wireUpInsertChain({
  required MockAppDatabase mockDb,
  required MockSyncQueueTable mockTable,
}) {
  final mockInsert = MockInsertStatement();
  when(() => mockDb.into(mockTable)).thenReturn(mockInsert);
  when(() => mockInsert.insert(any())).thenAnswer((_) async => 1);
  return mockInsert;
}

/// Wires up all database mock chains (delete, select, update, insert).
///
/// Returns a record with all mock statements for further customisation.
({
  MockDeleteStatement delete_,
  MockSelectStatement select_,
  MockUpdateStatement update_,
  MockInsertStatement insert_,
})
wireUpAllChains({
  required MockAppDatabase mockDb,
  required MockSyncQueueTable mockTable,
  required MockDeleteStatement mockDelete,
  List<SyncQueueData> selectResults = const [],
}) {
  wireUpDeleteChain(
    mockDb: mockDb,
    mockTable: mockTable,
    mockDelete: mockDelete,
  );
  final select_ = wireUpSelectChain(
    mockDb: mockDb,
    mockTable: mockTable,
    results: selectResults,
  );
  final update_ = wireUpUpdateChain(mockDb: mockDb, mockTable: mockTable);
  final insert_ = wireUpInsertChain(mockDb: mockDb, mockTable: mockTable);
  return (
    delete_: mockDelete,
    select_: select_,
    update_: update_,
    insert_: insert_,
  );
}
