import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/router.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

/// A test notifier that always returns authenticated state.
class _AuthenticatedNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState.authenticated(
      accessToken: 'test-token',
      refreshToken: 'test-refresh',
      userId: 'test-user',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('Auth routing guard', () {
    testWidgets('unauthenticated user is redirected to /login',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('authenticated user is redirected away from /login',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
            authNotifierProvider.overrideWith(_AuthenticatedNotifier.new),
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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsNothing);
    });

    testWidgets('login screen has link to register', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
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
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Don't have an account? Register"),
        findsOneWidget,
      );
    });

    testWidgets('navigating to register screen works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
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
        ),
      );
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
        overrides: [
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('initialize with tokens transitions to authenticated', () async {
      when(() => mockStorage.readToken())
          .thenAnswer((_) async => 'access-tok');
      when(() => mockStorage.readRefreshToken())
          .thenAnswer((_) async => 'refresh-tok');

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
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
        overrides: [
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.initialize();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('logout clears storage and transitions to unauthenticated',
        () async {
      when(() => mockStorage.writeToken(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeRefreshToken(any()))
          .thenAnswer((_) async {});
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
            authNotifierProvider.overrideWith(_AuthenticatedNotifier.new),
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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('Machines'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
