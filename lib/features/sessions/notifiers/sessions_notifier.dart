import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of sessions fetched from the daemon via gRPC.
///
/// On [build], fetches the first page of sessions, caches each one to the
/// local drift database for offline access, and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Uses [grpcListBuild] which watches connection status and selected machine.
class SessionsNotifier extends AsyncNotifier<List<SessionSummary>> {
  static const _pageSize = 20;

  @override
  Future<List<SessionSummary>> build() => grpcListBuild(ref, _fetchSessions);

  Future<List<SessionSummary>> _fetchSessions({int offset = 0}) async {
    final client = ref.read(agentServiceProvider);
    final response = await client
        .listSessions(ListSessionsRequest(limit: _pageSize, offset: offset))
        .timeout(grpcRpcTimeout);

    await _cacheToDb(response.sessions);
    return response.sessions.toList();
  }

  /// Re-fetches the first page of sessions from the daemon and replaces the
  /// current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSessions);
  }

  /// Triggers context compaction for a session.
  ///
  /// Returns the [CompactSessionResponse] with before/after message counts
  /// and tokens saved. Refreshes the session list after compaction.
  Future<CompactSessionResponse> compactSession(String sessionId) async {
    final client = ref.read(agentServiceProvider);
    final response = await client
        .compactSession(CompactSessionRequest(sessionId: sessionId))
        .timeout(grpcMutationTimeout);
    await refresh();
    return response;
  }

  /// Renames a session via gRPC and refreshes the local list.
  ///
  /// Throws on gRPC/timeout errors so callers can display feedback.
  Future<void> renameSession({
    required String sessionId,
    required String name,
  }) async {
    final client = ref.read(agentServiceProvider);
    await client
        .renameSession(RenameSessionRequest(sessionId: sessionId, name: name))
        .timeout(grpcMutationTimeout);
    await refresh();
  }

  /// Permanently deletes a session and all its messages.
  ///
  /// Throws on gRPC/timeout errors so callers can display feedback.
  Future<void> deleteSession(String sessionId) async {
    final client = ref.read(agentServiceProvider);
    await client
        .deleteSession(DeleteSessionRequest(sessionId: sessionId))
        .timeout(grpcMutationTimeout);
    await _removeFromCache(sessionId);
    await refresh();
  }

  /// Removes a deleted session from the local drift cache.
  Future<void> _removeFromCache(String sessionId) async {
    final db = ref.read(appDatabaseProvider);
    await db.batch((batch) {
      batch.deleteWhere(db.cachedSessions, (t) => t.id.equals(sessionId));
    });
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
