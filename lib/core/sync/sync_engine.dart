import 'dart:async';
import 'dart:math';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/lifecycle/lifecycle.dart';
import 'package:betcode_app/core/storage/storage.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/core/sync/sync_dispatcher.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Snapshot of the current sync queue health, emitted on every drain cycle.
class SyncStatus {
  /// Creates a [SyncStatus] with the given counts and state.
  const SyncStatus({
    this.pendingCount = 0,
    this.failedCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
    this.lastError,
  });

  /// Number of items waiting to be dispatched.
  final int pendingCount;

  /// Number of items that have permanently failed after max retries.
  final int failedCount;

  /// Whether a drain cycle is currently in progress.
  final bool isSyncing;

  /// When the most recent drain cycle completed.
  final DateTime? lastSyncTime;

  /// Human-readable error from the most recent drain failure.
  final String? lastError;
}

/// Offline-first sync engine that queues gRPC requests in a local drift
/// database and drains them when the device is online.
class SyncEngine {
  /// Creates a [SyncEngine] backed by the given [database], [connectivity]
  /// monitor, and gRPC [dispatcher].
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
  bool _paused = false;
  int _sequence = 0;

  /// Broadcast stream of [SyncStatus] updates emitted after each drain cycle.
  Stream<SyncStatus> get statusStream => _statusController.stream;

  static const _stabilityDelay = Duration(seconds: 3);
  static const _maxRetries = 5;
  static const int _ttlSeconds = 7 * 24 * 60 * 60; // 7 days

  /// Generates a new UUIDv7 idempotency key for a queued request.
  String generateIdempotencyKey() => _uuid.v7();

  int _nextSequence() => _sequence++;

  /// Starts listening for connectivity changes and drains on reconnect.
  void start() {
    _connectivitySub = _connectivity.statusStream.listen((status) {
      if (status == NetworkStatus.online && !_paused) {
        // Wait for connection stability before draining
        _drainTimer?.cancel();
        _drainTimer = Timer(_stabilityDelay, _drainQueue);
      }
    });
  }

  /// Stops the engine and releases all resources.
  void dispose() {
    _disposed = true;
    unawaited(_connectivitySub?.cancel());
    _drainTimer?.cancel();
    unawaited(_statusController.close());
  }

  /// Whether the engine is currently paused (app backgrounded).
  bool get isPaused => _paused;

  /// Pause queue drain operations. Called when the app is backgrounded.
  /// Does not interrupt an in-progress drain cycle.
  void pause() {
    if (_paused) return;
    _paused = true;
    _drainTimer?.cancel();
    _drainTimer = null;
    debugPrint('[SyncEngine] Paused');
  }

  /// Resume queue drain operations. Triggers a drain if currently online.
  void resume() {
    if (!_paused) return;
    _paused = false;
    debugPrint('[SyncEngine] Resumed');
    // Check connectivity and drain if online.
    unawaited(
      _connectivity.currentStatus.then((status) {
        if (status == NetworkStatus.online && !_isSyncing && !_paused) {
          unawaited(_drainQueue());
        }
      }),
    );
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
    // Trigger drain only if online, not already syncing, and not paused.
    if (!_isSyncing && !_paused) {
      final status = await _connectivity.currentStatus;
      if (status == NetworkStatus.online) {
        unawaited(_drainQueue());
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
        } on Exception catch (e) {
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
    } on Exception catch (e) {
      if (!_disposed) {
        _statusController.add(
          SyncStatus(lastError: e.toString()),
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

  /// Calculates an exponential backoff duration with jitter for the given
  /// [retryCount] (base 1s, max 5min).
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
    } on Exception catch (_) {
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

/// Provides a [SyncDispatcher] wired to the current gRPC service clients.
final syncDispatcherProvider = Provider<SyncDispatcher>((ref) {
  final agentClient = ref.watch(agentServiceProvider);
  final worktreeClient = ref.watch(worktreeServiceProvider);
  return SyncDispatcher(
    agentClient: agentClient,
    worktreeClient: worktreeClient,
  );
});

/// Provides the singleton [SyncEngine], started on creation and paused/resumed
/// with the app lifecycle.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityMonitorProvider);
  final dispatcher = ref.watch(syncDispatcherProvider);
  final engine = SyncEngine(
    database: db,
    connectivity: connectivity,
    dispatcher: dispatcher,
  )..start();
  ref
    ..listen(appLifecycleProvider, (prev, next) {
      if (next == AppLifecycleState.paused ||
          next == AppLifecycleState.hidden) {
        engine.pause();
      } else if (next == AppLifecycleState.resumed) {
        engine.resume();
      }
    })
    ..onDispose(engine.dispose);
  return engine;
});

/// Exposes the [SyncEngine]'s status stream as a Riverpod [StreamProvider].
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
});
