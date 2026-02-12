import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/core/router.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

/// Always-authenticated notifier for testing protected routes.
class _AuthenticatedNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState.authenticated(
      accessToken: 'tok',
      refreshToken: 'ref',
      userId: 'u1',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

/// Relay notifier that returns a non-null config for testing.
class _ConnectedRelayNotifier extends RelayConfigNotifier {
  @override
  RelayConfig? build() {
    return const RelayConfig(host: 'test-relay', port: 443);
  }
}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  Widget buildAuthApp({String? initialLocation}) {
    return ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(mockStorage),
        authNotifierProvider.overrideWith(_AuthenticatedNotifier.new),
        relayConfigNotifierProvider.overrideWith(_ConnectedRelayNotifier.new),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          if (initialLocation != null) {
            router.go(initialLocation);
          }
          return MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
          );
        },
      ),
    );
  }

  Widget buildUnauthApp({String? initialLocation}) {
    return ProviderScope(
      overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          if (initialLocation != null) {
            router.go(initialLocation);
          }
          return MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
          );
        },
      ),
    );
  }

  group('Router - redirect logic', () {
    testWidgets('unauthenticated user accessing /sessions -> /login', (
      tester,
    ) async {
      await tester.pumpWidget(buildUnauthApp(initialLocation: '/sessions'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('unauthenticated user accessing /machines -> /login', (
      tester,
    ) async {
      await tester.pumpWidget(buildUnauthApp(initialLocation: '/machines'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('unauthenticated user accessing /settings -> /login', (
      tester,
    ) async {
      await tester.pumpWidget(buildUnauthApp(initialLocation: '/settings'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('authenticated user accessing /register -> /conversation', (
      tester,
    ) async {
      await tester.pumpWidget(buildAuthApp(initialLocation: '/register'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
      expect(find.text('Register'), findsNothing);
    });

    testWidgets('authenticated user on /login -> /conversation', (
      tester,
    ) async {
      await tester.pumpWidget(buildAuthApp(initialLocation: '/login'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('null redirect when auth matches route', (tester) async {
      // Use a large surface to avoid overflow from ErrorDisplay content.
      await tester.binding.setSurfaceSize(const Size(800, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp(initialLocation: '/sessions'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Router - deep linking', () {
    testWidgets('conversation with sessionId parameter', (tester) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/conversation/sess-42'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('machines with machineId parameter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp(initialLocation: '/machines/m-1'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Router - AppShell navigation', () {
    // Use a large surface to avoid overflow from both 6 nav destinations
    // (width) and ErrorDisplay content in screens that lack gRPC (height).
    Future<void> setLargeSize(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
    }

    testWidgets('has exactly 6 navigation destinations', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations, hasLength(6));
    });

    testWidgets('tapping Sessions navigates to /sessions', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('tapping Machines navigates to /machines', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Machines'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);
    });

    testWidgets('tapping Worktrees navigates to /worktrees', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Worktrees'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 3);
    });

    testWidgets('tapping GitLab navigates to /gitlab', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('GitLab'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 4);
    });

    testWidgets('tapping Settings navigates to /settings', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 5);
    });

    testWidgets('tapping Chat returns to /conversation', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 0);
    });
  });
}
