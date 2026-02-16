import 'dart:convert';

import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/storage/storage.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

/// Decodes the payload of a JWT without verifying the signature.
/// Returns null if the token is malformed.
Map<String, dynamic>? _decodeJwtPayload(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) return null;
  try {
    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(payload) as Map<String, dynamic>;
  } on FormatException {
    return null;
  }
}

/// Manages authentication state (login, token refresh, logout) backed by
/// [SecureStorageService] for persistence and gRPC for server-side operations.
class AuthNotifier extends Notifier<AuthState> {
  static const _mutationTimeout = Duration(seconds: 30);

  late final SecureStorageService _storage;

  @override
  AuthState build() {
    _storage = ref.watch(secureStorageProvider);
    return const AuthState.unauthenticated();
  }

  /// Loads stored tokens from secure storage and transitions to
  /// [AuthAuthenticated] or [AuthUnauthenticated].
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
    } on Exception catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Persists the given tokens and transitions to [AuthAuthenticated].
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

  /// Clears all stored credentials and transitions to [AuthUnauthenticated].
  Future<void> logout() async {
    await _storage.clearAll();
    state = const AuthState.unauthenticated();
  }

  /// Attempts to refresh the access token via the given [authClient].
  /// Returns true on success, false on failure. Logs out on auth errors.
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
    } on Exception catch (e) {
      if (_isAuthError(e)) {
        await logout();
      }
      return false;
    }
  }

  /// Returns true if the error indicates an authentication/authorization
  /// failure (invalid or revoked token). Network and transient errors
  /// return false — we keep the session alive so reconnection can retry.
  static bool _isAuthError(Object error) {
    if (error is GrpcError) {
      return error.code == StatusCode.unauthenticated ||
          error.code == StatusCode.permissionDenied;
    }
    return false;
  }

  /// Revokes the current refresh token via gRPC and logs out.
  ///
  /// Returns true if the RPC call succeeded and logout completed,
  /// false otherwise. Always logs out regardless of the RPC result.
  Future<bool> revokeToken(AuthServiceClient authClient) async {
    final s = state;
    if (s is! AuthAuthenticated) return false;
    try {
      await authClient
          .revokeToken(RevokeTokenRequest(refreshToken: s.refreshToken))
          .timeout(_mutationTimeout);
      await logout();
      return true;
    } on Exception {
      await logout();
      return false;
    }
  }

  /// Whether the current state is [AuthAuthenticated].
  bool get isAuthenticated => state is AuthAuthenticated;

  /// The current JWT access token, or null if unauthenticated.
  String? get accessToken {
    final s = state;
    return s is AuthAuthenticated ? s.accessToken : null;
  }

  /// Whether the access token expires within the next 2 minutes.
  bool get isTokenExpiringSoon {
    final s = state;
    if (s is! AuthAuthenticated) return false;
    return s.expiresAt.difference(DateTime.now()).inMinutes < 2;
  }
}

/// Provides the [AuthNotifier] that manages authentication state.
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
