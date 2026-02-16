import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the command registry fetched from the daemon via gRPC.
///
/// On [build], fetches the full command registry and returns it. Callers can
/// pull-to-refresh via [refresh], list agents, or list path entries.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class CommandsNotifier extends AsyncNotifier<List<CommandEntry>> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<List<CommandEntry>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
    return _fetchCommands();
  }

  Future<List<CommandEntry>> _fetchCommands() async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .getCommandRegistry(GetCommandRegistryRequest())
        .timeout(_rpcTimeout);
    return response.commands.toList();
  }

  /// Re-fetches the command registry from the daemon and replaces state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchCommands);
  }

  /// Lists agents matching a query.
  Future<List<AgentInfo>> listAgents({
    String query = '',
    int maxResults = 20,
  }) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .listAgents(ListAgentsRequest(query: query, maxResults: maxResults))
        .timeout(_rpcTimeout);
    return response.agents.toList();
  }

  /// Lists path entries matching a query.
  Future<List<PathEntry>> listPath({
    String query = '',
    int maxResults = 20,
  }) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .listPath(ListPathRequest(query: query, maxResults: maxResults))
        .timeout(_rpcTimeout);
    return response.entries.toList();
  }

  /// Executes a service command and returns a server-streaming response.
  ///
  /// The returned stream emits [ServiceCommandOutput] messages containing
  /// stdout lines, stderr lines, an exit code, or an error string (oneof).
  Stream<ServiceCommandOutput> executeServiceCommand({
    required String command,
    List<String> args = const [],
  }) {
    final client = ref.read(commandServiceProvider);
    return client.executeServiceCommand(
      ExecuteServiceCommandRequest(command: command, args: args),
    );
  }
}
