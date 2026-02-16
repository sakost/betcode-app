import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages session-scoped permission grants fetched via gRPC.
///
/// Grants control which tools are pre-approved for a session so the user
/// does not have to confirm every invocation. The notifier watches the
/// connection status and re-fetches when the gRPC channel reconnects.
class SessionGrantsNotifier extends AsyncNotifier<List<SessionGrantEntry>> {
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  String _sessionId = '';

  /// Sets the session ID for which to fetch grants.
  ///
  /// Invalidates the provider so [build] re-runs with the new session ID.
  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    ref.invalidateSelf();
  }

  @override
  Future<List<SessionGrantEntry>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
    if (_sessionId.isEmpty) return [];
    return _fetchGrants();
  }

  Future<List<SessionGrantEntry>> _fetchGrants() async {
    final client = ref.read(agentServiceProvider);
    final response = await client
        .listSessionGrants(ListSessionGrantsRequest(sessionId: _sessionId))
        .timeout(_rpcTimeout);
    return response.grants.toList();
  }

  /// Re-fetches grants from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchGrants);
  }

  /// Sets or updates a session grant.
  ///
  /// Calls the `SetSessionGrant` RPC then refreshes the local list.
  Future<void> setGrant({
    required String toolName,
    required bool granted,
  }) async {
    final client = ref.read(agentServiceProvider);
    await client
        .setSessionGrant(
          SetSessionGrantRequest(
            sessionId: _sessionId,
            toolName: toolName,
            granted: granted,
          ),
        )
        .timeout(_mutationTimeout);
    await refresh();
  }

  /// Clears session grants, optionally for a specific tool.
  ///
  /// If [toolName] is null, all grants for the session are cleared.
  Future<void> clearGrants({String? toolName}) async {
    final client = ref.read(agentServiceProvider);
    await client
        .clearSessionGrants(
          ClearSessionGrantsRequest(
            sessionId: _sessionId,
            toolName: toolName ?? '',
          ),
        )
        .timeout(_mutationTimeout);
    await refresh();
  }
}
