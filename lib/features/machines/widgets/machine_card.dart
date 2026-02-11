import 'package:flutter/material.dart';

import '../../../generated/betcode/v1/machine.pb.dart';
import '../../../shared/theme/app_colors.dart';

/// A card displaying a single [MachineInfo] in the machines list.
///
/// Shows machine name, machine ID, status badge, last seen time, and any
/// metadata entries. Accepts an optional [onTap] callback.
class MachineCard extends StatelessWidget {
  const MachineCard({super.key, required this.machine, this.onTap});

  final MachineInfo machine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: machine name + status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      machine.name.isNotEmpty ? machine.name : 'Unknown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: machine.status),
                ],
              ),

              const SizedBox(height: 6),

              // Machine ID
              Text(
                machine.machineId,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'JetBrains Mono',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Last seen
              if (machine.hasLastSeen()) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _relativeTime(machine),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              // Metadata entries
              if (machine.metadata.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...machine.metadata.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(MachineInfo machine) {
    if (!machine.hasLastSeen()) return '';

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      machine.lastSeen.seconds.toInt() * 1000,
      isUtc: true,
    ).toLocal();

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}

/// A small colored chip indicating the machine status.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final MachineStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = _resolve(status);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) _resolve(MachineStatus status) {
    return switch (status) {
      MachineStatus.MACHINE_STATUS_ONLINE => (AppColors.online, 'Online'),
      MachineStatus.MACHINE_STATUS_OFFLINE => (AppColors.offline, 'Offline'),
      _ => (AppColors.agentIdle, 'Unknown'),
    };
  }
}
