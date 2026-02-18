import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A persistent banner shown at the top of the app when there are
/// connectivity issues.
///
/// Watches [networkStatusProvider] and [connectionStatusProvider] to
/// determine what to display. Hidden (zero height) when everything is fine.
class ConnectivityBanner extends ConsumerWidget {
  /// Creates a [ConnectivityBanner].
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAsync = ref.watch(networkStatusProvider);
    final connectionAsync = ref.watch(connectionStatusProvider);

    final isOffline = networkAsync.value == NetworkStatus.offline;
    final connectionStatus = connectionAsync.value;
    final isRelayDown =
        !isOffline &&
        (connectionStatus == GrpcConnectionStatus.disconnected ||
            connectionStatus == GrpcConnectionStatus.reconnecting);

    final String? message;
    final Color? backgroundColor;
    final IconData? icon;

    if (isOffline) {
      message = 'No internet connection';
      backgroundColor = Theme.of(context).colorScheme.error;
      icon = Icons.wifi_off;
    } else if (isRelayDown) {
      message = connectionStatus == GrpcConnectionStatus.reconnecting
          ? 'Relay unreachable \u2014 reconnecting...'
          : 'Relay unreachable';
      backgroundColor = Theme.of(context).colorScheme.tertiary;
      icon = Icons.cloud_off;
    } else {
      message = null;
      backgroundColor = null;
      icon = null;
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: message != null
          ? MaterialBanner(
              content: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: backgroundColor,
              actions: const [SizedBox.shrink()],
            )
          : const SizedBox.shrink(),
    );
  }
}
