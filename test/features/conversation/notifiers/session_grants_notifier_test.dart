import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/conversation/notifiers/session_grants_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/test_container.dart';

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
    registerFallbackValue(ListSessionGrantsRequest());
    registerFallbackValue(SetSessionGrantRequest());
    registerFallbackValue(ClearSessionGrantsRequest());
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    container = createTestContainer(
      overrides: [agentServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  SessionGrantEntry makeGrant(String tool, {bool granted = true}) =>
      SessionGrantEntry(toolName: tool, granted: granted);

  group('SessionGrantsNotifier - build', () {
    test('returns empty list when no session ID set', () async {
      final result = await container.read(sessionGrantsProvider.future);
      expect(result, isEmpty);
    });

    test('fetches grants when session ID is set', () async {
      when(() => mockClient.listSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionGrantsResponse(
            grants: [
              makeGrant('Bash', granted: true),
              makeGrant('Read', granted: false),
            ],
          ),
        ),
      );

      // Trigger build first, then set session ID
      await container.read(sessionGrantsProvider.future);
      final notifier = container.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-1');

      // Wait for the rebuild after setSessionId
      final result = await container.read(sessionGrantsProvider.future);

      expect(result, hasLength(2));
      expect(result[0].toolName, 'Bash');
      expect(result[0].granted, isTrue);
      expect(result[1].toolName, 'Read');
      expect(result[1].granted, isFalse);
    });

    test('passes correct session ID to gRPC', () async {
      when(() => mockClient.listSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListSessionGrantsResponse()),
      );

      await container.read(sessionGrantsProvider.future);
      final notifier = container.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-42');

      await container.read(sessionGrantsProvider.future);

      final captured =
          verify(
                () => mockClient.listSessionGrants(captureAny()),
              ).captured.single
              as ListSessionGrantsRequest;
      expect(captured.sessionId, 'sess-42');
    });
  });

  group('SessionGrantsNotifier - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final disconnectedContainer = createTestContainer(
        status: GrpcConnectionStatus.disconnected,
        overrides: [agentServiceProvider.overrideWithValue(mockClient)],
      );
      addTearDown(disconnectedContainer.dispose);

      disconnectedContainer.read(sessionGrantsProvider);
      await Future<void>.delayed(Duration.zero);

      final state = disconnectedContainer.read(sessionGrantsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });
  });

  group('SessionGrantsNotifier - setGrant', () {
    test('calls setSessionGrant RPC and refreshes', () async {
      // Initial build with empty session ID -> empty list
      await container.read(sessionGrantsProvider.future);

      when(() => mockClient.listSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListSessionGrantsResponse(grants: [makeGrant('Bash', granted: true)]),
        ),
      );

      when(
        () => mockClient.setSessionGrant(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(SetSessionGrantResponse()));

      final notifier = container.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-1');
      await container.read(sessionGrantsProvider.future);

      await notifier.setGrant(toolName: 'Bash', granted: true);

      final captured =
          verify(() => mockClient.setSessionGrant(captureAny())).captured.single
              as SetSessionGrantRequest;
      expect(captured.sessionId, 'sess-1');
      expect(captured.toolName, 'Bash');
      expect(captured.granted, isTrue);

      // listSessionGrants called once for setSessionId rebuild, once for
      // refresh after setGrant
      verify(() => mockClient.listSessionGrants(any())).called(2);
    });
  });

  group('SessionGrantsNotifier - clearGrants', () {
    test('calls clearSessionGrants RPC and refreshes', () async {
      await container.read(sessionGrantsProvider.future);

      when(() => mockClient.listSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListSessionGrantsResponse()),
      );

      when(() => mockClient.clearSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ClearSessionGrantsResponse()),
      );

      final notifier = container.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-1');
      await container.read(sessionGrantsProvider.future);

      await notifier.clearGrants();

      final captured =
          verify(
                () => mockClient.clearSessionGrants(captureAny()),
              ).captured.single
              as ClearSessionGrantsRequest;
      expect(captured.sessionId, 'sess-1');
      expect(captured.toolName, '');

      // listSessionGrants called once for setSessionId rebuild, once for
      // refresh after clearGrants
      verify(() => mockClient.listSessionGrants(any())).called(2);
    });

    test('passes toolName when specified', () async {
      await container.read(sessionGrantsProvider.future);

      when(() => mockClient.listSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListSessionGrantsResponse()),
      );

      when(() => mockClient.clearSessionGrants(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ClearSessionGrantsResponse()),
      );

      final notifier = container.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-1');
      await container.read(sessionGrantsProvider.future);

      await notifier.clearGrants(toolName: 'Bash');

      final captured =
          verify(
                () => mockClient.clearSessionGrants(captureAny()),
              ).captured.single
              as ClearSessionGrantsRequest;
      expect(captured.toolName, 'Bash');
    });
  });

  group('SessionGrantsNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final failClient = MockAgentServiceClient();

      when(
        () => failClient.listSessionGrants(any()),
      ).thenThrow(GrpcError.unavailable('connection refused'));

      final errContainer = createTestContainer(
        overrides: [agentServiceProvider.overrideWithValue(failClient)],
      );
      addTearDown(errContainer.dispose);

      // Initial build returns empty (no session ID) -- wait for it.
      await errContainer.read(sessionGrantsProvider.future);

      // Listen for state changes to capture the error state.
      final states = <AsyncValue<List<SessionGrantEntry>>>[];
      errContainer.listen(sessionGrantsProvider, (prev, next) {
        states.add(next);
      });

      // Set a session ID so the notifier rebuilds and calls listSessionGrants.
      final notifier = errContainer.read(sessionGrantsProvider.notifier);
      notifier.setSessionId('sess-fail');

      // Let microtasks settle. Riverpod 3.x retries on error, so we wait
      // for the first error state to appear.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Check that the state has an error.
      final state = errContainer.read(sessionGrantsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });
  });
}
