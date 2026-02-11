import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/storage_providers.dart';
import '../../../generated/betcode/v1/agent.pb.dart';

/// Manages the list of sessions fetched from the daemon via gRPC.
///
/// On [build], fetches the first page of sessions, caches each one to the
/// local drift database for offline access, and returns them. Callers can
/// pull-to-refresh via [refresh].
class SessionsNotifier extends AsyncNotifier<List<SessionSummary>> {
  static const _pageSize = 20;

  @override
  Future<List<SessionSummary>> build() async {
    return _fetchSessions();
  }

  Future<List<SessionSummary>> _fetchSessions({int offset = 0}) async {
    final client = ref.read(agentServiceProvider);
    final response = await client.listSessions(
      ListSessionsRequest(limit: _pageSize, offset: offset),
    );

    await _cacheToDb(response.sessions);
    return response.sessions.toList();
  }

  /// Re-fetches the first page of sessions from the daemon and replaces the
  /// current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchSessions());
  }

  /// Upserts each [SessionSummary] into the local [CachedSessions] table so
  /// the data is available when offline.
  Future<void> _cacheToDb(Iterable<SessionSummary> sessions) async {
    final db = ref.read(appDatabaseProvider);

    await db.batch((batch) {
      for (final session in sessions) {
        final updatedAtSeconds = session.hasUpdatedAt()
            ? session.updatedAt.seconds.toInt()
            : DateTime.now().millisecondsSinceEpoch ~/ 1000;

        batch.insert(
          db.cachedSessions,
          CachedSessionsCompanion.insert(
            id: session.id,
            machineId: '',
            model: Value(session.model),
            workingDirectory: Value(session.workingDirectory),
            worktreeId: Value(session.worktreeId),
            status: Value(session.status),
            messageCount: Value(session.messageCount),
            totalInputTokens: Value(session.totalInputTokens),
            totalOutputTokens: Value(session.totalOutputTokens),
            totalCostUsd: Value(session.totalCostUsd),
            lastMessagePreview: Value(session.lastMessagePreview),
            updatedAt: updatedAtSeconds,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
