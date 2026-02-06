// This is a generated file - do not edit.
//
// Generated from betcode/v1/worktree.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CreateWorktreeRequest extends $pb.GeneratedMessage {
  factory CreateWorktreeRequest({
    $core.String? name,
    $core.String? repoPath,
    $core.String? branch,
    $core.String? setupScript,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (repoPath != null) result.repoPath = repoPath;
    if (branch != null) result.branch = branch;
    if (setupScript != null) result.setupScript = setupScript;
    return result;
  }

  CreateWorktreeRequest._();

  factory CreateWorktreeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateWorktreeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWorktreeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'repoPath')
    ..aOS(3, _omitFieldNames ? '' : 'branch')
    ..aOS(4, _omitFieldNames ? '' : 'setupScript')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorktreeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorktreeRequest copyWith(
          void Function(CreateWorktreeRequest) updates) =>
      super.copyWith((message) => updates(message as CreateWorktreeRequest))
          as CreateWorktreeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateWorktreeRequest create() => CreateWorktreeRequest._();
  @$core.override
  CreateWorktreeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateWorktreeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWorktreeRequest>(create);
  static CreateWorktreeRequest? _defaultInstance;

  /// Human-readable name (e.g. "feat-login"). Used as directory name.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Path to the git repository root.
  @$pb.TagNumber(2)
  $core.String get repoPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set repoPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRepoPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearRepoPath() => $_clearField(2);

  /// Branch name to create (passed to `git worktree add -b`).
  @$pb.TagNumber(3)
  $core.String get branch => $_getSZ(2);
  @$pb.TagNumber(3)
  set branch($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBranch() => $_has(2);
  @$pb.TagNumber(3)
  void clearBranch() => $_clearField(3);

  /// Optional shell command to run after worktree creation (e.g. "npm install").
  @$pb.TagNumber(4)
  $core.String get setupScript => $_getSZ(3);
  @$pb.TagNumber(4)
  set setupScript($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSetupScript() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetupScript() => $_clearField(4);
}

class RemoveWorktreeRequest extends $pb.GeneratedMessage {
  factory RemoveWorktreeRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  RemoveWorktreeRequest._();

  factory RemoveWorktreeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveWorktreeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveWorktreeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveWorktreeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveWorktreeRequest copyWith(
          void Function(RemoveWorktreeRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveWorktreeRequest))
          as RemoveWorktreeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveWorktreeRequest create() => RemoveWorktreeRequest._();
  @$core.override
  RemoveWorktreeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveWorktreeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveWorktreeRequest>(create);
  static RemoveWorktreeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class ListWorktreesRequest extends $pb.GeneratedMessage {
  factory ListWorktreesRequest({
    $core.String? repoPath,
  }) {
    final result = create();
    if (repoPath != null) result.repoPath = repoPath;
    return result;
  }

  ListWorktreesRequest._();

  factory ListWorktreesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorktreesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorktreesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorktreesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorktreesRequest copyWith(void Function(ListWorktreesRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorktreesRequest))
          as ListWorktreesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorktreesRequest create() => ListWorktreesRequest._();
  @$core.override
  ListWorktreesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorktreesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorktreesRequest>(create);
  static ListWorktreesRequest? _defaultInstance;

  /// Filter by repo path. Empty string returns all.
  @$pb.TagNumber(1)
  $core.String get repoPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoPath() => $_clearField(1);
}

class GetWorktreeRequest extends $pb.GeneratedMessage {
  factory GetWorktreeRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetWorktreeRequest._();

  factory GetWorktreeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorktreeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorktreeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorktreeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorktreeRequest copyWith(void Function(GetWorktreeRequest) updates) =>
      super.copyWith((message) => updates(message as GetWorktreeRequest))
          as GetWorktreeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorktreeRequest create() => GetWorktreeRequest._();
  @$core.override
  GetWorktreeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorktreeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorktreeRequest>(create);
  static GetWorktreeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RemoveWorktreeResponse extends $pb.GeneratedMessage {
  factory RemoveWorktreeResponse({
    $core.bool? removed,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    return result;
  }

  RemoveWorktreeResponse._();

  factory RemoveWorktreeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveWorktreeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveWorktreeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'removed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveWorktreeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveWorktreeResponse copyWith(
          void Function(RemoveWorktreeResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveWorktreeResponse))
          as RemoveWorktreeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveWorktreeResponse create() => RemoveWorktreeResponse._();
  @$core.override
  RemoveWorktreeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveWorktreeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveWorktreeResponse>(create);
  static RemoveWorktreeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get removed => $_getBF(0);
  @$pb.TagNumber(1)
  set removed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);
}

class ListWorktreesResponse extends $pb.GeneratedMessage {
  factory ListWorktreesResponse({
    $core.Iterable<WorktreeDetail>? worktrees,
  }) {
    final result = create();
    if (worktrees != null) result.worktrees.addAll(worktrees);
    return result;
  }

  ListWorktreesResponse._();

  factory ListWorktreesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorktreesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorktreesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<WorktreeDetail>(1, _omitFieldNames ? '' : 'worktrees',
        subBuilder: WorktreeDetail.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorktreesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorktreesResponse copyWith(
          void Function(ListWorktreesResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorktreesResponse))
          as ListWorktreesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorktreesResponse create() => ListWorktreesResponse._();
  @$core.override
  ListWorktreesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorktreesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorktreesResponse>(create);
  static ListWorktreesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorktreeDetail> get worktrees => $_getList(0);
}

/// WorktreeDetail combines the database record with runtime status.
class WorktreeDetail extends $pb.GeneratedMessage {
  factory WorktreeDetail({
    $core.String? id,
    $core.String? name,
    $core.String? path,
    $core.String? branch,
    $core.String? repoPath,
    $core.String? setupScript,
    $core.bool? existsOnDisk,
    $core.int? sessionCount,
    $1.Timestamp? createdAt,
    $1.Timestamp? lastActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (path != null) result.path = path;
    if (branch != null) result.branch = branch;
    if (repoPath != null) result.repoPath = repoPath;
    if (setupScript != null) result.setupScript = setupScript;
    if (existsOnDisk != null) result.existsOnDisk = existsOnDisk;
    if (sessionCount != null) result.sessionCount = sessionCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (lastActive != null) result.lastActive = lastActive;
    return result;
  }

  WorktreeDetail._();

  factory WorktreeDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorktreeDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorktreeDetail',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOS(4, _omitFieldNames ? '' : 'branch')
    ..aOS(5, _omitFieldNames ? '' : 'repoPath')
    ..aOS(6, _omitFieldNames ? '' : 'setupScript')
    ..aOB(7, _omitFieldNames ? '' : 'existsOnDisk')
    ..aI(8, _omitFieldNames ? '' : 'sessionCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'lastActive',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorktreeDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorktreeDetail copyWith(void Function(WorktreeDetail) updates) =>
      super.copyWith((message) => updates(message as WorktreeDetail))
          as WorktreeDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorktreeDetail create() => WorktreeDetail._();
  @$core.override
  WorktreeDetail createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WorktreeDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorktreeDetail>(create);
  static WorktreeDetail? _defaultInstance;

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
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get branch => $_getSZ(3);
  @$pb.TagNumber(4)
  set branch($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBranch() => $_has(3);
  @$pb.TagNumber(4)
  void clearBranch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get repoPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set repoPath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRepoPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearRepoPath() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get setupScript => $_getSZ(5);
  @$pb.TagNumber(6)
  set setupScript($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSetupScript() => $_has(5);
  @$pb.TagNumber(6)
  void clearSetupScript() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get existsOnDisk => $_getBF(6);
  @$pb.TagNumber(7)
  set existsOnDisk($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExistsOnDisk() => $_has(6);
  @$pb.TagNumber(7)
  void clearExistsOnDisk() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get sessionCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set sessionCount($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSessionCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearSessionCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get lastActive => $_getN(9);
  @$pb.TagNumber(10)
  set lastActive($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLastActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastActive() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureLastActive() => $_ensure(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
