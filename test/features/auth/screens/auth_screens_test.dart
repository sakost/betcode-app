import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_helpers.dart';

/// Helper that builds the app routed to /login (unauthenticated default)
/// with relay defaults overridden for form tests.
Widget _buildTestApp({required MockSecureStorageService mockStorage}) {
  return buildUnauthApp(
    mockStorage: mockStorage,
    overrides: [
      relayDefaultsProvider.overrideWithValue(
        const RelayConfig(host: '', port: 443),
      ),
    ],
  );
}

/// Fills required credential fields and submits a form.
///
/// [navigate] is called first to get to the right screen.
/// [submitButton] is the label on the submit button ('Login' or 'Register').
/// [extraFields] is an optional map of additional TextFormField labels to fill.
Future<void> _fillAndSubmit(
  WidgetTester tester, {
  required Future<void> Function(WidgetTester) navigate,
  required String submitButton,
  Map<String, String> relayFields = const {},
  Map<String, String> extraFields = const {},
}) async {
  await navigate(tester);

  if (relayFields.isNotEmpty) {
    await tester.tap(find.text('Relay Server'));
    await tester.pumpAndSettle();
    for (final e in relayFields.entries) {
      await tester.enterText(
        find.widgetWithText(TextFormField, e.key),
        e.value,
      );
    }
  }

  for (final e in extraFields.entries) {
    await tester.enterText(find.widgetWithText(TextFormField, e.key), e.value);
  }

  await tester.ensureVisible(find.widgetWithText(FilledButton, submitButton));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(FilledButton, submitButton));
  await tester.pumpAndSettle();
}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  /// Common relay validation tests shared between Login and Register.
  void relayValidationTests({
    required Future<void> Function(WidgetTester) navigate,
    required String submitButton,
    required Map<String, String> validCredentials,
  }) {
    testWidgets('validates empty host shows error', (tester) async {
      await _fillAndSubmit(
        tester,
        navigate: navigate,
        submitButton: submitButton,
        relayFields: {'Port': '443'},
        extraFields: validCredentials,
      );
      expect(find.text('Relay host is required'), findsOneWidget);
    });

    testWidgets('validates invalid port shows error', (tester) async {
      await _fillAndSubmit(
        tester,
        navigate: navigate,
        submitButton: submitButton,
        relayFields: {'Host': 'relay.example.com', 'Port': '99999'},
        extraFields: validCredentials,
      );
      expect(find.text('Port must be between 1 and 65535'), findsOneWidget);
    });
  }

  group('LoginScreen', () {
    Future<void> navigateToLogin(WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();
    }

    testWidgets('renders username and password fields', (tester) async {
      await navigateToLogin(tester);

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders relay server fields', (tester) async {
      await navigateToLogin(tester);

      expect(find.text('Relay Server'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    relayValidationTests(
      navigate: (t) async {
        await t.pumpWidget(_buildTestApp(mockStorage: mockStorage));
        await t.pumpAndSettle();
      },
      submitButton: 'Login',
      validCredentials: {'Username': 'testuser', 'Password': 'password123'},
    );

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

    relayValidationTests(
      navigate: navigateToRegister,
      submitButton: 'Register',
      validCredentials: {
        'Username': 'testuser',
        'Email': 'test@example.com',
        'Password': 'password123',
      },
    );

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
