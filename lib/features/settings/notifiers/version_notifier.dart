import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/version.pb.dart';

/// Manages version and capability data fetched from the daemon via gRPC.
///
/// On [build], fetches the current version info. Callers can
/// pull-to-refresh via [refresh] or negotiate capabilities.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class VersionNotifier extends AsyncNotifier<GetVersionResponse> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<GetVersionResponse> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchVersion();
  }

  Future<GetVersionResponse> _fetchVersion() async {
    final client = ref.read(versionServiceProvider);
    return await client.getVersion(GetVersionRequest()).timeout(_rpcTimeout);
  }

  /// Re-fetches version info and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchVersion());
  }

  /// Negotiates capabilities with the server.
  Future<NegotiateResponse> negotiateCapabilities({
    required String clientVersion,
    required String clientType,
    List<String> requestedFeatures = const [],
  }) async {
    final client = ref.read(versionServiceProvider);
    return await client
        .negotiateCapabilities(
          NegotiateRequest(
            clientVersion: clientVersion,
            clientType: clientType,
            requestedFeatures: requestedFeatures,
          ),
        )
        .timeout(_rpcTimeout);
  }
}
