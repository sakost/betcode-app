import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/config.pb.dart';

/// Manages the list of MCP servers fetched from the daemon via gRPC.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class McpServersNotifier extends AsyncNotifier<List<McpServerInfo>> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<List<McpServerInfo>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchServers();
  }

  Future<List<McpServerInfo>> _fetchServers() async {
    final client = ref.read(configServiceProvider);
    final response = await client
        .listMcpServers(ListMcpServersRequest())
        .timeout(_rpcTimeout);
    return response.servers.toList();
  }

  /// Re-fetches the MCP servers list from the daemon and replaces the
  /// current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchServers());
  }
}
