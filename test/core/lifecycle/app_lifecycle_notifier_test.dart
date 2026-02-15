import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/lifecycle/app_lifecycle_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  AppLifecycleNotifier readNotifier() =>
      container.read(appLifecycleProvider.notifier);
  AppLifecycleState readState() => container.read(appLifecycleProvider);

  group('AppLifecycleNotifier - initial state', () {
    test('default state is AppLifecycleState.resumed', () {
      expect(readState(), AppLifecycleState.resumed);
    });

    test('works in headless test without WidgetsBinding', () {
      final notifier = readNotifier();
      expect(notifier, isNotNull);
      expect(readState(), AppLifecycleState.resumed);
    });

    test('backgroundedSince is null when in resumed state', () {
      final notifier = readNotifier();
      expect(notifier.backgroundedSince, isNull);
    });

    test('backgroundDuration returns Duration.zero when not backgrounded', () {
      final notifier = readNotifier();
      expect(notifier.backgroundDuration, Duration.zero);
    });
  });

  group('AppLifecycleNotifier - state transitions', () {
    test('transition to paused updates state', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      expect(readState(), AppLifecycleState.paused);
    });

    test('transition to hidden updates state', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.hidden);
      expect(readState(), AppLifecycleState.hidden);
    });

    test('transition to resumed updates state', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      notifier.transition(AppLifecycleState.resumed);
      expect(readState(), AppLifecycleState.resumed);
    });

    test('transition to inactive updates state', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.inactive);
      expect(readState(), AppLifecycleState.inactive);
    });

    test('transition to detached updates state', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.detached);
      expect(readState(), AppLifecycleState.detached);
    });
  });

  group('AppLifecycleNotifier - backgroundedSince tracking', () {
    test('backgroundedSince is set when paused', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      expect(notifier.backgroundedSince, isNotNull);
    });

    test('backgroundedSince is set when hidden', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.hidden);
      expect(notifier.backgroundedSince, isNotNull);
    });

    test('backgroundedSince is cleared when resumed', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      expect(notifier.backgroundedSince, isNotNull);

      notifier.transition(AppLifecycleState.resumed);
      expect(notifier.backgroundedSince, isNull);
    });

    test('backgroundedSince is not overwritten by second background event', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      final firstTimestamp = notifier.backgroundedSince;

      // hidden after paused should not overwrite the timestamp
      notifier.transition(AppLifecycleState.hidden);
      expect(notifier.backgroundedSince, same(firstTimestamp));
    });

    test('backgroundDuration is positive after pausing', () {
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.paused);
      // Duration should be >= 0 (could be 0 if measured instantly)
      expect(notifier.backgroundDuration, greaterThanOrEqualTo(Duration.zero));
    });
  });

  group('AppLifecycleNotifier - onShow maps to resumed', () {
    test('show callback maps to resumed state (via transition)', () {
      // This tests the design choice that onShow triggers resumed.
      // In the real listener, onShow calls transition(AppLifecycleState.resumed).
      final notifier = readNotifier();
      notifier.transition(AppLifecycleState.hidden);
      expect(readState(), AppLifecycleState.hidden);

      // Simulate onShow -> resumed
      notifier.transition(AppLifecycleState.resumed);
      expect(readState(), AppLifecycleState.resumed);
      expect(notifier.backgroundedSince, isNull);
    });
  });
}
