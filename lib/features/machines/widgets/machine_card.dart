import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:betcode_app/shared/utils/time_utils.dart';
import 'package:betcode_app/shared/widgets/status_badge.dart';
import 'package:betcode_app/shared/widgets/tappable_card.dart';
import 'package:flutter/material.dart';

/// A card displaying a single [MachineInfo] in the machines list.
///
/// Shows machine name, machine ID, status badge, last seen time, and any
/// metadata entries. Accepts an optional [onTap] callback.
class MachineCard extends StatelessWidget {
  const MachineCard({
    required this.machine,
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  final MachineInfo machine;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TappableCard(
      onTap: onTap,
      isSelected: isSelected,
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
              if (isSelected) ...[
                const SizedBox(width: 4),
                Icon(Icons.check_circle, size: 18, color: colorScheme.primary),
              ],
              const SizedBox(width: 8),
              _buildStatusBadge(machine.status),
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
    );
  }

  String _relativeTime(MachineInfo machine) {
    if (!machine.hasLastSeen()) return '';

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      machine.lastSeen.seconds.toInt() * 1000,
      isUtc: true,
    ).toLocal();
    return relativeTime(dateTime);
  }
}

StatusBadge _buildStatusBadge(MachineStatus status) {
  final (color, label) = _resolveMachineStatus(status);
  return StatusBadge(color: color, label: label);
}

(Color, String) _resolveMachineStatus(MachineStatus status) {
  return switch (status) {
    MachineStatus.MACHINE_STATUS_ONLINE => (AppColors.online, 'Online'),
    MachineStatus.MACHINE_STATUS_OFFLINE => (AppColors.offline, 'Offline'),
    _ => (AppColors.agentIdle, 'Unknown'),
  };
}
