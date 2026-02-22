import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/pump_helpers.dart';

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('Auth routing guard', () {
    testWidgets('unauthenticated user is redirected to /login', (tester) async {
      await tester.pumpWidget(buildUnauthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('authenticated user is redirected away from /login', (
      tester,
    ) async {
      await tester.pumpWidget(buildAuthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsNothing);
    });

    testWidgets('login screen has link to register', (tester) async {
      await tester.pumpWidget(buildUnauthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });

    testWidgets('navigating to register screen works', (tester) async {
      await tester.pumpWidget(buildUnauthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();

      // Register screen should be visible
      expect(find.text('Register'), findsWidgets);
    });
  });

  group('Auth state transitions', () {
    test('AuthNotifier starts as unauthenticated', () {
      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('initialize with tokens transitions to authenticated', () async {
      when(() => mockStorage.readToken()).thenAnswer((_) async => 'access-tok');
      when(
        () => mockStorage.readRefreshToken(),
      ).thenAnswer((_) async => 'refresh-tok');

      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.initialize();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      final auth = state as AuthAuthenticated;
      expect(auth.accessToken, 'access-tok');
      expect(auth.refreshToken, 'refresh-tok');
    });

    test('initialize without tokens stays unauthenticated', () async {
      when(() => mockStorage.readToken()).thenAnswer((_) async => null);
      when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.initialize();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('logout clears storage and transitions to unauthenticated', () async {
      when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeRefreshToken(any())).thenAnswer((_) async {});
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.setTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
        expiresInSecs: 900,
      );
      expect(container.read(authNotifierProvider), isA<AuthAuthenticated>());

      await notifier.logout();
      expect(container.read(authNotifierProvider), isA<AuthUnauthenticated>());
      verify(() => mockStorage.clearAll()).called(1);
    });
  });

  group('Bottom navigation', () {
    testWidgets('authenticated user sees navigation bar', (tester) async {
      await tester.pumpWidget(buildAuthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      // Verify the 3-tab layout: Sessions, Code, Settings.
      final navBarFinder = find.byType(NavigationBar);
      expect(
        find.descendant(of: navBarFinder, matching: find.text('Sessions')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: navBarFinder, matching: find.text('Code')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: navBarFinder, matching: find.text('Settings')),
        findsOneWidget,
      );
      // Machines tab was removed — machine selection is now in Settings.
      expect(
        find.descendant(of: navBarFinder, matching: find.text('Machines')),
        findsNothing,
      );
    });
  });
}
