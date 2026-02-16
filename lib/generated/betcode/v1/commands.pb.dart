// This is a generated file - do not edit.
//
// Generated from betcode/v1/commands.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'commands.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'commands.pbenum.dart';

/// CommandEntry represents a single command in the registry.
class CommandEntry extends $pb.GeneratedMessage {
  factory CommandEntry({
    $core.String? name,
    $core.String? description,
    CommandCategory? category,
    ExecutionMode? executionMode,
    $core.String? source,
    $core.String? argsSchema,
    $core.String? group,
    $core.String? displayName,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (category != null) result.category = category;
    if (executionMode != null) result.executionMode = executionMode;
    if (source != null) result.source = source;
    if (argsSchema != null) result.argsSchema = argsSchema;
    if (group != null) result.group = group;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  CommandEntry._();

  factory CommandEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommandEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommandEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aE<CommandCategory>(3, _omitFieldNames ? '' : 'category',
        enumValues: CommandCategory.values)
    ..aE<ExecutionMode>(4, _omitFieldNames ? '' : 'executionMode',
        enumValues: ExecutionMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..aOS(6, _omitFieldNames ? '' : 'argsSchema')
    ..aOS(7, _omitFieldNames ? '' : 'group')
    ..aOS(8, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandEntry copyWith(void Function(CommandEntry) updates) =>
      super.copyWith((message) => updates(message as CommandEntry))
          as CommandEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommandEntry create() => CommandEntry._();
  @$core.override
  CommandEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommandEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommandEntry>(create);
  static CommandEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  CommandCategory get category => $_getN(2);
  @$pb.TagNumber(3)
  set category(CommandCategory value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  ExecutionMode get executionMode => $_getN(3);
  @$pb.TagNumber(4)
  set executionMode(ExecutionMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExecutionMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearExecutionMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get argsSchema => $_getSZ(5);
  @$pb.TagNumber(6)
  set argsSchema($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArgsSchema() => $_has(5);
  @$pb.TagNumber(6)
  void clearArgsSchema() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get group => $_getSZ(6);
  @$pb.TagNumber(7)
  set group($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get displayName => $_getSZ(7);
  @$pb.TagNumber(8)
  set displayName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDisplayName() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisplayName() => $_clearField(8);
}

/// AgentInfo describes an agent for completion purposes.
class AgentInfo extends $pb.GeneratedMessage {
  factory AgentInfo({
    $core.String? name,
    AgentKind? kind,
    CommandAgentStatus? status,
    $core.String? source,
    $core.String? sessionId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (kind != null) result.kind = kind;
    if (status != null) result.status = status;
    if (source != null) result.source = source;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  AgentInfo._();

  factory AgentInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgentInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<AgentKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: AgentKind.values)
    ..aE<CommandAgentStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: CommandAgentStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..aOS(5, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentInfo copyWith(void Function(AgentInfo) updates) =>
      super.copyWith((message) => updates(message as AgentInfo)) as AgentInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentInfo create() => AgentInfo._();
  @$core.override
  AgentInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgentInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentInfo>(create);
  static AgentInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  AgentKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(AgentKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  CommandAgentStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(CommandAgentStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionId() => $_clearField(5);
}

/// PathEntry represents a filesystem path for completion.
class PathEntry extends $pb.GeneratedMessage {
  factory PathEntry({
    $core.String? path,
    PathKind? kind,
    $fixnum.Int64? size,
    $fixnum.Int64? modifiedAt,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (kind != null) result.kind = kind;
    if (size != null) result.size = size;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    return result;
  }

  PathEntry._();

  factory PathEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PathEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PathEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aE<PathKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: PathKind.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, _omitFieldNames ? '' : 'modifiedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathEntry copyWith(void Function(PathEntry) updates) =>
      super.copyWith((message) => updates(message as PathEntry)) as PathEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathEntry create() => PathEntry._();
  @$core.override
  PathEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PathEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathEntry>(create);
  static PathEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  PathKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(PathKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get size => $_getI64(2);
  @$pb.TagNumber(3)
  set size($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get modifiedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set modifiedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModifiedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearModifiedAt() => $_clearField(4);
}

enum ServiceCommandOutput_Output {
  stdoutLine,
  stderrLine,
  exitCode,
  error,
  notSet
}

/// ServiceCommandOutput streams output from a service command execution.
class ServiceCommandOutput extends $pb.GeneratedMessage {
  factory ServiceCommandOutput({
    $core.String? stdoutLine,
    $core.String? stderrLine,
    $core.int? exitCode,
    $core.String? error,
  }) {
    final result = create();
    if (stdoutLine != null) result.stdoutLine = stdoutLine;
    if (stderrLine != null) result.stderrLine = stderrLine;
    if (exitCode != null) result.exitCode = exitCode;
    if (error != null) result.error = error;
    return result;
  }

  ServiceCommandOutput._();

  factory ServiceCommandOutput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceCommandOutput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServiceCommandOutput_Output>
      _ServiceCommandOutput_OutputByTag = {
    1: ServiceCommandOutput_Output.stdoutLine,
    2: ServiceCommandOutput_Output.stderrLine,
    3: ServiceCommandOutput_Output.exitCode,
    4: ServiceCommandOutput_Output.error,
    0: ServiceCommandOutput_Output.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceCommandOutput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'stdoutLine')
    ..aOS(2, _omitFieldNames ? '' : 'stderrLine')
    ..aI(3, _omitFieldNames ? '' : 'exitCode')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceCommandOutput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceCommandOutput copyWith(void Function(ServiceCommandOutput) updates) =>
      super.copyWith((message) => updates(message as ServiceCommandOutput))
          as ServiceCommandOutput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceCommandOutput create() => ServiceCommandOutput._();
  @$core.override
  ServiceCommandOutput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceCommandOutput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceCommandOutput>(create);
  static ServiceCommandOutput? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ServiceCommandOutput_Output whichOutput() =>
      _ServiceCommandOutput_OutputByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearOutput() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get stdoutLine => $_getSZ(0);
  @$pb.TagNumber(1)
  set stdoutLine($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStdoutLine() => $_has(0);
  @$pb.TagNumber(1)
  void clearStdoutLine() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get stderrLine => $_getSZ(1);
  @$pb.TagNumber(2)
  set stderrLine($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStderrLine() => $_has(1);
  @$pb.TagNumber(2)
  void clearStderrLine() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get exitCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set exitCode($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExitCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearExitCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
}

/// PluginInfo describes a registered plugin.
class PluginInfo extends $pb.GeneratedMessage {
  factory PluginInfo({
    $core.String? name,
    $core.String? status,
    $core.bool? enabled,
    $core.String? socketPath,
    $core.int? commandCount,
    $core.String? healthMessage,
    $core.bool? healthy,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (enabled != null) result.enabled = enabled;
    if (socketPath != null) result.socketPath = socketPath;
    if (commandCount != null) result.commandCount = commandCount;
    if (healthMessage != null) result.healthMessage = healthMessage;
    if (healthy != null) result.healthy = healthy;
    return result;
  }

  PluginInfo._();

  factory PluginInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOB(3, _omitFieldNames ? '' : 'enabled')
    ..aOS(4, _omitFieldNames ? '' : 'socketPath')
    ..aI(5, _omitFieldNames ? '' : 'commandCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'healthMessage')
    ..aOB(7, _omitFieldNames ? '' : 'healthy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginInfo copyWith(void Function(PluginInfo) updates) =>
      super.copyWith((message) => updates(message as PluginInfo)) as PluginInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginInfo create() => PluginInfo._();
  @$core.override
  PluginInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginInfo>(create);
  static PluginInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get enabled => $_getBF(2);
  @$pb.TagNumber(3)
  set enabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get socketPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set socketPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSocketPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearSocketPath() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get commandCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set commandCount($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCommandCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommandCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get healthMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set healthMessage($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHealthMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearHealthMessage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get healthy => $_getBF(6);
  @$pb.TagNumber(7)
  set healthy($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHealthy() => $_has(6);
  @$pb.TagNumber(7)
  void clearHealthy() => $_clearField(7);
}

class GetCommandRegistryRequest extends $pb.GeneratedMessage {
  factory GetCommandRegistryRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  GetCommandRegistryRequest._();

  factory GetCommandRegistryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCommandRegistryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommandRegistryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommandRegistryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommandRegistryRequest copyWith(
          void Function(GetCommandRegistryRequest) updates) =>
      super.copyWith((message) => updates(message as GetCommandRegistryRequest))
          as GetCommandRegistryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCommandRegistryRequest create() => GetCommandRegistryRequest._();
  @$core.override
  GetCommandRegistryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCommandRegistryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommandRegistryRequest>(create);
  static GetCommandRegistryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class GetCommandRegistryResponse extends $pb.GeneratedMessage {
  factory GetCommandRegistryResponse({
    $core.Iterable<CommandEntry>? commands,
  }) {
    final result = create();
    if (commands != null) result.commands.addAll(commands);
    return result;
  }

  GetCommandRegistryResponse._();

  factory GetCommandRegistryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCommandRegistryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommandRegistryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<CommandEntry>(1, _omitFieldNames ? '' : 'commands',
        subBuilder: CommandEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommandRegistryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommandRegistryResponse copyWith(
          void Function(GetCommandRegistryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCommandRegistryResponse))
          as GetCommandRegistryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCommandRegistryResponse create() => GetCommandRegistryResponse._();
  @$core.override
  GetCommandRegistryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCommandRegistryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommandRegistryResponse>(create);
  static GetCommandRegistryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommandEntry> get commands => $_getList(0);
}

class ListAgentsRequest extends $pb.GeneratedMessage {
  factory ListAgentsRequest({
    $core.String? query,
    $core.int? maxResults,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (maxResults != null) result.maxResults = maxResults;
    return result;
  }

  ListAgentsRequest._();

  factory ListAgentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAgentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAgentsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'maxResults', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentsRequest copyWith(void Function(ListAgentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAgentsRequest))
          as ListAgentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentsRequest create() => ListAgentsRequest._();
  @$core.override
  ListAgentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAgentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAgentsRequest>(create);
  static ListAgentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxResults => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxResults($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxResults() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxResults() => $_clearField(2);
}

class ListAgentsResponse extends $pb.GeneratedMessage {
  factory ListAgentsResponse({
    $core.Iterable<AgentInfo>? agents,
  }) {
    final result = create();
    if (agents != null) result.agents.addAll(agents);
    return result;
  }

  ListAgentsResponse._();

  factory ListAgentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAgentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAgentsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<AgentInfo>(1, _omitFieldNames ? '' : 'agents',
        subBuilder: AgentInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentsResponse copyWith(void Function(ListAgentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAgentsResponse))
          as ListAgentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentsResponse create() => ListAgentsResponse._();
  @$core.override
  ListAgentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAgentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAgentsResponse>(create);
  static ListAgentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AgentInfo> get agents => $_getList(0);
}

class ListPathRequest extends $pb.GeneratedMessage {
  factory ListPathRequest({
    $core.String? query,
    $core.int? maxResults,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (maxResults != null) result.maxResults = maxResults;
    return result;
  }

  ListPathRequest._();

  factory ListPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'maxResults', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPathRequest copyWith(void Function(ListPathRequest) updates) =>
      super.copyWith((message) => updates(message as ListPathRequest))
          as ListPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPathRequest create() => ListPathRequest._();
  @$core.override
  ListPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPathRequest>(create);
  static ListPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxResults => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxResults($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxResults() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxResults() => $_clearField(2);
}

class ListPathResponse extends $pb.GeneratedMessage {
  factory ListPathResponse({
    $core.Iterable<PathEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListPathResponse._();

  factory ListPathResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPathResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPathResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<PathEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: PathEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPathResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPathResponse copyWith(void Function(ListPathResponse) updates) =>
      super.copyWith((message) => updates(message as ListPathResponse))
          as ListPathResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPathResponse create() => ListPathResponse._();
  @$core.override
  ListPathResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPathResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPathResponse>(create);
  static ListPathResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PathEntry> get entries => $_getList(0);
}

class ExecuteServiceCommandRequest extends $pb.GeneratedMessage {
  factory ExecuteServiceCommandRequest({
    $core.String? command,
    $core.Iterable<$core.String>? args,
    $core.String? sessionId,
  }) {
    final result = create();
    if (command != null) result.command = command;
    if (args != null) result.args.addAll(args);
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ExecuteServiceCommandRequest._();

  factory ExecuteServiceCommandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecuteServiceCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteServiceCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'command')
    ..pPS(2, _omitFieldNames ? '' : 'args')
    ..aOS(3, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteServiceCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteServiceCommandRequest copyWith(
          void Function(ExecuteServiceCommandRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteServiceCommandRequest))
          as ExecuteServiceCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteServiceCommandRequest create() =>
      ExecuteServiceCommandRequest._();
  @$core.override
  ExecuteServiceCommandRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecuteServiceCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteServiceCommandRequest>(create);
  static ExecuteServiceCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get command => $_getSZ(0);
  @$pb.TagNumber(1)
  set command($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get args => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => $_clearField(3);
}

class ListPluginsRequest extends $pb.GeneratedMessage {
  factory ListPluginsRequest() => create();

  ListPluginsRequest._();

  factory ListPluginsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPluginsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPluginsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPluginsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPluginsRequest copyWith(void Function(ListPluginsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPluginsRequest))
          as ListPluginsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPluginsRequest create() => ListPluginsRequest._();
  @$core.override
  ListPluginsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPluginsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPluginsRequest>(create);
  static ListPluginsRequest? _defaultInstance;
}

class ListPluginsResponse extends $pb.GeneratedMessage {
  factory ListPluginsResponse({
    $core.Iterable<PluginInfo>? plugins,
  }) {
    final result = create();
    if (plugins != null) result.plugins.addAll(plugins);
    return result;
  }

  ListPluginsResponse._();

  factory ListPluginsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPluginsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPluginsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<PluginInfo>(1, _omitFieldNames ? '' : 'plugins',
        subBuilder: PluginInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPluginsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPluginsResponse copyWith(void Function(ListPluginsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPluginsResponse))
          as ListPluginsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPluginsResponse create() => ListPluginsResponse._();
  @$core.override
  ListPluginsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPluginsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPluginsResponse>(create);
  static ListPluginsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PluginInfo> get plugins => $_getList(0);
}

class GetPluginStatusRequest extends $pb.GeneratedMessage {
  factory GetPluginStatusRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  GetPluginStatusRequest._();

  factory GetPluginStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPluginStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPluginStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPluginStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPluginStatusRequest copyWith(
          void Function(GetPluginStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetPluginStatusRequest))
          as GetPluginStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPluginStatusRequest create() => GetPluginStatusRequest._();
  @$core.override
  GetPluginStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPluginStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPluginStatusRequest>(create);
  static GetPluginStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class GetPluginStatusResponse extends $pb.GeneratedMessage {
  factory GetPluginStatusResponse({
    PluginInfo? plugin,
  }) {
    final result = create();
    if (plugin != null) result.plugin = plugin;
    return result;
  }

  GetPluginStatusResponse._();

  factory GetPluginStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPluginStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPluginStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<PluginInfo>(1, _omitFieldNames ? '' : 'plugin',
        subBuilder: PluginInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPluginStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPluginStatusResponse copyWith(
          void Function(GetPluginStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetPluginStatusResponse))
          as GetPluginStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPluginStatusResponse create() => GetPluginStatusResponse._();
  @$core.override
  GetPluginStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPluginStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPluginStatusResponse>(create);
  static GetPluginStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PluginInfo get plugin => $_getN(0);
  @$pb.TagNumber(1)
  set plugin(PluginInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlugin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlugin() => $_clearField(1);
  @$pb.TagNumber(1)
  PluginInfo ensurePlugin() => $_ensure(0);
}

class AddPluginRequest extends $pb.GeneratedMessage {
  factory AddPluginRequest({
    $core.String? name,
    $core.String? socketPath,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (socketPath != null) result.socketPath = socketPath;
    return result;
  }

  AddPluginRequest._();

  factory AddPluginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddPluginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddPluginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'socketPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPluginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPluginRequest copyWith(void Function(AddPluginRequest) updates) =>
      super.copyWith((message) => updates(message as AddPluginRequest))
          as AddPluginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddPluginRequest create() => AddPluginRequest._();
  @$core.override
  AddPluginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddPluginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddPluginRequest>(create);
  static AddPluginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get socketPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set socketPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSocketPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketPath() => $_clearField(2);
}

class AddPluginResponse extends $pb.GeneratedMessage {
  factory AddPluginResponse({
    PluginInfo? plugin,
  }) {
    final result = create();
    if (plugin != null) result.plugin = plugin;
    return result;
  }

  AddPluginResponse._();

  factory AddPluginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddPluginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddPluginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<PluginInfo>(1, _omitFieldNames ? '' : 'plugin',
        subBuilder: PluginInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPluginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPluginResponse copyWith(void Function(AddPluginResponse) updates) =>
      super.copyWith((message) => updates(message as AddPluginResponse))
          as AddPluginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddPluginResponse create() => AddPluginResponse._();
  @$core.override
  AddPluginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddPluginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddPluginResponse>(create);
  static AddPluginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PluginInfo get plugin => $_getN(0);
  @$pb.TagNumber(1)
  set plugin(PluginInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlugin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlugin() => $_clearField(1);
  @$pb.TagNumber(1)
  PluginInfo ensurePlugin() => $_ensure(0);
}

class RemovePluginRequest extends $pb.GeneratedMessage {
  factory RemovePluginRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  RemovePluginRequest._();

  factory RemovePluginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemovePluginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemovePluginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePluginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePluginRequest copyWith(void Function(RemovePluginRequest) updates) =>
      super.copyWith((message) => updates(message as RemovePluginRequest))
          as RemovePluginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemovePluginRequest create() => RemovePluginRequest._();
  @$core.override
  RemovePluginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemovePluginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemovePluginRequest>(create);
  static RemovePluginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class RemovePluginResponse extends $pb.GeneratedMessage {
  factory RemovePluginResponse({
    $core.bool? removed,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    return result;
  }

  RemovePluginResponse._();

  factory RemovePluginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemovePluginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemovePluginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'removed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePluginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePluginResponse copyWith(void Function(RemovePluginResponse) updates) =>
      super.copyWith((message) => updates(message as RemovePluginResponse))
          as RemovePluginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemovePluginResponse create() => RemovePluginResponse._();
  @$core.override
  RemovePluginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemovePluginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemovePluginResponse>(create);
  static RemovePluginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get removed => $_getBF(0);
  @$pb.TagNumber(1)
  set removed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);
}

class EnablePluginRequest extends $pb.GeneratedMessage {
  factory EnablePluginRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  EnablePluginRequest._();

  factory EnablePluginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnablePluginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnablePluginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnablePluginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnablePluginRequest copyWith(void Function(EnablePluginRequest) updates) =>
      super.copyWith((message) => updates(message as EnablePluginRequest))
          as EnablePluginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnablePluginRequest create() => EnablePluginRequest._();
  @$core.override
  EnablePluginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnablePluginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnablePluginRequest>(create);
  static EnablePluginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class EnablePluginResponse extends $pb.GeneratedMessage {
  factory EnablePluginResponse({
    PluginInfo? plugin,
  }) {
    final result = create();
    if (plugin != null) result.plugin = plugin;
    return result;
  }

  EnablePluginResponse._();

  factory EnablePluginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnablePluginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnablePluginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<PluginInfo>(1, _omitFieldNames ? '' : 'plugin',
        subBuilder: PluginInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnablePluginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnablePluginResponse copyWith(void Function(EnablePluginResponse) updates) =>
      super.copyWith((message) => updates(message as EnablePluginResponse))
          as EnablePluginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnablePluginResponse create() => EnablePluginResponse._();
  @$core.override
  EnablePluginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnablePluginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnablePluginResponse>(create);
  static EnablePluginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PluginInfo get plugin => $_getN(0);
  @$pb.TagNumber(1)
  set plugin(PluginInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlugin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlugin() => $_clearField(1);
  @$pb.TagNumber(1)
  PluginInfo ensurePlugin() => $_ensure(0);
}

class DisablePluginRequest extends $pb.GeneratedMessage {
  factory DisablePluginRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  DisablePluginRequest._();

  factory DisablePluginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisablePluginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisablePluginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisablePluginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisablePluginRequest copyWith(void Function(DisablePluginRequest) updates) =>
      super.copyWith((message) => updates(message as DisablePluginRequest))
          as DisablePluginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisablePluginRequest create() => DisablePluginRequest._();
  @$core.override
  DisablePluginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisablePluginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisablePluginRequest>(create);
  static DisablePluginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class DisablePluginResponse extends $pb.GeneratedMessage {
  factory DisablePluginResponse({
    PluginInfo? plugin,
  }) {
    final result = create();
    if (plugin != null) result.plugin = plugin;
    return result;
  }

  DisablePluginResponse._();

  factory DisablePluginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisablePluginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisablePluginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<PluginInfo>(1, _omitFieldNames ? '' : 'plugin',
        subBuilder: PluginInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisablePluginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisablePluginResponse copyWith(
          void Function(DisablePluginResponse) updates) =>
      super.copyWith((message) => updates(message as DisablePluginResponse))
          as DisablePluginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisablePluginResponse create() => DisablePluginResponse._();
  @$core.override
  DisablePluginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisablePluginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisablePluginResponse>(create);
  static DisablePluginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PluginInfo get plugin => $_getN(0);
  @$pb.TagNumber(1)
  set plugin(PluginInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlugin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlugin() => $_clearField(1);
  @$pb.TagNumber(1)
  PluginInfo ensurePlugin() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
