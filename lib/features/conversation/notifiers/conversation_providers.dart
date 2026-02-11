import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conversation_state.dart';
import 'conversation_notifier.dart';

/// Provider for conversation state, keyed by session ID.
///
/// Pass `null` to start a new session, or an existing session ID to resume.
/// The notifier manages the full bidi gRPC stream lifecycle.
final conversationProvider =
    AsyncNotifierProvider.family<
      ConversationNotifier,
      ConversationState,
      String?
    >((sessionId) {
      final notifier = ConversationNotifier();
      notifier.sessionId = sessionId;
      return notifier;
    });
