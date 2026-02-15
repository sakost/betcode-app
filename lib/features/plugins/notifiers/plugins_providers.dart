import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/commands.pb.dart';
import 'plugins_notifier.dart';

/// Provides the list of [PluginInfo] objects fetched from the daemon.
///
/// Use `ref.watch(pluginsProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final pluginsProvider =
    AsyncNotifierProvider<PluginsNotifier, List<PluginInfo>>(
      PluginsNotifier.new,
    );
