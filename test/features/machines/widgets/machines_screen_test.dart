import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import 'package:betcode_app/features/machines/notifiers/machines_notifier.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/machines/screens/machines_screen.dart';
import 'package:betcode_app/features/machines/widgets/machine_card.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) => MaterialApp(theme: AppTheme.lightTheme, home: child);

MachineInfo _makeMachine({
  String machineId = 'mach-1',
  String name = 'dev-box',
  MachineStatus? status,
  String ownerId = 'user-1',
  int? lastSeenSeconds,
}) {
  final machine = MachineInfo(
    machineId: machineId,
    name: name,
    ownerId: ownerId,
    status: status ?? MachineStatus.MACHINE_STATUS_ONLINE,
  );
  if (lastSeenSeconds != null) {
    machine.lastSeen = Timestamp(seconds: Int64(lastSeenSeconds));
  }
  return machine;
}

/// A notifier that returns a canned async value without gRPC calls.
///
/// For [AsyncLoading], [build] never completes so the widget stays in loading.
/// For [AsyncData], it returns the data immediately.
/// For [AsyncError], it throws the error.
class _FakeMachinesNotifier extends MachinesNotifier {
  _FakeMachinesNotifier(this._value);

  final AsyncValue<List<MachineInfo>> _value;

  @override
  Future<List<MachineInfo>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<MachineInfo>>().future, // never completes
      error: (e, st) => Future.error(e, st),
    );
  }
}

// ---------------------------------------------------------------------------
// MachinesScreen tests
// ---------------------------------------------------------------------------

void main() {
  group('MachinesScreen', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            machinesProvider.overrideWith(
              () => _FakeMachinesNotifier(const AsyncLoading()),
            ),
          ],
          child: _app(const MachinesScreen()),
        ),
      );
      // Don't pumpAndSettle -- the loading state is the point.
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Machines'), findsOneWidget);
    });

    testWidgets('displays list of MachineCard widgets when data arrives',
        (t) async {
      final machines = [
        _makeMachine(machineId: 'm-1', name: 'alpha'),
        _makeMachine(machineId: 'm-2', name: 'beta'),
        _makeMachine(machineId: 'm-3', name: 'gamma'),
      ];

      await t.pumpWidget(
        ProviderScope(
          overrides: [
            machinesProvider.overrideWith(
              () => _FakeMachinesNotifier(AsyncData(machines)),
            ),
          ],
          child: _app(const MachinesScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.byType(MachineCard), findsNWidgets(3));
      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('beta'), findsOneWidget);
      expect(find.text('gamma'), findsOneWidget);
    });

    testWidgets('shows empty state when no machines exist', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            machinesProvider.overrideWith(
              () => _FakeMachinesNotifier(const AsyncData([])),
            ),
          ],
          child: _app(const MachinesScreen()),
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('No machines connected'), findsOneWidget);
      expect(find.byIcon(Icons.dns_outlined), findsOneWidget);
      expect(find.byType(MachineCard), findsNothing);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            machinesProvider.overrideWith(
              () => _FakeMachinesNotifier(
                AsyncError(Exception('connection refused'), StackTrace.empty),
              ),
            ),
          ],
          child: _app(const MachinesScreen()),
        ),
      );
      await t.pumpAndSettle();

      // ErrorDisplay shows the error message and a Retry button
      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // MachineCard tests
  // ---------------------------------------------------------------------------

  group('MachineCard', () {
    testWidgets('displays machine name', (t) async {
      await t.pumpWidget(
        _app(MachineCard(machine: _makeMachine(name: 'production-server'))),
      );
      await t.pumpAndSettle();

      expect(find.text('production-server'), findsOneWidget);
    });

    testWidgets('displays machine ID in monospace', (t) async {
      await t.pumpWidget(
        _app(MachineCard(machine: _makeMachine(machineId: 'abc-123-def'))),
      );
      await t.pumpAndSettle();

      expect(find.text('abc-123-def'), findsOneWidget);
    });

    testWidgets('displays Online status badge for MACHINE_STATUS_ONLINE',
        (t) async {
      await t.pumpWidget(
        _app(MachineCard(
          machine: _makeMachine(
            status: MachineStatus.MACHINE_STATUS_ONLINE,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Online'), findsOneWidget);
    });

    testWidgets('displays Offline status badge for MACHINE_STATUS_OFFLINE',
        (t) async {
      await t.pumpWidget(
        _app(MachineCard(
          machine: _makeMachine(
            status: MachineStatus.MACHINE_STATUS_OFFLINE,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('displays Unknown status badge for MACHINE_STATUS_UNSPECIFIED',
        (t) async {
      await t.pumpWidget(
        _app(MachineCard(
          machine: _makeMachine(
            status: MachineStatus.MACHINE_STATUS_UNSPECIFIED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Unknown'), findsOneWidget);
    });

    testWidgets('renders card with InkWell for tap target', (t) async {
      await t.pumpWidget(
        _app(MachineCard(machine: _makeMachine())),
      );
      await t.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(MachineCard(
          machine: _makeMachine(),
          onTap: () => tapped = true,
        )),
      );
      await t.pumpAndSettle();

      await t.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('shows "Unknown" when name is empty', (t) async {
      await t.pumpWidget(
        _app(MachineCard(machine: _makeMachine(name: ''))),
      );
      await t.pumpAndSettle();

      // The name field should show 'Unknown' as fallback
      expect(find.text('Unknown'), findsOneWidget);
    });

    testWidgets('displays metadata entries when present', (t) async {
      final machine = _makeMachine();
      machine.metadata['os'] = 'linux';
      machine.metadata['arch'] = 'x86_64';

      await t.pumpWidget(
        _app(MachineCard(machine: machine)),
      );
      await t.pumpAndSettle();

      expect(find.text('os: linux'), findsOneWidget);
      expect(find.text('arch: x86_64'), findsOneWidget);
    });
  });
}
