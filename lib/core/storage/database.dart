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
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// The machine this request targets.
  TextColumn get machineId => text()();

  /// The session this request belongs to, if applicable.
  TextColumn get sessionId => text().nullable()();

  /// The type of gRPC request (e.g. `user_message`, `permission_response`).
  TextColumn get requestType => text()();

  /// Serialized protobuf payload for the request.
  BlobColumn get payload => blob()();

  /// UUIDv7 idempotency key for safe replay on the server.
  TextColumn get idempotencyKey => text()();

  /// Dispatch priority (1 = highest, 6 = lowest). Defaults to 3.
  IntColumn get priority => integer().withDefault(const Constant(3))();

  /// Monotonic insertion order within a single engine lifetime.
  IntColumn get sequence => integer()();

  /// Current queue state: `pending`, `sending`, `sent`, `blocked`, or `failed`.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Number of dispatch attempts so far.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Human-readable error from the last failed dispatch attempt.
  TextColumn get lastError => text().nullable()();

  /// Unix epoch seconds when the item was enqueued.
  IntColumn get createdAt => integer()();

  /// Unix epoch seconds after which the item is expired and will be deleted.
  IntColumn get expiresAt => integer()();
}

/// Locally cached session data for offline access and fast display.
class CachedSessions extends Table {
  /// Session identifier (primary key).
  TextColumn get id => text()();

  /// The machine that owns this session.
  TextColumn get machineId => text()();

  /// LLM model name used for this session.
  TextColumn get model => text().nullable()();

  /// Filesystem working directory for the session.
  TextColumn get workingDirectory => text().nullable()();

  /// Associated worktree identifier, if any.
  TextColumn get worktreeId => text().nullable()();

  /// Session status string (e.g. `idle`, `thinking`).
  TextColumn get status => text().nullable()();

  /// Total number of messages in the conversation.
  IntColumn get messageCount => integer().withDefault(const Constant(0))();

  /// Cumulative input tokens consumed.
  IntColumn get totalInputTokens => integer().withDefault(const Constant(0))();

  /// Cumulative output tokens generated.
  IntColumn get totalOutputTokens => integer().withDefault(const Constant(0))();

  /// Cumulative cost in USD.
  RealColumn get totalCostUsd => real().withDefault(const Constant(0))();

  /// Preview snippet of the most recent message.
  TextColumn get lastMessagePreview => text().nullable()();

  /// Highest event sequence number received for reconnection.
  IntColumn get lastSequence => integer().withDefault(const Constant(0))();

  /// Full conversation messages serialized as JSON.
  TextColumn get messagesJson => text().nullable()();

  /// Unix epoch seconds of the last update.
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Known machines (daemon instances) the user has connected to.
class Machines extends Table {
  /// Machine identifier (primary key).
  TextColumn get id => text()();

  /// Human-readable display name.
  TextColumn get name => text()();

  /// Relay URL used to reach this machine.
  TextColumn get relayUrl => text()();

  /// Operating system hostname, if known.
  TextColumn get hostname => text().nullable()();

  /// Connection status (e.g. `online`, `offline`).
  TextColumn get status => text().withDefault(const Constant('offline'))();

  /// Unix epoch seconds of the last successful connection.
  IntColumn get lastConnected => integer().nullable()();

  /// Whether the user has starred this machine.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Key-value settings store for app preferences.
class Settings extends Table {
  /// Setting name (primary key).
  TextColumn get key => text()();

  /// Setting value stored as text.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Deduplication cache for push notifications.
class NotificationCache extends Table {
  /// Unique notification identifier (primary key) for deduplication.
  TextColumn get notificationId => text()();

  /// Unix epoch seconds when the notification was received.
  IntColumn get receivedAt => integer()();

  @override
  Set<Column> get primaryKey => {notificationId};
}

@DriftDatabase(
  tables: [SyncQueue, CachedSessions, Machines, Settings, NotificationCache],
)
/// The app's drift (SQLite) database, containing all local persistence tables.
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given [QueryExecutor].
  AppDatabase(super.e);

  /// Opens a drift database backed by SQLite, stored in the platform-default
  /// application data directory.
  factory AppDatabase.defaults() {
    return AppDatabase(driftDatabase(name: 'betcode'));
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Future migrations go here, keyed on `from` version.
    },
  );
}
