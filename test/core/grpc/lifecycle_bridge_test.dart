import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/lifecycle_bridge.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

void main() {
  late GrpcClientManager manager;
  late GrpcLifecycleBridge bridge;

  setUp(() {
    manager = GrpcClientManager();
    bridge = GrpcLifecycleBridge(manager);
  });

  tearDown(() async {
    bridge.dispose();
    await manager.dispose();
  });

  group('GrpcLifecycleBridge', () {
    test('channel is NOT torn down before 5 minutes of background', () async {
      await manager.connect('localhost', 50051);
      expect(manager.status, GrpcConnectionStatus.connected);

      fakeAsync((async) {
        bridge.onPaused();
        async.elapse(const Duration(minutes: 4, seconds: 59));
        // Channel should still be present (not torn down)
        expect(manager.channelOrNull, isNotNull);
      });
    });

    test('channel IS torn down after 5 minutes of background', () async {
      await manager.connect('localhost', 50051);
      expect(manager.status, GrpcConnectionStatus.connected);

      fakeAsync((async) {
        bridge.onPaused();
        async
          ..elapse(const Duration(minutes: 5))
          // Timer fired, disconnect() was called (unawaited).
          // Flush microtasks so the async disconnect completes.
          ..flushMicrotasks();
        // Channel should be torn down
        expect(manager.channelOrNull, isNull);
        expect(manager.status, GrpcConnectionStatus.disconnected);
      });
    });

    test('resuming before 5 minutes cancels teardown timer', () async {
      await manager.connect('localhost', 50051);

      fakeAsync((async) {
        bridge.onPaused();
        async.elapse(const Duration(minutes: 3));
        bridge.onResumed();
        // Advance well past 5 minutes from original pause
        async
          ..elapse(const Duration(minutes: 3))
          ..flushMicrotasks();
        // Channel should still be available
        expect(manager.channelOrNull, isNotNull);
      });
    });

    test('resuming after teardown triggers reconnect', () async {
      await manager.connect('localhost', 50051);
      final origHost = manager.host;
      final origPort = manager.port;

      fakeAsync((async) {
        bridge.onPaused();
        async
          ..elapse(const Duration(minutes: 5))
          ..flushMicrotasks();
        expect(manager.status, GrpcConnectionStatus.disconnected);

        bridge.onResumed();
        // connect() is called as unawaited Future
        async.flushMicrotasks();

        // Manager should have attempted to reconnect with stored params
        expect(manager.host, origHost);
        expect(manager.port, origPort);
        // Status should be connecting or connected
        expect(
          manager.status,
          anyOf(
            GrpcConnectionStatus.connecting,
            GrpcConnectionStatus.connected,
          ),
        );
      });
    });

    test('reconnect uses stored connection parameters', () async {
      await manager.connect('relay.example.com', 443, useTls: true);

      fakeAsync((async) {
        bridge.onPaused();
        async
          ..elapse(const Duration(minutes: 5))
          ..flushMicrotasks();
        expect(manager.status, GrpcConnectionStatus.disconnected);

        bridge.onResumed();
        async.flushMicrotasks();

        // Should use stored params
        expect(manager.host, 'relay.example.com');
        expect(manager.port, 443);
        expect(manager.useTls, isTrue);
      });
    });

    test('onPaused is safe when not connected', () {
      // Should not throw
      bridge.onPaused();
      expect(manager.status, GrpcConnectionStatus.disconnected);
    });

    test('onResumed is safe when not connected and never paused', () {
      // Should not throw
      bridge.onResumed();
      expect(manager.status, GrpcConnectionStatus.disconnected);
    });

    test('dispose cancels pending teardown timer', () async {
      await manager.connect('localhost', 50051);

      fakeAsync((async) {
        bridge.onPaused();
        async.elapse(const Duration(minutes: 2));
        bridge.dispose();
        async
          ..elapse(const Duration(minutes: 4))
          ..flushMicrotasks();
        // Channel should NOT have been torn down
        expect(manager.channelOrNull, isNotNull);
      });
    });

    test('multiple pause/resume cycles work correctly', () async {
      await manager.connect('localhost', 50051);

      fakeAsync((async) {
        // First cycle: pause then resume quickly
        bridge.onPaused();
        async.elapse(const Duration(minutes: 1));

        // Second cycle: pause then resume quickly
        bridge
          ..onResumed()
          ..onPaused();
        async.elapse(const Duration(minutes: 1));
        bridge.onResumed();

        // Advance well past 5 minutes total
        async
          ..elapse(const Duration(minutes: 10))
          ..flushMicrotasks();

        // Channel should still be alive
        expect(manager.channelOrNull, isNotNull);
      });
    });

    test('onPaused also calls manager.pause()', () async {
      await manager.connect('localhost', 50051);
      expect(manager.isPaused, isFalse);

      bridge.onPaused();

      expect(manager.isPaused, isTrue);
    });

    test('onResumed also calls manager.resume()', () async {
      await manager.connect('localhost', 50051);

      bridge.onPaused();
      expect(manager.isPaused, isTrue);

      bridge.onResumed();
      expect(manager.isPaused, isFalse);
    });

    test(
      'short background with failing health check triggers reconnect',
      () async {
        // Create a manager whose health check always fails, simulating a
        // zombie channel (TCP died while the phone was asleep).
        final failingManager = GrpcClientManager(
          healthCheckFn: (_) async {
            throw Exception('connection dead');
          },
        );
        final failingBridge = GrpcLifecycleBridge(failingManager);
        addTearDown(() async {
          failingBridge.dispose();
          await failingManager.dispose();
        });

        await failingManager.connect('localhost', 50051);
        expect(failingManager.status, GrpcConnectionStatus.connected);

        fakeAsync((async) {
          // Short background (< 5 minutes)
          failingBridge.onPaused();
          async.elapse(const Duration(minutes: 1));
          failingBridge.onResumed();
          // Flush the health check + reconnect futures
          async.flushMicrotasks();

          // Manager should have attempted to reconnect (status is connecting
          // or connected depending on whether connect() to localhost succeeded)
          expect(
            failingManager.status,
            anyOf(
              GrpcConnectionStatus.connecting,
              GrpcConnectionStatus.connected,
            ),
          );
        });
      },
    );

    test(
      'short background with UNIMPLEMENTED health check does not reconnect',
      () async {
        // Simulate a relay that returns UNIMPLEMENTED for the Health service.
        // The healthCheckFn (as configured in grpc_providers) catches
        // UNIMPLEMENTED and returns normally — connection is alive.
        final unimplManager = GrpcClientManager(
          healthCheckFn: (_) async {
            try {
              throw const GrpcError.unimplemented();
            } on GrpcError catch (e) {
              if (e.code == StatusCode.unimplemented) return;
              rethrow;
            }
          },
        );
        final unimplBridge = GrpcLifecycleBridge(unimplManager);
        addTearDown(() async {
          unimplBridge.dispose();
          await unimplManager.dispose();
        });

        await unimplManager.connect('localhost', 50051);
        expect(unimplManager.status, GrpcConnectionStatus.connected);

        fakeAsync((async) {
          unimplBridge.onPaused();
          async.elapse(const Duration(minutes: 1));
          unimplBridge.onResumed();
          async.flushMicrotasks();

          // Channel should still be present — UNIMPLEMENTED means alive
          expect(unimplManager.channelOrNull, isNotNull);
          expect(unimplManager.status, GrpcConnectionStatus.connected);
        });
      },
    );

    test('short background with no health check skips verification', () async {
      // Default manager has no health check
      await manager.connect('localhost', 50051);
      expect(manager.hasHealthCheck, isFalse);

      fakeAsync((async) {
        bridge.onPaused();
        async.elapse(const Duration(minutes: 1));
        bridge.onResumed();
        async.flushMicrotasks();

        // Channel should still be the same (no reconnect triggered)
        expect(manager.channelOrNull, isNotNull);
        expect(manager.status, GrpcConnectionStatus.connected);
      });
    });
  });
}
