import 'dart:async';

import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

void main() {
  late GrpcClientManager manager;

  setUp(() {
    manager = GrpcClientManager();
  });

  tearDown(() async {
    await manager.dispose();
  });

  group('GrpcClientManager - initial state', () {
    test('starts disconnected', () {
      expect(manager.status, GrpcConnectionStatus.disconnected);
    });

    test('currentInfo starts with defaults', () {
      expect(manager.currentInfo.status, GrpcConnectionStatus.disconnected);
      expect(manager.currentInfo.errorMessage, isNull);
      expect(manager.currentInfo.reconnectAttempt, 0);
    });

    test('channelOrNull is null before connect', () {
      expect(manager.channelOrNull, isNull);
    });

    test('channel throws StateError before connect', () {
      expect(() => manager.channel, throwsA(isA<StateError>()));
    });

    test('interceptors defaults to empty list', () {
      expect(manager.interceptors, isEmpty);
    });
  });

  group('GrpcClientManager - statusStream', () {
    test('emits status changes', () async {
      final statuses = <GrpcConnectionStatus>[];
      manager.statusStream.listen(statuses.add);

      // connect emits connecting then connected
      await manager.connect('localhost', 50051);
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(GrpcConnectionStatus.connecting));
      expect(statuses, contains(GrpcConnectionStatus.connected));
    });

    test('disconnect emits disconnected', () async {
      final statuses = <GrpcConnectionStatus>[];
      manager.statusStream.listen(statuses.add);

      await manager.connect('localhost', 50051);
      await manager.disconnect();
      await Future<void>.delayed(Duration.zero);

      expect(statuses.last, GrpcConnectionStatus.disconnected);
    });
  });

  group('GrpcClientManager - connectionInfoStream', () {
    test('emits full ConnectionInfo with status', () async {
      final infos = <ConnectionInfo>[];
      manager.connectionInfoStream.listen(infos.add);

      await manager.connect('localhost', 50051);
      await Future<void>.delayed(Duration.zero);

      expect(
        infos.any((i) => i.status == GrpcConnectionStatus.connecting),
        isTrue,
      );
      expect(
        infos.any((i) => i.status == GrpcConnectionStatus.connected),
        isTrue,
      );
    });
  });

  group('GrpcClientManager - connect', () {
    test('sets channel after connect', () async {
      await manager.connect('localhost', 50051);
      expect(manager.channelOrNull, isNotNull);
      expect(manager.channel, isNotNull);
    });

    test('status is connected after success', () async {
      await manager.connect('localhost', 50051);
      expect(manager.status, GrpcConnectionStatus.connected);
    });

    test('second connect shuts down first channel', () async {
      await manager.connect('localhost', 50051);
      final firstChannel = manager.channel;

      await manager.connect('localhost', 50052);
      final secondChannel = manager.channel;

      expect(secondChannel, isNot(same(firstChannel)));
      expect(manager.status, GrpcConnectionStatus.connected);
    });
  });

  group('GrpcClientManager - disconnect', () {
    test('clears channel', () async {
      await manager.connect('localhost', 50051);
      expect(manager.channelOrNull, isNotNull);

      await manager.disconnect();
      expect(manager.channelOrNull, isNull);
      expect(manager.status, GrpcConnectionStatus.disconnected);
    });

    test('disconnect without connect is safe', () async {
      await manager.disconnect();
      expect(manager.status, GrpcConnectionStatus.disconnected);
    });
  });

  group('GrpcClientManager - reconnect', () {
    test('emits reconnecting status with attempt count', () async {
      final infos = <ConnectionInfo>[];
      manager.connectionInfoStream.listen(infos.add);

      manager.reconnect(host: 'localhost', port: 50051);
      await Future<void>.delayed(Duration.zero);

      expect(
        infos.any(
          (i) =>
              i.status == GrpcConnectionStatus.reconnecting &&
              i.reconnectAttempt == 1,
        ),
        isTrue,
      );
    });

    test('reconnect after dispose is no-op', () async {
      await manager.dispose();

      // Should not throw or emit.
      final manager2 = GrpcClientManager();
      await manager2.dispose();
      manager2.reconnect(host: 'localhost', port: 50051);
      // No assertion needed — just verify no crash.
      // Re-assign manager to avoid double-dispose in tearDown.
      manager = GrpcClientManager();
    });
  });

  group('GrpcClientManager - dispose', () {
    test('closes status stream', () async {
      await manager.dispose();

      // After dispose, adding listeners should get done event.
      final completer = Completer<void>();
      manager.statusStream.listen((_) {}, onDone: completer.complete);
      await completer.future.timeout(const Duration(seconds: 1));

      // Re-create to avoid double-dispose in tearDown.
      manager = GrpcClientManager();
    });

    test('closes connectionInfo stream', () async {
      await manager.dispose();

      final completer = Completer<void>();
      manager.connectionInfoStream.listen(
        (_) {},
        onDone: completer.complete,
      );
      await completer.future.timeout(const Duration(seconds: 1));

      manager = GrpcClientManager();
    });

    test('channel is null after dispose', () async {
      await manager.connect('localhost', 50051);
      await manager.dispose();
      expect(manager.channelOrNull, isNull);

      manager = GrpcClientManager();
    });
  });

  group('GrpcClientManager - stored connection parameters', () {
    test('stores host, port, useTls after connect', () async {
      await manager.connect('myhost', 9090, useTls: true);

      expect(manager.host, 'myhost');
      expect(manager.port, 9090);
      expect(manager.useTls, isTrue);
    });

    test('host, port, useTls are null/false before connect', () {
      expect(manager.host, isNull);
      expect(manager.port, isNull);
      expect(manager.useTls, isFalse);
    });

    test('reconnect uses stored parameters when none supplied', () async {
      await manager.connect('localhost', 50051);

      final infos = <ConnectionInfo>[];
      manager.connectionInfoStream.listen(infos.add);

      manager.reconnect();
      await Future<void>.delayed(Duration.zero);

      expect(
        infos.any(
          (i) =>
              i.status == GrpcConnectionStatus.reconnecting &&
              i.reconnectAttempt == 1,
        ),
        isTrue,
      );
    });

    test('reconnect throws if no stored params and none supplied', () {
      expect(() => manager.reconnect(), throwsA(isA<StateError>()));
    });

    test('reconnect with explicit args overrides stored params', () async {
      await manager.connect('localhost', 50051);

      // Reconnect with different params — should not throw
      manager.reconnect(host: 'otherhost', port: 9999, useTls: true);

      expect(manager.currentInfo.status, GrpcConnectionStatus.reconnecting);
    });
  });

  group('GrpcClientManager - health check', () {
    test('calls healthCheckFn during connect', () async {
      var healthCheckCalled = false;
      final mgr = GrpcClientManager(
        healthCheckFn: (channel) async {
          healthCheckCalled = true;
        },
      );
      addTearDown(mgr.dispose);

      await mgr.connect('localhost', 50051);

      expect(healthCheckCalled, isTrue);
      expect(mgr.status, GrpcConnectionStatus.connected);
    });

    test('emits connected after successful health check', () async {
      final statuses = <GrpcConnectionStatus>[];
      final mgr = GrpcClientManager(
        healthCheckFn: (channel) async {
          // Successful health check.
        },
      );
      addTearDown(mgr.dispose);
      mgr.statusStream.listen(statuses.add);

      await mgr.connect('localhost', 50051);
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(GrpcConnectionStatus.connecting));
      expect(statuses, contains(GrpcConnectionStatus.connected));
    });

    test(
      'emits connected even when health check throws (graceful fallback)',
      () async {
        final mgr = GrpcClientManager(
          healthCheckFn: (channel) async {
            throw const GrpcError.unavailable('daemon not ready');
          },
        );
        addTearDown(mgr.dispose);

        await mgr.connect('localhost', 50051);

        expect(mgr.status, GrpcConnectionStatus.connected);
        expect(mgr.channelOrNull, isNotNull);
      },
    );

    test('connect succeeds without healthCheckFn (backward compat)', () async {
      final mgr = GrpcClientManager();
      addTearDown(mgr.dispose);

      await mgr.connect('localhost', 50051);

      expect(mgr.status, GrpcConnectionStatus.connected);
    });

    test('health check receives the created channel', () async {
      ClientChannel? receivedChannel;
      final mgr = GrpcClientManager(
        healthCheckFn: (channel) async {
          receivedChannel = channel;
        },
      );
      addTearDown(mgr.dispose);

      await mgr.connect('localhost', 50051);

      expect(receivedChannel, isNotNull);
      expect(receivedChannel, same(mgr.channel));
    });
  });

  group('GrpcClientManager - backoff durations', () {
    test('reconnect sets attempt count on currentInfo synchronously', () {
      manager.reconnect(host: 'localhost', port: 50051);

      // _reconnectLoop emits synchronously before the timer fires.
      expect(manager.currentInfo.status, GrpcConnectionStatus.reconnecting);
      expect(manager.currentInfo.reconnectAttempt, 1);
    });
  });

  group('ConnectionInfo', () {
    test('default values', () {
      const info = ConnectionInfo();
      expect(info.status, GrpcConnectionStatus.disconnected);
      expect(info.errorMessage, isNull);
      expect(info.reconnectAttempt, 0);
    });

    test('custom values', () {
      const info = ConnectionInfo(
        status: GrpcConnectionStatus.connected,
        errorMessage: 'test error',
        reconnectAttempt: 3,
      );
      expect(info.status, GrpcConnectionStatus.connected);
      expect(info.errorMessage, 'test error');
      expect(info.reconnectAttempt, 3);
    });

    test('equality', () {
      const a = ConnectionInfo(status: GrpcConnectionStatus.connected);
      const b = ConnectionInfo(status: GrpcConnectionStatus.connected);
      const c = ConnectionInfo();
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('copyWith', () {
      const info = ConnectionInfo(
        status: GrpcConnectionStatus.connecting,
        reconnectAttempt: 2,
      );
      final updated = info.copyWith(status: GrpcConnectionStatus.connected);
      expect(updated.status, GrpcConnectionStatus.connected);
      expect(updated.reconnectAttempt, 2); // unchanged
    });
  });

  group('GrpcConnectionStatus', () {
    test('has all expected values', () {
      expect(
        GrpcConnectionStatus.values,
        containsAll([
          GrpcConnectionStatus.disconnected,
          GrpcConnectionStatus.connecting,
          GrpcConnectionStatus.authenticating,
          GrpcConnectionStatus.connected,
          GrpcConnectionStatus.reconnecting,
        ]),
      );
    });
  });

  group('GrpcClientManager - pause/resume lifecycle', () {
    test('isPaused is false initially', () {
      expect(manager.isPaused, isFalse);
    });

    test('pause() cancels active reconnection timer', () {
      fakeAsync((async) {
        final mgr = GrpcClientManager()
          // Start a reconnect — schedules a timer.
          ..reconnect(host: 'localhost', port: 50051);
        expect(mgr.status, GrpcConnectionStatus.reconnecting);

        // Pause before the timer fires.
        mgr.pause();
        expect(mgr.isPaused, isTrue);

        // Advance well past all backoff durations.
        async.elapse(const Duration(seconds: 60));

        // Status should still be reconnecting.
        expect(mgr.status, GrpcConnectionStatus.reconnecting);

        unawaited(mgr.dispose());
      });
    });

    test('pause() does not disconnect the channel', () async {
      await manager.connect('localhost', 50051);
      expect(manager.channelOrNull, isNotNull);
      expect(manager.status, GrpcConnectionStatus.connected);

      manager.pause();

      // Channel should still be available.
      expect(manager.channelOrNull, isNotNull);
      expect(manager.status, GrpcConnectionStatus.connected);
    });

    test('resume() restarts reconnection when in reconnecting state', () {
      fakeAsync((async) {
        final mgr = GrpcClientManager()
          // Start reconnect, then pause.
          ..reconnect(host: 'localhost', port: 50051)
          ..pause();

        // Advance past initial timer.
        async.elapse(const Duration(seconds: 1));
        expect(mgr.status, GrpcConnectionStatus.reconnecting);

        // Resume — should restart reconnection.
        mgr.resume();
        expect(mgr.isPaused, isFalse);

        expect(mgr.status, GrpcConnectionStatus.reconnecting);
        expect(mgr.currentInfo.reconnectAttempt, 1);

        unawaited(mgr.dispose());
      });
    });

    test('reconnect loop does not fire while paused', () {
      fakeAsync((async) {
        final mgr = GrpcClientManager()
          // Pause first, then trigger reconnect.
          ..pause()
          ..reconnect(host: 'localhost', port: 50051);

        // The _reconnectLoop should bail out immediately because _paused is
        // true. Status should still be whatever reconnect() set before
        // _reconnectLoop returned early. Since _reconnectLoop returns early
        // before emitting, let's check status stays disconnected or doesn't
        // schedule any timer.
        // Actually reconnect() calls _cancelReconnect() then _reconnectLoop().
        // _reconnectLoop checks _paused at top and returns immediately.
        // Status was 'disconnected' initially, and _reconnectLoop didn't emit.
        expect(mgr.status, GrpcConnectionStatus.disconnected);

        // Advance well past all backoff durations — nothing fires.
        async.elapse(const Duration(seconds: 60));
        expect(mgr.status, GrpcConnectionStatus.disconnected);

        unawaited(mgr.dispose());
      });
    });

    test('pause/resume cycle resets reconnect attempts', () {
      fakeAsync((async) {
        final mgr = GrpcClientManager()
          // Start reconnecting.
          ..reconnect(host: 'localhost', port: 50051);
        expect(mgr.currentInfo.reconnectAttempt, 1);

        // Pause to cancel the reconnect timer.
        mgr.pause();
        expect(
          mgr.currentInfo.status,
          GrpcConnectionStatus.reconnecting,
        );

        // Resume — should restart reconnection.
        mgr.resume();
        expect(
          mgr.currentInfo.reconnectAttempt,
          1,
        ); // reset: attempt 0+1=1
        expect(
          mgr.currentInfo.status,
          GrpcConnectionStatus.reconnecting,
        );

        unawaited(mgr.dispose());
      });
    });

    test('pause is idempotent', () {
      manager.pause();
      expect(manager.isPaused, isTrue);
      manager.pause(); // second call is no-op
      expect(manager.isPaused, isTrue);
    });

    test('resume is idempotent when not paused', () {
      manager.resume(); // no-op when not paused
      expect(manager.isPaused, isFalse);
    });
  });
}
