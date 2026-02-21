import 'package:flutter/material.dart';

/// A space-efficient [Chip] used for labels and tags in list cards.
///
/// Applies [MaterialTapTargetSize.shrinkWrap], [VisualDensity.compact], and
/// tight padding so many chips can fit in a single [Wrap] row.
class CompactChip extends StatelessWidget {
  /// Creates a [CompactChip] with the given text [label].
  const CompactChip({required this.label, super.key});

  /// The text displayed inside the chip.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}
