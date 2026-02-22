import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/pump_helpers.dart';

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('Router - redirect logic', () {
    for (final route in ['/sessions', '/code', '/settings']) {
      testWidgets('unauthenticated user accessing $route -> /login', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildUnauthApp(initialLocation: route, mockStorage: mockStorage),
        );
        await tester.pumpAndSettle();
        expect(find.text('Login'), findsOneWidget);
      });
    }

    testWidgets('authenticated user accessing /register -> /sessions', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/register', mockStorage: mockStorage),
      );
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
      expect(find.text('Register'), findsNothing);
    });

    testWidgets('authenticated user on /login -> /sessions', (tester) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/login', mockStorage: mockStorage),
      );
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('null redirect when auth matches route', (tester) async {
      // Use a large surface to avoid overflow from ErrorDisplay content.
      await tester.binding.setSurfaceSize(const Size(800, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(
        buildAuthApp(initialLocation: '/sessions', mockStorage: mockStorage),
      );
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Router - machine picker gate', () {
    testWidgets(
      'authenticated user with no machine -> /machine-picker',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 60000));
        addTearDown(
          () => tester.binding.setSurfaceSize(const Size(800, 600)),
        );

        await tester.pumpWidget(
          buildAuthApp(
            initialLocation: '/sessions',
            mockStorage: mockStorage,
            withMachine: false,
          ),
        );
        // Use pump() — machine picker may show loading spinner.
        await tester.pump();
        await tester.pump();

        expect(find.text('Select a machine'), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);
      },
    );

    testWidgets(
      'authenticated user with machine selected -> /sessions',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 60000));
        addTearDown(
          () => tester.binding.setSurfaceSize(const Size(800, 600)),
        );

        await tester.pumpWidget(
          buildAuthApp(
            initialLocation: '/sessions',
            mockStorage: mockStorage,
          ),
        );
        await tester.pumpAndSettle();

        // Should land on sessions, not machine picker.
        expect(find.text('Select a machine'), findsNothing);
        expect(find.byType(NavigationBar), findsOneWidget);
      },
    );

    testWidgets(
      '/machine-picker is accessible directly',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 60000));
        addTearDown(
          () => tester.binding.setSurfaceSize(const Size(800, 600)),
        );

        await tester.pumpWidget(
          buildAuthApp(
            initialLocation: '/machine-picker',
            mockStorage: mockStorage,
            withMachine: false,
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Select a machine'), findsOneWidget);
      },
    );
  });

  group('Router - deep linking', () {
    testWidgets('conversation with sessionId parameter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(
        buildAuthApp(
          initialLocation: '/sessions/sess-42',
          mockStorage: mockStorage,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets(
      '/sessions/new routes to ConversationScreen with null sessionId',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 60000));
        addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

        await tester.pumpWidget(
          buildAuthApp(
            initialLocation: '/sessions/new',
            mockStorage: mockStorage,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(NavigationBar), findsOneWidget);
        expect(find.text('Conversation'), findsOneWidget);
      },
    );

    testWidgets('code with repoId parameter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(
        buildAuthApp(
          initialLocation: '/code/repos/repo-42',
          mockStorage: mockStorage,
        ),
      );
      // Use pump() instead of pumpAndSettle() because RepoDetailScreen
      // shows a CircularProgressIndicator while loading worktrees, which
      // animates indefinitely and prevents settling.
      await tester.pump();
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('/settings/machine routes to machine detail', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));

      await tester.pumpWidget(
        buildAuthApp(
          initialLocation: '/settings/machine',
          mockStorage: mockStorage,
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Router - stability', () {
    testWidgets('GoRouter instance is reused when auth state changes', (
      tester,
    ) async {
      await tester.pumpWidget(buildAuthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();

      // Read the router instance before state change.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      final routerBefore = container.read(routerProvider);

      // Trigger an auth state change by invalidating the provider.
      // The router should use refreshListenable, NOT recreate.
      container
          .read(authNotifierProvider.notifier)
          .state = AuthState.authenticated(
        accessToken: 'tok2',
        refreshToken: 'ref2',
        userId: 'u2',
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
      );
      await tester.pumpAndSettle();

      final routerAfter = container.read(routerProvider);
      expect(
        identical(routerBefore, routerAfter),
        isTrue,
        reason: 'GoRouter should be the same instance after auth change',
      );
    });
  });

  group('Router - AppShell navigation', () {
    /// Sets up large surface, pumps the auth app, and settles.
    Future<void> pumpLargeAuthApp(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 60000));
      addTearDown(() => tester.binding.setSurfaceSize(const Size(800, 600)));
      await tester.pumpWidget(buildAuthApp(mockStorage: mockStorage));
      await tester.pumpAndSettle();
    }

    testWidgets('has exactly 3 navigation destinations', (tester) async {
      await pumpLargeAuthApp(tester);

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations, hasLength(3));
    });

    testWidgets('shell route paths match navigation destinations', (
      tester,
    ) async {
      await pumpLargeAuthApp(tester);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      final router = container.read(routerProvider);

      // Extract shell route tab paths from the route configuration.
      final shellRoute = router.configuration.routes
          .whereType<ShellRoute>()
          .first;
      final tabPaths = shellRoute.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      // Extract nav destination labels.
      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));

      // Same count — routes and destinations stay in sync.
      expect(
        tabPaths,
        hasLength(navBar.destinations.length),
        reason: 'Shell route count must match navigation destination count',
      );
      expect(tabPaths, ['/sessions', '/code', '/settings']);
    });

    testWidgets('tapping Sessions navigates to /sessions', (tester) async {
      await pumpLargeAuthApp(tester);

      // "Sessions" appears in both the screen title and the nav bar,
      // so target the one inside NavigationBar.
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Sessions'),
        ),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 0);
    });

    testWidgets('tapping Code navigates to /code', (tester) async {
      await pumpLargeAuthApp(tester);

      await tester.tap(find.text('Code'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('tapping Settings navigates to /settings', (tester) async {
      await pumpLargeAuthApp(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Settings'),
        ),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);
    });

    testWidgets('navigating right slides incoming page from the right', (
      tester,
    ) async {
      await pumpLargeAuthApp(tester);

      // Navigate from Sessions (index 0) to Code (index 1) — going right.
      await tester.tap(find.text('Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      final dxValues = tester
          .widgetList<SlideTransition>(find.byType(SlideTransition))
          .map((s) => s.position.value.dx)
          .where((dx) => dx != 0.0)
          .toList();
      expect(dxValues, isNotEmpty);
      // Incoming page enters from the right (positive dx).
      expect(dxValues, everyElement(isPositive));

      await tester.pumpAndSettle();
    });

    testWidgets('multi-step navigation: exit direction matches target', (
      tester,
    ) async {
      await pumpLargeAuthApp(tester);

      // Step 1: Sessions (0) → Settings (2).
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Settings'),
        ),
      );
      await tester.pumpAndSettle();

      // Step 2: Settings (2) → Code (1) — going left.
      await tester.tap(find.text('Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      final dxValues = tester
          .widgetList<SlideTransition>(find.byType(SlideTransition))
          .map((s) => s.position.value.dx)
          .where((dx) => dx != 0.0)
          .toList();
      expect(dxValues, isNotEmpty);
      // Incoming Code page enters from the left (negative dx).
      expect(dxValues, contains(isNegative));

      await tester.pumpAndSettle();
    });
  });
}
