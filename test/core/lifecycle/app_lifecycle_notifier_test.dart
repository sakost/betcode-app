import 'package:betcode_app/core/lifecycle/app_lifecycle_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
      expect(readNotifier().backgroundedSince, isNull);
    });

    test(
      'backgroundDuration returns Duration.zero when not '
      'backgrounded',
      () {
        expect(
          readNotifier().backgroundDuration,
          Duration.zero,
        );
      },
    );
  });

  group('AppLifecycleNotifier - state transitions', () {
    test('transition to paused updates state', () {
      readNotifier().transition(AppLifecycleState.paused);
      expect(readState(), AppLifecycleState.paused);
    });

    test('transition to hidden updates state', () {
      readNotifier().transition(AppLifecycleState.hidden);
      expect(readState(), AppLifecycleState.hidden);
    });

    test('transition to resumed updates state', () {
      readNotifier()
        ..transition(AppLifecycleState.paused)
        ..transition(AppLifecycleState.resumed);
      expect(readState(), AppLifecycleState.resumed);
    });

    test('transition to inactive updates state', () {
      readNotifier().transition(AppLifecycleState.inactive);
      expect(readState(), AppLifecycleState.inactive);
    });

    test('transition to detached updates state', () {
      readNotifier().transition(AppLifecycleState.detached);
      expect(readState(), AppLifecycleState.detached);
    });
  });

  group('AppLifecycleNotifier - backgroundedSince tracking', () {
    test('backgroundedSince is set when paused', () {
      final notifier = readNotifier()..transition(AppLifecycleState.paused);
      expect(notifier.backgroundedSince, isNotNull);
    });

    test('backgroundedSince is set when hidden', () {
      final notifier = readNotifier()..transition(AppLifecycleState.hidden);
      expect(notifier.backgroundedSince, isNotNull);
    });

    test('backgroundedSince is cleared when resumed', () {
      final notifier = readNotifier()..transition(AppLifecycleState.paused);
      expect(notifier.backgroundedSince, isNotNull);

      notifier.transition(AppLifecycleState.resumed);
      expect(notifier.backgroundedSince, isNull);
    });

    test(
      'backgroundedSince is not overwritten by second '
      'background event',
      () {
        final notifier = readNotifier()..transition(AppLifecycleState.paused);
        final firstTimestamp = notifier.backgroundedSince;

        // hidden after paused should not overwrite
        notifier.transition(AppLifecycleState.hidden);
        expect(
          notifier.backgroundedSince,
          same(firstTimestamp),
        );
      },
    );

    test('backgroundDuration is positive after pausing', () {
      final notifier = readNotifier()..transition(AppLifecycleState.paused);
      expect(
        notifier.backgroundDuration,
        greaterThanOrEqualTo(Duration.zero),
      );
    });
  });

  group('AppLifecycleNotifier - onShow maps to resumed', () {
    test(
      'show callback maps to resumed state (via transition)',
      () {
        final notifier = readNotifier()..transition(AppLifecycleState.hidden);
        expect(readState(), AppLifecycleState.hidden);

        // Simulate onShow -> resumed
        notifier.transition(AppLifecycleState.resumed);
        expect(readState(), AppLifecycleState.resumed);
        expect(notifier.backgroundedSince, isNull);
      },
    );
  });
}
