import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:riverpod/misc.dart' show Override, ProviderListenable;

import 'test_container.dart';

// -----------------------------------------------------------
// Connection awareness test group
// -----------------------------------------------------------

/// Adds the standard "connection awareness" test group shared
/// by all connection-aware notifier tests.
///
/// [provider] is the provider under test
/// (e.g. `gitReposProvider`).
///
/// [serviceOverrides] returns the provider overrides that
/// inject the mock client for this provider.
///
/// [verifyNoGrpcCalls] is a callback that asserts no gRPC
/// methods were called, e.g.
/// `() => verifyNever(() => mockClient.listRepos(any()))`.
void connectionAwarenessTests({
  required String label,
  required ProviderListenable<dynamic> provider,
  required List<Override> Function() serviceOverrides,
  required void Function() verifyNoGrpcCalls,
}) {
  group('$label - connection awareness', () {
    test('throws StateError when disconnected', () async {
      final dc = await createDisconnectedContainer(
        provider: provider,
        overrides: serviceOverrides(),
      );
      final state = dc.read(provider) as AsyncValue<dynamic>;
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });

    test('does not call gRPC when disconnected', () async {
      await createDisconnectedContainer(
        provider: provider,
        overrides: serviceOverrides(),
      );
      verifyNoGrpcCalls();
    });
  });
}

// -----------------------------------------------------------
// Error handling test group
// -----------------------------------------------------------

/// Adds the standard "error handling" test group shared by
/// all notifier tests.
///
/// [provider] is the provider under test.
///
/// [errorOverrides] returns provider overrides that inject a
/// failing client for the given [GrpcError].
void errorHandlingTests({
  required String label,
  required ProviderListenable<dynamic> provider,
  required List<Override> Function(GrpcError error) errorOverrides,
}) {
  group('$label - error handling', () {
    test('gRPC error is captured in state', () async {
      final ec = await createErrorContainer(
        provider: provider,
        overrides: errorOverrides(
          const GrpcError.unavailable('connection refused'),
        ),
      );
      final state = ec.read(provider) as AsyncValue<dynamic>;
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final ec = await createErrorContainer(
        provider: provider,
        overrides: errorOverrides(
          const GrpcError.unavailable(
            'daemon unreachable',
          ),
        ),
      );
      final state = ec.read(provider) as AsyncValue<dynamic>;
      expect(state.hasError, isTrue);
      expect(
        (state.error! as GrpcError).message,
        'daemon unreachable',
      );
    });
  });
}

// -----------------------------------------------------------
// Refresh test group
// -----------------------------------------------------------

/// Configuration object for the standard refresh tests.
///
/// `stubListEmpty` stubs the list/build RPC to return an
/// empty response.
///
/// `stubListItems` stubs the list/build RPC to return a
/// response with items.
///
/// `verifyListCalled` verifies the list RPC was called
/// exactly N times.
///
/// `resetMock` resets the mock client
/// (e.g. `() => reset(mockClient)`).
///
/// `getFirstItemId` extracts an identifying field from the
/// first item in the state value, used for
/// refresh-updates-state assertions.
class RefreshTestConfig<T> {
  const RefreshTestConfig({
    required this.provider,
    required this.label,
    required this.getContainer,
    required this.stubInitial,
    required this.stubRefreshed,
    required this.resetMock,
    required this.stubAfterReset,
    required this.verifyListCalledOnce,
    required this.getItemCount,
    required this.getSecondItemId,
  });

  /// The provider under test.
  final dynamic provider;
  final String label;
  final ProviderContainer Function() getContainer;

  /// Stubs the list RPC with an initial single-item response.
  final void Function() stubInitial;

  /// Stubs the list RPC with a refreshed multi-item response.
  final void Function() stubRefreshed;

  /// Resets the mock client.
  final void Function() resetMock;

  /// Stubs the list RPC after reset with an
  /// empty/minimal response.
  final void Function() stubAfterReset;

  /// Verifies the list RPC was called exactly once.
  final void Function() verifyListCalledOnce;

  /// Gets the item count from the state value.
  final int Function(T value) getItemCount;

  /// Gets an identifier from the second item
  /// (for verifying refresh added it).
  final String Function(T value) getSecondItemId;
}

/// Adds the standard "refresh" test group covering:
/// - re-fetches and updates state
/// - refresh calls gRPC exactly once
void refreshTests<T>(RefreshTestConfig<T> config) {
  // Extract typed accessors from the dynamic provider.
  final futureProvider =
      // ignore: avoid_dynamic_calls -- provider type varies
      config.provider.future as ProviderListenable<Future<T>>;
  final notifierProvider =
      // ignore: avoid_dynamic_calls -- provider type varies
      config.provider.notifier as ProviderListenable<dynamic>;
  final stateProvider = config.provider as ProviderListenable<AsyncValue<T>>;

  group('${config.label} - refresh', () {
    test('re-fetches and updates state', () async {
      config.stubInitial();
      final container = config.getContainer();
      await container.read(futureProvider);

      config.stubRefreshed();

      final notifier = container.read(notifierProvider);
      await (notifier as dynamic).refresh();

      final state = container.read(stateProvider);
      expect(
        config.getItemCount(state.value as T),
        2,
      );
      expect(
        config.getSecondItemId(state.value as T),
        isNotEmpty,
      );
    });

    test('refresh calls gRPC exactly once', () async {
      config.stubAfterReset();
      final container = config.getContainer();
      await container.read(futureProvider);

      config.resetMock();
      config.stubAfterReset();

      final notifier = container.read(notifierProvider);
      await (notifier as dynamic).refresh();

      config.verifyListCalledOnce();
    });
  });
}

// -----------------------------------------------------------
// "init then act" helper
// -----------------------------------------------------------

/// Stubs the initial build for a list-based notifier and
/// waits for it.
///
/// `stubEmpty` should stub the list RPC to return an empty
/// response. Returns after the provider's future resolves.
Future<void> initNotifier({
  required ProviderContainer container,
  required dynamic provider,
  required void Function() stubEmpty,
}) async {
  stubEmpty();
  // ignore: avoid_dynamic_calls -- provider type varies
  final futureProvider = provider.future as ProviderListenable<Future<dynamic>>;
  await container.read(futureProvider);
}
