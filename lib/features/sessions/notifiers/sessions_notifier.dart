import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of sessions fetched from the daemon via gRPC.
///
/// On [build], fetches the first page of sessions, caches each one to the
/// local drift database for offline access, and returns them. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class SessionsNotifier extends AsyncNotifier<List<SessionSummary>> {
  static const _pageSize = 20;
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  Future<List<SessionSummary>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
    return _fetchSessions();
  }

  Future<List<SessionSummary>> _fetchSessions({int offset = 0}) async {
    final client = ref.read(agentServiceProvider);
    final response = await client
        .listSessions(ListSessionsRequest(limit: _pageSize, offset: offset))
        .timeout(_rpcTimeout);

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
        .timeout(_mutationTimeout);
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
        .timeout(_mutationTimeout);
    await refresh();
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
