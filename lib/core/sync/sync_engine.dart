import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../storage/storage.dart';
import 'connectivity.dart';

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
  }) : _database = database,
       _connectivity = connectivity;

  final AppDatabase _database;
  final ConnectivityMonitor _connectivity;
  final _uuid = const Uuid();
  final _statusController = StreamController<SyncStatus>.broadcast();
  final _random = Random();

  StreamSubscription<NetworkStatus>? _connectivitySub;
  Timer? _drainTimer;
  bool _isSyncing = false;

  Stream<SyncStatus> get statusStream => _statusController.stream;

  static const _stabilityDelay = Duration(seconds: 3);

  String generateIdempotencyKey() => _uuid.v7();

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
    _connectivitySub?.cancel();
    _drainTimer?.cancel();
    _statusController.close();
  }

  Future<void> _drainQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _emitStatus();

    try {
      await _cleanupExpired();
      // TODO: Implement actual queue drain when gRPC services are connected
      // Query: SELECT * FROM sync_queue
      //   WHERE status IN ('pending', 'blocked') AND expires_at > :now
      //   ORDER BY priority ASC, sequence ASC
    } catch (e) {
      _statusController.add(
        SyncStatus(isSyncing: false, lastError: e.toString()),
      );
    } finally {
      _isSyncing = false;
      _emitStatus();
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

  void _emitStatus() {
    _statusController.add(
      SyncStatus(isSyncing: _isSyncing, lastSyncTime: DateTime.now()),
    );
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityMonitorProvider);
  final engine = SyncEngine(database: db, connectivity: connectivity)..start();
  ref.onDispose(engine.dispose);
  return engine;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
});
