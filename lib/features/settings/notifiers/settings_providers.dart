import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/config.pb.dart';
import 'mcp_servers_notifier.dart';
import 'settings_notifier.dart';

/// Provides the [Settings] fetched from the daemon.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);

/// Provides the list of [McpServerInfo] fetched from the daemon.
final mcpServersProvider =
    AsyncNotifierProvider<McpServersNotifier, List<McpServerInfo>>(
      McpServersNotifier.new,
    );
