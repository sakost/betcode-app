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
  await container.read(relayConfigNotifierProvider.notifier).initialize();

  // Initialize auth state before rendering
  await container.read(authNotifierProvider.notifier).initialize();

  // Restore previously selected machine
  await container.read(selectedMachineIdProvider.notifier).initialize();

  // Eagerly load machines so auto-select can pick the sole machine before
  // the conversation screen tries to send gRPC calls that require
  // the x-machine-id header.
  try {
    await container.read(machinesProvider.future);
  } on Exception {
    // Connection may not be ready; machines will load when screen is shown.
  }

  runApp(
    UncontrolledProviderScope(container: container, child: const BetCodeApp()),
  );
}
