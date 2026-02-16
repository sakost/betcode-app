import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the device currently has network connectivity.
enum NetworkStatus {
  /// The device has at least one active network interface.
  online,

  /// The device has no network connectivity.
  offline,
}

/// Monitors device connectivity via [Connectivity] and exposes a broadcast
/// stream of [NetworkStatus] changes.
class ConnectivityMonitor {
  /// Creates a [ConnectivityMonitor] backed by the default
  /// [Connectivity] plugin.
  ConnectivityMonitor() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<NetworkStatus>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Broadcast stream that emits a [NetworkStatus] on every
  /// connectivity change.
  Stream<NetworkStatus> get statusStream => _controller.stream;

  /// Returns the current [NetworkStatus] by querying the platform.
  Future<NetworkStatus> get currentStatus async {
    final results = await _connectivity.checkConnectivity();
    return _mapResults(results);
  }

  /// Starts listening for platform connectivity changes.
  void start() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_mapResults(results));
    });
  }

  /// Cancels the platform subscription and closes the status stream.
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
  }

  NetworkStatus _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return NetworkStatus.offline;
    }
    return NetworkStatus.online;
  }
}

/// Provides the singleton [ConnectivityMonitor], started and disposed with
/// the provider lifecycle.
final connectivityMonitorProvider = Provider<ConnectivityMonitor>((ref) {
  final monitor = ConnectivityMonitor()..start();
  ref.onDispose(monitor.dispose);
  return monitor;
});

/// Exposes the [ConnectivityMonitor]'s status stream as a Riverpod
/// [StreamProvider].
final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final monitor = ref.watch(connectivityMonitorProvider);
  return monitor.statusStream;
});
