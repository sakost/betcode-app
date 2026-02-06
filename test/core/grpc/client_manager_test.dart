import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';

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
      expect(
        () => manager.channel,
        throwsA(isA<StateError>()),
      );
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

      expect(infos.any((i) => i.status == GrpcConnectionStatus.connecting), isTrue);
      expect(infos.any((i) => i.status == GrpcConnectionStatus.connected), isTrue);
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

      manager.reconnect('localhost', 50051);
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
      manager2.reconnect('localhost', 50051);
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
      manager.statusStream.listen(
        (_) {},
        onDone: () => completer.complete(),
      );
      await completer.future.timeout(const Duration(seconds: 1));

      // Re-create to avoid double-dispose in tearDown.
      manager = GrpcClientManager();
    });

    test('closes connectionInfo stream', () async {
      await manager.dispose();

      final completer = Completer<void>();
      manager.connectionInfoStream.listen(
        (_) {},
        onDone: () => completer.complete(),
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

  group('GrpcClientManager - backoff durations', () {
    test('reconnect sets attempt count on currentInfo synchronously', () {
      manager.reconnect('localhost', 50051);

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
      const c = ConnectionInfo(status: GrpcConnectionStatus.disconnected);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('copyWith', () {
      const info = ConnectionInfo(
        status: GrpcConnectionStatus.connecting,
        reconnectAttempt: 2,
      );
      final updated = info.copyWith(
        status: GrpcConnectionStatus.connected,
      );
      expect(updated.status, GrpcConnectionStatus.connected);
      expect(updated.reconnectAttempt, 2); // unchanged
    });
  });

  group('GrpcConnectionStatus', () {
    test('has all expected values', () {
      expect(GrpcConnectionStatus.values, containsAll([
        GrpcConnectionStatus.disconnected,
        GrpcConnectionStatus.connecting,
        GrpcConnectionStatus.authenticating,
        GrpcConnectionStatus.connected,
        GrpcConnectionStatus.reconnecting,
      ]));
    });
  });
}
