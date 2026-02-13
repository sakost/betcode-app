// This is a generated file - do not edit.
//
// Generated from betcode/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use permissionDecisionDescriptor instead')
const PermissionDecision$json = {
  '1': 'PermissionDecision',
  '2': [
    {'1': 'PERMISSION_DECISION_UNSPECIFIED', '2': 0},
    {'1': 'PERMISSION_DECISION_ALLOW_ONCE', '2': 1},
    {'1': 'PERMISSION_DECISION_ALLOW_SESSION', '2': 2},
    {'1': 'PERMISSION_DECISION_DENY', '2': 3},
    {'1': 'PERMISSION_DECISION_ALLOW_WITH_EDIT', '2': 4},
    {'1': 'PERMISSION_DECISION_DENY_NO_INTERRUPT', '2': 5},
    {'1': 'PERMISSION_DECISION_DENY_WITH_INTERRUPT', '2': 6},
  ],
};

/// Descriptor for `PermissionDecision`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List permissionDecisionDescriptor = $convert.base64Decode(
    'ChJQZXJtaXNzaW9uRGVjaXNpb24SIwofUEVSTUlTU0lPTl9ERUNJU0lPTl9VTlNQRUNJRklFRB'
    'AAEiIKHlBFUk1JU1NJT05fREVDSVNJT05fQUxMT1dfT05DRRABEiUKIVBFUk1JU1NJT05fREVD'
    'SVNJT05fQUxMT1dfU0VTU0lPThACEhwKGFBFUk1JU1NJT05fREVDSVNJT05fREVOWRADEicKI1'
    'BFUk1JU1NJT05fREVDSVNJT05fQUxMT1dfV0lUSF9FRElUEAQSKQolUEVSTUlTU0lPTl9ERUNJ'
    'U0lPTl9ERU5ZX05PX0lOVEVSUlVQVBAFEisKJ1BFUk1JU1NJT05fREVDSVNJT05fREVOWV9XSV'
    'RIX0lOVEVSUlVQVBAG');

@$core.Deprecated('Use todoStatusDescriptor instead')
const TodoStatus$json = {
  '1': 'TodoStatus',
  '2': [
    {'1': 'TODO_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TODO_STATUS_PENDING', '2': 1},
    {'1': 'TODO_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'TODO_STATUS_COMPLETED', '2': 3},
  ],
};

/// Descriptor for `TodoStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List todoStatusDescriptor = $convert.base64Decode(
    'CgpUb2RvU3RhdHVzEhsKF1RPRE9fU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTVE9ET19TVEFUVV'
    'NfUEVORElORxABEhsKF1RPRE9fU1RBVFVTX0lOX1BST0dSRVNTEAISGQoVVE9ET19TVEFUVVNf'
    'Q09NUExFVEVEEAM=');

@$core.Deprecated('Use agentStatusDescriptor instead')
const AgentStatus$json = {
  '1': 'AgentStatus',
  '2': [
    {'1': 'AGENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_STATUS_THINKING', '2': 1},
    {'1': 'AGENT_STATUS_EXECUTING_TOOL', '2': 2},
    {'1': 'AGENT_STATUS_WAITING_FOR_USER', '2': 3},
    {'1': 'AGENT_STATUS_IDLE', '2': 4},
    {'1': 'AGENT_STATUS_COMPACTING', '2': 5},
    {'1': 'AGENT_STATUS_ERROR', '2': 6},
  ],
};

/// Descriptor for `AgentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentStatusDescriptor = $convert.base64Decode(
    'CgtBZ2VudFN0YXR1cxIcChhBR0VOVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVBR0VOVF9TVE'
    'FUVVNfVEhJTktJTkcQARIfChtBR0VOVF9TVEFUVVNfRVhFQ1VUSU5HX1RPT0wQAhIhCh1BR0VO'
    'VF9TVEFUVVNfV0FJVElOR19GT1JfVVNFUhADEhUKEUFHRU5UX1NUQVRVU19JRExFEAQSGwoXQU'
    'dFTlRfU1RBVFVTX0NPTVBBQ1RJTkcQBRIWChJBR0VOVF9TVEFUVVNfRVJST1IQBg==');

@$core.Deprecated('Use todoItemDescriptor instead')
const TodoItem$json = {
  '1': 'TodoItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'subject', '3': 2, '4': 1, '5': 9, '10': 'subject'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'active_form', '3': 4, '4': 1, '5': 9, '10': 'activeForm'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.TodoStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `TodoItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List todoItemDescriptor = $convert.base64Decode(
    'CghUb2RvSXRlbRIOCgJpZBgBIAEoCVICaWQSGAoHc3ViamVjdBgCIAEoCVIHc3ViamVjdBIgCg'
    'tkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SHwoLYWN0aXZlX2Zvcm0YBCABKAlSCmFj'
    'dGl2ZUZvcm0SLgoGc3RhdHVzGAUgASgOMhYuYmV0Y29kZS52MS5Ub2RvU3RhdHVzUgZzdGF0dX'
    'M=');

@$core.Deprecated('Use questionOptionDescriptor instead')
const QuestionOption$json = {
  '1': 'QuestionOption',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `QuestionOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List questionOptionDescriptor = $convert.base64Decode(
    'Cg5RdWVzdGlvbk9wdGlvbhIUCgV2YWx1ZRgBIAEoCVIFdmFsdWUSFAoFbGFiZWwYAiABKAlSBW'
    'xhYmVsEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use attachmentDescriptor instead')
const Attachment$json = {
  '1': 'Attachment',
  '2': [
    {'1': 'filename', '3': 1, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Attachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachmentDescriptor = $convert.base64Decode(
    'CgpBdHRhY2htZW50EhoKCGZpbGVuYW1lGAEgASgJUghmaWxlbmFtZRIbCgltaW1lX3R5cGUYAi'
    'ABKAlSCG1pbWVUeXBlEhIKBGRhdGEYAyABKAxSBGRhdGE=');
