import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      connectionStatusProvider.overrideWithValue(
        AsyncData(status),
      ),
      ...overrides,
    ],
  );
}
