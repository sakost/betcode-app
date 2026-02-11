import 'dart:typed_data';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/storage/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase - schema', () {
    test('schemaVersion is 1', () {
      expect(db.schemaVersion, 1);
    });
  });

  group('SyncQueue CRUD', () {
    SyncQueueCompanion _entry({
      required String machineId,
      String requestType = 'user_message',
      int priority = 3,
      int sequence = 1,
      String idempotencyKey = 'key-1',
      String? sessionId,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return SyncQueueCompanion.insert(
        machineId: machineId,
        requestType: requestType,
        payload: Uint8List.fromList([1, 2, 3]),
        idempotencyKey: idempotencyKey,
        sequence: sequence,
        createdAt: now,
        expiresAt: now + 86400000,
      );
    }

    test('insert and retrieve', () async {
      await db.into(db.syncQueue).insert(_entry(machineId: 'm-1'));

      final rows = await db.select(db.syncQueue).get();
      expect(rows, hasLength(1));
      expect(rows.first.machineId, 'm-1');
      expect(rows.first.requestType, 'user_message');
      expect(rows.first.status, 'pending'); // default
      expect(rows.first.retryCount, 0); // default
      expect(rows.first.priority, 3); // default
    });

    test('auto-increment id', () async {
      await db.into(db.syncQueue).insert(_entry(
        machineId: 'm-1',
        idempotencyKey: 'k-1',
        sequence: 1,
      ));
      await db.into(db.syncQueue).insert(_entry(
        machineId: 'm-2',
        idempotencyKey: 'k-2',
        sequence: 2,
      ));

      final rows = await db.select(db.syncQueue).get();
      expect(rows, hasLength(2));
      expect(rows[0].id, lessThan(rows[1].id));
    });

    test('update status', () async {
      await db.into(db.syncQueue).insert(_entry(machineId: 'm-1'));
      final row = (await db.select(db.syncQueue).get()).first;

      await (db.update(db.syncQueue)
            ..where((t) => t.id.equals(row.id)))
          .write(const SyncQueueCompanion(status: Value('sending')));

      final updated = await (db.select(db.syncQueue)
            ..where((t) => t.id.equals(row.id)))
          .getSingle();
      expect(updated.status, 'sending');
    });

    test('delete entry', () async {
      await db.into(db.syncQueue).insert(_entry(machineId: 'm-1'));
      expect(await db.select(db.syncQueue).get(), hasLength(1));

      await (db.delete(db.syncQueue)
            ..where((t) => t.machineId.equals('m-1')))
          .go();
      expect(await db.select(db.syncQueue).get(), isEmpty);
    });

    test('priority ordering query', () async {
      // Insert with explicit priority via update after insert.
      await db.into(db.syncQueue).insert(_entry(
        machineId: 'm-1',
        idempotencyKey: 'k-low',
        sequence: 1,
      ));
      await (db.update(db.syncQueue)
            ..where((t) => t.idempotencyKey.equals('k-low')))
          .write(const SyncQueueCompanion(priority: Value(5)));

      await db.into(db.syncQueue).insert(_entry(
        machineId: 'm-1',
        idempotencyKey: 'k-high',
        sequence: 2,
      ));
      await (db.update(db.syncQueue)
            ..where((t) => t.idempotencyKey.equals('k-high')))
          .write(const SyncQueueCompanion(priority: Value(1)));

      final rows = await (db.select(db.syncQueue)
            ..orderBy([(t) => OrderingTerm.asc(t.priority)]))
          .get();
      expect(rows.first.priority, 1);
      expect(rows.last.priority, 5);
    });
  });

  group('CachedSessions CRUD', () {
    CachedSessionsCompanion _session({
      required String id,
      String machineId = 'machine-1',
    }) {
      return CachedSessionsCompanion.insert(
        id: id,
        machineId: machineId,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }

    test('insert and retrieve', () async {
      await db.into(db.cachedSessions).insert(_session(id: 's-1'));

      final rows = await db.select(db.cachedSessions).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, 's-1');
      expect(rows.first.machineId, 'machine-1');
      expect(rows.first.messageCount, 0); // default
      expect(rows.first.totalCostUsd, 0.0); // default
    });

    test('insert with optional fields', () async {
      await db.into(db.cachedSessions).insert(
        CachedSessionsCompanion.insert(
          id: 's-2',
          machineId: 'machine-1',
          model: const Value('opus'),
          workingDirectory: const Value('/home/user'),
          status: const Value('active'),
          messageCount: const Value(10),
          totalCostUsd: const Value(0.05),
          lastMessagePreview: const Value('Hello world'),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final row = (await db.select(db.cachedSessions).get()).first;
      expect(row.model, 'opus');
      expect(row.workingDirectory, '/home/user');
      expect(row.status, 'active');
      expect(row.messageCount, 10);
      expect(row.totalCostUsd, 0.05);
      expect(row.lastMessagePreview, 'Hello world');
    });

    test('update session', () async {
      await db.into(db.cachedSessions).insert(_session(id: 's-1'));

      await (db.update(db.cachedSessions)
            ..where((t) => t.id.equals('s-1')))
          .write(const CachedSessionsCompanion(
            messageCount: Value(42),
            status: Value('idle'),
          ));

      final row = await (db.select(db.cachedSessions)
            ..where((t) => t.id.equals('s-1')))
          .getSingle();
      expect(row.messageCount, 42);
      expect(row.status, 'idle');
    });

    test('delete session', () async {
      await db.into(db.cachedSessions).insert(_session(id: 's-1'));
      await db.into(db.cachedSessions).insert(_session(id: 's-2'));

      await (db.delete(db.cachedSessions)
            ..where((t) => t.id.equals('s-1')))
          .go();

      final rows = await db.select(db.cachedSessions).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, 's-2');
    });

    test('primary key prevents duplicate ids', () async {
      await db.into(db.cachedSessions).insert(_session(id: 's-1'));

      expect(
        () => db.into(db.cachedSessions).insert(_session(id: 's-1')),
        throwsA(anything),
      );
    });

    test('batch insert', () async {
      await db.batch((batch) {
        batch.insertAll(db.cachedSessions, [
          _session(id: 's-1'),
          _session(id: 's-2'),
          _session(id: 's-3'),
        ]);
      });

      final rows = await db.select(db.cachedSessions).get();
      expect(rows, hasLength(3));
    });
  });

  group('Machines CRUD', () {
    MachinesCompanion _machine({
      required String id,
      String name = 'My Machine',
      String relayUrl = 'wss://relay.example.com',
    }) {
      return MachinesCompanion.insert(
        id: id,
        name: name,
        relayUrl: relayUrl,
      );
    }

    test('insert and retrieve with defaults', () async {
      await db.into(db.machines).insert(_machine(id: 'm-1'));

      final rows = await db.select(db.machines).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, 'm-1');
      expect(rows.first.name, 'My Machine');
      expect(rows.first.status, 'offline'); // default
      expect(rows.first.isFavorite, false); // default
      expect(rows.first.hostname, isNull);
    });

    test('update favorite status', () async {
      await db.into(db.machines).insert(_machine(id: 'm-1'));

      await (db.update(db.machines)..where((t) => t.id.equals('m-1')))
          .write(const MachinesCompanion(isFavorite: Value(true)));

      final row = await (db.select(db.machines)
            ..where((t) => t.id.equals('m-1')))
          .getSingle();
      expect(row.isFavorite, true);
    });

    test('filter by status', () async {
      await db.into(db.machines).insert(_machine(id: 'm-1'));
      await db.into(db.machines).insert(_machine(id: 'm-2'));

      await (db.update(db.machines)..where((t) => t.id.equals('m-2')))
          .write(const MachinesCompanion(status: Value('online')));

      final online = await (db.select(db.machines)
            ..where((t) => t.status.equals('online')))
          .get();
      expect(online, hasLength(1));
      expect(online.first.id, 'm-2');
    });
  });

  group('Settings CRUD', () {
    test('insert and retrieve key-value pair', () async {
      await db.into(db.settings).insert(
        SettingsCompanion.insert(key: 'theme', value: 'dark'),
      );

      final rows = await db.select(db.settings).get();
      expect(rows, hasLength(1));
      expect(rows.first.key, 'theme');
      expect(rows.first.value, 'dark');
    });

    test('update value by key', () async {
      await db.into(db.settings).insert(
        SettingsCompanion.insert(key: 'theme', value: 'dark'),
      );

      await (db.update(db.settings)..where((t) => t.key.equals('theme')))
          .write(const SettingsCompanion(value: Value('light')));

      final row = await (db.select(db.settings)
            ..where((t) => t.key.equals('theme')))
          .getSingle();
      expect(row.value, 'light');
    });

    test('primary key prevents duplicate keys', () async {
      await db.into(db.settings).insert(
        SettingsCompanion.insert(key: 'k', value: 'v1'),
      );

      expect(
        () => db.into(db.settings).insert(
          SettingsCompanion.insert(key: 'k', value: 'v2'),
        ),
        throwsA(anything),
      );
    });
  });

  group('NotificationCache CRUD', () {
    test('insert and retrieve', () async {
      await db.into(db.notificationCache).insert(
        NotificationCacheCompanion.insert(
          notificationId: 'n-1',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final rows = await db.select(db.notificationCache).get();
      expect(rows, hasLength(1));
      expect(rows.first.notificationId, 'n-1');
    });

    test('deduplication by primary key', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.into(db.notificationCache).insert(
        NotificationCacheCompanion.insert(
          notificationId: 'n-1',
          receivedAt: now,
        ),
      );

      expect(
        () => db.into(db.notificationCache).insert(
          NotificationCacheCompanion.insert(
            notificationId: 'n-1',
            receivedAt: now + 1000,
          ),
        ),
        throwsA(anything),
      );
    });
  });
}
