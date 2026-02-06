import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Offline sync queue for pending gRPC requests.
///
/// Priority levels (highest first):
///   1 - Permission responses (unblocks agent)
///   2 - User question responses (unblocks agent)
///   3 - Cancel requests (time-sensitive)
///   4 - User messages (primary intent)
///   5 - Session management (can wait)
///   6 - Status/heartbeat (background)
///
/// Status flow: pending -> sending -> sent (or blocked / failed)
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get machineId => text()();
  TextColumn get sessionId => text().nullable()();
  TextColumn get requestType => text()();
  BlobColumn get payload => blob()();
  TextColumn get idempotencyKey => text()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  IntColumn get sequence => integer()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get expiresAt => integer()();
}

/// Locally cached session data for offline access and fast display.
class CachedSessions extends Table {
  TextColumn get id => text()();
  TextColumn get machineId => text()();
  TextColumn get model => text().nullable()();
  TextColumn get workingDirectory => text().nullable()();
  TextColumn get worktreeId => text().nullable()();
  TextColumn get status => text().nullable()();
  IntColumn get messageCount => integer().withDefault(const Constant(0))();
  IntColumn get totalInputTokens => integer().withDefault(const Constant(0))();
  IntColumn get totalOutputTokens => integer().withDefault(const Constant(0))();
  RealColumn get totalCostUsd => real().withDefault(const Constant(0.0))();
  TextColumn get lastMessagePreview => text().nullable()();
  IntColumn get lastSequence => integer().withDefault(const Constant(0))();
  TextColumn get messagesJson => text().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Known machines (daemon instances) the user has connected to.
class Machines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get relayUrl => text()();
  TextColumn get hostname => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('offline'))();
  IntColumn get lastConnected => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Key-value settings store for app preferences.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Deduplication cache for push notifications.
class NotificationCache extends Table {
  TextColumn get notificationId => text()();
  IntColumn get receivedAt => integer()();

  @override
  Set<Column> get primaryKey => {notificationId};
}

@DriftDatabase(
  tables: [SyncQueue, CachedSessions, Machines, Settings, NotificationCache],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens a drift database backed by SQLite, stored in the platform-default
  /// application data directory.
  factory AppDatabase.defaults() {
    return AppDatabase(driftDatabase(name: 'betcode'));
  }

  @override
  int get schemaVersion => 1;
}
