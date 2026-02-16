import 'package:betcode_app/features/settings/notifiers/health_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/mcp_servers_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/permissions_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/settings_notifier.dart';
import 'package:betcode_app/features/settings/notifiers/version_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/config.pb.dart';
import 'package:betcode_app/generated/betcode/v1/health.pb.dart';
import 'package:betcode_app/generated/betcode/v1/version.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the [Settings] fetched from the daemon.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);

/// Provides the list of [McpServerInfo] fetched from the daemon.
final mcpServersProvider =
    AsyncNotifierProvider<McpServersNotifier, List<McpServerInfo>>(
      McpServersNotifier.new,
    );

/// Provides the [PermissionRules] fetched from the daemon,
/// scoped by session ID.
// ignore: specify_nonobvious_property_types, the family provider type is not publicly exported
final permissionsProvider =
    AsyncNotifierProvider.family<PermissionsNotifier, PermissionRules, String>((
      sessionId,
    ) {
      final notifier = PermissionsNotifier()..sessionId = sessionId;
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
