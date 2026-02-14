import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth.dart';
import '../features/conversation/conversation.dart';
import '../features/machines/machines.dart';
import '../features/sessions/sessions.dart';
import '../features/settings/settings.dart';
import '../features/git_repos/git_repos.dart';
import 'auth/auth.dart';
import 'grpc/grpc_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Tracks the previous tab index for directional slide animations.
///
/// Updated in [_AppShellState._onDestinationSelected] before navigation.
int _previousTabIndex = 1; // default: sessions (initial route)

/// Builds a [CustomTransitionPage] that slides in from the correct direction
/// based on the tab index relative to the previous tab.
CustomTransitionPage<void> _buildTabPage({
  required GoRouterState state,
  required int tabIndex,
  required Widget child,
}) {
  final goingLeft = tabIndex < _previousTabIndex;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(goingLeft ? -1.0 : 1.0, 0);
      final slideIn = Tween<Offset>(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );
      // Slide the outgoing page in the opposite direction.
      final outBegin = Offset(goingLeft ? 1.0 : -1.0, 0);
      final slideOut = Tween<Offset>(begin: Offset.zero, end: outBegin).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut),
      );
      return SlideTransition(
        position: slideOut,
        child: SlideTransition(position: slideIn, child: child),
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  // Notifier that triggers GoRouter redirect re-evaluation when
  // auth or relay config changes — without recreating the GoRouter.
  final refreshNotifier = _RouterRefreshNotifier();

  ref.listen(authNotifierProvider, (_, __) => refreshNotifier.notify());
  ref.listen(relayConfigNotifierProvider, (_, __) => refreshNotifier.notify());
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refreshNotifier,
    initialLocation: '/sessions',
    redirect: (context, state) {
      final isAuth = ref.read(authNotifierProvider) is AuthAuthenticated;
      final hasRelay = ref.read(relayConfigNotifierProvider) != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if ((!isAuth || !hasRelay) && !isAuthRoute) return '/login';
      if (isAuth && hasRelay && isAuthRoute) return '/sessions';
      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/machines',
            pageBuilder: (context, state) => _buildTabPage(
              state: state,
              tabIndex: 0,
              child: const MachinesScreen(),
            ),
            routes: [
              GoRoute(
                path: ':machineId',
                builder: (context, state) => const MachinesScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/sessions',
            pageBuilder: (context, state) => _buildTabPage(
              state: state,
              tabIndex: 1,
              child: const SessionsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':sessionId',
                builder: (context, state) {
                  final raw = state.pathParameters['sessionId'];
                  return ConversationScreen(
                    sessionId: raw == 'new' ? null : raw,
                    workingDirectory: state.extra as String?,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/code',
            pageBuilder: (context, state) => _buildTabPage(
              state: state,
              tabIndex: 2,
              child: const GitReposScreen(),
            ),
            routes: [
              GoRoute(
                path: 'repos/:repoId',
                builder: (context, state) => RepoDetailScreen(
                  repoId: state.pathParameters['repoId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => _buildTabPage(
              state: state,
              tabIndex: 3,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

/// A [ChangeNotifier] that GoRouter listens to via [refreshListenable].
///
/// When auth or relay state changes, [notify] is called, which triggers
/// GoRouter to re-evaluate its [redirect] without recreating the router.
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.computer_outlined),
      selectedIcon: Icon(Icons.computer),
      label: 'Machines',
    ),
    NavigationDestination(
      icon: Icon(Icons.history_outlined),
      selectedIcon: Icon(Icons.history),
      label: 'Sessions',
    ),
    NavigationDestination(
      icon: Icon(Icons.code_outlined),
      selectedIcon: Icon(Icons.code),
      label: 'Code',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  static const _routes = [
    '/machines',
    '/sessions',
    '/code',
    '/settings',
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _onDestinationSelected(int index) {
    _previousTabIndex = _currentIndex(context);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
      ),
    );
  }
}
