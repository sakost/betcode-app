import 'package:betcode_app/features/sessions/notifiers/sessions_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [SessionSummary] objects fetched from the daemon.
///
/// Use `ref.watch(sessionsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final sessionsProvider =
    AsyncNotifierProvider<SessionsNotifier, List<SessionSummary>>(
      SessionsNotifier.new,
    );
