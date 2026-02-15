import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the application lifecycle state as a Riverpod [Notifier].
///
/// Wraps [AppLifecycleListener] so that all components can react to
/// foreground / background transitions without duplicating the listener.
class AppLifecycleNotifier extends Notifier<AppLifecycleState> {
  DateTime? _backgroundedSince;
  AppLifecycleListener? _listener;

  @override
  AppLifecycleState build() {
    try {
      _listener = AppLifecycleListener(
        onPause: () => transition(AppLifecycleState.paused),
        onHide: () => transition(AppLifecycleState.hidden),
        onResume: () => transition(AppLifecycleState.resumed),
        onShow: () => transition(AppLifecycleState.resumed),
        onInactive: () => transition(AppLifecycleState.inactive),
        onDetach: () => transition(AppLifecycleState.detached),
      );
    } on Object catch (e) {
      debugPrint(
        '[AppLifecycleNotifier] No WidgetsBinding; lifecycle events disabled: $e',
      );
    }
    ref.onDispose(() {
      _listener?.dispose();
      _listener = null;
    });
    return AppLifecycleState.resumed;
  }

  /// When the app entered background, or null if currently foreground.
  DateTime? get backgroundedSince => _backgroundedSince;

  /// How long the app has been backgrounded ([Duration.zero] if foreground).
  Duration get backgroundDuration {
    final since = _backgroundedSince;
    if (since == null) return Duration.zero;
    return DateTime.now().difference(since);
  }

  /// Transition to a new lifecycle state.
  ///
  /// Exposed for testing; in production this is called by [AppLifecycleListener].
  @visibleForTesting
  void transition(AppLifecycleState newState) {
    if (newState == AppLifecycleState.paused ||
        newState == AppLifecycleState.hidden) {
      _backgroundedSince ??= DateTime.now();
    } else if (newState == AppLifecycleState.resumed) {
      _backgroundedSince = null;
    }
    state = newState;
  }
}

final appLifecycleProvider =
    NotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
      AppLifecycleNotifier.new,
    );
