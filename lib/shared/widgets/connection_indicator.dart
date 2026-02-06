import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connection status states for the gRPC link to the daemon.
enum ConnectionStatus { connected, connecting, reconnecting, disconnected }

/// A small indicator widget that displays the current connection status
/// as a colored dot with accompanying text.
///
/// Uses [Consumer] so it can be dropped into any widget tree and later
/// wired to a Riverpod provider that supplies [ConnectionStatus].
class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({super.key, required this.status});

  final ConnectionStatus status;

  Color _dotColor() {
    return switch (status) {
      ConnectionStatus.connected => Colors.green,
      ConnectionStatus.connecting => Colors.orange,
      ConnectionStatus.reconnecting => Colors.amber,
      ConnectionStatus.disconnected => Colors.red,
    };
  }

  String _label() {
    return switch (status) {
      ConnectionStatus.connected => 'Connected',
      ConnectionStatus.connecting => 'Connecting...',
      ConnectionStatus.reconnecting => 'Reconnecting...',
      ConnectionStatus.disconnected => 'Disconnected',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _dotColor();
    final label = _label();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
