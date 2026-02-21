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

import 'package:protobuf/protobuf.dart' as $pb;

/// SubagentStatus represents a subagent's lifecycle state.
class SubagentStatus extends $pb.ProtobufEnum {
  static const SubagentStatus SUBAGENT_STATUS_UNSPECIFIED =
      SubagentStatus._(0, _omitEnumNames ? '' : 'SUBAGENT_STATUS_UNSPECIFIED');
  static const SubagentStatus SUBAGENT_STATUS_PENDING =
      SubagentStatus._(1, _omitEnumNames ? '' : 'SUBAGENT_STATUS_PENDING');
  static const SubagentStatus SUBAGENT_STATUS_RUNNING =
      SubagentStatus._(2, _omitEnumNames ? '' : 'SUBAGENT_STATUS_RUNNING');
  static const SubagentStatus SUBAGENT_STATUS_COMPLETED =
      SubagentStatus._(3, _omitEnumNames ? '' : 'SUBAGENT_STATUS_COMPLETED');
  static const SubagentStatus SUBAGENT_STATUS_FAILED =
      SubagentStatus._(4, _omitEnumNames ? '' : 'SUBAGENT_STATUS_FAILED');
  static const SubagentStatus SUBAGENT_STATUS_CANCELLED =
      SubagentStatus._(5, _omitEnumNames ? '' : 'SUBAGENT_STATUS_CANCELLED');

  static const $core.List<SubagentStatus> values = <SubagentStatus>[
    SUBAGENT_STATUS_UNSPECIFIED,
    SUBAGENT_STATUS_PENDING,
    SUBAGENT_STATUS_RUNNING,
    SUBAGENT_STATUS_COMPLETED,
    SUBAGENT_STATUS_FAILED,
    SUBAGENT_STATUS_CANCELLED,
  ];

  static final $core.List<SubagentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SubagentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubagentStatus._(super.value, super.name);
}

/// OrchestrationStrategy defines how orchestration steps are executed.
class OrchestrationStrategy extends $pb.ProtobufEnum {
  static const OrchestrationStrategy ORCHESTRATION_STRATEGY_UNSPECIFIED =
      OrchestrationStrategy._(
          0, _omitEnumNames ? '' : 'ORCHESTRATION_STRATEGY_UNSPECIFIED');
  static const OrchestrationStrategy ORCHESTRATION_STRATEGY_PARALLEL =
      OrchestrationStrategy._(
          1, _omitEnumNames ? '' : 'ORCHESTRATION_STRATEGY_PARALLEL');
  static const OrchestrationStrategy ORCHESTRATION_STRATEGY_SEQUENTIAL =
      OrchestrationStrategy._(
          2, _omitEnumNames ? '' : 'ORCHESTRATION_STRATEGY_SEQUENTIAL');
  static const OrchestrationStrategy ORCHESTRATION_STRATEGY_DAG =
      OrchestrationStrategy._(
          3, _omitEnumNames ? '' : 'ORCHESTRATION_STRATEGY_DAG');

  static const $core.List<OrchestrationStrategy> values =
      <OrchestrationStrategy>[
    ORCHESTRATION_STRATEGY_UNSPECIFIED,
    ORCHESTRATION_STRATEGY_PARALLEL,
    ORCHESTRATION_STRATEGY_SEQUENTIAL,
    ORCHESTRATION_STRATEGY_DAG,
  ];

  static final $core.List<OrchestrationStrategy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static OrchestrationStrategy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrchestrationStrategy._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
