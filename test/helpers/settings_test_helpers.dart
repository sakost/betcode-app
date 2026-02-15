import 'package:betcode_app/generated/betcode/v1/config.pb.dart';

/// Creates a test [Settings] protobuf with sensible defaults.
///
/// Shared across settings_notifier_test, settings_screen_test, and any other
/// test that needs to construct a Settings instance.
Settings makeTestSettings({
  String defaultModel = 'opus',
  bool autoCompact = true,
  int autoCompactThreshold = 100,
  int maxMessagesPerSession = 500,
  int connectedTimeoutSecs = 30,
  int disconnectedTimeoutSecs = 120,
  bool enableAutoApprove = false,
  bool activityRefreshEnabled = true,
}) => Settings(
  sessions: SessionSettings(
    defaultModel: defaultModel,
    autoCompact: autoCompact,
    autoCompactThreshold: autoCompactThreshold,
    maxMessagesPerSession: maxMessagesPerSession,
  ),
  permissions: PermissionSettings(
    connectedTimeoutSecs: connectedTimeoutSecs,
    disconnectedTimeoutSecs: disconnectedTimeoutSecs,
    enableAutoApprove: enableAutoApprove,
    activityRefreshEnabled: activityRefreshEnabled,
  ),
);
