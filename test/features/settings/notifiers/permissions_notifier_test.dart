import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/settings/notifiers/settings_providers.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbgrpc.dart';
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

class MockConfigServiceClient extends Mock implements ConfigServiceClient {}

class _FailingConfigClient extends Fake implements ConfigServiceClient {
  _FailingConfigClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<PermissionRules> getPermissions(
    GetPermissionsRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockConfigServiceClient mockClient;
  late ProviderContainer container;
  const testSessionId = 'test-session-42';

  setUpAll(() {
    registerFallbackValue(GetPermissionsRequest());
  });

  setUp(() {
    mockClient = MockConfigServiceClient();
    container = createTestContainer(
      overrides: [configServiceProvider.overrideWithValue(mockClient)],
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------------------------
  // PermissionsNotifier - build
  // ---------------------------------------------------------------------------

  group('PermissionsNotifier - build', () {
    test('fetches permissions from gRPC', () async {
      final rules = PermissionRules(
        rules: [
          PermissionRule(
            id: 'rule-1',
            toolPattern: 'bash*',
            action: PermissionAction.PERMISSION_ACTION_ALLOW,
          ),
        ],
        deniedTools: ['rm', 'shutdown'],
        requireApproval: ['dangerous-tool'],
      );
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(rules));

      final result = await container.read(
        permissionsProvider(testSessionId).future,
      );

      expect(result.rules, hasLength(1));
      expect(result.rules.first.id, 'rule-1');
      expect(result.rules.first.toolPattern, 'bash*');
      expect(
        result.rules.first.action,
        PermissionAction.PERMISSION_ACTION_ALLOW,
      );
      expect(result.deniedTools, ['rm', 'shutdown']);
      expect(result.requireApproval, ['dangerous-tool']);
    });

    test('returns empty rules when none configured', () async {
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));

      final result = await container.read(
        permissionsProvider(testSessionId).future,
      );
      expect(result.rules, isEmpty);
      expect(result.deniedTools, isEmpty);
      expect(result.requireApproval, isEmpty);
    });

    test('calls getPermissions exactly once on build', () async {
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));

      await container.read(permissionsProvider(testSessionId).future);

      verify(() => mockClient.getPermissions(any())).called(1);
    });

    test('passes sessionId to GetPermissionsRequest', () async {
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));

      await container.read(permissionsProvider(testSessionId).future);

      final captured =
          verify(() => mockClient.getPermissions(captureAny())).captured.single
              as GetPermissionsRequest;
      expect(captured.sessionId, testSessionId);
    });

    test('preserves all PermissionRule fields', () async {
      when(() => mockClient.getPermissions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          PermissionRules(
            rules: [
              PermissionRule(
                id: 'rule-2',
                toolPattern: 'file_*',
                pathPattern: '/home/**',
                action: PermissionAction.PERMISSION_ACTION_DENY,
                priority: 10,
                description: 'Deny file tools in home',
                source: 'user',
              ),
            ],
          ),
        ),
      );

      final result = await container.read(
        permissionsProvider(testSessionId).future,
      );
      final rule = result.rules.first;

      expect(rule.id, 'rule-2');
      expect(rule.toolPattern, 'file_*');
      expect(rule.pathPattern, '/home/**');
      expect(rule.action, PermissionAction.PERMISSION_ACTION_DENY);
      expect(rule.priority, 10);
      expect(rule.description, 'Deny file tools in home');
      expect(rule.source, 'user');
    });
  });

  connectionAwarenessTests(
    label: 'PermissionsNotifier',
    provider: permissionsProvider(testSessionId),
    serviceOverrides: () => [
      configServiceProvider.overrideWithValue(mockClient),
    ],
    verifyNoGrpcCalls: () =>
        verifyNever(() => mockClient.getPermissions(any())),
  );

  errorHandlingTests(
    label: 'PermissionsNotifier',
    provider: permissionsProvider(testSessionId),
    errorOverrides: (error) => [
      configServiceProvider.overrideWithValue(_FailingConfigClient(error)),
    ],
  );

  // ---------------------------------------------------------------------------
  // PermissionsNotifier - refresh
  // ---------------------------------------------------------------------------

  group('PermissionsNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));
      await container.read(permissionsProvider(testSessionId).future);

      when(() => mockClient.getPermissions(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          PermissionRules(rules: [PermissionRule(id: 'new-rule')]),
        ),
      );

      final notifier = container.read(
        permissionsProvider(testSessionId).notifier,
      );
      await notifier.refresh();

      final state = container.read(permissionsProvider(testSessionId));
      expect(state.value!.rules, hasLength(1));
      expect(state.value!.rules.first.id, 'new-rule');
    });

    test('refresh calls gRPC exactly once', () async {
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));
      await container.read(permissionsProvider(testSessionId).future);

      reset(mockClient);
      when(
        () => mockClient.getPermissions(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(PermissionRules()));

      final notifier = container.read(
        permissionsProvider(testSessionId).notifier,
      );
      await notifier.refresh();

      verify(() => mockClient.getPermissions(any())).called(1);
    });
  });
}
