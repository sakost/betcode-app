import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pbgrpc.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockMachineServiceClient extends Mock implements MachineServiceClient {}

/// A fake client whose [listMachines] always throws [GrpcError].
class _FailingMachineClient extends Fake implements MachineServiceClient {
  _FailingMachineClient(this.error);
  final GrpcError error;

  @override
  ResponseFuture<ListMachinesResponse> listMachines(
    ListMachinesRequest request, {
    CallOptions? options,
  }) {
    throw error;
  }
}

/// Wraps a pre-computed value (or error) as a [ResponseFuture] so that
/// mocked gRPC calls can be awaited in production code.
class FakeResponseFuture<T> extends Fake implements ResponseFuture<T> {
  FakeResponseFuture.value(T value) : _future = Future.value(value);
  FakeResponseFuture.error(Object error) : _future = Future.error(error);

  final Future<T> _future;

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      _future.then(onValue, onError: onError);

  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _future.whenComplete(action);

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<void> cancel() async {}

  @override
  bool get isCancelled => false;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockMachineServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListMachinesRequest());
  });

  setUp(() {
    mockClient = MockMachineServiceClient();

    container = ProviderContainer(
      overrides: [
        machineServiceProvider.overrideWithValue(mockClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  MachineInfo makeMachine(String id, {String name = 'dev-box', MachineStatus? status}) =>
      MachineInfo(
        machineId: id,
        name: name,
        status: status ?? MachineStatus.MACHINE_STATUS_ONLINE,
      );

  group('MachinesNotifier - build', () {
    test('fetches machines from gRPC', () async {
      final machines = [makeMachine('m-1'), makeMachine('m-2')];
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: machines, total: 2),
        ),
      );

      final result = await container.read(machinesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].machineId, 'm-1');
      expect(result[1].machineId, 'm-2');
    });

    test('returns empty list when no machines exist', () async {
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMachinesResponse()),
      );

      final result = await container.read(machinesProvider.future);
      expect(result, isEmpty);
    });

    test('preserves machine fields from the response', () async {
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(
            machines: [
              MachineInfo(
                machineId: 'mach-42',
                name: 'production-server',
                ownerId: 'user-1',
                status: MachineStatus.MACHINE_STATUS_OFFLINE,
              ),
            ],
          ),
        ),
      );

      final result = await container.read(machinesProvider.future);

      expect(result, hasLength(1));
      final machine = result.first;
      expect(machine.machineId, 'mach-42');
      expect(machine.name, 'production-server');
      expect(machine.ownerId, 'user-1');
      expect(machine.status, MachineStatus.MACHINE_STATUS_OFFLINE);
    });
  });

  group('MachinesNotifier - error handling', () {
    test('gRPC error is captured in state', () async {
      final errContainer = ProviderContainer(
        overrides: [
          machineServiceProvider.overrideWithValue(
            _FailingMachineClient(GrpcError.unavailable('connection refused')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      // Trigger build and let microtasks settle.
      errContainer.read(machinesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(machinesProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<GrpcError>());
    });

    test('gRPC error preserves error details', () async {
      final errContainer = ProviderContainer(
        overrides: [
          machineServiceProvider.overrideWithValue(
            _FailingMachineClient(GrpcError.unavailable('daemon unreachable')),
          ),
        ],
      );
      addTearDown(errContainer.dispose);

      errContainer.read(machinesProvider);
      await Future<void>.delayed(Duration.zero);

      final state = errContainer.read(machinesProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as GrpcError).message, 'daemon unreachable');
    });
  });

  group('MachinesNotifier - refresh', () {
    test('re-fetches and updates state', () async {
      // Initial fetch
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('m-1')]),
        ),
      );
      await container.read(machinesProvider.future);

      // Refresh with updated data
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(
            machines: [makeMachine('m-1'), makeMachine('m-new')],
          ),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.refresh();

      final state = container.read(machinesProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].machineId, 'm-new');
    });

    test('transitions through loading state during refresh', () async {
      final states = <AsyncValue<List<MachineInfo>>>[];

      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('m-1')]),
        ),
      );
      await container.read(machinesProvider.future);

      container.listen(machinesProvider, (prev, next) {
        states.add(next);
      });

      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('m-2')]),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.refresh();

      expect(states.any((s) => s is AsyncLoading), isTrue);
      expect(states.last.value, hasLength(1));
      expect(states.last.value!.first.machineId, 'm-2');
    });

    test('recovers from error state on refresh', () async {
      final errClient = MockMachineServiceClient();
      when(() => errClient.listMachines(any())).thenThrow(
        GrpcError.unavailable(),
      );

      final errContainer = ProviderContainer(
        overrides: [
          machineServiceProvider.overrideWithValue(errClient),
        ],
      );
      addTearDown(errContainer.dispose);

      // Trigger build and let error settle.
      errContainer.read(machinesProvider);
      await Future<void>.delayed(Duration.zero);

      // Now re-stub to succeed.
      when(() => errClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('recovered')]),
        ),
      );

      final notifier = errContainer.read(machinesProvider.notifier);
      await notifier.refresh();

      final state = errContainer.read(machinesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.first.machineId, 'recovered');
    });

    test('refresh calls gRPC exactly once', () async {
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMachinesResponse()),
      );
      await container.read(machinesProvider.future);

      // Reset call count
      reset(mockClient);
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(ListMachinesResponse()),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.refresh();

      verify(() => mockClient.listMachines(any())).called(1);
    });
  });
}
