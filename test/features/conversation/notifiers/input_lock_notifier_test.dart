import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/conversation/notifiers/input_lock_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockAgentServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(InputLockRequest());
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    container = ProviderContainer(
      overrides: [agentServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  group('InputLockNotifier - build', () {
    test('initial state is null', () {
      final state = container.read(inputLockProvider);
      expect(state, isNull);
    });
  });

  group('InputLockNotifier - requestInputLock', () {
    test('calls RPC with correct session ID', () async {
      when(() => mockClient.requestInputLock(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          InputLockResponse(granted: true, previousHolder: ''),
        ),
      );

      final notifier = container.read(inputLockProvider.notifier);
      await notifier.requestInputLock('sess-42');

      final captured =
          verify(
                () => mockClient.requestInputLock(captureAny()),
              ).captured.single
              as InputLockRequest;
      expect(captured.sessionId, 'sess-42');
    });

    test('returns response with granted and previousHolder', () async {
      when(() => mockClient.requestInputLock(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          InputLockResponse(granted: true, previousHolder: 'user-A'),
        ),
      );

      final notifier = container.read(inputLockProvider.notifier);
      final result = await notifier.requestInputLock('sess-1');

      expect(result.granted, isTrue);
      expect(result.previousHolder, 'user-A');
    });

    test('updates state after successful request', () async {
      when(() => mockClient.requestInputLock(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          InputLockResponse(granted: false, previousHolder: 'user-B'),
        ),
      );

      final notifier = container.read(inputLockProvider.notifier);
      await notifier.requestInputLock('sess-1');

      final state = container.read(inputLockProvider);
      expect(state, isNotNull);
      expect(state!.granted, isFalse);
      expect(state.previousHolder, 'user-B');
    });

    test('propagates gRPC error', () async {
      when(
        () => mockClient.requestInputLock(any()),
      ).thenThrow(const GrpcError.unavailable('daemon down'));

      final notifier = container.read(inputLockProvider.notifier);
      expect(
        () => notifier.requestInputLock('sess-1'),
        throwsA(isA<GrpcError>()),
      );
    });
  });
}
