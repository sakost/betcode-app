import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the plugin list fetched from the daemon via gRPC.
///
/// On [build], fetches all plugins and returns them. Callers can
/// pull-to-refresh via [refresh], get individual plugin status, or
/// add/remove/enable/disable plugins.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class PluginsNotifier extends AsyncNotifier<List<PluginInfo>> {
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  Future<List<PluginInfo>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
    return _fetchPlugins();
  }

  Future<List<PluginInfo>> _fetchPlugins() async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .listPlugins(ListPluginsRequest())
        .timeout(_rpcTimeout);
    return response.plugins.toList();
  }

  /// Re-fetches plugins from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPlugins);
  }

  /// Gets the status of a specific plugin.
  Future<PluginInfo> getPluginStatus(String name) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .getPluginStatus(GetPluginStatusRequest(name: name))
        .timeout(_rpcTimeout);
    return response.plugin;
  }

  /// Adds a new plugin and refreshes the list.
  Future<PluginInfo> addPlugin({
    required String name,
    required String socketPath,
  }) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .addPlugin(AddPluginRequest(name: name, socketPath: socketPath))
        .timeout(_mutationTimeout);
    await refresh();
    return response.plugin;
  }

  /// Removes a plugin and refreshes the list.
  Future<bool> removePlugin(String name) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .removePlugin(RemovePluginRequest(name: name))
        .timeout(_mutationTimeout);
    await refresh();
    return response.removed;
  }

  /// Enables a plugin and refreshes the list.
  Future<PluginInfo> enablePlugin(String name) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .enablePlugin(EnablePluginRequest(name: name))
        .timeout(_mutationTimeout);
    await refresh();
    return response.plugin;
  }

  /// Disables a plugin and refreshes the list.
  Future<PluginInfo> disablePlugin(String name) async {
    final client = ref.read(commandServiceProvider);
    final response = await client
        .disablePlugin(DisablePluginRequest(name: name))
        .timeout(_mutationTimeout);
    await refresh();
    return response.plugin;
  }
}
