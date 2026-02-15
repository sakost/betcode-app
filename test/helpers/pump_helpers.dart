import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;

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

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockSecureStorageService extends Mock implements SecureStorageService {}

// ---------------------------------------------------------------------------
// Test notifiers
// ---------------------------------------------------------------------------

/// Always-authenticated notifier for testing protected routes.
class TestAuthenticatedNotifier extends AuthNotifier {
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
class TestConnectedRelayNotifier extends RelayConfigNotifier {
  @override
  RelayConfig? build() {
    return const RelayConfig(host: 'test-relay', port: 443);
  }
}

// ---------------------------------------------------------------------------
// Widget builders
// ---------------------------------------------------------------------------

/// Internal helper that builds a routed app with the given overrides.
Widget _buildRoutedApp({
  String? initialLocation,
  required List<Override> overrides,
}) {
  return ProviderScope(
    overrides: overrides,
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

/// Builds a fully-routed, authenticated app for widget tests.
///
/// Overrides [secureStorageProvider], [authNotifierProvider], and
/// [relayConfigNotifierProvider] so that the router's redirect guard treats
/// the user as logged in. Pass extra [overrides] to layer on
/// feature-specific provider stubs.
Widget buildAuthApp({
  String? initialLocation,
  List<Override> overrides = const [],
  required MockSecureStorageService mockStorage,
}) {
  return _buildRoutedApp(
    initialLocation: initialLocation,
    overrides: [
      secureStorageProvider.overrideWithValue(mockStorage),
      authNotifierProvider.overrideWith(TestAuthenticatedNotifier.new),
      relayConfigNotifierProvider.overrideWith(TestConnectedRelayNotifier.new),
      ...overrides,
    ],
  );
}

/// Builds a fully-routed, unauthenticated app for widget tests.
///
/// Only overrides [secureStorageProvider] (no auth / relay overrides), so the
/// default [AuthNotifier] returns [AuthUnauthenticated] and the router
/// redirects to `/login`. Pass extra [overrides] as needed.
Widget buildUnauthApp({
  String? initialLocation,
  List<Override> overrides = const [],
  required MockSecureStorageService mockStorage,
}) {
  return _buildRoutedApp(
    initialLocation: initialLocation,
    overrides: [
      secureStorageProvider.overrideWithValue(mockStorage),
      ...overrides,
    ],
  );
}
