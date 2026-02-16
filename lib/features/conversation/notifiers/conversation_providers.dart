import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for conversation state, keyed by session ID.
///
/// Pass `null` to start a new session, or an existing session ID to
/// resume. The notifier manages the full bidi gRPC stream lifecycle.
// ignore: specify_nonobvious_property_types, the family provider type is not publicly exported
final conversationProvider =
    AsyncNotifierProvider.family<
      ConversationNotifier,
      ConversationState,
      String?
    >((sessionId) {
      final notifier = ConversationNotifier()..sessionId = sessionId;
      return notifier;
    });
