import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/agent.pb.dart';
import 'sessions_notifier.dart';

/// Provides the list of [SessionSummary] objects fetched from the daemon.
///
/// Use `ref.watch(sessionsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final sessionsProvider =
    AsyncNotifierProvider<SessionsNotifier, List<SessionSummary>>(
      SessionsNotifier.new,
    );
