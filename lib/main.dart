import 'package:betcode_app/app.dart';
import 'package:betcode_app/core/auth/auth.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Load machines and auto-select the sole machine before the app renders,
  // so gRPC calls that require the x-machine-id header have it available.
  try {
    await container.read(machinesProvider.future);
    debugPrint('[main] Machines loaded');
  } on Exception catch (e) {
    debugPrint('[main] Machines pre-load failed: $e');
  }

  debugPrint('[main] Starting app');
  runApp(
    UncontrolledProviderScope(container: container, child: const BetCodeApp()),
  );
}
