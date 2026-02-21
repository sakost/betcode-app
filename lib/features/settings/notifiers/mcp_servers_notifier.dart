import 'package:betcode_app/core/grpc/grpc_notifier_helpers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of MCP servers fetched from the daemon via gRPC.
///
/// Uses [grpcListBuild] which watches connection status and selected machine.
class McpServersNotifier extends AsyncNotifier<List<McpServerInfo>> {
  @override
  Future<List<McpServerInfo>> build() => grpcListBuild(ref, _fetchServers);

  Future<List<McpServerInfo>> _fetchServers() async {
    final client = ref.read(configServiceProvider);
    final response = await client
        .listMcpServers(ListMcpServersRequest())
        .timeout(grpcRpcTimeout);
    return response.servers.toList();
  }

  /// Re-fetches the MCP servers list from the daemon and replaces the
  /// current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchServers);
  }
}
