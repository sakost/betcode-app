import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/health.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages health check data fetched from the daemon via gRPC.
///
/// On [build], fetches the current health details. Callers can
/// pull-to-refresh via [refresh].
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class HealthNotifier extends AsyncNotifier<HealthDetailsResponse> {
  static const _rpcTimeout = Duration(seconds: 10);

  @override
  Future<HealthDetailsResponse> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    return _fetchHealthDetails();
  }

  Future<HealthDetailsResponse> _fetchHealthDetails() async {
    final client = ref.read(betcodeHealthServiceProvider);
    return client.getHealthDetails(HealthDetailsRequest()).timeout(_rpcTimeout);
  }

  /// Re-fetches health details and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchHealthDetails);
  }

  /// Checks the health status of a specific service via the standard
  /// Health endpoint.
  Future<HealthCheckResponse> checkHealth({String service = ''}) async {
    final client = ref.read(healthServiceProvider);
    return client
        .check(HealthCheckRequest(service: service))
        .timeout(_rpcTimeout);
  }

  /// Watches the health status of a specific service via server-streaming.
  ///
  /// Returns a stream that emits [HealthCheckResponse] updates whenever the
  /// serving status of the named service changes.
  Stream<HealthCheckResponse> watchHealth({String service = ''}) {
    final client = ref.read(healthServiceProvider);
    return client.watch(HealthCheckRequest(service: service));
  }
}
