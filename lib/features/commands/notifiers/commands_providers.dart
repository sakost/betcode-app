import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/commands.pb.dart';
import 'commands_notifier.dart';

/// Provides the list of [CommandEntry] objects fetched from the daemon.
///
/// Use `ref.watch(commandsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final commandsProvider =
    AsyncNotifierProvider<CommandsNotifier, List<CommandEntry>>(
      CommandsNotifier.new,
    );
