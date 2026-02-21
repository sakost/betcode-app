import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Default timeout for read-only gRPC RPCs (list, get).
const grpcRpcTimeout = Duration(seconds: 10);

/// Default timeout for mutating gRPC RPCs (create, update, delete).
const grpcMutationTimeout = Duration(seconds: 30);

/// Shared build helper for notifiers that return a list from gRPC.
///
/// Watches [connectionStatusProvider] and [selectedMachineIdProvider].
/// Returns an empty list when no machine is selected. Throws [StateError]
/// when not connected to the daemon.
Future<List<T>> grpcListBuild<T>(
  Ref ref,
  Future<List<T>> Function() fetch,
) async {
  final status = await ref.watch(connectionStatusProvider.future);
  if (status != GrpcConnectionStatus.connected) {
    throw StateError('Not connected to daemon');
  }
  final machineId = ref.watch(selectedMachineIdProvider);
  if (machineId == null) return [];
  return fetch();
}

/// Shared build helper for notifiers that return a single value from gRPC.
///
/// Watches [connectionStatusProvider] and [selectedMachineIdProvider].
/// Throws [StateError] when not connected or when no machine is selected.
Future<T> grpcSingleBuild<T>(
  Ref ref,
  Future<T> Function() fetch,
) async {
  final status = await ref.watch(connectionStatusProvider.future);
  if (status != GrpcConnectionStatus.connected) {
    throw StateError('Not connected to daemon');
  }
  final machineId = ref.watch(selectedMachineIdProvider);
  if (machineId == null) {
    throw StateError('No machine selected');
  }
  return fetch();
}
