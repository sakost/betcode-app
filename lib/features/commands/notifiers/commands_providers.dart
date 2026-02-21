import 'package:betcode_app/features/commands/notifiers/commands_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [CommandEntry] objects fetched from the daemon,
/// scoped by session ID.
///
/// Pass a session ID to fetch session-specific commands, or `null` for
/// global commands. Use `ref.watch(commandsProvider(sessionId))` in
/// widgets to reactively rebuild on loading / data / error transitions.
// ignore: specify_nonobvious_property_types, the family provider type is not publicly exported
final commandsProvider =
    AsyncNotifierProvider.family<CommandsNotifier, List<CommandEntry>, String?>(
      (sessionId) {
        final notifier = CommandsNotifier()..sessionId = sessionId;
        return notifier;
      },
    );
