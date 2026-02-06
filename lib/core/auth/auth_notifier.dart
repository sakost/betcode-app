import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final SecureStorageService _storage;

  @override
  AuthState build() {
    _storage = ref.watch(secureStorageProvider);
    return const AuthState.unauthenticated();
  }

  Future<void> initialize() async {
    state = const AuthState.loading();
    try {
      final accessToken = await _storage.readToken();
      final refreshToken = await _storage.readRefreshToken();
      if (accessToken != null && refreshToken != null) {
        state = AuthState.authenticated(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: '', // Will be populated on token decode
          expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required int expiresInSecs,
  }) async {
    await _storage.writeToken(accessToken);
    await _storage.writeRefreshToken(refreshToken);
    state = AuthState.authenticated(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      expiresAt: DateTime.now().add(Duration(seconds: expiresInSecs)),
    );
  }

  Future<void> logout() async {
    await _storage.clearAll();
    state = const AuthState.unauthenticated();
  }

  bool get isAuthenticated => state is AuthAuthenticated;

  String? get accessToken {
    final s = state;
    return s is AuthAuthenticated ? s.accessToken : null;
  }

  bool get isTokenExpiringSoon {
    final s = state;
    if (s is! AuthAuthenticated) return false;
    return s.expiresAt.difference(DateTime.now()).inMinutes < 2;
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
