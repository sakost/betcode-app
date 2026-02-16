import 'dart:async';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/settings/notifiers/health_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/health.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/fake_response_stream.dart';
import '../../../helpers/notifier_test_helpers.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockBetCodeHealthClient extends Mock implements BetCodeHealthClient {}

class MockHealthClient extends Mock implements HealthClient {}

class _FailingBetCodeHealthClient extends Fake implements BetCodeHealthClient {
  _FailingBetCodeHealthClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<HealthDetailsResponse> getHealthDetails(
    HealthDetailsRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockBetCodeHealthClient mockBetCodeClient;
  late MockHealthClient mockHealthClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(HealthDetailsRequest());
    registerFallbackValue(HealthCheckRequest());
  });

  setUp(() {
    mockBetCodeClient = MockBetCodeHealthClient();
    mockHealthClient = MockHealthClient();
    container = createTestContainer(
      overrides: [
        betcodeHealthServiceProvider.overrideWithValue(mockBetCodeClient),
        healthServiceProvider.overrideWithValue(mockHealthClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------------------------
  // HealthNotifier - build
  // ---------------------------------------------------------------------------

  group('HealthNotifier - build', () {
    test('fetches health details from gRPC', () async {
      final details = HealthDetailsResponse(
        overallStatus: ServingStatus.SERVING,
        components: [
          ComponentHealth(
            name: 'database',
            status: ServingStatus.SERVING,
            message: 'OK',
          ),
        ],
        degraded: false,
      );
      when(
        () => mockBetCodeClient.getHealthDetails(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(details));

      final result = await container.read(healthProvider.future);

      expect(result.overallStatus, ServingStatus.SERVING);
      expect(result.components, hasLength(1));
      expect(result.components.first.name, 'database');
      expect(result.degraded, isFalse);
    });

    test('calls getHealthDetails exactly once on build', () async {
      when(
        () => mockBetCodeClient.getHealthDetails(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(HealthDetailsResponse()));

      await container.read(healthProvider.future);

      verify(() => mockBetCodeClient.getHealthDetails(any())).called(1);
    });

    test('preserves all response fields', () async {
      when(() => mockBetCodeClient.getHealthDetails(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          HealthDetailsResponse(
            overallStatus: ServingStatus.NOT_SERVING,
            components: [
              ComponentHealth(
                name: 'agent',
                status: ServingStatus.NOT_SERVING,
                message: 'agent crashed',
              ),
              ComponentHealth(
                name: 'database',
                status: ServingStatus.SERVING,
                message: 'OK',
              ),
            ],
            degraded: true,
            degradedReason: 'agent down',
          ),
        ),
      );

      final result = await container.read(healthProvider.future);

      expect(result.overallStatus, ServingStatus.NOT_SERVING);
      expect(result.components, hasLength(2));
      expect(result.components[0].name, 'agent');
      expect(result.components[0].status, ServingStatus.NOT_SERVING);
      expect(result.components[0].message, 'agent crashed');
      expect(result.components[1].name, 'database');
      expect(result.components[1].status, ServingStatus.SERVING);
      expect(result.degraded, isTrue);
      expect(result.degradedReason, 'agent down');
    });
  });

  connectionAwarenessTests(
    label: 'HealthNotifier',
    provider: healthProvider,
    serviceOverrides: () => [
      betcodeHealthServiceProvider.overrideWithValue(mockBetCodeClient),
      healthServiceProvider.overrideWithValue(mockHealthClient),
    ],
    verifyNoGrpcCalls: () =>
        verifyNever(() => mockBetCodeClient.getHealthDetails(any())),
  );

  errorHandlingTests(
    label: 'HealthNotifier',
    provider: healthProvider,
    errorOverrides: (error) => [
      betcodeHealthServiceProvider.overrideWithValue(
        _FailingBetCodeHealthClient(error),
      ),
      healthServiceProvider.overrideWithValue(mockHealthClient),
    ],
  );

  // ---------------------------------------------------------------------------
  // HealthNotifier - checkHealth
  // ---------------------------------------------------------------------------

  void stubHealthEmpty() {
    when(
      () => mockBetCodeClient.getHealthDetails(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(HealthDetailsResponse()));
  }

  group('HealthNotifier - checkHealth', () {
    /// Initializes the notifier and returns it ready for checkHealth calls.
    Future<HealthNotifier> initForCheck({
      HealthCheckResponse? stubResponse,
    }) async {
      await initNotifier(
        container: container,
        provider: healthProvider,
        stubEmpty: stubHealthEmpty,
      );
      when(() => mockHealthClient.check(any())).thenAnswer(
        (_) => FakeResponseFuture.value(stubResponse ?? HealthCheckResponse()),
      );
      return container.read(healthProvider.notifier);
    }

    test('calls Health.Check and returns response', () async {
      final notifier = await initForCheck(
        stubResponse: HealthCheckResponse(status: ServingStatus.SERVING),
      );
      final result = await notifier.checkHealth(service: 'agent');
      expect(result.status, ServingStatus.SERVING);
    });

    test('passes correct service name to gRPC', () async {
      final notifier = await initForCheck();
      await notifier.checkHealth(service: 'database');

      final captured =
          verify(() => mockHealthClient.check(captureAny())).captured.single
              as HealthCheckRequest;
      expect(captured.service, 'database');
    });

    test('defaults to empty service name', () async {
      final notifier = await initForCheck();
      await notifier.checkHealth();

      final captured =
          verify(() => mockHealthClient.check(captureAny())).captured.single
              as HealthCheckRequest;
      expect(captured.service, '');
    });
  });

  // ---------------------------------------------------------------------------
  // HealthNotifier - refresh
  // ---------------------------------------------------------------------------

  group('HealthNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockBetCodeClient.getHealthDetails(any())).thenAnswer(
        (_) => FakeResponseFuture.value(HealthDetailsResponse(degraded: false)),
      );
      await container.read(healthProvider.future);

      when(() => mockBetCodeClient.getHealthDetails(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          HealthDetailsResponse(degraded: true, degradedReason: 'high load'),
        ),
      );

      final notifier = container.read(healthProvider.notifier);
      await notifier.refresh();

      final state = container.read(healthProvider);
      expect(state.value!.degraded, isTrue);
      expect(state.value!.degradedReason, 'high load');
    });

    test('refresh calls gRPC exactly once', () async {
      stubHealthEmpty();
      await container.read(healthProvider.future);

      reset(mockBetCodeClient);
      stubHealthEmpty();

      final notifier = container.read(healthProvider.notifier);
      await notifier.refresh();

      verify(() => mockBetCodeClient.getHealthDetails(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // HealthNotifier - watchHealth (server-streaming)
  // ---------------------------------------------------------------------------

  group('HealthNotifier - watchHealth', () {
    /// Initializes notifier and stubs watch to use the returned controller.
    Future<
      ({
        HealthNotifier notifier,
        StreamController<HealthCheckResponse> controller,
      })
    >
    initForWatch() async {
      await initNotifier(
        container: container,
        provider: healthProvider,
        stubEmpty: stubHealthEmpty,
      );
      final controller = StreamController<HealthCheckResponse>();
      when(
        () => mockHealthClient.watch(any()),
      ).thenAnswer((_) => FakeResponseStream(controller));
      final notifier = container.read(healthProvider.notifier);
      return (notifier: notifier, controller: controller);
    }

    test('returns stream of HealthCheckResponse', () async {
      final (:notifier, :controller) = await initForWatch();
      final stream = notifier.watchHealth(service: 'agent');
      final eventsFuture = stream.toList();

      controller
        ..add(HealthCheckResponse(status: ServingStatus.SERVING))
        ..add(
          HealthCheckResponse(
            status: ServingStatus.NOT_SERVING,
          ),
        );
      unawaited(controller.close());

      final events = await eventsFuture;
      expect(events, hasLength(2));
      expect(events[0].status, ServingStatus.SERVING);
      expect(events[1].status, ServingStatus.NOT_SERVING);
    });

    test('passes correct service name to gRPC', () async {
      final (:notifier, :controller) = await initForWatch();
      addTearDown(() => unawaited(controller.close()));
      notifier.watchHealth(service: 'database');

      final captured =
          verify(() => mockHealthClient.watch(captureAny())).captured.single
              as HealthCheckRequest;
      expect(captured.service, 'database');
    });

    test('defaults to empty service name', () async {
      final (:notifier, :controller) = await initForWatch();
      addTearDown(() => unawaited(controller.close()));
      notifier.watchHealth();

      final captured =
          verify(() => mockHealthClient.watch(captureAny())).captured.single
              as HealthCheckRequest;
      expect(captured.service, '');
    });

    test('propagates stream errors', () async {
      final (:notifier, :controller) = await initForWatch();
      final stream = notifier.watchHealth();

      controller.addError(const GrpcError.unavailable('stream broken'));
      unawaited(controller.close());

      await expectLater(stream, emitsError(isA<GrpcError>()));
    });
  });
}
