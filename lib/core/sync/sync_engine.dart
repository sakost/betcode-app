import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../grpc/service_providers.dart';
import '../storage/storage.dart';
import 'connectivity.dart';
import 'sync_dispatcher.dart';

class SyncStatus {
  const SyncStatus({
    this.pendingCount = 0,
    this.failedCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
    this.lastError,
  });

  final int pendingCount;
  final int failedCount;
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final String? lastError;
}

class SyncEngine {
  SyncEngine({
    required AppDatabase database,
    required ConnectivityMonitor connectivity,
    required SyncDispatcher dispatcher,
  }) : _database = database,
       _connectivity = connectivity,
       _dispatcher = dispatcher;

  final AppDatabase _database;
  final ConnectivityMonitor _connectivity;
  final SyncDispatcher _dispatcher;
  final _uuid = const Uuid();
  final _statusController = StreamController<SyncStatus>.broadcast();
  final _random = Random();

  StreamSubscription<NetworkStatus>? _connectivitySub;
  Timer? _drainTimer;
  bool _isSyncing = false;
  bool _disposed = false;
  int _sequence = 0;

  Stream<SyncStatus> get statusStream => _statusController.stream;

  static const _stabilityDelay = Duration(seconds: 3);
  static const _maxRetries = 5;
  static const _ttlSeconds = 7 * 24 * 60 * 60; // 7 days

  String generateIdempotencyKey() => _uuid.v7();

  int _nextSequence() => _sequence++;

  void start() {
    _connectivitySub = _connectivity.statusStream.listen((status) {
      if (status == NetworkStatus.online) {
        // Wait for connection stability before draining
        _drainTimer?.cancel();
        _drainTimer = Timer(_stabilityDelay, _drainQueue);
      }
    });
  }

  void dispose() {
    _disposed = true;
    _connectivitySub?.cancel();
    _drainTimer?.cancel();
    _statusController.close();
  }

  /// Add an item to the offline sync queue.
  ///
  /// The item is immediately persisted to the local drift database and will
  /// be dispatched via gRPC when the device is online. If the engine is
  /// currently online and not already syncing, a drain cycle is triggered
  /// immediately.
  Future<void> enqueue({
    required String machineId,
    required String requestType,
    required Uint8List payload,
    String? sessionId,
    int priority = 4,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _database
        .into(_database.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            machineId: machineId,
            requestType: requestType,
            payload: payload,
            idempotencyKey: generateIdempotencyKey(),
            priority: Value(priority),
            sequence: _nextSequence(),
            createdAt: now,
            expiresAt: now + _ttlSeconds,
            sessionId: Value(sessionId),
          ),
        );
    // Trigger drain only if online and not already syncing
    if (!_isSyncing) {
      final status = await _connectivity.currentStatus;
      if (status == NetworkStatus.online) {
        _drainQueue();
      }
    }
  }

  /// Query the number of items with 'pending' or 'blocked' status.
  Future<int> pendingCount() async {
    final query = _database.select(_database.syncQueue)
      ..where((t) => t.status.isIn(const ['pending', 'blocked']));
    final rows = await query.get();
    return rows.length;
  }

  Future<void> _drainQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;
    await _emitStatus();

    try {
      await _cleanupExpired();

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Fetch all processable items ordered by priority (ascending) then
      // insertion sequence (ascending) so that higher-priority items (lower
      // number) are dispatched first.
      final query = _database.select(_database.syncQueue)
        ..where(
          (t) =>
              t.status.isIn(const ['pending', 'blocked']) &
              t.expiresAt.isBiggerThanValue(now),
        )
        ..orderBy([
          (t) => OrderingTerm.asc(t.priority),
          (t) => OrderingTerm.asc(t.sequence),
        ]);

      final items = await query.get();

      for (final item in items) {
        // Mark as sending
        await (_database.update(_database.syncQueue)
              ..where((t) => t.id.equals(item.id)))
            .write(const SyncQueueCompanion(status: Value('sending')));

        try {
          await _dispatcher.dispatch(item);
          await (_database.update(_database.syncQueue)
                ..where((t) => t.id.equals(item.id)))
              .write(const SyncQueueCompanion(status: Value('sent')));
        } catch (e) {
          final newRetryCount = item.retryCount + 1;
          final newStatus = newRetryCount >= _maxRetries ? 'failed' : 'blocked';

          await (_database.update(
            _database.syncQueue,
          )..where((t) => t.id.equals(item.id))).write(
            SyncQueueCompanion(
              status: Value(newStatus),
              retryCount: Value(newRetryCount),
              lastError: Value(e.toString()),
            ),
          );
        }
      }
    } catch (e) {
      if (!_disposed) {
        _statusController.add(
          SyncStatus(isSyncing: false, lastError: e.toString()),
        );
      }
    } finally {
      _isSyncing = false;
      await _emitStatus();
    }
  }

  Future<void> _cleanupExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (_database.delete(
      _database.syncQueue,
    )..where((t) => t.expiresAt.isSmallerThanValue(now))).go();
  }

  Duration calculateBackoff(int retryCount) {
    const baseMs = 1000;
    const maxMs = 300000; // 5 minutes
    const jitterFactor = 0.2;

    final delay = min(baseMs * pow(2, retryCount).toInt(), maxMs);
    final jitter = (delay * jitterFactor * (_random.nextDouble() * 2 - 1))
        .toInt();
    return Duration(milliseconds: delay + jitter);
  }

  /// Emit the current sync status with real counts from the database.
  Future<void> _emitStatus() async {
    if (_disposed) return;
    try {
      final pendingQuery = _database.select(_database.syncQueue)
        ..where((t) => t.status.isIn(const ['pending', 'blocked']));
      final pendingRows = await pendingQuery.get();

      final failedQuery = _database.select(_database.syncQueue)
        ..where((t) => t.status.equals('failed'));
      final failedRows = await failedQuery.get();

      if (!_disposed) {
        _statusController.add(
          SyncStatus(
            pendingCount: pendingRows.length,
            failedCount: failedRows.length,
            isSyncing: _isSyncing,
            lastSyncTime: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      // If we cannot query the database for counts (e.g. mock not wired),
      // fall back to a status without counts.
      if (!_disposed) {
        _statusController.add(
          SyncStatus(isSyncing: _isSyncing, lastSyncTime: DateTime.now()),
        );
      }
    }
  }
}

final syncDispatcherProvider = Provider<SyncDispatcher>((ref) {
  final agentClient = ref.watch(agentServiceProvider);
  final worktreeClient = ref.watch(worktreeServiceProvider);
  return SyncDispatcher(
    agentClient: agentClient,
    worktreeClient: worktreeClient,
  );
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityMonitorProvider);
  final dispatcher = ref.watch(syncDispatcherProvider);
  final engine = SyncEngine(
    database: db,
    connectivity: connectivity,
    dispatcher: dispatcher,
  )..start();
  ref.onDispose(engine.dispose);
  return engine;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
});
