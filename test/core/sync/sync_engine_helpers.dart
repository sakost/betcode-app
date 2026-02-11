import 'dart:async';

import 'package:drift/drift.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/sync/connectivity.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAppDatabase extends Mock implements AppDatabase {}

class MockSyncQueueTable extends Mock implements $SyncQueueTable {}

class MockDeleteStatement extends Mock
    implements DeleteStatement<$SyncQueueTable, SyncQueueData> {}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// A controllable connectivity monitor for tests.
///
/// Instead of relying on the real [Connectivity] plugin, this exposes
/// a [StreamController] so tests can push [NetworkStatus] events at will.
class FakeConnectivityMonitor extends ConnectivityMonitor {
  FakeConnectivityMonitor()
      : _controller = StreamController<NetworkStatus>.broadcast();

  final StreamController<NetworkStatus> _controller;

  @override
  Stream<NetworkStatus> get statusStream => _controller.stream;

  /// Push a status event into the stream.
  void emit(NetworkStatus status) => _controller.add(status);

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
// Setup helper
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
