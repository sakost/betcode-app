import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/auth/auth.dart';
import 'core/grpc/grpc_providers.dart';
import 'features/machines/notifiers/machines_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Connect to relay (if previously configured) before initializing auth,
  // since auth initialization may need the gRPC channel.
  debugPrint('[main] Connecting to relay...');
  await container.read(relayConfigNotifierProvider.notifier).initialize();
  debugPrint('[main] Relay init done');

  // Initialize auth state before rendering
  debugPrint('[main] Initializing auth...');
  await container.read(authNotifierProvider.notifier).initialize();
  debugPrint('[main] Auth init done');

  // Restore previously selected machine
  debugPrint('[main] Restoring selected machine...');
  await container.read(selectedMachineIdProvider.notifier).initialize();
  debugPrint('[main] Machine selection restored');

  // Eagerly load machines so auto-select can pick the sole machine before
  // the conversation screen tries to send gRPC calls that require
  // the x-machine-id header. Fire-and-forget — don't block app startup.
  container.read(machinesProvider.future).then(
    (_) => debugPrint('[main] Machines loaded'),
    onError: (Object e) => debugPrint('[main] Machines pre-load failed: $e'),
  );

  debugPrint('[main] Starting app');
  runApp(
    UncontrolledProviderScope(container: container, child: const BetCodeApp()),
  );
}
