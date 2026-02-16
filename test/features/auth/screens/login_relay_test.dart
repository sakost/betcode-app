import 'package:betcode_app/core/grpc/client_manager.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockGrpcClientManager extends Mock implements GrpcClientManager {}

/// A test-friendly [RelayConfigNotifier] that tracks calls to [connectTo]
/// and can be pre-seeded with an existing config.
class TestRelayConfigNotifier extends RelayConfigNotifier {
  TestRelayConfigNotifier({this.initialConfig, this.connectError});

  final RelayConfig? initialConfig;
  final Exception? connectError;

  int connectToCallCount = 0;
  RelayConfig? lastConnectConfig;

  @override
  RelayConfig? build() => initialConfig;

  @override
  Future<void> connectTo(RelayConfig config) async {
    connectToCallCount++;
    lastConnectConfig = config;
    if (connectError != null) {
      throw connectError!;
    }
    state = config;
  }
}

/// Builds a minimal widget tree containing just the [LoginScreen] with
/// all required providers overridden.
Widget _buildLoginApp({
  required MockSecureStorageService mockStorage,
  required MockGrpcClientManager mockManager,
  required TestRelayConfigNotifier testNotifier,
  RelayConfig relayDefaults = const RelayConfig(host: '', port: 443),
}) {
  return ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(mockStorage),
      grpcClientManagerProvider.overrideWithValue(mockManager),
      relayConfigNotifierProvider.overrideWith(() => testNotifier),
      relayDefaultsProvider.overrideWithValue(relayDefaults),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  late MockSecureStorageService mockStorage;
  late MockGrpcClientManager mockManager;

  setUpAll(() {
    registerFallbackValue(const RelayConfig(host: '', port: 0));
  });

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockManager = MockGrpcClientManager();
  });

  /// Expands the relay section and fills in all form fields needed for a
  /// valid login submission.
  Future<void> fillFormFields(
    WidgetTester tester, {
    String host = 'relay.test',
    String port = '443',
    String username = 'testuser',
    String password = 'password123',
  }) async {
    // Expand relay section
    await tester.tap(find.text('Relay Server'));
    await tester.pumpAndSettle();

    // Fill relay fields
    await tester.enterText(find.widgetWithText(TextFormField, 'Host'), host);
    await tester.enterText(find.widgetWithText(TextFormField, 'Port'), port);

    // Fill credential fields
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      username,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      password,
    );
  }

  group('Login relay flow', () {
    /// Pumps the login app with the given notifier, fills in form fields,
    /// scrolls to the Login button and taps it.
    Future<void> pumpAndSubmitLogin(
      WidgetTester tester, {
      required TestRelayConfigNotifier testNotifier,
    }) async {
      await tester.pumpWidget(
        _buildLoginApp(
          mockStorage: mockStorage,
          mockManager: mockManager,
          testNotifier: testNotifier,
        ),
      );
      await tester.pumpAndSettle();
      await fillFormFields(tester);
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
    }

    testWidgets('connectTo called before login', (tester) async {
      final testNotifier = TestRelayConfigNotifier();
      await pumpAndSubmitLogin(tester, testNotifier: testNotifier);

      expect(testNotifier.connectToCallCount, equals(1));
      expect(
        testNotifier.lastConnectConfig,
        equals(const RelayConfig(host: 'relay.test', port: 443)),
      );
    });

    testWidgets('error on relay failure', (tester) async {
      final testNotifier = TestRelayConfigNotifier(
        connectError: Exception('connection refused'),
      );
      await pumpAndSubmitLogin(tester, testNotifier: testNotifier);

      expect(
        find.text('Relay connection failed: Exception: connection refused'),
        findsOneWidget,
      );
    });

    testWidgets('error on login failure after relay success', (tester) async {
      final testNotifier = TestRelayConfigNotifier();
      when(() => mockManager.channel).thenThrow(StateError('No channel'));
      await pumpAndSubmitLogin(tester, testNotifier: testNotifier);

      expect(testNotifier.connectToCallCount, equals(1));
      expect(find.textContaining('Login failed:'), findsOneWidget);
    });

    testWidgets('skips connect if already connected with same config', (
      tester,
    ) async {
      const existingConfig = RelayConfig(
        host: 'relay.test',
        port: 443,
      );
      final testNotifier = TestRelayConfigNotifier(
        initialConfig: existingConfig,
      );
      await pumpAndSubmitLogin(tester, testNotifier: testNotifier);

      expect(testNotifier.connectToCallCount, equals(0));
    });
  });
}
