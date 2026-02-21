import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the permission rules fetched from the daemon via gRPC.
///
/// On [build], fetches the current permissions.
/// Callers can pull-to-refresh via [refresh].
///
/// Uses [grpcSingleBuild] which watches connection status and selected machine.
class PermissionsNotifier extends AsyncNotifier<PermissionRules> {
  /// The session ID to scope the permissions query. Set by the
  /// provider factory.
  late String sessionId;

  @override
  Future<PermissionRules> build() => grpcSingleBuild(ref, _fetchPermissions);

  Future<PermissionRules> _fetchPermissions() async {
    final client = ref.read(configServiceProvider);
    return client
        .getPermissions(GetPermissionsRequest(sessionId: sessionId))
        .timeout(grpcRpcTimeout);
  }

  /// Re-fetches the permissions and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPermissions);
  }
}
