import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/config.pb.dart';

/// Manages the list of MCP servers fetched from the daemon via gRPC.
class McpServersNotifier extends AsyncNotifier<List<McpServerInfo>> {
  @override
  Future<List<McpServerInfo>> build() async {
    return _fetchServers();
  }

  Future<List<McpServerInfo>> _fetchServers() async {
    final client = ref.read(configServiceProvider);
    final response = await client.listMcpServers(ListMcpServersRequest());
    return response.servers.toList();
  }

  /// Re-fetches the MCP servers list from the daemon and replaces the
  /// current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchServers());
  }
}
