// This is a generated file - do not edit.
//
// Generated from betcode/v1/plugin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// PluginRegisterRequest is sent by the daemon to discover plugin commands.
class PluginRegisterRequest extends $pb.GeneratedMessage {
  factory PluginRegisterRequest() => create();

  PluginRegisterRequest._();

  factory PluginRegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginRegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginRegisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginRegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginRegisterRequest copyWith(
          void Function(PluginRegisterRequest) updates) =>
      super.copyWith((message) => updates(message as PluginRegisterRequest))
          as PluginRegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginRegisterRequest create() => PluginRegisterRequest._();
  @$core.override
  PluginRegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginRegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginRegisterRequest>(create);
  static PluginRegisterRequest? _defaultInstance;
}

/// CommandDefinition describes a single command provided by a plugin.
class CommandDefinition extends $pb.GeneratedMessage {
  factory CommandDefinition({
    $core.String? name,
    $core.String? description,
    $core.String? argsSchema,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (argsSchema != null) result.argsSchema = argsSchema;
    return result;
  }

  CommandDefinition._();

  factory CommandDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommandDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommandDefinition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'argsSchema')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDefinition copyWith(void Function(CommandDefinition) updates) =>
      super.copyWith((message) => updates(message as CommandDefinition))
          as CommandDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommandDefinition create() => CommandDefinition._();
  @$core.override
  CommandDefinition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommandDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommandDefinition>(create);
  static CommandDefinition? _defaultInstance;

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
  $core.String get argsSchema => $_getSZ(2);
  @$pb.TagNumber(3)
  set argsSchema($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArgsSchema() => $_has(2);
  @$pb.TagNumber(3)
  void clearArgsSchema() => $_clearField(3);
}

/// PluginRegisterResponse contains the plugin's command definitions.
class PluginRegisterResponse extends $pb.GeneratedMessage {
  factory PluginRegisterResponse({
    $core.Iterable<CommandDefinition>? commands,
  }) {
    final result = create();
    if (commands != null) result.commands.addAll(commands);
    return result;
  }

  PluginRegisterResponse._();

  factory PluginRegisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginRegisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginRegisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<CommandDefinition>(1, _omitFieldNames ? '' : 'commands',
        subBuilder: CommandDefinition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginRegisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginRegisterResponse copyWith(
          void Function(PluginRegisterResponse) updates) =>
      super.copyWith((message) => updates(message as PluginRegisterResponse))
          as PluginRegisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginRegisterResponse create() => PluginRegisterResponse._();
  @$core.override
  PluginRegisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginRegisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginRegisterResponse>(create);
  static PluginRegisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommandDefinition> get commands => $_getList(0);
}

/// PluginExecuteRequest asks the plugin to execute a command.
class PluginExecuteRequest extends $pb.GeneratedMessage {
  factory PluginExecuteRequest({
    $core.String? command,
    $core.String? args,
  }) {
    final result = create();
    if (command != null) result.command = command;
    if (args != null) result.args = args;
    return result;
  }

  PluginExecuteRequest._();

  factory PluginExecuteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginExecuteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginExecuteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'command')
    ..aOS(2, _omitFieldNames ? '' : 'args')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginExecuteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginExecuteRequest copyWith(void Function(PluginExecuteRequest) updates) =>
      super.copyWith((message) => updates(message as PluginExecuteRequest))
          as PluginExecuteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginExecuteRequest create() => PluginExecuteRequest._();
  @$core.override
  PluginExecuteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginExecuteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginExecuteRequest>(create);
  static PluginExecuteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get command => $_getSZ(0);
  @$pb.TagNumber(1)
  set command($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get args => $_getSZ(1);
  @$pb.TagNumber(2)
  set args($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArgs() => $_has(1);
  @$pb.TagNumber(2)
  void clearArgs() => $_clearField(2);
}

enum PluginExecuteResponse_Output {
  stdoutLine,
  stderrLine,
  exitCode,
  error,
  notSet
}

/// PluginExecuteResponse streams output from a plugin command execution.
class PluginExecuteResponse extends $pb.GeneratedMessage {
  factory PluginExecuteResponse({
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

  PluginExecuteResponse._();

  factory PluginExecuteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginExecuteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PluginExecuteResponse_Output>
      _PluginExecuteResponse_OutputByTag = {
    1: PluginExecuteResponse_Output.stdoutLine,
    2: PluginExecuteResponse_Output.stderrLine,
    3: PluginExecuteResponse_Output.exitCode,
    4: PluginExecuteResponse_Output.error,
    0: PluginExecuteResponse_Output.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginExecuteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'stdoutLine')
    ..aOS(2, _omitFieldNames ? '' : 'stderrLine')
    ..aI(3, _omitFieldNames ? '' : 'exitCode')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginExecuteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginExecuteResponse copyWith(
          void Function(PluginExecuteResponse) updates) =>
      super.copyWith((message) => updates(message as PluginExecuteResponse))
          as PluginExecuteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginExecuteResponse create() => PluginExecuteResponse._();
  @$core.override
  PluginExecuteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginExecuteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginExecuteResponse>(create);
  static PluginExecuteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  PluginExecuteResponse_Output whichOutput() =>
      _PluginExecuteResponse_OutputByTag[$_whichOneof(0)]!;
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

/// PluginHealthCheckRequest is sent periodically to verify plugin health.
class PluginHealthCheckRequest extends $pb.GeneratedMessage {
  factory PluginHealthCheckRequest() => create();

  PluginHealthCheckRequest._();

  factory PluginHealthCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginHealthCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginHealthCheckRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginHealthCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginHealthCheckRequest copyWith(
          void Function(PluginHealthCheckRequest) updates) =>
      super.copyWith((message) => updates(message as PluginHealthCheckRequest))
          as PluginHealthCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginHealthCheckRequest create() => PluginHealthCheckRequest._();
  @$core.override
  PluginHealthCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginHealthCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginHealthCheckRequest>(create);
  static PluginHealthCheckRequest? _defaultInstance;
}

/// PluginHealthCheckResponse indicates plugin health status.
class PluginHealthCheckResponse extends $pb.GeneratedMessage {
  factory PluginHealthCheckResponse({
    $core.bool? status,
    $core.String? message,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (message != null) result.message = message;
    return result;
  }

  PluginHealthCheckResponse._();

  factory PluginHealthCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PluginHealthCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PluginHealthCheckResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'status')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginHealthCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PluginHealthCheckResponse copyWith(
          void Function(PluginHealthCheckResponse) updates) =>
      super.copyWith((message) => updates(message as PluginHealthCheckResponse))
          as PluginHealthCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PluginHealthCheckResponse create() => PluginHealthCheckResponse._();
  @$core.override
  PluginHealthCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PluginHealthCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PluginHealthCheckResponse>(create);
  static PluginHealthCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get status => $_getBF(0);
  @$pb.TagNumber(1)
  set status($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
