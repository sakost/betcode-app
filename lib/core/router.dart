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
final _previousTabIndexProvider =
    NotifierProvider<_PreviousTabIndexNotifier, int>(
      _PreviousTabIndexNotifier.new,
    );

class _PreviousTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 1; // default: sessions (initial route)
}

/// Tracks the destination tab index so exiting pages can determine the
/// correct exit direction at animation time.
final _targetTabIndexProvider =
    NotifierProvider<_TargetTabIndexNotifier, int>(
      _TargetTabIndexNotifier.new,
    );

class _TargetTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 1; // default: sessions (initial route)
}

/// Route paths for the bottom navigation tabs (single source of truth).
const _tabPaths = ['/machines', '/sessions', '/code', '/settings'];

/// Builds a [CustomTransitionPage] that slides in from the correct direction
/// based on the tab index relative to the previous tab.
///
/// The [previousTabIndex] value is captured at navigation time, fixing the
/// entry slide direction. For exit animations (when the page is being
/// replaced), the direction is read from [_targetTabIndexProvider] at
/// animation time so the page exits toward the new destination.
CustomTransitionPage<void> _buildTabPage({
  required GoRouterState state,
  required int tabIndex,
  required int previousTabIndex,
  required Ref ref,
  required Widget child,
}) {
  final enteringFromLeft = tabIndex < previousTabIndex;
  final isSameTab = tabIndex == previousTabIndex;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (animation.status == AnimationStatus.reverse) {
        // Exiting: read the current destination to determine exit direction.
        // E.g. if destination is to the right, this page exits to the left.
        final target = ref.read(_targetTabIndexProvider);
        if (target == tabIndex) return child; // same-tab: no exit animation
        final begin = Offset(target > tabIndex ? -1.0 : 1.0, 0);
        final slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        return SlideTransition(position: slide, child: child);
      }
      // Entering (or at rest). Same-tab / initial route: no entry animation.
      if (isSameTab) return child;
      final begin = Offset(enteringFromLeft ? -1.0 : 1.0, 0);
      final slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );
      return SlideTransition(position: slide, child: child);
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
              previousTabIndex: ref.read(_previousTabIndexProvider),
              ref: ref,
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
              previousTabIndex: ref.read(_previousTabIndexProvider),
              ref: ref,
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
              previousTabIndex: ref.read(_previousTabIndexProvider),
              ref: ref,
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
              previousTabIndex: ref.read(_previousTabIndexProvider),
              ref: ref,
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

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
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

  static int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabPaths.length; i++) {
      if (location.startsWith(_tabPaths[i])) return i;
    }
    return 0;
  }

  void _onDestinationSelected(int index) {
    ref.read(_previousTabIndexProvider.notifier).state =
        _currentIndex(context);
    ref.read(_targetTabIndexProvider.notifier).state = index;
    context.go(_tabPaths[index]);
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
