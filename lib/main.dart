import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Initialize database and auth state before rendering
  await container.read(authNotifierProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const BetCodeApp()),
  );
}
