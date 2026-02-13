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

import 'package:protobuf/protobuf.dart' as $pb;

/// CommandCategory identifies the source type of a command.
class CommandCategory extends $pb.ProtobufEnum {
  static const CommandCategory COMMAND_CATEGORY_UNSPECIFIED = CommandCategory._(
      0, _omitEnumNames ? '' : 'COMMAND_CATEGORY_UNSPECIFIED');
  static const CommandCategory COMMAND_CATEGORY_SERVICE =
      CommandCategory._(1, _omitEnumNames ? '' : 'COMMAND_CATEGORY_SERVICE');
  static const CommandCategory COMMAND_CATEGORY_CLAUDE_CODE = CommandCategory._(
      2, _omitEnumNames ? '' : 'COMMAND_CATEGORY_CLAUDE_CODE');
  static const CommandCategory COMMAND_CATEGORY_PLUGIN =
      CommandCategory._(3, _omitEnumNames ? '' : 'COMMAND_CATEGORY_PLUGIN');

  static const $core.List<CommandCategory> values = <CommandCategory>[
    COMMAND_CATEGORY_UNSPECIFIED,
    COMMAND_CATEGORY_SERVICE,
    COMMAND_CATEGORY_CLAUDE_CODE,
    COMMAND_CATEGORY_PLUGIN,
  ];

  static final $core.List<CommandCategory?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CommandCategory? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommandCategory._(super.value, super.name);
}

/// ExecutionMode describes how a command is executed.
class ExecutionMode extends $pb.ProtobufEnum {
  static const ExecutionMode EXECUTION_MODE_UNSPECIFIED =
      ExecutionMode._(0, _omitEnumNames ? '' : 'EXECUTION_MODE_UNSPECIFIED');
  static const ExecutionMode EXECUTION_MODE_LOCAL =
      ExecutionMode._(1, _omitEnumNames ? '' : 'EXECUTION_MODE_LOCAL');
  static const ExecutionMode EXECUTION_MODE_PASSTHROUGH =
      ExecutionMode._(2, _omitEnumNames ? '' : 'EXECUTION_MODE_PASSTHROUGH');
  static const ExecutionMode EXECUTION_MODE_PLUGIN =
      ExecutionMode._(3, _omitEnumNames ? '' : 'EXECUTION_MODE_PLUGIN');

  static const $core.List<ExecutionMode> values = <ExecutionMode>[
    EXECUTION_MODE_UNSPECIFIED,
    EXECUTION_MODE_LOCAL,
    EXECUTION_MODE_PASSTHROUGH,
    EXECUTION_MODE_PLUGIN,
  ];

  static final $core.List<ExecutionMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ExecutionMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExecutionMode._(super.value, super.name);
}

/// AgentKind identifies the type of agent.
class AgentKind extends $pb.ProtobufEnum {
  static const AgentKind AGENT_KIND_UNSPECIFIED =
      AgentKind._(0, _omitEnumNames ? '' : 'AGENT_KIND_UNSPECIFIED');
  static const AgentKind AGENT_KIND_CLAUDE_INTERNAL =
      AgentKind._(1, _omitEnumNames ? '' : 'AGENT_KIND_CLAUDE_INTERNAL');
  static const AgentKind AGENT_KIND_DAEMON_ORCHESTRATED =
      AgentKind._(2, _omitEnumNames ? '' : 'AGENT_KIND_DAEMON_ORCHESTRATED');
  static const AgentKind AGENT_KIND_TEAM_MEMBER =
      AgentKind._(3, _omitEnumNames ? '' : 'AGENT_KIND_TEAM_MEMBER');

  static const $core.List<AgentKind> values = <AgentKind>[
    AGENT_KIND_UNSPECIFIED,
    AGENT_KIND_CLAUDE_INTERNAL,
    AGENT_KIND_DAEMON_ORCHESTRATED,
    AGENT_KIND_TEAM_MEMBER,
  ];

  static final $core.List<AgentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AgentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentKind._(super.value, super.name);
}

/// CommandAgentStatus represents the status of an agent in the command system.
/// Note: This is separate from common.proto's AgentStatus which tracks
/// the agent's runtime state (thinking, executing, etc.).
class CommandAgentStatus extends $pb.ProtobufEnum {
  static const CommandAgentStatus COMMAND_AGENT_STATUS_UNSPECIFIED =
      CommandAgentStatus._(
          0, _omitEnumNames ? '' : 'COMMAND_AGENT_STATUS_UNSPECIFIED');
  static const CommandAgentStatus COMMAND_AGENT_STATUS_IDLE =
      CommandAgentStatus._(
          1, _omitEnumNames ? '' : 'COMMAND_AGENT_STATUS_IDLE');
  static const CommandAgentStatus COMMAND_AGENT_STATUS_WORKING =
      CommandAgentStatus._(
          2, _omitEnumNames ? '' : 'COMMAND_AGENT_STATUS_WORKING');
  static const CommandAgentStatus COMMAND_AGENT_STATUS_DONE =
      CommandAgentStatus._(
          3, _omitEnumNames ? '' : 'COMMAND_AGENT_STATUS_DONE');
  static const CommandAgentStatus COMMAND_AGENT_STATUS_FAILED =
      CommandAgentStatus._(
          4, _omitEnumNames ? '' : 'COMMAND_AGENT_STATUS_FAILED');

  static const $core.List<CommandAgentStatus> values = <CommandAgentStatus>[
    COMMAND_AGENT_STATUS_UNSPECIFIED,
    COMMAND_AGENT_STATUS_IDLE,
    COMMAND_AGENT_STATUS_WORKING,
    COMMAND_AGENT_STATUS_DONE,
    COMMAND_AGENT_STATUS_FAILED,
  ];

  static final $core.List<CommandAgentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommandAgentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommandAgentStatus._(super.value, super.name);
}

/// PathKind identifies the type of a filesystem entry.
class PathKind extends $pb.ProtobufEnum {
  static const PathKind PATH_KIND_UNSPECIFIED =
      PathKind._(0, _omitEnumNames ? '' : 'PATH_KIND_UNSPECIFIED');
  static const PathKind PATH_KIND_FILE =
      PathKind._(1, _omitEnumNames ? '' : 'PATH_KIND_FILE');
  static const PathKind PATH_KIND_DIRECTORY =
      PathKind._(2, _omitEnumNames ? '' : 'PATH_KIND_DIRECTORY');
  static const PathKind PATH_KIND_SYMLINK =
      PathKind._(3, _omitEnumNames ? '' : 'PATH_KIND_SYMLINK');

  static const $core.List<PathKind> values = <PathKind>[
    PATH_KIND_UNSPECIFIED,
    PATH_KIND_FILE,
    PATH_KIND_DIRECTORY,
    PATH_KIND_SYMLINK,
  ];

  static final $core.List<PathKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PathKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PathKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
