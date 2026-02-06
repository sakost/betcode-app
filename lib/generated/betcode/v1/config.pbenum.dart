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

class McpServerStatus extends $pb.ProtobufEnum {
  static const McpServerStatus MCP_SERVER_STATUS_UNSPECIFIED =
      McpServerStatus._(
          0, _omitEnumNames ? '' : 'MCP_SERVER_STATUS_UNSPECIFIED');
  static const McpServerStatus MCP_SERVER_STATUS_RUNNING =
      McpServerStatus._(1, _omitEnumNames ? '' : 'MCP_SERVER_STATUS_RUNNING');
  static const McpServerStatus MCP_SERVER_STATUS_STOPPED =
      McpServerStatus._(2, _omitEnumNames ? '' : 'MCP_SERVER_STATUS_STOPPED');
  static const McpServerStatus MCP_SERVER_STATUS_STARTING =
      McpServerStatus._(3, _omitEnumNames ? '' : 'MCP_SERVER_STATUS_STARTING');
  static const McpServerStatus MCP_SERVER_STATUS_ERROR =
      McpServerStatus._(4, _omitEnumNames ? '' : 'MCP_SERVER_STATUS_ERROR');

  static const $core.List<McpServerStatus> values = <McpServerStatus>[
    MCP_SERVER_STATUS_UNSPECIFIED,
    MCP_SERVER_STATUS_RUNNING,
    MCP_SERVER_STATUS_STOPPED,
    MCP_SERVER_STATUS_STARTING,
    MCP_SERVER_STATUS_ERROR,
  ];

  static final $core.List<McpServerStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static McpServerStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const McpServerStatus._(super.value, super.name);
}

class PermissionAction extends $pb.ProtobufEnum {
  static const PermissionAction PERMISSION_ACTION_UNSPECIFIED =
      PermissionAction._(
          0, _omitEnumNames ? '' : 'PERMISSION_ACTION_UNSPECIFIED');
  static const PermissionAction PERMISSION_ACTION_ALLOW =
      PermissionAction._(1, _omitEnumNames ? '' : 'PERMISSION_ACTION_ALLOW');
  static const PermissionAction PERMISSION_ACTION_DENY =
      PermissionAction._(2, _omitEnumNames ? '' : 'PERMISSION_ACTION_DENY');
  static const PermissionAction PERMISSION_ACTION_ASK =
      PermissionAction._(3, _omitEnumNames ? '' : 'PERMISSION_ACTION_ASK');
  static const PermissionAction PERMISSION_ACTION_ASK_SESSION =
      PermissionAction._(
          4, _omitEnumNames ? '' : 'PERMISSION_ACTION_ASK_SESSION');

  static const $core.List<PermissionAction> values = <PermissionAction>[
    PERMISSION_ACTION_UNSPECIFIED,
    PERMISSION_ACTION_ALLOW,
    PERMISSION_ACTION_DENY,
    PERMISSION_ACTION_ASK,
    PERMISSION_ACTION_ASK_SESSION,
  ];

  static final $core.List<PermissionAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PermissionAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PermissionAction._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
