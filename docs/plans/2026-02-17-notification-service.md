# Notification Service — Push Notification Device Registration

**Date**: 2026-02-17
**Status**: Draft

## Overview

Push notification device registration for mobile clients. The app registers FCM (Android) / APNs (iOS) device tokens with the betcode-daemon via the `NotificationService` gRPC API so the daemon can push permission requests, task completions, and session status changes to idle devices.

## Proto API

Defined in `proto/betcode/v1/notification.proto`:

```protobuf
service NotificationService {
  rpc RegisterDevice(RegisterDeviceRequest) returns (RegisterDeviceResponse);
  rpc UnregisterDevice(UnregisterDeviceRequest) returns (UnregisterDeviceResponse);
}

message RegisterDeviceRequest {
  string device_token = 1;    // FCM/APNs token
  DevicePlatform platform = 2; // ANDROID or IOS
  string user_id = 3;          // Authenticated user ID
}

enum DevicePlatform {
  DEVICE_PLATFORM_UNSPECIFIED = 0;
  DEVICE_PLATFORM_ANDROID = 1;
  DEVICE_PLATFORM_IOS = 2;
}

message RegisterDeviceResponse { bool success = 1; }
message UnregisterDeviceRequest { string device_token = 1; }
message UnregisterDeviceResponse { bool success = 1; }
```

## Dependencies

### New packages

| Package | Purpose |
|---------|---------|
| `firebase_messaging` | FCM token acquisition, push receipt, token refresh stream |
| `firebase_core` | Firebase initialization (required by `firebase_messaging`) |

### Platform setup

- **Android**: Add `google-services.json` to `android/app/`, apply `com.google.gms:google-services` plugin in `android/app/build.gradle`.
- **iOS**: Add APNs capability in Xcode, upload APNs auth key to Firebase console. `firebase_messaging` handles the APNs-to-FCM token bridging automatically.

## Architecture

### File layout

```
lib/features/notifications/
  notification_notifier.dart   # NotificationNotifier (registration state machine)
  notification_providers.dart  # Riverpod providers
  notifications.dart           # Barrel export
```

### Providers

Add to `lib/core/grpc/service_providers.dart`:

```dart
/// Provides the [NotificationServiceClient] for device registration.
final notificationServiceProvider = Provider<NotificationServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  return NotificationServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});
```

This follows the exact pattern used by all other service providers (e.g. `agentServiceProvider`, `machineServiceProvider`).

### NotificationNotifier

A `Notifier<NotificationState>` managing the device registration lifecycle:

```dart
@freezed
sealed class NotificationState with _$NotificationState {
  const factory NotificationState.unregistered() = _Unregistered;
  const factory NotificationState.registering() = _Registering;
  const factory NotificationState.registered({required String deviceToken}) = _Registered;
  const factory NotificationState.error(String message) = _Error;
}
```

Key methods:

- `register(String userId)` -- Requests FCM token, sends `RegisterDevice` RPC, stores token in secure storage, transitions to `registered`.
- `unregister()` -- Reads stored token, sends `UnregisterDevice` RPC, clears stored token, transitions to `unregistered`.
- `_onTokenRefresh(String newToken)` -- Re-registers with the new token (FCM tokens can rotate at any time).

### Secure storage

Add a `_keyDeviceToken` constant to `SecureStorageService` with matching `readDeviceToken()` / `writeDeviceToken()` / `deleteDeviceToken()` methods, following the existing pattern for `_keyAccessToken`.

## Registration Flow

### On login (`setTokens()` in `auth_notifier.dart`)

```
setTokens() called
  --> AuthState transitions to authenticated
  --> Riverpod listener on authNotifierProvider detects authenticated state
  --> NotificationNotifier.register(userId) fires:
       1. FirebaseMessaging.instance.getToken()  --> deviceToken
       2. notificationServiceClient.registerDevice(
            RegisterDeviceRequest(
              deviceToken: deviceToken,
              platform: _detectPlatform(),
              userId: userId,
            )
          )
       3. secureStorage.writeDeviceToken(deviceToken)
       4. State --> NotificationState.registered(deviceToken: deviceToken)
```

The registration is triggered by a Riverpod listener (not by modifying `setTokens()` directly), keeping `AuthNotifier` free of notification concerns.

### On logout (`logout()` in `auth_notifier.dart`)

```
logout() called
  --> AuthState transitions to unauthenticated
  --> Riverpod listener detects unauthenticated state
  --> NotificationNotifier.unregister() fires:
       1. Read stored device token from secure storage
       2. notificationServiceClient.unregisterDevice(
            UnregisterDeviceRequest(deviceToken: storedToken)
          )
       3. secureStorage.deleteDeviceToken()
       4. State --> NotificationState.unregistered()
```

If the `UnregisterDevice` RPC fails (e.g. already offline), the token is still cleared locally. The daemon will eventually expire stale tokens server-side.

## Token Refresh

FCM tokens can rotate at any time (app update, cache clear, etc.). The notifier subscribes to the refresh stream:

```dart
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  // Re-register with the daemon using the new token
  _onTokenRefresh(newToken);
});
```

`_onTokenRefresh` sends a new `RegisterDevice` RPC with the updated token. The daemon is expected to handle this idempotently (upsert by user_id + platform).

## Platform Detection

Map `dart:io` `Platform` to the proto enum:

```dart
DevicePlatform _detectPlatform() {
  if (Platform.isAndroid) return DevicePlatform.DEVICE_PLATFORM_ANDROID;
  if (Platform.isIOS) return DevicePlatform.DEVICE_PLATFORM_IOS;
  return DevicePlatform.DEVICE_PLATFORM_UNSPECIFIED;
}
```

Desktop platforms (macOS) return `UNSPECIFIED` and skip registration entirely.

## Existing Infrastructure

### NotificationCache drift table (`database.dart:146-155`)

```dart
class NotificationCache extends Table {
  TextColumn get notificationId => text()();
  IntColumn get receivedAt => integer()();

  @override
  Set<Column> get primaryKey => {notificationId};
}
```

Already included in the `@DriftDatabase` tables list. Used for **incoming** notification deduplication -- when a push arrives, insert `notificationId`; if it already exists, drop the duplicate. This is separate from the registration flow but part of the same feature area.

### SecureStorageService (`secure_storage.dart`)

Will be extended with `readDeviceToken()`, `writeDeviceToken()`, and `deleteDeviceToken()` methods using a new `_keyDeviceToken = 'device_token'` constant. Follows the existing pattern for access tokens and relay config.

## Error Handling

- **Registration failure**: Transition to `NotificationState.error(message)`. Retry on next app foreground or next auth state change.
- **Unregistration failure**: Log and proceed with local cleanup. Daemon handles stale token expiry.
- **FCM unavailable**: On platforms where `FirebaseMessaging` is not available (desktop), skip registration silently.
- **No permission**: On iOS, `FirebaseMessaging.instance.requestPermission()` must be called before `getToken()`. If the user denies, state stays `unregistered`.

## Testing Strategy

### Unit tests (`test/features/notifications/`)

1. **Registration flow**: Mock `NotificationServiceClient` and `FirebaseMessaging`. Verify `RegisterDevice` RPC is called with correct token, platform, and userId. Verify state transitions: `unregistered -> registering -> registered`.

2. **Unregistration flow**: Verify `UnregisterDevice` RPC is called with stored token. Verify secure storage is cleared. Verify state transitions: `registered -> unregistered`.

3. **Token refresh**: Simulate `onTokenRefresh` stream emission. Verify re-registration RPC with new token.

4. **Error handling**: Simulate gRPC errors. Verify state transitions to `error`. Verify unregistration proceeds despite RPC failure.

5. **Auth state listener**: Verify registration triggers on `authenticated` state, unregistration triggers on `unauthenticated` state.

### Mocking approach

```dart
class MockNotificationServiceClient extends Mock
    implements NotificationServiceClient {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}
```

Use `FakeResponseFuture<RegisterDeviceResponse>` from the shared test helpers (see deduplication plan Task 8) to mock gRPC responses.

## Implementation Order

1. Generate Dart code from `notification.proto` (`protoc --dart_out=grpc:lib/generated/`)
2. Add `notificationServiceProvider` to `service_providers.dart`
3. Add `readDeviceToken` / `writeDeviceToken` / `deleteDeviceToken` to `SecureStorageService`
4. Create `lib/features/notifications/notification_notifier.dart` with state and logic
5. Create `lib/features/notifications/notification_providers.dart` with Riverpod providers
6. Wire auth state listener in notification providers (listen to `authNotifierProvider`)
7. Add `firebase_messaging` and `firebase_core` to `pubspec.yaml`
8. Platform setup (Android `google-services.json`, iOS APNs capability)
9. Write unit tests
10. Integration test on physical device
