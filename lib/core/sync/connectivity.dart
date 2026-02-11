import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { online, offline }

class ConnectivityMonitor {
  ConnectivityMonitor() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<NetworkStatus>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<NetworkStatus> get statusStream => _controller.stream;

  Future<NetworkStatus> get currentStatus async {
    final results = await _connectivity.checkConnectivity();
    return _mapResults(results);
  }

  void start() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_mapResults(results));
    });
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }

  NetworkStatus _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return NetworkStatus.offline;
    }
    return NetworkStatus.online;
  }
}

final connectivityMonitorProvider = Provider<ConnectivityMonitor>((ref) {
  final monitor = ConnectivityMonitor()..start();
  ref.onDispose(monitor.dispose);
  return monitor;
});

final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final monitor = ref.watch(connectivityMonitorProvider);
  return monitor.statusStream;
});
