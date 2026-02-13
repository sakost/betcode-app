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

/// Worktree storage mode for a repository.
class WorktreeMode extends $pb.ProtobufEnum {
  /// Default / unset — server treats as GLOBAL.
  static const WorktreeMode WORKTREE_MODE_UNSPECIFIED =
      WorktreeMode._(0, _omitEnumNames ? '' : 'WORKTREE_MODE_UNSPECIFIED');

  /// Worktrees stored in a global shared directory.
  static const WorktreeMode WORKTREE_MODE_GLOBAL =
      WorktreeMode._(1, _omitEnumNames ? '' : 'WORKTREE_MODE_GLOBAL');

  /// Worktrees stored inside the repository directory.
  static const WorktreeMode WORKTREE_MODE_LOCAL =
      WorktreeMode._(2, _omitEnumNames ? '' : 'WORKTREE_MODE_LOCAL');

  /// Worktrees stored in a user-specified custom path.
  static const WorktreeMode WORKTREE_MODE_CUSTOM =
      WorktreeMode._(3, _omitEnumNames ? '' : 'WORKTREE_MODE_CUSTOM');

  static const $core.List<WorktreeMode> values = <WorktreeMode>[
    WORKTREE_MODE_UNSPECIFIED,
    WORKTREE_MODE_GLOBAL,
    WORKTREE_MODE_LOCAL,
    WORKTREE_MODE_CUSTOM,
  ];

  static final $core.List<WorktreeMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static WorktreeMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorktreeMode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
