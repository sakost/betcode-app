// This is a generated file - do not edit.
//
// Generated from betcode/v1/gitlab.proto.

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

import 'gitlab.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'gitlab.pbenum.dart';

class MergeRequestInfo extends $pb.GeneratedMessage {
  factory MergeRequestInfo({
    $fixnum.Int64? id,
    $fixnum.Int64? iid,
    $core.String? title,
    $core.String? description,
    MergeRequestState? state,
    $core.String? sourceBranch,
    $core.String? targetBranch,
    $core.String? author,
    $core.Iterable<$core.String>? labels,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? webUrl,
    $core.bool? draft,
    MergeStatus? mergeStatus,
    $core.String? assignee,
    $core.Iterable<$core.String>? assignees,
    $core.Iterable<$core.String>? reviewers,
    $core.String? milestone,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (iid != null) result.iid = iid;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (state != null) result.state = state;
    if (sourceBranch != null) result.sourceBranch = sourceBranch;
    if (targetBranch != null) result.targetBranch = targetBranch;
    if (author != null) result.author = author;
    if (labels != null) result.labels.addAll(labels);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (webUrl != null) result.webUrl = webUrl;
    if (draft != null) result.draft = draft;
    if (mergeStatus != null) result.mergeStatus = mergeStatus;
    if (assignee != null) result.assignee = assignee;
    if (assignees != null) result.assignees.addAll(assignees);
    if (reviewers != null) result.reviewers.addAll(reviewers);
    if (milestone != null) result.milestone = milestone;
    return result;
  }

  MergeRequestInfo._();

  factory MergeRequestInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MergeRequestInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MergeRequestInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'iid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aE<MergeRequestState>(5, _omitFieldNames ? '' : 'state',
        enumValues: MergeRequestState.values)
    ..aOS(6, _omitFieldNames ? '' : 'sourceBranch')
    ..aOS(7, _omitFieldNames ? '' : 'targetBranch')
    ..aOS(8, _omitFieldNames ? '' : 'author')
    ..pPS(9, _omitFieldNames ? '' : 'labels')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'webUrl')
    ..aOB(13, _omitFieldNames ? '' : 'draft')
    ..aE<MergeStatus>(14, _omitFieldNames ? '' : 'mergeStatus',
        enumValues: MergeStatus.values)
    ..aOS(15, _omitFieldNames ? '' : 'assignee')
    ..pPS(16, _omitFieldNames ? '' : 'assignees')
    ..pPS(17, _omitFieldNames ? '' : 'reviewers')
    ..aOS(18, _omitFieldNames ? '' : 'milestone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergeRequestInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergeRequestInfo copyWith(void Function(MergeRequestInfo) updates) =>
      super.copyWith((message) => updates(message as MergeRequestInfo))
          as MergeRequestInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MergeRequestInfo create() => MergeRequestInfo._();
  @$core.override
  MergeRequestInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MergeRequestInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MergeRequestInfo>(create);
  static MergeRequestInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iid => $_getI64(1);
  @$pb.TagNumber(2)
  set iid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  MergeRequestState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(MergeRequestState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceBranch => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceBranch($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceBranch() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceBranch() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get targetBranch => $_getSZ(6);
  @$pb.TagNumber(7)
  set targetBranch($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetBranch() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetBranch() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get author => $_getSZ(7);
  @$pb.TagNumber(8)
  set author($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthor() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthor() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get labels => $_getList(8);

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
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get webUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set webUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWebUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearWebUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get draft => $_getBF(12);
  @$pb.TagNumber(13)
  set draft($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDraft() => $_has(12);
  @$pb.TagNumber(13)
  void clearDraft() => $_clearField(13);

  @$pb.TagNumber(14)
  MergeStatus get mergeStatus => $_getN(13);
  @$pb.TagNumber(14)
  set mergeStatus(MergeStatus value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasMergeStatus() => $_has(13);
  @$pb.TagNumber(14)
  void clearMergeStatus() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get assignee => $_getSZ(14);
  @$pb.TagNumber(15)
  set assignee($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAssignee() => $_has(14);
  @$pb.TagNumber(15)
  void clearAssignee() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get assignees => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<$core.String> get reviewers => $_getList(16);

  @$pb.TagNumber(18)
  $core.String get milestone => $_getSZ(17);
  @$pb.TagNumber(18)
  set milestone($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasMilestone() => $_has(17);
  @$pb.TagNumber(18)
  void clearMilestone() => $_clearField(18);
}

class ListMergeRequestsRequest extends $pb.GeneratedMessage {
  factory ListMergeRequestsRequest({
    $core.String? project,
    MergeRequestState? stateFilter,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (stateFilter != null) result.stateFilter = stateFilter;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListMergeRequestsRequest._();

  factory ListMergeRequestsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMergeRequestsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMergeRequestsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..aE<MergeRequestState>(2, _omitFieldNames ? '' : 'stateFilter',
        enumValues: MergeRequestState.values)
    ..aI(3, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMergeRequestsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMergeRequestsRequest copyWith(
          void Function(ListMergeRequestsRequest) updates) =>
      super.copyWith((message) => updates(message as ListMergeRequestsRequest))
          as ListMergeRequestsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMergeRequestsRequest create() => ListMergeRequestsRequest._();
  @$core.override
  ListMergeRequestsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMergeRequestsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMergeRequestsRequest>(create);
  static ListMergeRequestsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  MergeRequestState get stateFilter => $_getN(1);
  @$pb.TagNumber(2)
  set stateFilter(MergeRequestState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStateFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStateFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListMergeRequestsResponse extends $pb.GeneratedMessage {
  factory ListMergeRequestsResponse({
    $core.Iterable<MergeRequestInfo>? mergeRequests,
    $core.int? total,
  }) {
    final result = create();
    if (mergeRequests != null) result.mergeRequests.addAll(mergeRequests);
    if (total != null) result.total = total;
    return result;
  }

  ListMergeRequestsResponse._();

  factory ListMergeRequestsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMergeRequestsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMergeRequestsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<MergeRequestInfo>(1, _omitFieldNames ? '' : 'mergeRequests',
        subBuilder: MergeRequestInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMergeRequestsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMergeRequestsResponse copyWith(
          void Function(ListMergeRequestsResponse) updates) =>
      super.copyWith((message) => updates(message as ListMergeRequestsResponse))
          as ListMergeRequestsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMergeRequestsResponse create() => ListMergeRequestsResponse._();
  @$core.override
  ListMergeRequestsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMergeRequestsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMergeRequestsResponse>(create);
  static ListMergeRequestsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MergeRequestInfo> get mergeRequests => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetMergeRequestRequest extends $pb.GeneratedMessage {
  factory GetMergeRequestRequest({
    $core.String? project,
    $fixnum.Int64? iid,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (iid != null) result.iid = iid;
    return result;
  }

  GetMergeRequestRequest._();

  factory GetMergeRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMergeRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMergeRequestRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'iid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMergeRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMergeRequestRequest copyWith(
          void Function(GetMergeRequestRequest) updates) =>
      super.copyWith((message) => updates(message as GetMergeRequestRequest))
          as GetMergeRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMergeRequestRequest create() => GetMergeRequestRequest._();
  @$core.override
  GetMergeRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMergeRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMergeRequestRequest>(create);
  static GetMergeRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iid => $_getI64(1);
  @$pb.TagNumber(2)
  set iid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIid() => $_clearField(2);
}

class GetMergeRequestResponse extends $pb.GeneratedMessage {
  factory GetMergeRequestResponse({
    MergeRequestInfo? mergeRequest,
  }) {
    final result = create();
    if (mergeRequest != null) result.mergeRequest = mergeRequest;
    return result;
  }

  GetMergeRequestResponse._();

  factory GetMergeRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMergeRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMergeRequestResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<MergeRequestInfo>(1, _omitFieldNames ? '' : 'mergeRequest',
        subBuilder: MergeRequestInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMergeRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMergeRequestResponse copyWith(
          void Function(GetMergeRequestResponse) updates) =>
      super.copyWith((message) => updates(message as GetMergeRequestResponse))
          as GetMergeRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMergeRequestResponse create() => GetMergeRequestResponse._();
  @$core.override
  GetMergeRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMergeRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMergeRequestResponse>(create);
  static GetMergeRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MergeRequestInfo get mergeRequest => $_getN(0);
  @$pb.TagNumber(1)
  set mergeRequest(MergeRequestInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMergeRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearMergeRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  MergeRequestInfo ensureMergeRequest() => $_ensure(0);
}

class PipelineInfo extends $pb.GeneratedMessage {
  factory PipelineInfo({
    $fixnum.Int64? id,
    PipelineStatus? status,
    $core.String? refName,
    $core.String? sha,
    $core.String? source,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? webUrl,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (status != null) result.status = status;
    if (refName != null) result.refName = refName;
    if (sha != null) result.sha = sha;
    if (source != null) result.source = source;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (webUrl != null) result.webUrl = webUrl;
    return result;
  }

  PipelineInfo._();

  factory PipelineInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PipelineInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PipelineInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<PipelineStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: PipelineStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'refName')
    ..aOS(4, _omitFieldNames ? '' : 'sha')
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'webUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PipelineInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PipelineInfo copyWith(void Function(PipelineInfo) updates) =>
      super.copyWith((message) => updates(message as PipelineInfo))
          as PipelineInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PipelineInfo create() => PipelineInfo._();
  @$core.override
  PipelineInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PipelineInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PipelineInfo>(create);
  static PipelineInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  PipelineStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(PipelineStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refName => $_getSZ(2);
  @$pb.TagNumber(3)
  set refName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sha => $_getSZ(3);
  @$pb.TagNumber(4)
  set sha($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSha() => $_has(3);
  @$pb.TagNumber(4)
  void clearSha() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureUpdatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get webUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set webUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWebUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearWebUrl() => $_clearField(8);
}

class ListPipelinesRequest extends $pb.GeneratedMessage {
  factory ListPipelinesRequest({
    $core.String? project,
    PipelineStatus? statusFilter,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListPipelinesRequest._();

  factory ListPipelinesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPipelinesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPipelinesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..aE<PipelineStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: PipelineStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPipelinesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPipelinesRequest copyWith(void Function(ListPipelinesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPipelinesRequest))
          as ListPipelinesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPipelinesRequest create() => ListPipelinesRequest._();
  @$core.override
  ListPipelinesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPipelinesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPipelinesRequest>(create);
  static ListPipelinesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  PipelineStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(PipelineStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListPipelinesResponse extends $pb.GeneratedMessage {
  factory ListPipelinesResponse({
    $core.Iterable<PipelineInfo>? pipelines,
    $core.int? total,
  }) {
    final result = create();
    if (pipelines != null) result.pipelines.addAll(pipelines);
    if (total != null) result.total = total;
    return result;
  }

  ListPipelinesResponse._();

  factory ListPipelinesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPipelinesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPipelinesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<PipelineInfo>(1, _omitFieldNames ? '' : 'pipelines',
        subBuilder: PipelineInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPipelinesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPipelinesResponse copyWith(
          void Function(ListPipelinesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPipelinesResponse))
          as ListPipelinesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPipelinesResponse create() => ListPipelinesResponse._();
  @$core.override
  ListPipelinesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPipelinesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPipelinesResponse>(create);
  static ListPipelinesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PipelineInfo> get pipelines => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetPipelineRequest extends $pb.GeneratedMessage {
  factory GetPipelineRequest({
    $core.String? project,
    $fixnum.Int64? pipelineId,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (pipelineId != null) result.pipelineId = pipelineId;
    return result;
  }

  GetPipelineRequest._();

  factory GetPipelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPipelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'pipelineId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineRequest copyWith(void Function(GetPipelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetPipelineRequest))
          as GetPipelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPipelineRequest create() => GetPipelineRequest._();
  @$core.override
  GetPipelineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPipelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineRequest>(create);
  static GetPipelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pipelineId => $_getI64(1);
  @$pb.TagNumber(2)
  set pipelineId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPipelineId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPipelineId() => $_clearField(2);
}

class GetPipelineResponse extends $pb.GeneratedMessage {
  factory GetPipelineResponse({
    PipelineInfo? pipeline,
  }) {
    final result = create();
    if (pipeline != null) result.pipeline = pipeline;
    return result;
  }

  GetPipelineResponse._();

  factory GetPipelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPipelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<PipelineInfo>(1, _omitFieldNames ? '' : 'pipeline',
        subBuilder: PipelineInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineResponse copyWith(void Function(GetPipelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetPipelineResponse))
          as GetPipelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPipelineResponse create() => GetPipelineResponse._();
  @$core.override
  GetPipelineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPipelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineResponse>(create);
  static GetPipelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PipelineInfo get pipeline => $_getN(0);
  @$pb.TagNumber(1)
  set pipeline(PipelineInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPipeline() => $_has(0);
  @$pb.TagNumber(1)
  void clearPipeline() => $_clearField(1);
  @$pb.TagNumber(1)
  PipelineInfo ensurePipeline() => $_ensure(0);
}

class IssueInfo extends $pb.GeneratedMessage {
  factory IssueInfo({
    $fixnum.Int64? id,
    $fixnum.Int64? iid,
    $core.String? title,
    $core.String? description,
    IssueState? state,
    $core.String? author,
    $core.Iterable<$core.String>? labels,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? webUrl,
    $core.bool? confidential,
    $core.String? assignee,
    $core.Iterable<$core.String>? assignees,
    $core.String? milestone,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (iid != null) result.iid = iid;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (state != null) result.state = state;
    if (author != null) result.author = author;
    if (labels != null) result.labels.addAll(labels);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (webUrl != null) result.webUrl = webUrl;
    if (confidential != null) result.confidential = confidential;
    if (assignee != null) result.assignee = assignee;
    if (assignees != null) result.assignees.addAll(assignees);
    if (milestone != null) result.milestone = milestone;
    return result;
  }

  IssueInfo._();

  factory IssueInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'iid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aE<IssueState>(5, _omitFieldNames ? '' : 'state',
        enumValues: IssueState.values)
    ..aOS(6, _omitFieldNames ? '' : 'author')
    ..pPS(7, _omitFieldNames ? '' : 'labels')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'webUrl')
    ..aOB(11, _omitFieldNames ? '' : 'confidential')
    ..aOS(12, _omitFieldNames ? '' : 'assignee')
    ..pPS(13, _omitFieldNames ? '' : 'assignees')
    ..aOS(14, _omitFieldNames ? '' : 'milestone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueInfo copyWith(void Function(IssueInfo) updates) =>
      super.copyWith((message) => updates(message as IssueInfo)) as IssueInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueInfo create() => IssueInfo._();
  @$core.override
  IssueInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IssueInfo>(create);
  static IssueInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iid => $_getI64(1);
  @$pb.TagNumber(2)
  set iid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  IssueState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(IssueState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get author => $_getSZ(5);
  @$pb.TagNumber(6)
  set author($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthor() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthor() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get labels => $_getList(6);

  @$pb.TagNumber(8)
  $1.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureUpdatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get webUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set webUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWebUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearWebUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get confidential => $_getBF(10);
  @$pb.TagNumber(11)
  set confidential($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasConfidential() => $_has(10);
  @$pb.TagNumber(11)
  void clearConfidential() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get assignee => $_getSZ(11);
  @$pb.TagNumber(12)
  set assignee($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAssignee() => $_has(11);
  @$pb.TagNumber(12)
  void clearAssignee() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get assignees => $_getList(12);

  @$pb.TagNumber(14)
  $core.String get milestone => $_getSZ(13);
  @$pb.TagNumber(14)
  set milestone($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasMilestone() => $_has(13);
  @$pb.TagNumber(14)
  void clearMilestone() => $_clearField(14);
}

class ListIssuesRequest extends $pb.GeneratedMessage {
  factory ListIssuesRequest({
    $core.String? project,
    IssueState? stateFilter,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (stateFilter != null) result.stateFilter = stateFilter;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListIssuesRequest._();

  factory ListIssuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIssuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIssuesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..aE<IssueState>(2, _omitFieldNames ? '' : 'stateFilter',
        enumValues: IssueState.values)
    ..aI(3, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesRequest copyWith(void Function(ListIssuesRequest) updates) =>
      super.copyWith((message) => updates(message as ListIssuesRequest))
          as ListIssuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIssuesRequest create() => ListIssuesRequest._();
  @$core.override
  ListIssuesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIssuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIssuesRequest>(create);
  static ListIssuesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  IssueState get stateFilter => $_getN(1);
  @$pb.TagNumber(2)
  set stateFilter(IssueState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStateFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStateFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListIssuesResponse extends $pb.GeneratedMessage {
  factory ListIssuesResponse({
    $core.Iterable<IssueInfo>? issues,
    $core.int? total,
  }) {
    final result = create();
    if (issues != null) result.issues.addAll(issues);
    if (total != null) result.total = total;
    return result;
  }

  ListIssuesResponse._();

  factory ListIssuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIssuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIssuesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<IssueInfo>(1, _omitFieldNames ? '' : 'issues',
        subBuilder: IssueInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesResponse copyWith(void Function(ListIssuesResponse) updates) =>
      super.copyWith((message) => updates(message as ListIssuesResponse))
          as ListIssuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIssuesResponse create() => ListIssuesResponse._();
  @$core.override
  ListIssuesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIssuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIssuesResponse>(create);
  static ListIssuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IssueInfo> get issues => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetIssueRequest extends $pb.GeneratedMessage {
  factory GetIssueRequest({
    $core.String? project,
    $fixnum.Int64? iid,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (iid != null) result.iid = iid;
    return result;
  }

  GetIssueRequest._();

  factory GetIssueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIssueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIssueRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'project')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'iid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIssueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIssueRequest copyWith(void Function(GetIssueRequest) updates) =>
      super.copyWith((message) => updates(message as GetIssueRequest))
          as GetIssueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIssueRequest create() => GetIssueRequest._();
  @$core.override
  GetIssueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIssueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIssueRequest>(create);
  static GetIssueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get project => $_getSZ(0);
  @$pb.TagNumber(1)
  set project($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iid => $_getI64(1);
  @$pb.TagNumber(2)
  set iid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIid() => $_clearField(2);
}

class GetIssueResponse extends $pb.GeneratedMessage {
  factory GetIssueResponse({
    IssueInfo? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  GetIssueResponse._();

  factory GetIssueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIssueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIssueResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<IssueInfo>(1, _omitFieldNames ? '' : 'issue',
        subBuilder: IssueInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIssueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIssueResponse copyWith(void Function(GetIssueResponse) updates) =>
      super.copyWith((message) => updates(message as GetIssueResponse))
          as GetIssueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIssueResponse create() => GetIssueResponse._();
  @$core.override
  GetIssueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIssueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIssueResponse>(create);
  static GetIssueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IssueInfo get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(IssueInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  IssueInfo ensureIssue() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
