import 'package:betcode_app/core/grpc/relay_reconnect_provider.dart';
import 'package:betcode_app/core/router.dart';
import 'package:betcode_app/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BetCodeApp extends ConsumerWidget {
  const BetCodeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(relayAutoReconnectProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BetCode',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
