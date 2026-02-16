import 'package:betcode_app/features/plugins/notifiers/plugins_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [PluginInfo] objects fetched from the daemon.
///
/// Use `ref.watch(pluginsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final pluginsProvider =
    AsyncNotifierProvider<PluginsNotifier, List<PluginInfo>>(
      PluginsNotifier.new,
    );
