// This is a generated file - do not edit.
//
// Generated from betcode/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// PermissionDecision represents possible permission decisions.
class PermissionDecision extends $pb.ProtobufEnum {
  static const PermissionDecision PERMISSION_DECISION_UNSPECIFIED =
      PermissionDecision._(
          0, _omitEnumNames ? '' : 'PERMISSION_DECISION_UNSPECIFIED');
  static const PermissionDecision PERMISSION_DECISION_ALLOW_ONCE =
      PermissionDecision._(
          1, _omitEnumNames ? '' : 'PERMISSION_DECISION_ALLOW_ONCE');
  static const PermissionDecision PERMISSION_DECISION_ALLOW_SESSION =
      PermissionDecision._(
          2, _omitEnumNames ? '' : 'PERMISSION_DECISION_ALLOW_SESSION');
  static const PermissionDecision PERMISSION_DECISION_DENY =
      PermissionDecision._(3, _omitEnumNames ? '' : 'PERMISSION_DECISION_DENY');

  /// Allow with modified tool input (Tab → edit input).
  static const PermissionDecision PERMISSION_DECISION_ALLOW_WITH_EDIT =
      PermissionDecision._(
          4, _omitEnumNames ? '' : 'PERMISSION_DECISION_ALLOW_WITH_EDIT');

  /// Deny without interrupting the current turn.
  static const PermissionDecision PERMISSION_DECISION_DENY_NO_INTERRUPT =
      PermissionDecision._(
          5, _omitEnumNames ? '' : 'PERMISSION_DECISION_DENY_NO_INTERRUPT');

  /// Deny and interrupt the current turn.
  static const PermissionDecision PERMISSION_DECISION_DENY_WITH_INTERRUPT =
      PermissionDecision._(
          6, _omitEnumNames ? '' : 'PERMISSION_DECISION_DENY_WITH_INTERRUPT');

  static const $core.List<PermissionDecision> values = <PermissionDecision>[
    PERMISSION_DECISION_UNSPECIFIED,
    PERMISSION_DECISION_ALLOW_ONCE,
    PERMISSION_DECISION_ALLOW_SESSION,
    PERMISSION_DECISION_DENY,
    PERMISSION_DECISION_ALLOW_WITH_EDIT,
    PERMISSION_DECISION_DENY_NO_INTERRUPT,
    PERMISSION_DECISION_DENY_WITH_INTERRUPT,
  ];

  static final $core.List<PermissionDecision?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PermissionDecision? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PermissionDecision._(super.value, super.name);
}

/// TodoStatus represents the state of a todo item.
class TodoStatus extends $pb.ProtobufEnum {
  static const TodoStatus TODO_STATUS_UNSPECIFIED =
      TodoStatus._(0, _omitEnumNames ? '' : 'TODO_STATUS_UNSPECIFIED');
  static const TodoStatus TODO_STATUS_PENDING =
      TodoStatus._(1, _omitEnumNames ? '' : 'TODO_STATUS_PENDING');
  static const TodoStatus TODO_STATUS_IN_PROGRESS =
      TodoStatus._(2, _omitEnumNames ? '' : 'TODO_STATUS_IN_PROGRESS');
  static const TodoStatus TODO_STATUS_COMPLETED =
      TodoStatus._(3, _omitEnumNames ? '' : 'TODO_STATUS_COMPLETED');

  static const $core.List<TodoStatus> values = <TodoStatus>[
    TODO_STATUS_UNSPECIFIED,
    TODO_STATUS_PENDING,
    TODO_STATUS_IN_PROGRESS,
    TODO_STATUS_COMPLETED,
  ];

  static final $core.List<TodoStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TodoStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TodoStatus._(super.value, super.name);
}

/// AgentStatus represents the agent's current state.
class AgentStatus extends $pb.ProtobufEnum {
  static const AgentStatus AGENT_STATUS_UNSPECIFIED =
      AgentStatus._(0, _omitEnumNames ? '' : 'AGENT_STATUS_UNSPECIFIED');
  static const AgentStatus AGENT_STATUS_THINKING =
      AgentStatus._(1, _omitEnumNames ? '' : 'AGENT_STATUS_THINKING');
  static const AgentStatus AGENT_STATUS_EXECUTING_TOOL =
      AgentStatus._(2, _omitEnumNames ? '' : 'AGENT_STATUS_EXECUTING_TOOL');
  static const AgentStatus AGENT_STATUS_WAITING_FOR_USER =
      AgentStatus._(3, _omitEnumNames ? '' : 'AGENT_STATUS_WAITING_FOR_USER');
  static const AgentStatus AGENT_STATUS_IDLE =
      AgentStatus._(4, _omitEnumNames ? '' : 'AGENT_STATUS_IDLE');
  static const AgentStatus AGENT_STATUS_COMPACTING =
      AgentStatus._(5, _omitEnumNames ? '' : 'AGENT_STATUS_COMPACTING');
  static const AgentStatus AGENT_STATUS_ERROR =
      AgentStatus._(6, _omitEnumNames ? '' : 'AGENT_STATUS_ERROR');

  static const $core.List<AgentStatus> values = <AgentStatus>[
    AGENT_STATUS_UNSPECIFIED,
    AGENT_STATUS_THINKING,
    AGENT_STATUS_EXECUTING_TOOL,
    AGENT_STATUS_WAITING_FOR_USER,
    AGENT_STATUS_IDLE,
    AGENT_STATUS_COMPACTING,
    AGENT_STATUS_ERROR,
  ];

  static final $core.List<AgentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static AgentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
