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

    testWidgets('authenticated user accessing /register -> /sessions', (
      tester,
    ) async {
      await tester.pumpWidget(buildAuthApp(initialLocation: '/register'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
      expect(find.text('Register'), findsNothing);
    });

    testWidgets('authenticated user on /login -> /sessions', (
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
        buildAuthApp(initialLocation: '/sessions/sess-42'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('/sessions/new routes to ConversationScreen with null sessionId',
        (tester) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/sessions/new'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Conversation'), findsOneWidget);
    });

    testWidgets('machines with machineId parameter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp(initialLocation: '/machines/m-1'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('code with repoId parameter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/code/repos/repo-42'),
      );
      // Use pump() instead of pumpAndSettle() because RepoDetailScreen
      // shows a CircularProgressIndicator while loading worktrees, which
      // animates indefinitely and prevents settling.
      await tester.pump();
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Router - stability', () {
    testWidgets('GoRouter instance is reused when auth state changes', (
      tester,
    ) async {
      // Create a mutable auth notifier so we can change state mid-test.
      late AuthNotifier authNotifier;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(mockStorage),
            authNotifierProvider.overrideWith(() {
              authNotifier = _AuthenticatedNotifier();
              return authNotifier;
            }),
            relayConfigNotifierProvider
                .overrideWith(_ConnectedRelayNotifier.new),
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

      // Read the router instance before state change.
      final container =
          ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
      final routerBefore = container.read(routerProvider);

      // Trigger an auth state change by invalidating the provider.
      // The router should use refreshListenable, NOT recreate.
      container.read(authNotifierProvider.notifier).state =
          AuthState.authenticated(
        accessToken: 'tok2',
        refreshToken: 'ref2',
        userId: 'u2',
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
      );
      await tester.pumpAndSettle();

      final routerAfter = container.read(routerProvider);
      expect(identical(routerBefore, routerAfter), isTrue,
          reason: 'GoRouter should be the same instance after auth change');
    });
  });

  group('Router - AppShell navigation', () {
    // Use a large surface to avoid overflow from nav destinations
    // (width) and ErrorDisplay content in screens that lack gRPC (height).
    Future<void> setLargeSize(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
    }

    testWidgets('has exactly 4 navigation destinations', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations, hasLength(4));
    });

    testWidgets('tapping Machines navigates to /machines', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Machines'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 0);
    });

    testWidgets('tapping Sessions navigates to /sessions', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      // "Sessions" appears in both the screen title and the nav bar,
      // so target the one inside NavigationBar.
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Sessions'),
      ));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('tapping Code navigates to /code', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Code'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);
    });

    testWidgets('tapping Settings navigates to /settings', (tester) async {
      await setLargeSize(tester);
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 3);
    });
  });
}
