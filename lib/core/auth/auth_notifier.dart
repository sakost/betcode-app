import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/betcode/v1/auth.pbgrpc.dart';
import '../storage/storage.dart';
import 'auth_state.dart';

/// Decodes the payload of a JWT without verifying the signature.
/// Returns null if the token is malformed.
Map<String, dynamic>? _decodeJwtPayload(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) return null;
  try {
    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(payload) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

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
        final claims = _decodeJwtPayload(accessToken);
        final userId = (claims != null ? claims['sub'] as String? : null) ?? '';
        final exp = claims != null ? claims['exp'] as int? : null;
        final expiresAt = exp != null
            ? DateTime.fromMillisecondsSinceEpoch(exp * 1000)
            : DateTime.now().add(const Duration(minutes: 15));
        state = AuthState.authenticated(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: userId,
          expiresAt: expiresAt,
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

  Future<bool> refreshTokens(AuthServiceClient authClient) async {
    final s = state;
    if (s is! AuthAuthenticated) return false;
    try {
      final response = await authClient.refreshToken(
        RefreshTokenRequest(refreshToken: s.refreshToken),
      );
      await setTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: s.userId,
        expiresInSecs: response.expiresInSecs.toInt(),
      );
      return true;
    } catch (e) {
      await logout();
      return false;
    }
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
