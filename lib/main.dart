import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/auth/auth.dart';
import 'core/grpc/grpc_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Connect to relay (if previously configured) before initializing auth,
  // since auth initialization may need the gRPC channel.
  await container.read(relayConfigNotifierProvider.notifier).initialize();

  // Initialize auth state before rendering
  await container.read(authNotifierProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const BetCodeApp()),
  );
}
