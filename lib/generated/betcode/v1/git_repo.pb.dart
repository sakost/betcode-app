// This is a generated file - do not edit.
//
// Generated from betcode/v1/git_repo.proto.

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

import 'git_repo.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'git_repo.pbenum.dart';

class RegisterRepoRequest extends $pb.GeneratedMessage {
  factory RegisterRepoRequest({
    $core.String? repoPath,
    $core.String? name,
    WorktreeMode? worktreeMode,
    $core.String? localSubfolder,
    $core.String? customPath,
    $core.String? setupScript,
    $core.bool? autoGitignore,
  }) {
    final result = create();
    if (repoPath != null) result.repoPath = repoPath;
    if (name != null) result.name = name;
    if (worktreeMode != null) result.worktreeMode = worktreeMode;
    if (localSubfolder != null) result.localSubfolder = localSubfolder;
    if (customPath != null) result.customPath = customPath;
    if (setupScript != null) result.setupScript = setupScript;
    if (autoGitignore != null) result.autoGitignore = autoGitignore;
    return result;
  }

  RegisterRepoRequest._();

  factory RegisterRepoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterRepoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterRepoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoPath')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<WorktreeMode>(3, _omitFieldNames ? '' : 'worktreeMode',
        enumValues: WorktreeMode.values)
    ..aOS(4, _omitFieldNames ? '' : 'localSubfolder')
    ..aOS(5, _omitFieldNames ? '' : 'customPath')
    ..aOS(6, _omitFieldNames ? '' : 'setupScript')
    ..aOB(7, _omitFieldNames ? '' : 'autoGitignore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRepoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRepoRequest copyWith(void Function(RegisterRepoRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRepoRequest))
          as RegisterRepoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRepoRequest create() => RegisterRepoRequest._();
  @$core.override
  RegisterRepoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterRepoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterRepoRequest>(create);
  static RegisterRepoRequest? _defaultInstance;

  /// Absolute path to the git repository root.
  @$pb.TagNumber(1)
  $core.String get repoPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoPath() => $_clearField(1);

  /// Display name (optional; defaults to last path component).
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Worktree storage mode (default: GLOBAL).
  @$pb.TagNumber(3)
  WorktreeMode get worktreeMode => $_getN(2);
  @$pb.TagNumber(3)
  set worktreeMode(WorktreeMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWorktreeMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorktreeMode() => $_clearField(3);

  /// Subfolder name for local mode (default: ".worktree").
  @$pb.TagNumber(4)
  $core.String get localSubfolder => $_getSZ(3);
  @$pb.TagNumber(4)
  set localSubfolder($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocalSubfolder() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalSubfolder() => $_clearField(4);

  /// Absolute path for custom mode.
  @$pb.TagNumber(5)
  $core.String get customPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set customPath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCustomPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomPath() => $_clearField(5);

  /// Default setup script for new worktrees.
  @$pb.TagNumber(6)
  $core.String get setupScript => $_getSZ(5);
  @$pb.TagNumber(6)
  set setupScript($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSetupScript() => $_has(5);
  @$pb.TagNumber(6)
  void clearSetupScript() => $_clearField(6);

  /// Whether to auto-add local subfolder to .gitignore (default: true).
  @$pb.TagNumber(7)
  $core.bool get autoGitignore => $_getBF(6);
  @$pb.TagNumber(7)
  set autoGitignore($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAutoGitignore() => $_has(6);
  @$pb.TagNumber(7)
  void clearAutoGitignore() => $_clearField(7);
}

class UnregisterRepoRequest extends $pb.GeneratedMessage {
  factory UnregisterRepoRequest({
    $core.String? id,
    $core.bool? removeWorktrees,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (removeWorktrees != null) result.removeWorktrees = removeWorktrees;
    return result;
  }

  UnregisterRepoRequest._();

  factory UnregisterRepoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnregisterRepoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnregisterRepoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'removeWorktrees')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRepoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRepoRequest copyWith(
          void Function(UnregisterRepoRequest) updates) =>
      super.copyWith((message) => updates(message as UnregisterRepoRequest))
          as UnregisterRepoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnregisterRepoRequest create() => UnregisterRepoRequest._();
  @$core.override
  UnregisterRepoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnregisterRepoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnregisterRepoRequest>(create);
  static UnregisterRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// If true, also remove all worktrees on disk.
  @$pb.TagNumber(2)
  $core.bool get removeWorktrees => $_getBF(1);
  @$pb.TagNumber(2)
  set removeWorktrees($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemoveWorktrees() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoveWorktrees() => $_clearField(2);
}

class ListReposRequest extends $pb.GeneratedMessage {
  factory ListReposRequest({
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListReposRequest._();

  factory ListReposRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReposRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReposRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReposRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReposRequest copyWith(void Function(ListReposRequest) updates) =>
      super.copyWith((message) => updates(message as ListReposRequest))
          as ListReposRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReposRequest create() => ListReposRequest._();
  @$core.override
  ListReposRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReposRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReposRequest>(create);
  static ListReposRequest? _defaultInstance;

  /// Maximum number of results to return (0 = no limit).
  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);

  /// Number of results to skip for pagination.
  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class GetRepoRequest extends $pb.GeneratedMessage {
  factory GetRepoRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetRepoRequest._();

  factory GetRepoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRepoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRepoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRepoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRepoRequest copyWith(void Function(GetRepoRequest) updates) =>
      super.copyWith((message) => updates(message as GetRepoRequest))
          as GetRepoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRepoRequest create() => GetRepoRequest._();
  @$core.override
  GetRepoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRepoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRepoRequest>(create);
  static GetRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class UpdateRepoRequest extends $pb.GeneratedMessage {
  factory UpdateRepoRequest({
    $core.String? id,
    $core.String? name,
    WorktreeMode? worktreeMode,
    $core.String? localSubfolder,
    $core.String? customPath,
    $core.String? setupScript,
    $core.bool? autoGitignore,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (worktreeMode != null) result.worktreeMode = worktreeMode;
    if (localSubfolder != null) result.localSubfolder = localSubfolder;
    if (customPath != null) result.customPath = customPath;
    if (setupScript != null) result.setupScript = setupScript;
    if (autoGitignore != null) result.autoGitignore = autoGitignore;
    return result;
  }

  UpdateRepoRequest._();

  factory UpdateRepoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRepoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRepoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<WorktreeMode>(3, _omitFieldNames ? '' : 'worktreeMode',
        enumValues: WorktreeMode.values)
    ..aOS(4, _omitFieldNames ? '' : 'localSubfolder')
    ..aOS(5, _omitFieldNames ? '' : 'customPath')
    ..aOS(6, _omitFieldNames ? '' : 'setupScript')
    ..aOB(7, _omitFieldNames ? '' : 'autoGitignore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRepoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRepoRequest copyWith(void Function(UpdateRepoRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRepoRequest))
          as UpdateRepoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRepoRequest create() => UpdateRepoRequest._();
  @$core.override
  UpdateRepoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRepoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRepoRequest>(create);
  static UpdateRepoRequest? _defaultInstance;

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
  WorktreeMode get worktreeMode => $_getN(2);
  @$pb.TagNumber(3)
  set worktreeMode(WorktreeMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWorktreeMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorktreeMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get localSubfolder => $_getSZ(3);
  @$pb.TagNumber(4)
  set localSubfolder($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocalSubfolder() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalSubfolder() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get customPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set customPath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCustomPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomPath() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get setupScript => $_getSZ(5);
  @$pb.TagNumber(6)
  set setupScript($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSetupScript() => $_has(5);
  @$pb.TagNumber(6)
  void clearSetupScript() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get autoGitignore => $_getBF(6);
  @$pb.TagNumber(7)
  set autoGitignore($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAutoGitignore() => $_has(6);
  @$pb.TagNumber(7)
  void clearAutoGitignore() => $_clearField(7);
}

class ScanReposRequest extends $pb.GeneratedMessage {
  factory ScanReposRequest({
    $core.String? scanPath,
    $core.int? maxDepth,
  }) {
    final result = create();
    if (scanPath != null) result.scanPath = scanPath;
    if (maxDepth != null) result.maxDepth = maxDepth;
    return result;
  }

  ScanReposRequest._();

  factory ScanReposRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScanReposRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanReposRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scanPath')
    ..aI(2, _omitFieldNames ? '' : 'maxDepth', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanReposRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanReposRequest copyWith(void Function(ScanReposRequest) updates) =>
      super.copyWith((message) => updates(message as ScanReposRequest))
          as ScanReposRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanReposRequest create() => ScanReposRequest._();
  @$core.override
  ScanReposRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScanReposRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanReposRequest>(create);
  static ScanReposRequest? _defaultInstance;

  /// Directory to scan for git repositories.
  @$pb.TagNumber(1)
  $core.String get scanPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set scanPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScanPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearScanPath() => $_clearField(1);

  /// Maximum depth to scan (default: 2).
  @$pb.TagNumber(2)
  $core.int get maxDepth => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxDepth($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxDepth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxDepth() => $_clearField(2);
}

class UnregisterRepoResponse extends $pb.GeneratedMessage {
  factory UnregisterRepoResponse({
    $core.bool? removed,
    $core.int? worktreesRemoved,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    if (worktreesRemoved != null) result.worktreesRemoved = worktreesRemoved;
    return result;
  }

  UnregisterRepoResponse._();

  factory UnregisterRepoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnregisterRepoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnregisterRepoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'removed')
    ..aI(2, _omitFieldNames ? '' : 'worktreesRemoved',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRepoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRepoResponse copyWith(
          void Function(UnregisterRepoResponse) updates) =>
      super.copyWith((message) => updates(message as UnregisterRepoResponse))
          as UnregisterRepoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnregisterRepoResponse create() => UnregisterRepoResponse._();
  @$core.override
  UnregisterRepoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnregisterRepoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnregisterRepoResponse>(create);
  static UnregisterRepoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get removed => $_getBF(0);
  @$pb.TagNumber(1)
  set removed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get worktreesRemoved => $_getIZ(1);
  @$pb.TagNumber(2)
  set worktreesRemoved($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorktreesRemoved() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorktreesRemoved() => $_clearField(2);
}

class ListReposResponse extends $pb.GeneratedMessage {
  factory ListReposResponse({
    $core.Iterable<GitRepoDetail>? repos,
    $core.int? totalCount,
  }) {
    final result = create();
    if (repos != null) result.repos.addAll(repos);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListReposResponse._();

  factory ListReposResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReposResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReposResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<GitRepoDetail>(1, _omitFieldNames ? '' : 'repos',
        subBuilder: GitRepoDetail.create)
    ..aI(2, _omitFieldNames ? '' : 'totalCount', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReposResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReposResponse copyWith(void Function(ListReposResponse) updates) =>
      super.copyWith((message) => updates(message as ListReposResponse))
          as ListReposResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReposResponse create() => ListReposResponse._();
  @$core.override
  ListReposResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReposResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReposResponse>(create);
  static ListReposResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GitRepoDetail> get repos => $_getList(0);

  /// Total number of repositories (before pagination).
  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class GitRepoDetail extends $pb.GeneratedMessage {
  factory GitRepoDetail({
    $core.String? id,
    $core.String? name,
    $core.String? repoPath,
    WorktreeMode? worktreeMode,
    $core.String? localSubfolder,
    $core.String? customPath,
    $core.String? setupScript,
    $core.bool? autoGitignore,
    $core.int? worktreeCount,
    $1.Timestamp? createdAt,
    $1.Timestamp? lastActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (repoPath != null) result.repoPath = repoPath;
    if (worktreeMode != null) result.worktreeMode = worktreeMode;
    if (localSubfolder != null) result.localSubfolder = localSubfolder;
    if (customPath != null) result.customPath = customPath;
    if (setupScript != null) result.setupScript = setupScript;
    if (autoGitignore != null) result.autoGitignore = autoGitignore;
    if (worktreeCount != null) result.worktreeCount = worktreeCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (lastActive != null) result.lastActive = lastActive;
    return result;
  }

  GitRepoDetail._();

  factory GitRepoDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GitRepoDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GitRepoDetail',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'repoPath')
    ..aE<WorktreeMode>(4, _omitFieldNames ? '' : 'worktreeMode',
        enumValues: WorktreeMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'localSubfolder')
    ..aOS(6, _omitFieldNames ? '' : 'customPath')
    ..aOS(7, _omitFieldNames ? '' : 'setupScript')
    ..aOB(8, _omitFieldNames ? '' : 'autoGitignore')
    ..aI(9, _omitFieldNames ? '' : 'worktreeCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'lastActive',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GitRepoDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GitRepoDetail copyWith(void Function(GitRepoDetail) updates) =>
      super.copyWith((message) => updates(message as GitRepoDetail))
          as GitRepoDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GitRepoDetail create() => GitRepoDetail._();
  @$core.override
  GitRepoDetail createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GitRepoDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GitRepoDetail>(create);
  static GitRepoDetail? _defaultInstance;

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
  $core.String get repoPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set repoPath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRepoPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearRepoPath() => $_clearField(3);

  @$pb.TagNumber(4)
  WorktreeMode get worktreeMode => $_getN(3);
  @$pb.TagNumber(4)
  set worktreeMode(WorktreeMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWorktreeMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorktreeMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get localSubfolder => $_getSZ(4);
  @$pb.TagNumber(5)
  set localSubfolder($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocalSubfolder() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocalSubfolder() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get customPath => $_getSZ(5);
  @$pb.TagNumber(6)
  set customPath($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCustomPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearCustomPath() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get setupScript => $_getSZ(6);
  @$pb.TagNumber(7)
  set setupScript($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSetupScript() => $_has(6);
  @$pb.TagNumber(7)
  void clearSetupScript() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get autoGitignore => $_getBF(7);
  @$pb.TagNumber(8)
  set autoGitignore($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAutoGitignore() => $_has(7);
  @$pb.TagNumber(8)
  void clearAutoGitignore() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get worktreeCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set worktreeCount($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWorktreeCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearWorktreeCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get lastActive => $_getN(10);
  @$pb.TagNumber(11)
  set lastActive($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLastActive() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastActive() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureLastActive() => $_ensure(10);
}

class BranchInfo extends $pb.GeneratedMessage {
  factory BranchInfo({
    $core.String? name,
    $core.bool? isHead,
    $core.String? commitSha,
    $core.String? commitMessage,
    $core.bool? hasWorktree,
    $core.bool? isRemote,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (isHead != null) result.isHead = isHead;
    if (commitSha != null) result.commitSha = commitSha;
    if (commitMessage != null) result.commitMessage = commitMessage;
    if (hasWorktree != null) result.hasWorktree = hasWorktree;
    if (isRemote != null) result.isRemote = isRemote;
    return result;
  }

  BranchInfo._();

  factory BranchInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BranchInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'isHead')
    ..aOS(3, _omitFieldNames ? '' : 'commitSha')
    ..aOS(4, _omitFieldNames ? '' : 'commitMessage')
    ..aOB(5, _omitFieldNames ? '' : 'hasWorktree')
    ..aOB(6, _omitFieldNames ? '' : 'isRemote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BranchInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BranchInfo copyWith(void Function(BranchInfo) updates) =>
      super.copyWith((message) => updates(message as BranchInfo)) as BranchInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchInfo create() => BranchInfo._();
  @$core.override
  BranchInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BranchInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchInfo>(create);
  static BranchInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isHead => $_getBF(1);
  @$pb.TagNumber(2)
  set isHead($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsHead() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsHead() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commitSha => $_getSZ(2);
  @$pb.TagNumber(3)
  set commitSha($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommitSha() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitSha() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get commitMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set commitMessage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCommitMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommitMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasWorktree => $_getBF(4);
  @$pb.TagNumber(5)
  set hasWorktree($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasWorktree() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasWorktree() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isRemote => $_getBF(5);
  @$pb.TagNumber(6)
  set isRemote($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsRemote() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsRemote() => $_clearField(6);
}

class ListBranchesRequest extends $pb.GeneratedMessage {
  factory ListBranchesRequest({
    $core.String? repoId,
    $core.bool? includeRemote,
  }) {
    final result = create();
    if (repoId != null) result.repoId = repoId;
    if (includeRemote != null) result.includeRemote = includeRemote;
    return result;
  }

  ListBranchesRequest._();

  factory ListBranchesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBranchesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBranchesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoId')
    ..aOB(2, _omitFieldNames ? '' : 'includeRemote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBranchesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBranchesRequest copyWith(void Function(ListBranchesRequest) updates) =>
      super.copyWith((message) => updates(message as ListBranchesRequest))
          as ListBranchesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBranchesRequest create() => ListBranchesRequest._();
  @$core.override
  ListBranchesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBranchesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBranchesRequest>(create);
  static ListBranchesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeRemote => $_getBF(1);
  @$pb.TagNumber(2)
  set includeRemote($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeRemote() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeRemote() => $_clearField(2);
}

class ListBranchesResponse extends $pb.GeneratedMessage {
  factory ListBranchesResponse({
    $core.Iterable<BranchInfo>? branches,
  }) {
    final result = create();
    if (branches != null) result.branches.addAll(branches);
    return result;
  }

  ListBranchesResponse._();

  factory ListBranchesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBranchesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBranchesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<BranchInfo>(1, _omitFieldNames ? '' : 'branches',
        subBuilder: BranchInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBranchesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBranchesResponse copyWith(void Function(ListBranchesResponse) updates) =>
      super.copyWith((message) => updates(message as ListBranchesResponse))
          as ListBranchesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBranchesResponse create() => ListBranchesResponse._();
  @$core.override
  ListBranchesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBranchesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBranchesResponse>(create);
  static ListBranchesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BranchInfo> get branches => $_getList(0);
}

class CreateBranchRequest extends $pb.GeneratedMessage {
  factory CreateBranchRequest({
    $core.String? repoId,
    $core.String? name,
    $core.String? startPoint,
  }) {
    final result = create();
    if (repoId != null) result.repoId = repoId;
    if (name != null) result.name = name;
    if (startPoint != null) result.startPoint = startPoint;
    return result;
  }

  CreateBranchRequest._();

  factory CreateBranchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateBranchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateBranchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'startPoint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBranchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBranchRequest copyWith(void Function(CreateBranchRequest) updates) =>
      super.copyWith((message) => updates(message as CreateBranchRequest))
          as CreateBranchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateBranchRequest create() => CreateBranchRequest._();
  @$core.override
  CreateBranchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateBranchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateBranchRequest>(create);
  static CreateBranchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Base ref (branch, tag, or commit SHA). Empty = HEAD.
  @$pb.TagNumber(3)
  $core.String get startPoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set startPoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartPoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartPoint() => $_clearField(3);
}

class DeleteBranchRequest extends $pb.GeneratedMessage {
  factory DeleteBranchRequest({
    $core.String? repoId,
    $core.String? name,
    $core.bool? force,
  }) {
    final result = create();
    if (repoId != null) result.repoId = repoId;
    if (name != null) result.name = name;
    if (force != null) result.force = force;
    return result;
  }

  DeleteBranchRequest._();

  factory DeleteBranchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteBranchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteBranchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteBranchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteBranchRequest copyWith(void Function(DeleteBranchRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteBranchRequest))
          as DeleteBranchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteBranchRequest create() => DeleteBranchRequest._();
  @$core.override
  DeleteBranchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteBranchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteBranchRequest>(create);
  static DeleteBranchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get force => $_getBF(2);
  @$pb.TagNumber(3)
  set force($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForce() => $_has(2);
  @$pb.TagNumber(3)
  void clearForce() => $_clearField(3);
}

class DeleteBranchResponse extends $pb.GeneratedMessage {
  factory DeleteBranchResponse({
    $core.bool? deleted,
  }) {
    final result = create();
    if (deleted != null) result.deleted = deleted;
    return result;
  }

  DeleteBranchResponse._();

  factory DeleteBranchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteBranchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteBranchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'deleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteBranchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteBranchResponse copyWith(void Function(DeleteBranchResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteBranchResponse))
          as DeleteBranchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteBranchResponse create() => DeleteBranchResponse._();
  @$core.override
  DeleteBranchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteBranchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteBranchResponse>(create);
  static DeleteBranchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get deleted => $_getBF(0);
  @$pb.TagNumber(1)
  set deleted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeleted() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleted() => $_clearField(1);
}

class GetBranchRequest extends $pb.GeneratedMessage {
  factory GetBranchRequest({
    $core.String? repoId,
    $core.String? name,
  }) {
    final result = create();
    if (repoId != null) result.repoId = repoId;
    if (name != null) result.name = name;
    return result;
  }

  GetBranchRequest._();

  factory GetBranchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBranchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBranchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repoId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBranchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBranchRequest copyWith(void Function(GetBranchRequest) updates) =>
      super.copyWith((message) => updates(message as GetBranchRequest))
          as GetBranchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBranchRequest create() => GetBranchRequest._();
  @$core.override
  GetBranchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBranchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBranchRequest>(create);
  static GetBranchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
