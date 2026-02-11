import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/router.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

/// Helper that builds the app routed to /login (unauthenticated default).
Widget _buildTestApp({required MockSecureStorageService mockStorage}) {
  return ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(mockStorage),
      relayDefaultsProvider.overrideWithValue(
        const RelayConfig(host: '', port: 443),
      ),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.lightTheme,
        );
      },
    ),
  );
}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('LoginScreen', () {
    testWidgets('renders username and password fields', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders relay server fields', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text('Relay Server'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    testWidgets('validates empty host shows error', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      // Expand the relay section
      await tester.tap(find.text('Relay Server'));
      await tester.pumpAndSettle();

      // Enter port but leave host empty
      await tester.enterText(find.widgetWithText(TextFormField, 'Port'), '443');

      // Fill in valid username and password so those validators pass
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Scroll to the Login button and tap
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Relay host is required'), findsOneWidget);
    });

    testWidgets('validates invalid port shows error', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      // Expand the relay section
      await tester.tap(find.text('Relay Server'));
      await tester.pumpAndSettle();

      // Enter valid host but invalid port
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Host'),
        'relay.example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Port'),
        '99999',
      );

      // Fill in valid username and password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Scroll to the Login button and tap
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Port must be between 1 and 65535'), findsOneWidget);
    });

    testWidgets('empty username shows validation error on submit', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      // Leave username empty, put valid password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'validpass',
      );

      // Tap Login button
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be at least 3 characters'),
        findsOneWidget,
      );
    });

    testWidgets('short username shows validation error on submit', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'ab',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'validpass',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be at least 3 characters'),
        findsOneWidget,
      );
    });

    testWidgets('empty password shows validation error on submit', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      // Leave password empty

      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('short password shows validation error on submit', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '12345',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('valid inputs keep login button enabled', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Login button should be enabled (onPressed is not null)
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Login'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('register link is visible', (tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    Future<void> navigateToRegister(WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      // Navigate from login to register
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();
    }

    testWidgets('renders all form fields', (tester) async {
      await navigateToRegister(tester);

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders relay server fields', (tester) async {
      await navigateToRegister(tester);

      expect(find.text('Relay Server'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    testWidgets('validates empty host shows error', (tester) async {
      await navigateToRegister(tester);

      // Expand the relay section
      await tester.tap(find.text('Relay Server'));
      await tester.pumpAndSettle();

      // Enter port but leave host empty
      await tester.enterText(find.widgetWithText(TextFormField, 'Port'), '443');

      // Fill in valid fields
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Scroll to the Register button and tap
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Relay host is required'), findsOneWidget);
    });

    testWidgets('validates invalid port shows error', (tester) async {
      await navigateToRegister(tester);

      // Expand the relay section
      await tester.tap(find.text('Relay Server'));
      await tester.pumpAndSettle();

      // Enter valid host but invalid port
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Host'),
        'relay.example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Port'),
        '99999',
      );

      // Fill in valid fields
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Scroll to the Register button and tap
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Port must be between 1 and 65535'), findsOneWidget);
    });

    testWidgets('empty username shows validation error on submit', (
      tester,
    ) async {
      await navigateToRegister(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be at least 3 characters'),
        findsOneWidget,
      );
    });

    testWidgets('invalid email shows validation error on submit', (
      tester,
    ) async {
      await navigateToRegister(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('empty password shows validation error on submit', (
      tester,
    ) async {
      await navigateToRegister(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      // Leave password empty

      await tester.tap(find.widgetWithText(FilledButton, 'Register'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('valid inputs keep register button enabled', (tester) async {
      await navigateToRegister(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Register'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('login link is visible', (tester) async {
      await navigateToRegister(tester);

      expect(find.text('Already have an account? Login'), findsOneWidget);
    });
  });
}
