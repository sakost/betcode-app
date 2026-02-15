import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/config.pb.dart';

/// Manages the permission rules fetched from the daemon via gRPC.
///
/// On [build], fetches the current permissions.
/// Callers can pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class PermissionsNotifier extends AsyncNotifier<PermissionRules> {
  static const _rpcTimeout = Duration(seconds: 10);

  /// The session ID to scope the permissions query. Set by the provider factory.
  late String sessionId;

  @override
  Future<PermissionRules> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchPermissions();
  }

  Future<PermissionRules> _fetchPermissions() async {
    final client = ref.read(configServiceProvider);
    return await client
        .getPermissions(GetPermissionsRequest(sessionId: sessionId))
        .timeout(_rpcTimeout);
  }

  /// Re-fetches the permissions and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPermissions());
  }
}
