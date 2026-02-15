import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';

/// Creates a [ProviderContainer] with the common connection status override.
///
/// Most notifier tests need a connected status. Pass additional overrides
/// for service mocks.
ProviderContainer createTestContainer({
  GrpcConnectionStatus status = GrpcConnectionStatus.connected,
  List overrides = const [],
}) {
  return ProviderContainer(
    overrides: [
      connectionStatusProvider.overrideWithValue(AsyncData(status)),
      ...overrides,
    ],
  );
}

/// Creates a disconnected [ProviderContainer], reads the given [provider],
/// waits a microtask, and returns the container for assertions.
///
/// Registers [addTearDown] to dispose the container automatically.
/// This eliminates the repeated disconnected-container boilerplate
/// found in connection awareness tests.
Future<ProviderContainer> createDisconnectedContainer({
  required dynamic provider,
  required List overrides,
  GrpcConnectionStatus status = GrpcConnectionStatus.disconnected,
}) async {
  final container = createTestContainer(status: status, overrides: overrides);
  addTearDown(container.dispose);

  container.read(provider);
  await Future<void>.delayed(Duration.zero);

  return container;
}

/// Creates a [ProviderContainer] with the given overrides, reads the
/// [provider], waits a microtask, and returns the container for error
/// assertions.
///
/// Registers [addTearDown] to dispose the container automatically.
/// This eliminates the repeated error-container boilerplate found in
/// error handling tests.
Future<ProviderContainer> createErrorContainer({
  required dynamic provider,
  required List overrides,
}) async {
  final container = createTestContainer(overrides: overrides);
  addTearDown(container.dispose);

  container.read(provider);
  await Future<void>.delayed(Duration.zero);

  return container;
}
