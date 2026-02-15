import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/config.pb.dart';
import '../../../generated/betcode/v1/health.pb.dart';
import '../../../generated/betcode/v1/version.pb.dart';
import 'health_notifier.dart';
import 'mcp_servers_notifier.dart';
import 'permissions_notifier.dart';
import 'settings_notifier.dart';
import 'version_notifier.dart';

/// Provides the [Settings] fetched from the daemon.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);

/// Provides the list of [McpServerInfo] fetched from the daemon.
final mcpServersProvider =
    AsyncNotifierProvider<McpServersNotifier, List<McpServerInfo>>(
      McpServersNotifier.new,
    );

/// Provides the [PermissionRules] fetched from the daemon, scoped by session ID.
final permissionsProvider =
    AsyncNotifierProvider.family<PermissionsNotifier, PermissionRules, String>((
      sessionId,
    ) {
      final notifier = PermissionsNotifier();
      notifier.sessionId = sessionId;
      return notifier;
    });

/// Provides the [HealthDetailsResponse] fetched from the daemon.
final healthProvider =
    AsyncNotifierProvider<HealthNotifier, HealthDetailsResponse>(
      HealthNotifier.new,
    );

/// Provides the [GetVersionResponse] fetched from the daemon.
final versionProvider =
    AsyncNotifierProvider<VersionNotifier, GetVersionResponse>(
      VersionNotifier.new,
    );
