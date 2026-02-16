import 'package:betcode_app/features/commands/notifiers/commands_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [CommandEntry] objects fetched from the daemon.
///
/// Use `ref.watch(commandsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final commandsProvider =
    AsyncNotifierProvider<CommandsNotifier, List<CommandEntry>>(
      CommandsNotifier.new,
    );
