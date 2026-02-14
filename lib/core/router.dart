import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth.dart';
import '../features/conversation/conversation.dart';
import '../features/machines/machines.dart';
import '../features/sessions/sessions.dart';
import '../features/settings/settings.dart';
import '../features/git_repos/git_repos.dart';
import '../features/git_repos/screens/repo_detail_screen.dart';
import '../features/worktrees/worktrees.dart';
import 'auth/auth.dart';
import 'grpc/grpc_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final relayConfig = ref.watch(relayConfigNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/sessions',
    redirect: (context, state) {
      final isAuth = authState is AuthAuthenticated;
      final hasRelay = relayConfig != null;
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
            builder: (context, state) => const MachinesScreen(),
            routes: [
              GoRoute(
                path: ':machineId',
                builder: (context, state) => const MachinesScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/sessions',
            builder: (context, state) => const SessionsScreen(),
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
            builder: (context, state) => const GitReposScreen(),
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
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) => context.go(_routes[index]),
        destinations: _destinations,
      ),
    );
  }
}
