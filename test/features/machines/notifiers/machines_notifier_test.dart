import 'package:betcode_app/core/auth/auth.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/machines/notifiers/selected_machine_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_response_future.dart';
import '../../../helpers/notifier_test_helpers.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockMachineServiceClient extends Mock implements MachineServiceClient {}

/// A fake notifier that stores selection in memory without secure storage.
class _FakeSelectedMachineNotifier extends SelectedMachineNotifier {
  @override
  String? build() => null;

  @override
  Future<void> select(String machineId) async {
    state = machineId;
  }

  @override
  Future<void> clear() async {
    state = null;
  }
}

/// A fake auth notifier that always returns an authenticated state.
class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState.authenticated(
    accessToken: 'fake-token',
    refreshToken: 'fake-refresh',
    userId: 'user-1',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );
}

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

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockMachineServiceClient mockClient;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ListMachinesRequest());
    registerFallbackValue(RegisterMachineRequest());
    registerFallbackValue(RemoveMachineRequest());
    registerFallbackValue(GetMachineRequest());
  });

  setUp(() {
    mockClient = MockMachineServiceClient();

    container = ProviderContainer(
      overrides: [
        machineServiceProvider.overrideWithValue(mockClient),
        selectedMachineIdProvider.overrideWith(
          _FakeSelectedMachineNotifier.new,
        ),
        authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
      ],
    );
  });

  tearDown(() => container.dispose());

  MachineInfo makeMachine(
    String id, {
    String name = 'dev-box',
    MachineStatus? status,
  }) => MachineInfo(
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
      when(
        () => mockClient.listMachines(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListMachinesResponse()));

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

  errorHandlingTests(
    label: 'MachinesNotifier',
    provider: machinesProvider,
    errorOverrides: (error) => [
      machineServiceProvider.overrideWithValue(_FailingMachineClient(error)),
      authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
    ],
  );

  refreshTests(
    RefreshTestConfig<List<MachineInfo>>(
      provider: machinesProvider,
      label: 'MachinesNotifier',
      getContainer: () => container,
      stubInitial: () {
        when(() => mockClient.listMachines(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListMachinesResponse(machines: [makeMachine('m-1')]),
          ),
        );
      },
      stubRefreshed: () {
        when(() => mockClient.listMachines(any())).thenAnswer(
          (_) => FakeResponseFuture.value(
            ListMachinesResponse(
              machines: [makeMachine('m-1'), makeMachine('m-new')],
            ),
          ),
        );
      },
      resetMock: () => reset(mockClient),
      stubAfterReset: () {
        when(
          () => mockClient.listMachines(any()),
        ).thenAnswer((_) => FakeResponseFuture.value(ListMachinesResponse()));
      },
      verifyListCalledOnce: () =>
          verify(() => mockClient.listMachines(any())).called(1),
      getItemCount: (v) => v.length,
      getSecondItemId: (v) => v[1].machineId,
    ),
  );

  group('MachinesNotifier - auto-select', () {
    test('auto-selects when exactly one machine and none selected', () async {
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('only-one')]),
        ),
      );

      await container.read(machinesProvider.future);

      expect(container.read(selectedMachineIdProvider), 'only-one');
    });

    test('does not auto-select when multiple machines', () async {
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(
            machines: [makeMachine('m-1'), makeMachine('m-2')],
          ),
        ),
      );

      await container.read(machinesProvider.future);

      expect(container.read(selectedMachineIdProvider), isNull);
    });

    test('does not auto-select when a machine is already selected', () async {
      // Pre-select a machine
      await container
          .read(selectedMachineIdProvider.notifier)
          .select('existing');

      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('only-one')]),
        ),
      );

      await container.read(machinesProvider.future);

      // Should keep existing selection, not override
      expect(container.read(selectedMachineIdProvider), 'existing');
    });

    test('does not auto-select when no machines', () async {
      when(
        () => mockClient.listMachines(any()),
      ).thenAnswer((_) => FakeResponseFuture.value(ListMachinesResponse()));

      await container.read(machinesProvider.future);

      expect(container.read(selectedMachineIdProvider), isNull);
    });
  });

  void stubMachinesEmpty() {
    when(
      () => mockClient.listMachines(any()),
    ).thenAnswer((_) => FakeResponseFuture.value(ListMachinesResponse()));
  }

  group('MachinesNotifier - registerMachine', () {
    test('calls gRPC registerMachine and refreshes', () async {
      // Initial build
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('m-1')]),
        ),
      );
      await container.read(machinesProvider.future);

      // Stub registerMachine
      final registered = makeMachine('m-new', name: 'new-box');
      when(() => mockClient.registerMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          RegisterMachineResponse(machine: registered),
        ),
      );

      // After register, list returns both machines
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(
            machines: [
              makeMachine('m-1'),
              makeMachine('m-new', name: 'new-box'),
            ],
          ),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.registerMachine(machineId: 'm-new', name: 'new-box');

      verify(() => mockClient.registerMachine(any())).called(1);

      final state = container.read(machinesProvider);
      expect(state.value, hasLength(2));
      expect(state.value![1].machineId, 'm-new');
    });

    test('passes correct parameters to gRPC', () async {
      await initNotifier(
        container: container,
        provider: machinesProvider,
        stubEmpty: stubMachinesEmpty,
      );

      when(() => mockClient.registerMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          RegisterMachineResponse(
            machine: makeMachine('reg-1', name: 'my-server'),
          ),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.registerMachine(
        machineId: 'reg-1',
        name: 'my-server',
        metadata: {'env': 'prod', 'region': 'us-east'},
      );

      final captured =
          verify(() => mockClient.registerMachine(captureAny())).captured.single
              as RegisterMachineRequest;

      expect(captured.machineId, 'reg-1');
      expect(captured.name, 'my-server');
      expect(captured.metadata['env'], 'prod');
      expect(captured.metadata['region'], 'us-east');
    });
  });

  group('MachinesNotifier - removeMachine', () {
    test('calls gRPC removeMachine and refreshes', () async {
      // Initial build with two machines
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(
            machines: [makeMachine('m-1'), makeMachine('m-2')],
          ),
        ),
      );
      await container.read(machinesProvider.future);

      // Stub removeMachine
      when(() => mockClient.removeMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RemoveMachineResponse(removed: true)),
      );

      // After removal, list returns only one machine
      when(() => mockClient.listMachines(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          ListMachinesResponse(machines: [makeMachine('m-1')]),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.removeMachine('m-2');

      verify(() => mockClient.removeMachine(any())).called(1);

      final state = container.read(machinesProvider);
      expect(state.value, hasLength(1));
      expect(state.value!.first.machineId, 'm-1');
    });

    test('passes correct machineId to gRPC', () async {
      await initNotifier(
        container: container,
        provider: machinesProvider,
        stubEmpty: stubMachinesEmpty,
      );

      when(() => mockClient.removeMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(RemoveMachineResponse(removed: true)),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.removeMachine('target-42');

      final captured =
          verify(() => mockClient.removeMachine(captureAny())).captured.single
              as RemoveMachineRequest;

      expect(captured.machineId, 'target-42');
    });
  });

  group('MachinesNotifier - getMachine', () {
    test('returns MachineInfo for given machineId', () async {
      await initNotifier(
        container: container,
        provider: machinesProvider,
        stubEmpty: stubMachinesEmpty,
      );

      final expected = MachineInfo(
        machineId: 'get-1',
        name: 'fetched-box',
        status: MachineStatus.MACHINE_STATUS_ONLINE,
      );
      when(() => mockClient.getMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(GetMachineResponse(machine: expected)),
      );

      final notifier = container.read(machinesProvider.notifier);
      final result = await notifier.getMachine('get-1');

      expect(result.machineId, 'get-1');
      expect(result.name, 'fetched-box');
      expect(result.status, MachineStatus.MACHINE_STATUS_ONLINE);
    });

    test('passes correct machineId to gRPC', () async {
      await initNotifier(
        container: container,
        provider: machinesProvider,
        stubEmpty: stubMachinesEmpty,
      );

      when(() => mockClient.getMachine(any())).thenAnswer(
        (_) => FakeResponseFuture.value(
          GetMachineResponse(machine: makeMachine('lookup-99')),
        ),
      );

      final notifier = container.read(machinesProvider.notifier);
      await notifier.getMachine('lookup-99');

      final captured =
          verify(() => mockClient.getMachine(captureAny())).captured.single
              as GetMachineRequest;

      expect(captured.machineId, 'lookup-99');
    });
  });
}
