import 'dart:async';

import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:flutter/foundation.dart';

/// Bridges app lifecycle events to the gRPC client manager, adding
/// extended background detection that tears down the channel after
/// 5 minutes.
///
/// On pause, it delegates to [GrpcClientManager.pause] immediately and starts
/// a 5-minute timer. If the timer fires before the app resumes, the channel
/// is torn down via [GrpcClientManager.disconnect].
///
/// On resume, it cancels the timer, delegates to [GrpcClientManager.resume],
/// and — if the channel was torn down — reconnects using the stored connection
/// parameters.
class GrpcLifecycleBridge {
  /// Creates a [GrpcLifecycleBridge] for the given manager.
  GrpcLifecycleBridge(this._manager);

  final GrpcClientManager _manager;
  Timer? _teardownTimer;
  bool _tornDown = false;

  /// How long the app must remain in the background before the gRPC channel
  /// is torn down to conserve resources.
  static const teardownDelay = Duration(minutes: 5);

  /// Called when the app enters background (paused/hidden).
  ///
  /// Immediately delegates to [GrpcClientManager.pause] to cancel any
  /// in-flight reconnection attempts, then starts the extended-background
  /// teardown timer.
  void onPaused() {
    _manager.pause();
    _teardownTimer?.cancel();
    _teardownTimer = Timer(teardownDelay, _teardownChannel);
  }

  /// Called when the app returns to foreground (resumed).
  ///
  /// Cancels the teardown timer if it hasn't fired yet. If the channel was
  /// torn down during extended background, reconnects using the stored
  /// connection parameters.
  void onResumed() {
    _teardownTimer?.cancel();
    _teardownTimer = null;
    _manager.resume();

    if (_tornDown) {
      _tornDown = false;
      _reconnect();
    }
  }

  /// Cancel the teardown timer and release resources.
  void dispose() {
    _teardownTimer?.cancel();
    _teardownTimer = null;
  }

  void _teardownChannel() {
    _teardownTimer = null;
    debugPrint(
      '[GrpcLifecycleBridge] Tearing down channel after extended background',
    );
    _tornDown = true;
    unawaited(_manager.disconnect());
  }

  void _reconnect() {
    final host = _manager.host;
    final port = _manager.port;
    if (host == null || port == null) return;

    debugPrint(
      '[GrpcLifecycleBridge] Reconnecting after extended background',
    );
    unawaited(
      _manager.connect(host, port, useTls: _manager.useTls),
    );
  }
}
