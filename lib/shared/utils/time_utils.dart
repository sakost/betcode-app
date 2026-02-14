/// Converts a [DateTime] into a human-readable relative time string.
///
/// Returns strings like `'just now'`, `'5m ago'`, `'2h ago'`, `'3d ago'`,
/// or a date in `M/D/YYYY` format for timestamps older than 7 days.
String relativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
}
