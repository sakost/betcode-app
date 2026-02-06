# BetCode App - Client Database Schemas

**Version**: 0.1.0
**Last Updated**: 2026-02-06

The app uses drift (formerly moor) for local SQLite storage. Schema documented in SQL for reference; actual DDL is generated from Dart drift table classes.

Conventions: timestamps = Unix epoch seconds (INTEGER), IDs = UUIDv7 (TEXT), booleans = INTEGER (0/1).

---

## sync_queue

Offline command queue. Actions queued when disconnected, drained by priority on reconnect.

```sql
CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    machine_id TEXT NOT NULL,
    session_id TEXT,
    request_type TEXT NOT NULL,
    payload BLOB NOT NULL,
    idempotency_key TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 3 CHECK (priority BETWEEN 0 AND 5),
    sequence INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'sending', 'sent', 'blocked', 'failed')),
    retry_count INTEGER NOT NULL DEFAULT 0,
    last_error TEXT,
    created_at INTEGER NOT NULL,
    expires_at INTEGER NOT NULL
);

CREATE INDEX idx_sync_status ON sync_queue(status, priority, sequence)
    WHERE status IN ('pending', 'blocked');
CREATE INDEX idx_sync_expiry ON sync_queue(expires_at)
    WHERE status NOT IN ('sent', 'failed');
```

| Column | Type | Description |
|--------|------|-------------|
| machine_id | TEXT | Target machine identifier |
| session_id | TEXT | Target session (nullable for session creation) |
| request_type | TEXT | gRPC method (e.g. "SendMessage", "PermissionResponse") |
| payload | BLOB | Serialized protobuf request bytes |
| idempotency_key | TEXT | UUIDv7, generated at queue time for dedup |
| priority | INTEGER | 0=permission responses, 3=messages, 5=heartbeats |
| sequence | INTEGER | Monotonic ordering for FIFO within same priority |
| status | TEXT | pending -> sending -> sent, or blocked/failed |
| retry_count | INTEGER | Delivery attempts |
| expires_at | INTEGER | Default: created_at + 604800 (7 days) |

**Drain query:** `SELECT ... WHERE status IN ('pending','blocked') AND expires_at > :now ORDER BY priority ASC, sequence ASC`

**Cleanup:** `DELETE FROM sync_queue WHERE expires_at < :now`

---

## cached_sessions

Local cache for offline viewing. Snapshots taken on each sync.

```sql
CREATE TABLE cached_sessions (
    id TEXT PRIMARY KEY,
    machine_id TEXT NOT NULL,
    model TEXT,
    working_directory TEXT,
    worktree_id TEXT,
    status TEXT,
    message_count INTEGER DEFAULT 0,
    total_input_tokens INTEGER DEFAULT 0,
    total_output_tokens INTEGER DEFAULT 0,
    total_cost_usd REAL DEFAULT 0.0,
    last_message_preview TEXT,
    last_sequence INTEGER DEFAULT 0,
    messages_json TEXT,
    updated_at INTEGER NOT NULL
);

CREATE INDEX idx_cached_machine ON cached_sessions(machine_id);
CREATE INDEX idx_cached_updated ON cached_sessions(updated_at DESC);
```

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT PK | Session ID (matches daemon session ID) |
| machine_id | TEXT | Machine the session belongs to |
| last_sequence | INTEGER | Last event sequence received |
| messages_json | TEXT | JSON array of cached conversation messages |
| updated_at | INTEGER | Unix epoch seconds of last sync |

Other columns mirror `SessionSummary` fields from gRPC for display.

---

## machines

Local bookmarks of known machines. Independent of relay's machines table.

```sql
CREATE TABLE machines (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    relay_url TEXT NOT NULL,
    hostname TEXT,
    status TEXT DEFAULT 'offline',
    last_connected INTEGER,
    is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1))
);
```

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT PK | Machine ID (matches relay machine ID) |
| name | TEXT | Display name |
| relay_url | TEXT | Relay URL this machine connects through |
| is_favorite | INTEGER | Controls sort order in UI |

---

## settings

Key-value store for local preferences.

```sql
CREATE TABLE settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
```

### Known Keys

| Key | Type | Description |
|-----|------|-------------|
| `theme` | string | "light", "dark", "system" |
| `default_machine_id` | string | Auto-select on launch |
| `last_session_id` | string | Resume on launch |
| `notification_permissions` | bool | Push enabled |
| `notification_task_complete` | bool | Notify on completion |
| `notification_errors` | bool | Notify on errors |
| `push_token` | string | Current FCM/APNs token |
| `push_platform` | string | "fcm", "apns", "apns_sandbox" |

---

## notification_cache

Push notification deduplication. Prevents showing duplicates from relay retries.

```sql
CREATE TABLE notification_cache (
    notification_id TEXT PRIMARY KEY,
    received_at INTEGER NOT NULL
);
```

Cleanup: `DELETE WHERE received_at < now() - 3600` (1 hour TTL).

---

## Design Decisions

**Why drift**: Type-safe queries with compile-time checking. Reactive `watch()` streams integrate with Riverpod. Full SQLite feature set (indexes, transactions, WAL). Versioned schema migrations.

**Why no foreign keys**: Machine/session IDs are soft references to daemon/relay entities. The client caches sessions from machines it may no longer be connected to. Hard FKs would prevent offline caching.

**Why UUIDv7 for idempotency keys**: Time-sortable (natural queue order), globally unique (no collision across devices), compact TEXT storage.

**Why 7-day queue TTL**: Covers weekend disconnects. Prevents stale intents from replaying weeks later when context has changed.

---

## Drift Table Registration

```dart
@DriftDatabase(tables: [
  SyncQueue, CachedSessions, Machines, Settings, NotificationCache,
])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Incremental migrations: if (from < 2) { addColumn(...) }
    },
  );
}
```

Migration rules: version increments on any table change, never delete a migration step, test with drift_dev migration helpers.
