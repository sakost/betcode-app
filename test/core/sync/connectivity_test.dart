import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/sync/connectivity.dart';

void main() {
  group('NetworkStatus', () {
    test('has online and offline values', () {
      expect(NetworkStatus.values, hasLength(2));
      expect(NetworkStatus.values, contains(NetworkStatus.online));
      expect(NetworkStatus.values, contains(NetworkStatus.offline));
    });
  });

  group('ConnectivityMonitor', () {
    late ConnectivityMonitor monitor;

    setUp(() {
      monitor = ConnectivityMonitor();
    });

    tearDown(() {
      monitor.dispose();
    });

    test('statusStream is a broadcast stream', () {
      // Should allow multiple listeners without throwing.
      monitor.statusStream.listen((_) {});
      monitor.statusStream.listen((_) {});
    });

    test('dispose closes the stream', () async {
      var done = false;
      monitor.statusStream.listen(
        (_) {},
        onDone: () => done = true,
      );

      monitor.dispose();
      await Future<void>.delayed(Duration.zero);

      expect(done, isTrue);

      // Recreate to avoid double-dispose in tearDown.
      monitor = ConnectivityMonitor();
    });
  });
}
