import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required DateTime expiresAt,
  }) = AuthAuthenticated;
  const factory AuthState.error(String message) = AuthError;
}
