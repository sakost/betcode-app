// This is a generated file - do not edit.
//
// Generated from betcode/v1/subagent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'subagent.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'subagent.pbenum.dart';

/// SpawnSubagentRequest spawns a new Claude subprocess as a subagent.
class SpawnSubagentRequest extends $pb.GeneratedMessage {
  factory SpawnSubagentRequest({
    $core.String? parentSessionId,
    $core.String? prompt,
    $core.String? model,
    $core.String? workingDirectory,
    $core.Iterable<$core.String>? allowedTools,
    $core.int? maxTurns,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? env,
    $core.String? name,
    $core.bool? autoApprove,
  }) {
    final result = create();
    if (parentSessionId != null) result.parentSessionId = parentSessionId;
    if (prompt != null) result.prompt = prompt;
    if (model != null) result.model = model;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (allowedTools != null) result.allowedTools.addAll(allowedTools);
    if (maxTurns != null) result.maxTurns = maxTurns;
    if (env != null) result.env.addEntries(env);
    if (name != null) result.name = name;
    if (autoApprove != null) result.autoApprove = autoApprove;
    return result;
  }

  SpawnSubagentRequest._();

  factory SpawnSubagentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpawnSubagentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpawnSubagentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'model')
    ..aOS(4, _omitFieldNames ? '' : 'workingDirectory')
    ..pPS(5, _omitFieldNames ? '' : 'allowedTools')
    ..aI(6, _omitFieldNames ? '' : 'maxTurns')
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'env',
        entryClassName: 'SpawnSubagentRequest.EnvEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..aOS(8, _omitFieldNames ? '' : 'name')
    ..aOB(9, _omitFieldNames ? '' : 'autoApprove')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubagentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubagentRequest copyWith(void Function(SpawnSubagentRequest) updates) =>
      super.copyWith((message) => updates(message as SpawnSubagentRequest))
          as SpawnSubagentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpawnSubagentRequest create() => SpawnSubagentRequest._();
  @$core.override
  SpawnSubagentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpawnSubagentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpawnSubagentRequest>(create);
  static SpawnSubagentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get model => $_getSZ(2);
  @$pb.TagNumber(3)
  set model($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workingDirectory => $_getSZ(3);
  @$pb.TagNumber(4)
  set workingDirectory($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkingDirectory() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkingDirectory() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get allowedTools => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get maxTurns => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxTurns($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxTurns() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxTurns() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get env => $_getMap(6);

  @$pb.TagNumber(8)
  $core.String get name => $_getSZ(7);
  @$pb.TagNumber(8)
  set name($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasName() => $_has(7);
  @$pb.TagNumber(8)
  void clearName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get autoApprove => $_getBF(8);
  @$pb.TagNumber(9)
  set autoApprove($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAutoApprove() => $_has(8);
  @$pb.TagNumber(9)
  void clearAutoApprove() => $_clearField(9);
}

/// SpawnSubagentResponse returns the IDs of the spawned subagent.
class SpawnSubagentResponse extends $pb.GeneratedMessage {
  factory SpawnSubagentResponse({
    $core.String? subagentId,
    $core.String? sessionId,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  SpawnSubagentResponse._();

  factory SpawnSubagentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpawnSubagentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpawnSubagentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubagentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubagentResponse copyWith(
          void Function(SpawnSubagentResponse) updates) =>
      super.copyWith((message) => updates(message as SpawnSubagentResponse))
          as SpawnSubagentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpawnSubagentResponse create() => SpawnSubagentResponse._();
  @$core.override
  SpawnSubagentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpawnSubagentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpawnSubagentResponse>(create);
  static SpawnSubagentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

/// WatchSubagentRequest subscribes to a subagent's event stream.
class WatchSubagentRequest extends $pb.GeneratedMessage {
  factory WatchSubagentRequest({
    $core.String? subagentId,
    $fixnum.Int64? fromSequence,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (fromSequence != null) result.fromSequence = fromSequence;
    return result;
  }

  WatchSubagentRequest._();

  factory WatchSubagentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchSubagentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchSubagentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'fromSequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSubagentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSubagentRequest copyWith(void Function(WatchSubagentRequest) updates) =>
      super.copyWith((message) => updates(message as WatchSubagentRequest))
          as WatchSubagentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSubagentRequest create() => WatchSubagentRequest._();
  @$core.override
  WatchSubagentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchSubagentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchSubagentRequest>(create);
  static WatchSubagentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set fromSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromSequence() => $_clearField(2);
}

/// SendToSubagentRequest sends input to a running subagent.
class SendToSubagentRequest extends $pb.GeneratedMessage {
  factory SendToSubagentRequest({
    $core.String? subagentId,
    $core.String? content,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (content != null) result.content = content;
    return result;
  }

  SendToSubagentRequest._();

  factory SendToSubagentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendToSubagentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendToSubagentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendToSubagentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendToSubagentRequest copyWith(
          void Function(SendToSubagentRequest) updates) =>
      super.copyWith((message) => updates(message as SendToSubagentRequest))
          as SendToSubagentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendToSubagentRequest create() => SendToSubagentRequest._();
  @$core.override
  SendToSubagentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendToSubagentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendToSubagentRequest>(create);
  static SendToSubagentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

/// SendToSubagentResponse acknowledges input delivery.
class SendToSubagentResponse extends $pb.GeneratedMessage {
  factory SendToSubagentResponse({
    $core.bool? delivered,
  }) {
    final result = create();
    if (delivered != null) result.delivered = delivered;
    return result;
  }

  SendToSubagentResponse._();

  factory SendToSubagentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendToSubagentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendToSubagentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'delivered')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendToSubagentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendToSubagentResponse copyWith(
          void Function(SendToSubagentResponse) updates) =>
      super.copyWith((message) => updates(message as SendToSubagentResponse))
          as SendToSubagentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendToSubagentResponse create() => SendToSubagentResponse._();
  @$core.override
  SendToSubagentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendToSubagentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendToSubagentResponse>(create);
  static SendToSubagentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get delivered => $_getBF(0);
  @$pb.TagNumber(1)
  set delivered($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDelivered() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelivered() => $_clearField(1);
}

/// CancelSubagentRequest cancels a running subagent.
class CancelSubagentRequest extends $pb.GeneratedMessage {
  factory CancelSubagentRequest({
    $core.String? subagentId,
    $core.String? reason,
    $core.bool? force,
    $core.bool? cleanupWorktree,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (reason != null) result.reason = reason;
    if (force != null) result.force = force;
    if (cleanupWorktree != null) result.cleanupWorktree = cleanupWorktree;
    return result;
  }

  CancelSubagentRequest._();

  factory CancelSubagentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSubagentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSubagentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOB(3, _omitFieldNames ? '' : 'force')
    ..aOB(4, _omitFieldNames ? '' : 'cleanupWorktree')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubagentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubagentRequest copyWith(
          void Function(CancelSubagentRequest) updates) =>
      super.copyWith((message) => updates(message as CancelSubagentRequest))
          as CancelSubagentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSubagentRequest create() => CancelSubagentRequest._();
  @$core.override
  CancelSubagentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSubagentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSubagentRequest>(create);
  static CancelSubagentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get force => $_getBF(2);
  @$pb.TagNumber(3)
  set force($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForce() => $_has(2);
  @$pb.TagNumber(3)
  void clearForce() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get cleanupWorktree => $_getBF(3);
  @$pb.TagNumber(4)
  set cleanupWorktree($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCleanupWorktree() => $_has(3);
  @$pb.TagNumber(4)
  void clearCleanupWorktree() => $_clearField(4);
}

/// CancelSubagentResponse returns the result of cancellation.
class CancelSubagentResponse extends $pb.GeneratedMessage {
  factory CancelSubagentResponse({
    $core.bool? cancelled,
    $core.String? finalStatus,
    $core.int? toolCallsExecuted,
    $core.int? toolCallsAutoApproved,
  }) {
    final result = create();
    if (cancelled != null) result.cancelled = cancelled;
    if (finalStatus != null) result.finalStatus = finalStatus;
    if (toolCallsExecuted != null) result.toolCallsExecuted = toolCallsExecuted;
    if (toolCallsAutoApproved != null)
      result.toolCallsAutoApproved = toolCallsAutoApproved;
    return result;
  }

  CancelSubagentResponse._();

  factory CancelSubagentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSubagentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSubagentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'cancelled')
    ..aOS(2, _omitFieldNames ? '' : 'finalStatus')
    ..aI(3, _omitFieldNames ? '' : 'toolCallsExecuted')
    ..aI(4, _omitFieldNames ? '' : 'toolCallsAutoApproved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubagentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubagentResponse copyWith(
          void Function(CancelSubagentResponse) updates) =>
      super.copyWith((message) => updates(message as CancelSubagentResponse))
          as CancelSubagentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSubagentResponse create() => CancelSubagentResponse._();
  @$core.override
  CancelSubagentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSubagentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSubagentResponse>(create);
  static CancelSubagentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get cancelled => $_getBF(0);
  @$pb.TagNumber(1)
  set cancelled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCancelled() => $_has(0);
  @$pb.TagNumber(1)
  void clearCancelled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get finalStatus => $_getSZ(1);
  @$pb.TagNumber(2)
  set finalStatus($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFinalStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearFinalStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get toolCallsExecuted => $_getIZ(2);
  @$pb.TagNumber(3)
  set toolCallsExecuted($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallsExecuted() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallsExecuted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get toolCallsAutoApproved => $_getIZ(3);
  @$pb.TagNumber(4)
  set toolCallsAutoApproved($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolCallsAutoApproved() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolCallsAutoApproved() => $_clearField(4);
}

/// ListSubagentsRequest lists subagents under a parent session.
class ListSubagentsRequest extends $pb.GeneratedMessage {
  factory ListSubagentsRequest({
    $core.String? parentSessionId,
    $core.String? statusFilter,
  }) {
    final result = create();
    if (parentSessionId != null) result.parentSessionId = parentSessionId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  ListSubagentsRequest._();

  factory ListSubagentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSubagentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubagentsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'statusFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubagentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubagentsRequest copyWith(void Function(ListSubagentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSubagentsRequest))
          as ListSubagentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSubagentsRequest create() => ListSubagentsRequest._();
  @$core.override
  ListSubagentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSubagentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubagentsRequest>(create);
  static ListSubagentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get statusFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set statusFilter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);
}

/// ListSubagentsResponse returns matching subagents.
class ListSubagentsResponse extends $pb.GeneratedMessage {
  factory ListSubagentsResponse({
    $core.Iterable<SubagentInfo>? subagents,
  }) {
    final result = create();
    if (subagents != null) result.subagents.addAll(subagents);
    return result;
  }

  ListSubagentsResponse._();

  factory ListSubagentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSubagentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubagentsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<SubagentInfo>(1, _omitFieldNames ? '' : 'subagents',
        subBuilder: SubagentInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubagentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubagentsResponse copyWith(
          void Function(ListSubagentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSubagentsResponse))
          as ListSubagentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSubagentsResponse create() => ListSubagentsResponse._();
  @$core.override
  ListSubagentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSubagentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubagentsResponse>(create);
  static ListSubagentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SubagentInfo> get subagents => $_getList(0);
}

/// SubagentInfo describes a subagent's current state.
class SubagentInfo extends $pb.GeneratedMessage {
  factory SubagentInfo({
    $core.String? id,
    $core.String? parentSessionId,
    $core.String? sessionId,
    $core.String? name,
    $core.String? prompt,
    $core.String? model,
    $core.String? workingDirectory,
    SubagentStatus? status,
    $core.bool? autoApprove,
    $core.int? maxTurns,
    $core.Iterable<$core.String>? allowedTools,
    $core.String? resultSummary,
    $1.Timestamp? createdAt,
    $1.Timestamp? completedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parentSessionId != null) result.parentSessionId = parentSessionId;
    if (sessionId != null) result.sessionId = sessionId;
    if (name != null) result.name = name;
    if (prompt != null) result.prompt = prompt;
    if (model != null) result.model = model;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (status != null) result.status = status;
    if (autoApprove != null) result.autoApprove = autoApprove;
    if (maxTurns != null) result.maxTurns = maxTurns;
    if (allowedTools != null) result.allowedTools.addAll(allowedTools);
    if (resultSummary != null) result.resultSummary = resultSummary;
    if (createdAt != null) result.createdAt = createdAt;
    if (completedAt != null) result.completedAt = completedAt;
    return result;
  }

  SubagentInfo._();

  factory SubagentInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'parentSessionId')
    ..aOS(3, _omitFieldNames ? '' : 'sessionId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'prompt')
    ..aOS(6, _omitFieldNames ? '' : 'model')
    ..aOS(7, _omitFieldNames ? '' : 'workingDirectory')
    ..aE<SubagentStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: SubagentStatus.values)
    ..aOB(9, _omitFieldNames ? '' : 'autoApprove')
    ..aI(10, _omitFieldNames ? '' : 'maxTurns')
    ..pPS(11, _omitFieldNames ? '' : 'allowedTools')
    ..aOS(12, _omitFieldNames ? '' : 'resultSummary')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentInfo copyWith(void Function(SubagentInfo) updates) =>
      super.copyWith((message) => updates(message as SubagentInfo))
          as SubagentInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentInfo create() => SubagentInfo._();
  @$core.override
  SubagentInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentInfo>(create);
  static SubagentInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentSessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentSessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get prompt => $_getSZ(4);
  @$pb.TagNumber(5)
  set prompt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrompt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrompt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get model => $_getSZ(5);
  @$pb.TagNumber(6)
  set model($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearModel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get workingDirectory => $_getSZ(6);
  @$pb.TagNumber(7)
  set workingDirectory($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkingDirectory() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkingDirectory() => $_clearField(7);

  @$pb.TagNumber(8)
  SubagentStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(SubagentStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get autoApprove => $_getBF(8);
  @$pb.TagNumber(9)
  set autoApprove($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAutoApprove() => $_has(8);
  @$pb.TagNumber(9)
  void clearAutoApprove() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get maxTurns => $_getIZ(9);
  @$pb.TagNumber(10)
  set maxTurns($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMaxTurns() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxTurns() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get allowedTools => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get resultSummary => $_getSZ(11);
  @$pb.TagNumber(12)
  set resultSummary($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasResultSummary() => $_has(11);
  @$pb.TagNumber(12)
  void clearResultSummary() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $1.Timestamp get completedAt => $_getN(13);
  @$pb.TagNumber(14)
  set completedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCompletedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCompletedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureCompletedAt() => $_ensure(13);
}

enum SubagentEvent_Event {
  started,
  output,
  toolUse,
  permissionRequest,
  completed,
  failed,
  cancelled,
  notSet
}

/// SubagentEvent wraps all subagent-to-client event types.
class SubagentEvent extends $pb.GeneratedMessage {
  factory SubagentEvent({
    $core.String? subagentId,
    $1.Timestamp? timestamp,
    SubagentStarted? started,
    SubagentOutput? output,
    SubagentToolUse? toolUse,
    SubagentPermissionRequest? permissionRequest,
    SubagentCompleted? completed,
    SubagentFailed? failed,
    SubagentCancelled? cancelled,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (timestamp != null) result.timestamp = timestamp;
    if (started != null) result.started = started;
    if (output != null) result.output = output;
    if (toolUse != null) result.toolUse = toolUse;
    if (permissionRequest != null) result.permissionRequest = permissionRequest;
    if (completed != null) result.completed = completed;
    if (failed != null) result.failed = failed;
    if (cancelled != null) result.cancelled = cancelled;
    return result;
  }

  SubagentEvent._();

  factory SubagentEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SubagentEvent_Event>
      _SubagentEvent_EventByTag = {
    3: SubagentEvent_Event.started,
    4: SubagentEvent_Event.output,
    5: SubagentEvent_Event.toolUse,
    6: SubagentEvent_Event.permissionRequest,
    7: SubagentEvent_Event.completed,
    8: SubagentEvent_Event.failed,
    9: SubagentEvent_Event.cancelled,
    0: SubagentEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9])
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aOM<SubagentStarted>(3, _omitFieldNames ? '' : 'started',
        subBuilder: SubagentStarted.create)
    ..aOM<SubagentOutput>(4, _omitFieldNames ? '' : 'output',
        subBuilder: SubagentOutput.create)
    ..aOM<SubagentToolUse>(5, _omitFieldNames ? '' : 'toolUse',
        subBuilder: SubagentToolUse.create)
    ..aOM<SubagentPermissionRequest>(
        6, _omitFieldNames ? '' : 'permissionRequest',
        subBuilder: SubagentPermissionRequest.create)
    ..aOM<SubagentCompleted>(7, _omitFieldNames ? '' : 'completed',
        subBuilder: SubagentCompleted.create)
    ..aOM<SubagentFailed>(8, _omitFieldNames ? '' : 'failed',
        subBuilder: SubagentFailed.create)
    ..aOM<SubagentCancelled>(9, _omitFieldNames ? '' : 'cancelled',
        subBuilder: SubagentCancelled.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentEvent copyWith(void Function(SubagentEvent) updates) =>
      super.copyWith((message) => updates(message as SubagentEvent))
          as SubagentEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentEvent create() => SubagentEvent._();
  @$core.override
  SubagentEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentEvent>(create);
  static SubagentEvent? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  SubagentEvent_Event whichEvent() =>
      _SubagentEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  SubagentStarted get started => $_getN(2);
  @$pb.TagNumber(3)
  set started(SubagentStarted value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStarted() => $_has(2);
  @$pb.TagNumber(3)
  void clearStarted() => $_clearField(3);
  @$pb.TagNumber(3)
  SubagentStarted ensureStarted() => $_ensure(2);

  @$pb.TagNumber(4)
  SubagentOutput get output => $_getN(3);
  @$pb.TagNumber(4)
  set output(SubagentOutput value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOutput() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutput() => $_clearField(4);
  @$pb.TagNumber(4)
  SubagentOutput ensureOutput() => $_ensure(3);

  @$pb.TagNumber(5)
  SubagentToolUse get toolUse => $_getN(4);
  @$pb.TagNumber(5)
  set toolUse(SubagentToolUse value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasToolUse() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolUse() => $_clearField(5);
  @$pb.TagNumber(5)
  SubagentToolUse ensureToolUse() => $_ensure(4);

  @$pb.TagNumber(6)
  SubagentPermissionRequest get permissionRequest => $_getN(5);
  @$pb.TagNumber(6)
  set permissionRequest(SubagentPermissionRequest value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPermissionRequest() => $_has(5);
  @$pb.TagNumber(6)
  void clearPermissionRequest() => $_clearField(6);
  @$pb.TagNumber(6)
  SubagentPermissionRequest ensurePermissionRequest() => $_ensure(5);

  @$pb.TagNumber(7)
  SubagentCompleted get completed => $_getN(6);
  @$pb.TagNumber(7)
  set completed(SubagentCompleted value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCompleted() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompleted() => $_clearField(7);
  @$pb.TagNumber(7)
  SubagentCompleted ensureCompleted() => $_ensure(6);

  @$pb.TagNumber(8)
  SubagentFailed get failed => $_getN(7);
  @$pb.TagNumber(8)
  set failed(SubagentFailed value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFailed() => $_has(7);
  @$pb.TagNumber(8)
  void clearFailed() => $_clearField(8);
  @$pb.TagNumber(8)
  SubagentFailed ensureFailed() => $_ensure(7);

  @$pb.TagNumber(9)
  SubagentCancelled get cancelled => $_getN(8);
  @$pb.TagNumber(9)
  set cancelled(SubagentCancelled value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCancelled() => $_has(8);
  @$pb.TagNumber(9)
  void clearCancelled() => $_clearField(9);
  @$pb.TagNumber(9)
  SubagentCancelled ensureCancelled() => $_ensure(8);
}

/// SubagentStarted indicates the subagent process has started.
class SubagentStarted extends $pb.GeneratedMessage {
  factory SubagentStarted({
    $core.String? sessionId,
    $core.String? model,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (model != null) result.model = model;
    return result;
  }

  SubagentStarted._();

  factory SubagentStarted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentStarted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentStarted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentStarted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentStarted copyWith(void Function(SubagentStarted) updates) =>
      super.copyWith((message) => updates(message as SubagentStarted))
          as SubagentStarted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentStarted create() => SubagentStarted._();
  @$core.override
  SubagentStarted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentStarted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentStarted>(create);
  static SubagentStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get model => $_getSZ(1);
  @$pb.TagNumber(2)
  set model($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);
}

/// SubagentOutput streams incremental text output from the subagent.
class SubagentOutput extends $pb.GeneratedMessage {
  factory SubagentOutput({
    $core.String? text,
    $core.bool? isComplete,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (isComplete != null) result.isComplete = isComplete;
    return result;
  }

  SubagentOutput._();

  factory SubagentOutput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentOutput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentOutput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOB(2, _omitFieldNames ? '' : 'isComplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentOutput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentOutput copyWith(void Function(SubagentOutput) updates) =>
      super.copyWith((message) => updates(message as SubagentOutput))
          as SubagentOutput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentOutput create() => SubagentOutput._();
  @$core.override
  SubagentOutput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentOutput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentOutput>(create);
  static SubagentOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isComplete => $_getBF(1);
  @$pb.TagNumber(2)
  set isComplete($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsComplete() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsComplete() => $_clearField(2);
}

/// SubagentToolUse indicates the subagent is invoking a tool.
class SubagentToolUse extends $pb.GeneratedMessage {
  factory SubagentToolUse({
    $core.String? toolId,
    $core.String? toolName,
    $core.String? description,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (toolName != null) result.toolName = toolName;
    if (description != null) result.description = description;
    return result;
  }

  SubagentToolUse._();

  factory SubagentToolUse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentToolUse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentToolUse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentToolUse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentToolUse copyWith(void Function(SubagentToolUse) updates) =>
      super.copyWith((message) => updates(message as SubagentToolUse))
          as SubagentToolUse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentToolUse create() => SubagentToolUse._();
  @$core.override
  SubagentToolUse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentToolUse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentToolUse>(create);
  static SubagentToolUse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

/// SubagentPermissionRequest forwards a permission request from the subagent.
class SubagentPermissionRequest extends $pb.GeneratedMessage {
  factory SubagentPermissionRequest({
    $core.String? requestId,
    $core.String? toolName,
    $core.String? description,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (toolName != null) result.toolName = toolName;
    if (description != null) result.description = description;
    return result;
  }

  SubagentPermissionRequest._();

  factory SubagentPermissionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentPermissionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentPermissionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentPermissionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentPermissionRequest copyWith(
          void Function(SubagentPermissionRequest) updates) =>
      super.copyWith((message) => updates(message as SubagentPermissionRequest))
          as SubagentPermissionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentPermissionRequest create() => SubagentPermissionRequest._();
  @$core.override
  SubagentPermissionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentPermissionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentPermissionRequest>(create);
  static SubagentPermissionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

/// SubagentCompleted indicates the subagent finished successfully.
class SubagentCompleted extends $pb.GeneratedMessage {
  factory SubagentCompleted({
    $core.int? exitCode,
    $core.String? resultSummary,
  }) {
    final result = create();
    if (exitCode != null) result.exitCode = exitCode;
    if (resultSummary != null) result.resultSummary = resultSummary;
    return result;
  }

  SubagentCompleted._();

  factory SubagentCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'exitCode')
    ..aOS(2, _omitFieldNames ? '' : 'resultSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentCompleted copyWith(void Function(SubagentCompleted) updates) =>
      super.copyWith((message) => updates(message as SubagentCompleted))
          as SubagentCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentCompleted create() => SubagentCompleted._();
  @$core.override
  SubagentCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentCompleted>(create);
  static SubagentCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get exitCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set exitCode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExitCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearExitCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resultSummary => $_getSZ(1);
  @$pb.TagNumber(2)
  set resultSummary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResultSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultSummary() => $_clearField(2);
}

/// SubagentFailed indicates the subagent exited with an error.
class SubagentFailed extends $pb.GeneratedMessage {
  factory SubagentFailed({
    $core.int? exitCode,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (exitCode != null) result.exitCode = exitCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  SubagentFailed._();

  factory SubagentFailed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentFailed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentFailed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'exitCode')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentFailed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentFailed copyWith(void Function(SubagentFailed) updates) =>
      super.copyWith((message) => updates(message as SubagentFailed))
          as SubagentFailed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentFailed create() => SubagentFailed._();
  @$core.override
  SubagentFailed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentFailed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentFailed>(create);
  static SubagentFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get exitCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set exitCode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExitCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearExitCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

/// SubagentCancelled indicates the subagent was cancelled.
class SubagentCancelled extends $pb.GeneratedMessage {
  factory SubagentCancelled({
    $core.String? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  SubagentCancelled._();

  factory SubagentCancelled.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentCancelled.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentCancelled',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentCancelled clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentCancelled copyWith(void Function(SubagentCancelled) updates) =>
      super.copyWith((message) => updates(message as SubagentCancelled))
          as SubagentCancelled;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentCancelled create() => SubagentCancelled._();
  @$core.override
  SubagentCancelled createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentCancelled getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentCancelled>(create);
  static SubagentCancelled? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

/// RevokeAutoApproveRequest revokes auto-approve on a running subagent.
class RevokeAutoApproveRequest extends $pb.GeneratedMessage {
  factory RevokeAutoApproveRequest({
    $core.String? subagentId,
    $core.String? reason,
    $core.bool? terminateIfPending,
  }) {
    final result = create();
    if (subagentId != null) result.subagentId = subagentId;
    if (reason != null) result.reason = reason;
    if (terminateIfPending != null)
      result.terminateIfPending = terminateIfPending;
    return result;
  }

  RevokeAutoApproveRequest._();

  factory RevokeAutoApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevokeAutoApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeAutoApproveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subagentId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOB(3, _omitFieldNames ? '' : 'terminateIfPending')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAutoApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAutoApproveRequest copyWith(
          void Function(RevokeAutoApproveRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeAutoApproveRequest))
          as RevokeAutoApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeAutoApproveRequest create() => RevokeAutoApproveRequest._();
  @$core.override
  RevokeAutoApproveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevokeAutoApproveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeAutoApproveRequest>(create);
  static RevokeAutoApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subagentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subagentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubagentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubagentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get terminateIfPending => $_getBF(2);
  @$pb.TagNumber(3)
  set terminateIfPending($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTerminateIfPending() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerminateIfPending() => $_clearField(3);
}

/// RevokeAutoApproveResponse returns the result of revocation.
class RevokeAutoApproveResponse extends $pb.GeneratedMessage {
  factory RevokeAutoApproveResponse({
    $core.bool? revoked,
    $core.int? pendingToolCalls,
    $core.String? subagentStatus,
  }) {
    final result = create();
    if (revoked != null) result.revoked = revoked;
    if (pendingToolCalls != null) result.pendingToolCalls = pendingToolCalls;
    if (subagentStatus != null) result.subagentStatus = subagentStatus;
    return result;
  }

  RevokeAutoApproveResponse._();

  factory RevokeAutoApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevokeAutoApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeAutoApproveResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'revoked')
    ..aI(2, _omitFieldNames ? '' : 'pendingToolCalls')
    ..aOS(3, _omitFieldNames ? '' : 'subagentStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAutoApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAutoApproveResponse copyWith(
          void Function(RevokeAutoApproveResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeAutoApproveResponse))
          as RevokeAutoApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeAutoApproveResponse create() => RevokeAutoApproveResponse._();
  @$core.override
  RevokeAutoApproveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevokeAutoApproveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeAutoApproveResponse>(create);
  static RevokeAutoApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get revoked => $_getBF(0);
  @$pb.TagNumber(1)
  set revoked($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevoked() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevoked() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pendingToolCalls => $_getIZ(1);
  @$pb.TagNumber(2)
  set pendingToolCalls($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPendingToolCalls() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingToolCalls() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subagentStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentStatus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentStatus() => $_clearField(3);
}

/// CreateOrchestrationRequest creates a multi-step orchestration plan.
class CreateOrchestrationRequest extends $pb.GeneratedMessage {
  factory CreateOrchestrationRequest({
    $core.String? parentSessionId,
    $core.Iterable<OrchestrationStep>? steps,
    OrchestrationStrategy? strategy,
  }) {
    final result = create();
    if (parentSessionId != null) result.parentSessionId = parentSessionId;
    if (steps != null) result.steps.addAll(steps);
    if (strategy != null) result.strategy = strategy;
    return result;
  }

  CreateOrchestrationRequest._();

  factory CreateOrchestrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateOrchestrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateOrchestrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentSessionId')
    ..pPM<OrchestrationStep>(2, _omitFieldNames ? '' : 'steps',
        subBuilder: OrchestrationStep.create)
    ..aE<OrchestrationStrategy>(3, _omitFieldNames ? '' : 'strategy',
        enumValues: OrchestrationStrategy.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrchestrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrchestrationRequest copyWith(
          void Function(CreateOrchestrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateOrchestrationRequest))
          as CreateOrchestrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateOrchestrationRequest create() => CreateOrchestrationRequest._();
  @$core.override
  CreateOrchestrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateOrchestrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateOrchestrationRequest>(create);
  static CreateOrchestrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<OrchestrationStep> get steps => $_getList(1);

  @$pb.TagNumber(3)
  OrchestrationStrategy get strategy => $_getN(2);
  @$pb.TagNumber(3)
  set strategy(OrchestrationStrategy value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStrategy() => $_has(2);
  @$pb.TagNumber(3)
  void clearStrategy() => $_clearField(3);
}

/// CreateOrchestrationResponse returns the orchestration ID.
class CreateOrchestrationResponse extends $pb.GeneratedMessage {
  factory CreateOrchestrationResponse({
    $core.String? orchestrationId,
    $core.int? totalSteps,
  }) {
    final result = create();
    if (orchestrationId != null) result.orchestrationId = orchestrationId;
    if (totalSteps != null) result.totalSteps = totalSteps;
    return result;
  }

  CreateOrchestrationResponse._();

  factory CreateOrchestrationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateOrchestrationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateOrchestrationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orchestrationId')
    ..aI(2, _omitFieldNames ? '' : 'totalSteps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrchestrationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrchestrationResponse copyWith(
          void Function(CreateOrchestrationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateOrchestrationResponse))
          as CreateOrchestrationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateOrchestrationResponse create() =>
      CreateOrchestrationResponse._();
  @$core.override
  CreateOrchestrationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateOrchestrationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateOrchestrationResponse>(create);
  static CreateOrchestrationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orchestrationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orchestrationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrchestrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrchestrationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalSteps => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalSteps($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSteps() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSteps() => $_clearField(2);
}

/// OrchestrationStep defines a single step in an orchestration plan.
class OrchestrationStep extends $pb.GeneratedMessage {
  factory OrchestrationStep({
    $core.String? id,
    $core.String? name,
    $core.String? prompt,
    $core.String? model,
    $core.String? workingDirectory,
    $core.Iterable<$core.String>? allowedTools,
    $core.Iterable<$core.String>? dependsOn,
    $core.int? maxTurns,
    $core.bool? autoApprove,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (prompt != null) result.prompt = prompt;
    if (model != null) result.model = model;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (allowedTools != null) result.allowedTools.addAll(allowedTools);
    if (dependsOn != null) result.dependsOn.addAll(dependsOn);
    if (maxTurns != null) result.maxTurns = maxTurns;
    if (autoApprove != null) result.autoApprove = autoApprove;
    return result;
  }

  OrchestrationStep._();

  factory OrchestrationStep.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrchestrationStep.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrchestrationStep',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..aOS(4, _omitFieldNames ? '' : 'model')
    ..aOS(5, _omitFieldNames ? '' : 'workingDirectory')
    ..pPS(6, _omitFieldNames ? '' : 'allowedTools')
    ..pPS(7, _omitFieldNames ? '' : 'dependsOn')
    ..aI(8, _omitFieldNames ? '' : 'maxTurns')
    ..aOB(9, _omitFieldNames ? '' : 'autoApprove')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationStep clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationStep copyWith(void Function(OrchestrationStep) updates) =>
      super.copyWith((message) => updates(message as OrchestrationStep))
          as OrchestrationStep;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrchestrationStep create() => OrchestrationStep._();
  @$core.override
  OrchestrationStep createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrchestrationStep getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrchestrationStep>(create);
  static OrchestrationStep? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get workingDirectory => $_getSZ(4);
  @$pb.TagNumber(5)
  set workingDirectory($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkingDirectory() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkingDirectory() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get allowedTools => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get dependsOn => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get maxTurns => $_getIZ(7);
  @$pb.TagNumber(8)
  set maxTurns($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMaxTurns() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxTurns() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get autoApprove => $_getBF(8);
  @$pb.TagNumber(9)
  set autoApprove($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAutoApprove() => $_has(8);
  @$pb.TagNumber(9)
  void clearAutoApprove() => $_clearField(9);
}

/// WatchOrchestrationRequest subscribes to orchestration progress events.
class WatchOrchestrationRequest extends $pb.GeneratedMessage {
  factory WatchOrchestrationRequest({
    $core.String? orchestrationId,
  }) {
    final result = create();
    if (orchestrationId != null) result.orchestrationId = orchestrationId;
    return result;
  }

  WatchOrchestrationRequest._();

  factory WatchOrchestrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchOrchestrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchOrchestrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orchestrationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchOrchestrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchOrchestrationRequest copyWith(
          void Function(WatchOrchestrationRequest) updates) =>
      super.copyWith((message) => updates(message as WatchOrchestrationRequest))
          as WatchOrchestrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchOrchestrationRequest create() => WatchOrchestrationRequest._();
  @$core.override
  WatchOrchestrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchOrchestrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchOrchestrationRequest>(create);
  static WatchOrchestrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orchestrationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orchestrationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrchestrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrchestrationId() => $_clearField(1);
}

enum OrchestrationEvent_Event {
  stepStarted,
  stepCompleted,
  stepFailed,
  completed,
  failed,
  notSet
}

/// OrchestrationEvent wraps orchestration progress events.
class OrchestrationEvent extends $pb.GeneratedMessage {
  factory OrchestrationEvent({
    $core.String? orchestrationId,
    $1.Timestamp? timestamp,
    StepStarted? stepStarted,
    StepCompleted? stepCompleted,
    StepFailed? stepFailed,
    OrchestrationCompleted? completed,
    OrchestrationFailed? failed,
  }) {
    final result = create();
    if (orchestrationId != null) result.orchestrationId = orchestrationId;
    if (timestamp != null) result.timestamp = timestamp;
    if (stepStarted != null) result.stepStarted = stepStarted;
    if (stepCompleted != null) result.stepCompleted = stepCompleted;
    if (stepFailed != null) result.stepFailed = stepFailed;
    if (completed != null) result.completed = completed;
    if (failed != null) result.failed = failed;
    return result;
  }

  OrchestrationEvent._();

  factory OrchestrationEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrchestrationEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, OrchestrationEvent_Event>
      _OrchestrationEvent_EventByTag = {
    3: OrchestrationEvent_Event.stepStarted,
    4: OrchestrationEvent_Event.stepCompleted,
    5: OrchestrationEvent_Event.stepFailed,
    6: OrchestrationEvent_Event.completed,
    7: OrchestrationEvent_Event.failed,
    0: OrchestrationEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrchestrationEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'orchestrationId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aOM<StepStarted>(3, _omitFieldNames ? '' : 'stepStarted',
        subBuilder: StepStarted.create)
    ..aOM<StepCompleted>(4, _omitFieldNames ? '' : 'stepCompleted',
        subBuilder: StepCompleted.create)
    ..aOM<StepFailed>(5, _omitFieldNames ? '' : 'stepFailed',
        subBuilder: StepFailed.create)
    ..aOM<OrchestrationCompleted>(6, _omitFieldNames ? '' : 'completed',
        subBuilder: OrchestrationCompleted.create)
    ..aOM<OrchestrationFailed>(7, _omitFieldNames ? '' : 'failed',
        subBuilder: OrchestrationFailed.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationEvent copyWith(void Function(OrchestrationEvent) updates) =>
      super.copyWith((message) => updates(message as OrchestrationEvent))
          as OrchestrationEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrchestrationEvent create() => OrchestrationEvent._();
  @$core.override
  OrchestrationEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrchestrationEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrchestrationEvent>(create);
  static OrchestrationEvent? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  OrchestrationEvent_Event whichEvent() =>
      _OrchestrationEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get orchestrationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orchestrationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrchestrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrchestrationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  StepStarted get stepStarted => $_getN(2);
  @$pb.TagNumber(3)
  set stepStarted(StepStarted value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStepStarted() => $_has(2);
  @$pb.TagNumber(3)
  void clearStepStarted() => $_clearField(3);
  @$pb.TagNumber(3)
  StepStarted ensureStepStarted() => $_ensure(2);

  @$pb.TagNumber(4)
  StepCompleted get stepCompleted => $_getN(3);
  @$pb.TagNumber(4)
  set stepCompleted(StepCompleted value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStepCompleted() => $_has(3);
  @$pb.TagNumber(4)
  void clearStepCompleted() => $_clearField(4);
  @$pb.TagNumber(4)
  StepCompleted ensureStepCompleted() => $_ensure(3);

  @$pb.TagNumber(5)
  StepFailed get stepFailed => $_getN(4);
  @$pb.TagNumber(5)
  set stepFailed(StepFailed value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStepFailed() => $_has(4);
  @$pb.TagNumber(5)
  void clearStepFailed() => $_clearField(5);
  @$pb.TagNumber(5)
  StepFailed ensureStepFailed() => $_ensure(4);

  @$pb.TagNumber(6)
  OrchestrationCompleted get completed => $_getN(5);
  @$pb.TagNumber(6)
  set completed(OrchestrationCompleted value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCompleted() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompleted() => $_clearField(6);
  @$pb.TagNumber(6)
  OrchestrationCompleted ensureCompleted() => $_ensure(5);

  @$pb.TagNumber(7)
  OrchestrationFailed get failed => $_getN(6);
  @$pb.TagNumber(7)
  set failed(OrchestrationFailed value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFailed() => $_has(6);
  @$pb.TagNumber(7)
  void clearFailed() => $_clearField(7);
  @$pb.TagNumber(7)
  OrchestrationFailed ensureFailed() => $_ensure(6);
}

/// StepStarted indicates an orchestration step has begun.
class StepStarted extends $pb.GeneratedMessage {
  factory StepStarted({
    $core.String? stepId,
    $core.String? subagentId,
    $core.String? name,
  }) {
    final result = create();
    if (stepId != null) result.stepId = stepId;
    if (subagentId != null) result.subagentId = subagentId;
    if (name != null) result.name = name;
    return result;
  }

  StepStarted._();

  factory StepStarted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StepStarted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StepStarted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stepId')
    ..aOS(2, _omitFieldNames ? '' : 'subagentId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepStarted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepStarted copyWith(void Function(StepStarted) updates) =>
      super.copyWith((message) => updates(message as StepStarted))
          as StepStarted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StepStarted create() => StepStarted._();
  @$core.override
  StepStarted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StepStarted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StepStarted>(create);
  static StepStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subagentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

/// StepCompleted indicates a step finished successfully.
class StepCompleted extends $pb.GeneratedMessage {
  factory StepCompleted({
    $core.String? stepId,
    $core.String? resultSummary,
    $core.int? completedCount,
    $core.int? totalCount,
  }) {
    final result = create();
    if (stepId != null) result.stepId = stepId;
    if (resultSummary != null) result.resultSummary = resultSummary;
    if (completedCount != null) result.completedCount = completedCount;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  StepCompleted._();

  factory StepCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StepCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StepCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stepId')
    ..aOS(2, _omitFieldNames ? '' : 'resultSummary')
    ..aI(3, _omitFieldNames ? '' : 'completedCount')
    ..aI(4, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepCompleted copyWith(void Function(StepCompleted) updates) =>
      super.copyWith((message) => updates(message as StepCompleted))
          as StepCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StepCompleted create() => StepCompleted._();
  @$core.override
  StepCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StepCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StepCompleted>(create);
  static StepCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resultSummary => $_getSZ(1);
  @$pb.TagNumber(2)
  set resultSummary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResultSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultSummary() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get completedCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set completedCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompletedCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompletedCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalCount() => $_clearField(4);
}

/// StepFailed indicates a step failed.
class StepFailed extends $pb.GeneratedMessage {
  factory StepFailed({
    $core.String? stepId,
    $core.String? errorMessage,
    $core.Iterable<$core.String>? blockedSteps,
  }) {
    final result = create();
    if (stepId != null) result.stepId = stepId;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (blockedSteps != null) result.blockedSteps.addAll(blockedSteps);
    return result;
  }

  StepFailed._();

  factory StepFailed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StepFailed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StepFailed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stepId')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..pPS(3, _omitFieldNames ? '' : 'blockedSteps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepFailed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepFailed copyWith(void Function(StepFailed) updates) =>
      super.copyWith((message) => updates(message as StepFailed)) as StepFailed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StepFailed create() => StepFailed._();
  @$core.override
  StepFailed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StepFailed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StepFailed>(create);
  static StepFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get blockedSteps => $_getList(2);
}

/// OrchestrationCompleted indicates all steps finished.
class OrchestrationCompleted extends $pb.GeneratedMessage {
  factory OrchestrationCompleted({
    $core.int? totalSteps,
    $core.int? succeeded,
    $core.int? failed,
  }) {
    final result = create();
    if (totalSteps != null) result.totalSteps = totalSteps;
    if (succeeded != null) result.succeeded = succeeded;
    if (failed != null) result.failed = failed;
    return result;
  }

  OrchestrationCompleted._();

  factory OrchestrationCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrchestrationCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrchestrationCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'totalSteps')
    ..aI(2, _omitFieldNames ? '' : 'succeeded')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationCompleted copyWith(
          void Function(OrchestrationCompleted) updates) =>
      super.copyWith((message) => updates(message as OrchestrationCompleted))
          as OrchestrationCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrchestrationCompleted create() => OrchestrationCompleted._();
  @$core.override
  OrchestrationCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrchestrationCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrchestrationCompleted>(create);
  static OrchestrationCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalSteps => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalSteps($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalSteps() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalSteps() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get succeeded => $_getIZ(1);
  @$pb.TagNumber(2)
  set succeeded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucceeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucceeded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

/// OrchestrationFailed indicates the orchestration could not complete.
class OrchestrationFailed extends $pb.GeneratedMessage {
  factory OrchestrationFailed({
    $core.String? errorMessage,
    $core.int? completedSteps,
    $core.int? failedSteps,
  }) {
    final result = create();
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (completedSteps != null) result.completedSteps = completedSteps;
    if (failedSteps != null) result.failedSteps = failedSteps;
    return result;
  }

  OrchestrationFailed._();

  factory OrchestrationFailed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrchestrationFailed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrchestrationFailed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'errorMessage')
    ..aI(2, _omitFieldNames ? '' : 'completedSteps')
    ..aI(3, _omitFieldNames ? '' : 'failedSteps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationFailed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrchestrationFailed copyWith(void Function(OrchestrationFailed) updates) =>
      super.copyWith((message) => updates(message as OrchestrationFailed))
          as OrchestrationFailed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrchestrationFailed create() => OrchestrationFailed._();
  @$core.override
  OrchestrationFailed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrchestrationFailed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrchestrationFailed>(create);
  static OrchestrationFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorMessage => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMessage($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get completedSteps => $_getIZ(1);
  @$pb.TagNumber(2)
  set completedSteps($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompletedSteps() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompletedSteps() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failedSteps => $_getIZ(2);
  @$pb.TagNumber(3)
  set failedSteps($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailedSteps() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailedSteps() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
