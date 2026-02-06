// This is a generated file - do not edit.
//
// Generated from betcode/v1/config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'config.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'config.pbenum.dart';

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest({
    $core.String? scope,
  }) {
    final result = create();
    if (scope != null) result.scope = scope;
    return result;
  }

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scope')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scope => $_getSZ(0);
  @$pb.TagNumber(1)
  set scope($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScope() => $_has(0);
  @$pb.TagNumber(1)
  void clearScope() => $_clearField(1);
}

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    DaemonSettings? daemon,
    SessionSettings? sessions,
    PermissionSettings? permissions,
    $core.Iterable<$core.MapEntry<$core.String, $core.bool>>? featureFlags,
  }) {
    final result = create();
    if (daemon != null) result.daemon = daemon;
    if (sessions != null) result.sessions = sessions;
    if (permissions != null) result.permissions = permissions;
    if (featureFlags != null) result.featureFlags.addEntries(featureFlags);
    return result;
  }

  Settings._();

  factory Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<DaemonSettings>(1, _omitFieldNames ? '' : 'daemon',
        subBuilder: DaemonSettings.create)
    ..aOM<SessionSettings>(2, _omitFieldNames ? '' : 'sessions',
        subBuilder: SessionSettings.create)
    ..aOM<PermissionSettings>(3, _omitFieldNames ? '' : 'permissions',
        subBuilder: PermissionSettings.create)
    ..m<$core.String, $core.bool>(4, _omitFieldNames ? '' : 'featureFlags',
        entryClassName: 'Settings.FeatureFlagsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings copyWith(void Function(Settings) updates) =>
      super.copyWith((message) => updates(message as Settings)) as Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  @$core.override
  Settings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  DaemonSettings get daemon => $_getN(0);
  @$pb.TagNumber(1)
  set daemon(DaemonSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDaemon() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaemon() => $_clearField(1);
  @$pb.TagNumber(1)
  DaemonSettings ensureDaemon() => $_ensure(0);

  @$pb.TagNumber(2)
  SessionSettings get sessions => $_getN(1);
  @$pb.TagNumber(2)
  set sessions(SessionSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSessions() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessions() => $_clearField(2);
  @$pb.TagNumber(2)
  SessionSettings ensureSessions() => $_ensure(1);

  @$pb.TagNumber(3)
  PermissionSettings get permissions => $_getN(2);
  @$pb.TagNumber(3)
  set permissions(PermissionSettings value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissions() => $_clearField(3);
  @$pb.TagNumber(3)
  PermissionSettings ensurePermissions() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.bool> get featureFlags => $_getMap(3);
}

class DaemonSettings extends $pb.GeneratedMessage {
  factory DaemonSettings({
    $core.int? maxSubprocesses,
    $core.String? socketPath,
    $core.int? port,
    $core.String? databasePath,
    $core.String? logLevel,
    $core.int? maxPayloadBytes,
  }) {
    final result = create();
    if (maxSubprocesses != null) result.maxSubprocesses = maxSubprocesses;
    if (socketPath != null) result.socketPath = socketPath;
    if (port != null) result.port = port;
    if (databasePath != null) result.databasePath = databasePath;
    if (logLevel != null) result.logLevel = logLevel;
    if (maxPayloadBytes != null) result.maxPayloadBytes = maxPayloadBytes;
    return result;
  }

  DaemonSettings._();

  factory DaemonSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DaemonSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DaemonSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'maxSubprocesses',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'socketPath')
    ..aI(3, _omitFieldNames ? '' : 'port', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'databasePath')
    ..aOS(5, _omitFieldNames ? '' : 'logLevel')
    ..aI(6, _omitFieldNames ? '' : 'maxPayloadBytes',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DaemonSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DaemonSettings copyWith(void Function(DaemonSettings) updates) =>
      super.copyWith((message) => updates(message as DaemonSettings))
          as DaemonSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DaemonSettings create() => DaemonSettings._();
  @$core.override
  DaemonSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DaemonSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DaemonSettings>(create);
  static DaemonSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get maxSubprocesses => $_getIZ(0);
  @$pb.TagNumber(1)
  set maxSubprocesses($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxSubprocesses() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxSubprocesses() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get socketPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set socketPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSocketPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get databasePath => $_getSZ(3);
  @$pb.TagNumber(4)
  set databasePath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDatabasePath() => $_has(3);
  @$pb.TagNumber(4)
  void clearDatabasePath() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get logLevel => $_getSZ(4);
  @$pb.TagNumber(5)
  set logLevel($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLogLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLogLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get maxPayloadBytes => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxPayloadBytes($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxPayloadBytes() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxPayloadBytes() => $_clearField(6);
}

class SessionSettings extends $pb.GeneratedMessage {
  factory SessionSettings({
    $core.String? defaultModel,
    $core.bool? autoCompact,
    $core.int? autoCompactThreshold,
    $core.int? maxMessagesPerSession,
  }) {
    final result = create();
    if (defaultModel != null) result.defaultModel = defaultModel;
    if (autoCompact != null) result.autoCompact = autoCompact;
    if (autoCompactThreshold != null)
      result.autoCompactThreshold = autoCompactThreshold;
    if (maxMessagesPerSession != null)
      result.maxMessagesPerSession = maxMessagesPerSession;
    return result;
  }

  SessionSettings._();

  factory SessionSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'defaultModel')
    ..aOB(2, _omitFieldNames ? '' : 'autoCompact')
    ..aI(3, _omitFieldNames ? '' : 'autoCompactThreshold',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'maxMessagesPerSession',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSettings copyWith(void Function(SessionSettings) updates) =>
      super.copyWith((message) => updates(message as SessionSettings))
          as SessionSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionSettings create() => SessionSettings._();
  @$core.override
  SessionSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionSettings>(create);
  static SessionSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get defaultModel => $_getSZ(0);
  @$pb.TagNumber(1)
  set defaultModel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDefaultModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefaultModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get autoCompact => $_getBF(1);
  @$pb.TagNumber(2)
  set autoCompact($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoCompact() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoCompact() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get autoCompactThreshold => $_getIZ(2);
  @$pb.TagNumber(3)
  set autoCompactThreshold($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoCompactThreshold() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoCompactThreshold() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxMessagesPerSession => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxMessagesPerSession($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxMessagesPerSession() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxMessagesPerSession() => $_clearField(4);
}

class PermissionSettings extends $pb.GeneratedMessage {
  factory PermissionSettings({
    $core.int? connectedTimeoutSecs,
    $core.int? disconnectedTimeoutSecs,
    $core.bool? enableAutoApprove,
    $core.Iterable<$core.String>? autoApproveDirectories,
    $core.bool? activityRefreshEnabled,
  }) {
    final result = create();
    if (connectedTimeoutSecs != null)
      result.connectedTimeoutSecs = connectedTimeoutSecs;
    if (disconnectedTimeoutSecs != null)
      result.disconnectedTimeoutSecs = disconnectedTimeoutSecs;
    if (enableAutoApprove != null) result.enableAutoApprove = enableAutoApprove;
    if (autoApproveDirectories != null)
      result.autoApproveDirectories.addAll(autoApproveDirectories);
    if (activityRefreshEnabled != null)
      result.activityRefreshEnabled = activityRefreshEnabled;
    return result;
  }

  PermissionSettings._();

  factory PermissionSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'connectedTimeoutSecs',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'disconnectedTimeoutSecs',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'enableAutoApprove')
    ..pPS(4, _omitFieldNames ? '' : 'autoApproveDirectories')
    ..aOB(5, _omitFieldNames ? '' : 'activityRefreshEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettings copyWith(void Function(PermissionSettings) updates) =>
      super.copyWith((message) => updates(message as PermissionSettings))
          as PermissionSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionSettings create() => PermissionSettings._();
  @$core.override
  PermissionSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionSettings>(create);
  static PermissionSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get connectedTimeoutSecs => $_getIZ(0);
  @$pb.TagNumber(1)
  set connectedTimeoutSecs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectedTimeoutSecs() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectedTimeoutSecs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get disconnectedTimeoutSecs => $_getIZ(1);
  @$pb.TagNumber(2)
  set disconnectedTimeoutSecs($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisconnectedTimeoutSecs() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisconnectedTimeoutSecs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get enableAutoApprove => $_getBF(2);
  @$pb.TagNumber(3)
  set enableAutoApprove($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnableAutoApprove() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnableAutoApprove() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get autoApproveDirectories => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get activityRefreshEnabled => $_getBF(4);
  @$pb.TagNumber(5)
  set activityRefreshEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActivityRefreshEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivityRefreshEnabled() => $_clearField(5);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    Settings? settings,
    $core.String? scope,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    if (scope != null) result.scope = scope;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..aOS(2, _omitFieldNames ? '' : 'scope')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get scope => $_getSZ(1);
  @$pb.TagNumber(2)
  set scope($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScope() => $_has(1);
  @$pb.TagNumber(2)
  void clearScope() => $_clearField(2);
}

class ListMcpServersRequest extends $pb.GeneratedMessage {
  factory ListMcpServersRequest({
    $core.String? statusFilter,
  }) {
    final result = create();
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  ListMcpServersRequest._();

  factory ListMcpServersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMcpServersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMcpServersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'statusFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMcpServersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMcpServersRequest copyWith(
          void Function(ListMcpServersRequest) updates) =>
      super.copyWith((message) => updates(message as ListMcpServersRequest))
          as ListMcpServersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMcpServersRequest create() => ListMcpServersRequest._();
  @$core.override
  ListMcpServersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMcpServersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMcpServersRequest>(create);
  static ListMcpServersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get statusFilter => $_getSZ(0);
  @$pb.TagNumber(1)
  set statusFilter($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatusFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatusFilter() => $_clearField(1);
}

class ListMcpServersResponse extends $pb.GeneratedMessage {
  factory ListMcpServersResponse({
    $core.Iterable<McpServerInfo>? servers,
  }) {
    final result = create();
    if (servers != null) result.servers.addAll(servers);
    return result;
  }

  ListMcpServersResponse._();

  factory ListMcpServersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMcpServersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMcpServersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<McpServerInfo>(1, _omitFieldNames ? '' : 'servers',
        subBuilder: McpServerInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMcpServersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMcpServersResponse copyWith(
          void Function(ListMcpServersResponse) updates) =>
      super.copyWith((message) => updates(message as ListMcpServersResponse))
          as ListMcpServersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMcpServersResponse create() => ListMcpServersResponse._();
  @$core.override
  ListMcpServersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMcpServersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMcpServersResponse>(create);
  static ListMcpServersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<McpServerInfo> get servers => $_getList(0);
}

class McpServerInfo extends $pb.GeneratedMessage {
  factory McpServerInfo({
    $core.String? name,
    $core.String? serverType,
    $core.String? endpoint,
    McpServerStatus? status,
    $core.Iterable<$core.String>? tools,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (serverType != null) result.serverType = serverType;
    if (endpoint != null) result.endpoint = endpoint;
    if (status != null) result.status = status;
    if (tools != null) result.tools.addAll(tools);
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  McpServerInfo._();

  factory McpServerInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory McpServerInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'McpServerInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'serverType')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..aE<McpServerStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: McpServerStatus.values)
    ..pPS(5, _omitFieldNames ? '' : 'tools')
    ..aOS(6, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  McpServerInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  McpServerInfo copyWith(void Function(McpServerInfo) updates) =>
      super.copyWith((message) => updates(message as McpServerInfo))
          as McpServerInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static McpServerInfo create() => McpServerInfo._();
  @$core.override
  McpServerInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static McpServerInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<McpServerInfo>(create);
  static McpServerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverType => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerType() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);

  @$pb.TagNumber(4)
  McpServerStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(McpServerStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get tools => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get errorMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set errorMessage($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasErrorMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrorMessage() => $_clearField(6);
}

class GetPermissionsRequest extends $pb.GeneratedMessage {
  factory GetPermissionsRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  GetPermissionsRequest._();

  factory GetPermissionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPermissionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPermissionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPermissionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPermissionsRequest copyWith(
          void Function(GetPermissionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPermissionsRequest))
          as GetPermissionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPermissionsRequest create() => GetPermissionsRequest._();
  @$core.override
  GetPermissionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPermissionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPermissionsRequest>(create);
  static GetPermissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class PermissionRules extends $pb.GeneratedMessage {
  factory PermissionRules({
    $core.Iterable<PermissionRule>? rules,
    $core.Iterable<$core.String>? deniedTools,
    $core.Iterable<$core.String>? requireApproval,
  }) {
    final result = create();
    if (rules != null) result.rules.addAll(rules);
    if (deniedTools != null) result.deniedTools.addAll(deniedTools);
    if (requireApproval != null) result.requireApproval.addAll(requireApproval);
    return result;
  }

  PermissionRules._();

  factory PermissionRules.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionRules.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionRules',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<PermissionRule>(1, _omitFieldNames ? '' : 'rules',
        subBuilder: PermissionRule.create)
    ..pPS(2, _omitFieldNames ? '' : 'deniedTools')
    ..pPS(3, _omitFieldNames ? '' : 'requireApproval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRules clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRules copyWith(void Function(PermissionRules) updates) =>
      super.copyWith((message) => updates(message as PermissionRules))
          as PermissionRules;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionRules create() => PermissionRules._();
  @$core.override
  PermissionRules createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionRules getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionRules>(create);
  static PermissionRules? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PermissionRule> get rules => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get deniedTools => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get requireApproval => $_getList(2);
}

class PermissionRule extends $pb.GeneratedMessage {
  factory PermissionRule({
    $core.String? id,
    $core.String? toolPattern,
    $core.String? pathPattern,
    PermissionAction? action,
    $core.int? priority,
    $core.String? description,
    $core.String? source,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (toolPattern != null) result.toolPattern = toolPattern;
    if (pathPattern != null) result.pathPattern = pathPattern;
    if (action != null) result.action = action;
    if (priority != null) result.priority = priority;
    if (description != null) result.description = description;
    if (source != null) result.source = source;
    return result;
  }

  PermissionRule._();

  factory PermissionRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionRule',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'toolPattern')
    ..aOS(3, _omitFieldNames ? '' : 'pathPattern')
    ..aE<PermissionAction>(4, _omitFieldNames ? '' : 'action',
        enumValues: PermissionAction.values)
    ..aI(5, _omitFieldNames ? '' : 'priority', fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOS(7, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRule copyWith(void Function(PermissionRule) updates) =>
      super.copyWith((message) => updates(message as PermissionRule))
          as PermissionRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionRule create() => PermissionRule._();
  @$core.override
  PermissionRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionRule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionRule>(create);
  static PermissionRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolPattern => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolPattern($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolPattern() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolPattern() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pathPattern => $_getSZ(2);
  @$pb.TagNumber(3)
  set pathPattern($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPathPattern() => $_has(2);
  @$pb.TagNumber(3)
  void clearPathPattern() => $_clearField(3);

  @$pb.TagNumber(4)
  PermissionAction get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(PermissionAction value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get priority => $_getIZ(4);
  @$pb.TagNumber(5)
  set priority($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get source => $_getSZ(6);
  @$pb.TagNumber(7)
  set source($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
