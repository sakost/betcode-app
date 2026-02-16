import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/machines/notifiers/selected_machine_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override, ProviderListenable;

/// Creates a [ProviderContainer] with the common connection
/// status override.
///
/// Most notifier tests need a connected status and a selected
/// machine. Pass additional overrides for service mocks.
///
/// Set [machineId] to control the selected machine (defaults
/// to `'test-machine'`). Set [includeMachineId] to `false`
/// when providing your own `selectedMachineIdProvider`
/// override to avoid duplicates.
ProviderContainer createTestContainer({
  GrpcConnectionStatus status = GrpcConnectionStatus.connected,
  String? machineId = 'test-machine',
  bool includeMachineId = true,
  List<Override> overrides = const [],
}) {
  return ProviderContainer(
    overrides: [
      connectionStatusProvider.overrideWithValue(AsyncData(status)),
      if (includeMachineId)
        selectedMachineIdProvider.overrideWith(
          () => _FixedMachineNotifier(machineId),
        ),
      ...overrides,
    ],
  );
}

class _FixedMachineNotifier extends SelectedMachineNotifier {
  _FixedMachineNotifier(this._value);
  final String? _value;
  @override
  String? build() => _value;
}

/// Creates a disconnected [ProviderContainer], reads the
/// given [provider], waits a microtask, and returns the
/// container for assertions.
///
/// Registers [addTearDown] to dispose the container
/// automatically. This eliminates the repeated
/// disconnected-container boilerplate found in connection
/// awareness tests.
Future<ProviderContainer> createDisconnectedContainer({
  required ProviderListenable<dynamic> provider,
  required List<Override> overrides,
  GrpcConnectionStatus status = GrpcConnectionStatus.disconnected,
}) async {
  final container = createTestContainer(
    status: status,
    overrides: overrides,
  );
  addTearDown(container.dispose);

  container.read(provider);
  await Future<void>.delayed(Duration.zero);

  return container;
}

/// Creates a [ProviderContainer] with the given overrides,
/// reads the [provider], waits a microtask, and returns the
/// container for error assertions.
///
/// Registers [addTearDown] to dispose the container
/// automatically. This eliminates the repeated
/// error-container boilerplate found in error handling tests.
Future<ProviderContainer> createErrorContainer({
  required ProviderListenable<dynamic> provider,
  required List<Override> overrides,
}) async {
  final container = createTestContainer(overrides: overrides);
  addTearDown(container.dispose);

  container.read(provider);
  await Future<void>.delayed(Duration.zero);

  return container;
}
