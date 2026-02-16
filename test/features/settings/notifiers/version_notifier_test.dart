import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/version.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/notifier_test_helpers.dart';
import '../../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockVersionServiceClient extends Mock implements VersionServiceClient {}

class _FailingVersionClient extends Fake implements VersionServiceClient {
  _FailingVersionClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<GetVersionResponse> getVersion(
    GetVersionRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockVersionServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(GetVersionRequest());
    registerFallbackValue(NegotiateRequest());
  });

  setUp(() {
    mockClient = MockVersionServiceClient();
    container = createTestContainer(
      overrides: [versionServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------------------------
  // VersionNotifier - build
  // ---------------------------------------------------------------------------

  group('VersionNotifier - build', () {
    test('fetches version from gRPC', () async {
      final version = GetVersionResponse(
        apiVersion: '1.0.0',
        serverVersion: '2.3.1',
        features: ['streaming', 'permissions'],
      );
      when(
        () => mockClient.getVersion(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(version));

      final result = await container.read(versionProvider.future);

      expect(result.apiVersion, '1.0.0');
      expect(result.serverVersion, '2.3.1');
      expect(result.features, ['streaming', 'permissions']);
    });

    test('calls getVersion exactly once on build', () async {
      when(
        () => mockClient.getVersion(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(GetVersionResponse()));

      await container.read(versionProvider.future);

      verify(() => mockClient.getVersion(any())).called(1);
    });

    test('preserves all version response fields', () async {
      when(() => mockClient.getVersion(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetVersionResponse(
            apiVersion: '2.0.0',
            serverVersion: '3.1.0',
            features: ['streaming', 'offline', 'e2e'],
            claudeCode: ClaudeCodeInfo(version: '1.5.0', apiVersion: '2.0.0'),
            constraints: VersionConstraints(
              minClientVersion: '1.0.0',
              recommendedClient: '2.0.0',
            ),
          ),
        ),
      );

      final result = await container.read(versionProvider.future);

      expect(result.apiVersion, '2.0.0');
      expect(result.serverVersion, '3.1.0');
      expect(result.features, hasLength(3));
      expect(result.claudeCode.version, '1.5.0');
      expect(result.constraints.minClientVersion, '1.0.0');
      expect(result.constraints.recommendedClient, '2.0.0');
    });
  });

  connectionAwarenessTests(
    label: 'VersionNotifier',
    provider: versionProvider,
    serviceOverrides: () => [
      versionServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () => verifyNever(() => mockClient.getVersion(any())),
  );

  errorHandlingTests(
    label: 'VersionNotifier',
    provider: versionProvider,
    errorOverrides: (error) => [
      versionServiceProvider.overrideWithValue(_FailingVersionClient(error)),
    ],
  );

  void stubVersionEmpty() {
    when(
      () => mockClient.getVersion(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(GetVersionResponse()));
  }

  // ---------------------------------------------------------------------------
  // VersionNotifier - negotiateCapabilities
  // ---------------------------------------------------------------------------

  group('VersionNotifier - negotiateCapabilities', () {
    test('sends negotiation request and returns response', () async {
      await initNotifier(
        container: container,
        provider: versionProvider,
        stubEmpty: stubVersionEmpty,
      );

      when(() => mockClient.negotiateCapabilities(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          NegotiateResponse(accepted: true, grantedFeatures: ['streaming']),
        ),
      );

      final notifier = container.read(versionProvider.notifier);
      final result = await notifier.negotiateCapabilities(
        clientVersion: '1.0.0',
        clientType: 'flutter',
        requestedFeatures: ['streaming', 'offline'],
      );

      expect(result.accepted, isTrue);
      expect(result.grantedFeatures, ['streaming']);
    });

    test('passes correct parameters to gRPC', () async {
      await initNotifier(
        container: container,
        provider: versionProvider,
        stubEmpty: stubVersionEmpty,
      );

      when(
        () => mockClient.negotiateCapabilities(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(NegotiateResponse()));

      final notifier = container.read(versionProvider.notifier);
      await notifier.negotiateCapabilities(
        clientVersion: '2.0.0',
        clientType: 'android',
        requestedFeatures: ['e2e-encryption'],
      );

      final captured =
          verify(
                () => mockClient.negotiateCapabilities(captureAny()),
              ).captured.single
              as NegotiateRequest;
      expect(captured.clientVersion, '2.0.0');
      expect(captured.clientType, 'android');
      expect(captured.requestedFeatures, ['e2e-encryption']);
    });

    test('returns rejection with reason', () async {
      await initNotifier(
        container: container,
        provider: versionProvider,
        stubEmpty: stubVersionEmpty,
      );

      when(() => mockClient.negotiateCapabilities(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          NegotiateResponse(
            accepted: false,
            rejectionReason: 'Client version too old',
            upgradeUrl: 'https://example.com/upgrade',
          ),
        ),
      );

      final notifier = container.read(versionProvider.notifier);
      final result = await notifier.negotiateCapabilities(
        clientVersion: '0.1.0',
        clientType: 'flutter',
      );

      expect(result.accepted, isFalse);
      expect(result.rejectionReason, 'Client version too old');
      expect(result.upgradeUrl, 'https://example.com/upgrade');
    });
  });

  // ---------------------------------------------------------------------------
  // VersionNotifier - refresh
  // ---------------------------------------------------------------------------

  group('VersionNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(() => mockClient.getVersion(any())).thenAnswer(
        (_) =>
            FakeResponseFuture.value(GetVersionResponse(apiVersion: '1.0.0')),
      );
      await container.read(versionProvider.future);

      when(() => mockClient.getVersion(any())).thenAnswer(
        (_) =>
            FakeResponseFuture.value(GetVersionResponse(apiVersion: '2.0.0')),
      );

      final notifier = container.read(versionProvider.notifier);
      await notifier.refresh();

      final state = container.read(versionProvider);
      expect(state.value!.apiVersion, '2.0.0');
    });

    test('refresh calls gRPC exactly once', () async {
      stubVersionEmpty();
      await container.read(versionProvider.future);

      reset(mockClient);
      stubVersionEmpty();

      final notifier = container.read(versionProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.getVersion(any())).called(1);
    });
  });
}
