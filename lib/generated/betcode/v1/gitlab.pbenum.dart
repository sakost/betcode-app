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

import 'package:protobuf/protobuf.dart' as $pb;

class MergeRequestState extends $pb.ProtobufEnum {
  static const MergeRequestState MERGE_REQUEST_STATE_UNSPECIFIED =
      MergeRequestState._(
          0, _omitEnumNames ? '' : 'MERGE_REQUEST_STATE_UNSPECIFIED');
  static const MergeRequestState MERGE_REQUEST_STATE_OPENED =
      MergeRequestState._(
          1, _omitEnumNames ? '' : 'MERGE_REQUEST_STATE_OPENED');
  static const MergeRequestState MERGE_REQUEST_STATE_CLOSED =
      MergeRequestState._(
          2, _omitEnumNames ? '' : 'MERGE_REQUEST_STATE_CLOSED');
  static const MergeRequestState MERGE_REQUEST_STATE_MERGED =
      MergeRequestState._(
          3, _omitEnumNames ? '' : 'MERGE_REQUEST_STATE_MERGED');
  static const MergeRequestState MERGE_REQUEST_STATE_LOCKED =
      MergeRequestState._(
          4, _omitEnumNames ? '' : 'MERGE_REQUEST_STATE_LOCKED');

  static const $core.List<MergeRequestState> values = <MergeRequestState>[
    MERGE_REQUEST_STATE_UNSPECIFIED,
    MERGE_REQUEST_STATE_OPENED,
    MERGE_REQUEST_STATE_CLOSED,
    MERGE_REQUEST_STATE_MERGED,
    MERGE_REQUEST_STATE_LOCKED,
  ];

  static final $core.List<MergeRequestState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MergeRequestState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MergeRequestState._(super.value, super.name);
}

class PipelineStatus extends $pb.ProtobufEnum {
  static const PipelineStatus PIPELINE_STATUS_UNSPECIFIED =
      PipelineStatus._(0, _omitEnumNames ? '' : 'PIPELINE_STATUS_UNSPECIFIED');
  static const PipelineStatus PIPELINE_STATUS_CREATED =
      PipelineStatus._(1, _omitEnumNames ? '' : 'PIPELINE_STATUS_CREATED');
  static const PipelineStatus PIPELINE_STATUS_WAITING_FOR_RESOURCE =
      PipelineStatus._(
          2, _omitEnumNames ? '' : 'PIPELINE_STATUS_WAITING_FOR_RESOURCE');
  static const PipelineStatus PIPELINE_STATUS_PREPARING =
      PipelineStatus._(3, _omitEnumNames ? '' : 'PIPELINE_STATUS_PREPARING');
  static const PipelineStatus PIPELINE_STATUS_PENDING =
      PipelineStatus._(4, _omitEnumNames ? '' : 'PIPELINE_STATUS_PENDING');
  static const PipelineStatus PIPELINE_STATUS_RUNNING =
      PipelineStatus._(5, _omitEnumNames ? '' : 'PIPELINE_STATUS_RUNNING');
  static const PipelineStatus PIPELINE_STATUS_SUCCESS =
      PipelineStatus._(6, _omitEnumNames ? '' : 'PIPELINE_STATUS_SUCCESS');
  static const PipelineStatus PIPELINE_STATUS_FAILED =
      PipelineStatus._(7, _omitEnumNames ? '' : 'PIPELINE_STATUS_FAILED');
  static const PipelineStatus PIPELINE_STATUS_CANCELED =
      PipelineStatus._(8, _omitEnumNames ? '' : 'PIPELINE_STATUS_CANCELED');
  static const PipelineStatus PIPELINE_STATUS_SKIPPED =
      PipelineStatus._(9, _omitEnumNames ? '' : 'PIPELINE_STATUS_SKIPPED');
  static const PipelineStatus PIPELINE_STATUS_MANUAL =
      PipelineStatus._(10, _omitEnumNames ? '' : 'PIPELINE_STATUS_MANUAL');
  static const PipelineStatus PIPELINE_STATUS_SCHEDULED =
      PipelineStatus._(11, _omitEnumNames ? '' : 'PIPELINE_STATUS_SCHEDULED');

  static const $core.List<PipelineStatus> values = <PipelineStatus>[
    PIPELINE_STATUS_UNSPECIFIED,
    PIPELINE_STATUS_CREATED,
    PIPELINE_STATUS_WAITING_FOR_RESOURCE,
    PIPELINE_STATUS_PREPARING,
    PIPELINE_STATUS_PENDING,
    PIPELINE_STATUS_RUNNING,
    PIPELINE_STATUS_SUCCESS,
    PIPELINE_STATUS_FAILED,
    PIPELINE_STATUS_CANCELED,
    PIPELINE_STATUS_SKIPPED,
    PIPELINE_STATUS_MANUAL,
    PIPELINE_STATUS_SCHEDULED,
  ];

  static final $core.List<PipelineStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 11);
  static PipelineStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PipelineStatus._(super.value, super.name);
}

class MergeStatus extends $pb.ProtobufEnum {
  static const MergeStatus MERGE_STATUS_UNSPECIFIED =
      MergeStatus._(0, _omitEnumNames ? '' : 'MERGE_STATUS_UNSPECIFIED');
  static const MergeStatus MERGE_STATUS_CAN_BE_MERGED =
      MergeStatus._(1, _omitEnumNames ? '' : 'MERGE_STATUS_CAN_BE_MERGED');
  static const MergeStatus MERGE_STATUS_CANNOT_BE_MERGED =
      MergeStatus._(2, _omitEnumNames ? '' : 'MERGE_STATUS_CANNOT_BE_MERGED');
  static const MergeStatus MERGE_STATUS_CHECKING =
      MergeStatus._(3, _omitEnumNames ? '' : 'MERGE_STATUS_CHECKING');
  static const MergeStatus MERGE_STATUS_UNCHECKED =
      MergeStatus._(4, _omitEnumNames ? '' : 'MERGE_STATUS_UNCHECKED');

  static const $core.List<MergeStatus> values = <MergeStatus>[
    MERGE_STATUS_UNSPECIFIED,
    MERGE_STATUS_CAN_BE_MERGED,
    MERGE_STATUS_CANNOT_BE_MERGED,
    MERGE_STATUS_CHECKING,
    MERGE_STATUS_UNCHECKED,
  ];

  static final $core.List<MergeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MergeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MergeStatus._(super.value, super.name);
}

class IssueState extends $pb.ProtobufEnum {
  static const IssueState ISSUE_STATE_UNSPECIFIED =
      IssueState._(0, _omitEnumNames ? '' : 'ISSUE_STATE_UNSPECIFIED');
  static const IssueState ISSUE_STATE_OPENED =
      IssueState._(1, _omitEnumNames ? '' : 'ISSUE_STATE_OPENED');
  static const IssueState ISSUE_STATE_CLOSED =
      IssueState._(2, _omitEnumNames ? '' : 'ISSUE_STATE_CLOSED');

  static const $core.List<IssueState> values = <IssueState>[
    ISSUE_STATE_UNSPECIFIED,
    ISSUE_STATE_OPENED,
    ISSUE_STATE_CLOSED,
  ];

  static final $core.List<IssueState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static IssueState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IssueState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
