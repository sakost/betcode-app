import 'package:betcode_app/features/conversation/notifiers/session_grants_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [SessionGrantEntry] for the active session.
///
/// Use [SessionGrantsNotifier.setSessionId] to change which session's grants
/// are fetched. The provider auto-refreshes when the session ID changes.
final sessionGrantsProvider =
    AsyncNotifierProvider<SessionGrantsNotifier, List<SessionGrantEntry>>(
      SessionGrantsNotifier.new,
    );
