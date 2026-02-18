// This is a generated file - do not edit.
//
// Generated from betcode/v1/subagent.proto.

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

@$core.Deprecated('Use subagentStatusDescriptor instead')
const SubagentStatus$json = {
  '1': 'SubagentStatus',
  '2': [
    {'1': 'SUBAGENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SUBAGENT_STATUS_PENDING', '2': 1},
    {'1': 'SUBAGENT_STATUS_RUNNING', '2': 2},
    {'1': 'SUBAGENT_STATUS_COMPLETED', '2': 3},
    {'1': 'SUBAGENT_STATUS_FAILED', '2': 4},
    {'1': 'SUBAGENT_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `SubagentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subagentStatusDescriptor = $convert.base64Decode(
    'Cg5TdWJhZ2VudFN0YXR1cxIfChtTVUJBR0VOVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdTVU'
    'JBR0VOVF9TVEFUVVNfUEVORElORxABEhsKF1NVQkFHRU5UX1NUQVRVU19SVU5OSU5HEAISHQoZ'
    'U1VCQUdFTlRfU1RBVFVTX0NPTVBMRVRFRBADEhoKFlNVQkFHRU5UX1NUQVRVU19GQUlMRUQQBB'
    'IdChlTVUJBR0VOVF9TVEFUVVNfQ0FOQ0VMTEVEEAU=');

@$core.Deprecated('Use orchestrationStrategyDescriptor instead')
const OrchestrationStrategy$json = {
  '1': 'OrchestrationStrategy',
  '2': [
    {'1': 'ORCHESTRATION_STRATEGY_UNSPECIFIED', '2': 0},
    {'1': 'ORCHESTRATION_STRATEGY_PARALLEL', '2': 1},
    {'1': 'ORCHESTRATION_STRATEGY_SEQUENTIAL', '2': 2},
    {'1': 'ORCHESTRATION_STRATEGY_DAG', '2': 3},
  ],
};

/// Descriptor for `OrchestrationStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orchestrationStrategyDescriptor = $convert.base64Decode(
    'ChVPcmNoZXN0cmF0aW9uU3RyYXRlZ3kSJgoiT1JDSEVTVFJBVElPTl9TVFJBVEVHWV9VTlNQRU'
    'NJRklFRBAAEiMKH09SQ0hFU1RSQVRJT05fU1RSQVRFR1lfUEFSQUxMRUwQARIlCiFPUkNIRVNU'
    'UkFUSU9OX1NUUkFURUdZX1NFUVVFTlRJQUwQAhIeChpPUkNIRVNUUkFUSU9OX1NUUkFURUdZX0'
    'RBRxAD');

@$core.Deprecated('Use spawnSubagentRequestDescriptor instead')
const SpawnSubagentRequest$json = {
  '1': 'SpawnSubagentRequest',
  '2': [
    {'1': 'parent_session_id', '3': 1, '4': 1, '5': 9, '10': 'parentSessionId'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'model', '3': 3, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'working_directory',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'allowed_tools', '3': 5, '4': 3, '5': 9, '10': 'allowedTools'},
    {'1': 'max_turns', '3': 6, '4': 1, '5': 5, '10': 'maxTurns'},
    {
      '1': 'env',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.SpawnSubagentRequest.EnvEntry',
      '10': 'env'
    },
    {'1': 'name', '3': 8, '4': 1, '5': 9, '10': 'name'},
    {'1': 'auto_approve', '3': 9, '4': 1, '5': 8, '10': 'autoApprove'},
  ],
  '3': [SpawnSubagentRequest_EnvEntry$json],
};

@$core.Deprecated('Use spawnSubagentRequestDescriptor instead')
const SpawnSubagentRequest_EnvEntry$json = {
  '1': 'EnvEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SpawnSubagentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spawnSubagentRequestDescriptor = $convert.base64Decode(
    'ChRTcGF3blN1YmFnZW50UmVxdWVzdBIqChFwYXJlbnRfc2Vzc2lvbl9pZBgBIAEoCVIPcGFyZW'
    '50U2Vzc2lvbklkEhYKBnByb21wdBgCIAEoCVIGcHJvbXB0EhQKBW1vZGVsGAMgASgJUgVtb2Rl'
    'bBIrChF3b3JraW5nX2RpcmVjdG9yeRgEIAEoCVIQd29ya2luZ0RpcmVjdG9yeRIjCg1hbGxvd2'
    'VkX3Rvb2xzGAUgAygJUgxhbGxvd2VkVG9vbHMSGwoJbWF4X3R1cm5zGAYgASgFUghtYXhUdXJu'
    'cxI7CgNlbnYYByADKAsyKS5iZXRjb2RlLnYxLlNwYXduU3ViYWdlbnRSZXF1ZXN0LkVudkVudH'
    'J5UgNlbnYSEgoEbmFtZRgIIAEoCVIEbmFtZRIhCgxhdXRvX2FwcHJvdmUYCSABKAhSC2F1dG9B'
    'cHByb3ZlGjYKCEVudkVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YW'
    'x1ZToCOAE=');

@$core.Deprecated('Use spawnSubagentResponseDescriptor instead')
const SpawnSubagentResponse$json = {
  '1': 'SpawnSubagentResponse',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SpawnSubagentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spawnSubagentResponseDescriptor = $convert.base64Decode(
    'ChVTcGF3blN1YmFnZW50UmVzcG9uc2USHwoLc3ViYWdlbnRfaWQYASABKAlSCnN1YmFnZW50SW'
    'QSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use watchSubagentRequestDescriptor instead')
const WatchSubagentRequest$json = {
  '1': 'WatchSubagentRequest',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'from_sequence', '3': 2, '4': 1, '5': 4, '10': 'fromSequence'},
  ],
};

/// Descriptor for `WatchSubagentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchSubagentRequestDescriptor = $convert.base64Decode(
    'ChRXYXRjaFN1YmFnZW50UmVxdWVzdBIfCgtzdWJhZ2VudF9pZBgBIAEoCVIKc3ViYWdlbnRJZB'
    'IjCg1mcm9tX3NlcXVlbmNlGAIgASgEUgxmcm9tU2VxdWVuY2U=');

@$core.Deprecated('Use sendToSubagentRequestDescriptor instead')
const SendToSubagentRequest$json = {
  '1': 'SendToSubagentRequest',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `SendToSubagentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendToSubagentRequestDescriptor = $convert.base64Decode(
    'ChVTZW5kVG9TdWJhZ2VudFJlcXVlc3QSHwoLc3ViYWdlbnRfaWQYASABKAlSCnN1YmFnZW50SW'
    'QSGAoHY29udGVudBgCIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use sendToSubagentResponseDescriptor instead')
const SendToSubagentResponse$json = {
  '1': 'SendToSubagentResponse',
  '2': [
    {'1': 'delivered', '3': 1, '4': 1, '5': 8, '10': 'delivered'},
  ],
};

/// Descriptor for `SendToSubagentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendToSubagentResponseDescriptor =
    $convert.base64Decode(
        'ChZTZW5kVG9TdWJhZ2VudFJlc3BvbnNlEhwKCWRlbGl2ZXJlZBgBIAEoCFIJZGVsaXZlcmVk');

@$core.Deprecated('Use cancelSubagentRequestDescriptor instead')
const CancelSubagentRequest$json = {
  '1': 'CancelSubagentRequest',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'force', '3': 3, '4': 1, '5': 8, '10': 'force'},
    {'1': 'cleanup_worktree', '3': 4, '4': 1, '5': 8, '10': 'cleanupWorktree'},
  ],
};

/// Descriptor for `CancelSubagentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSubagentRequestDescriptor = $convert.base64Decode(
    'ChVDYW5jZWxTdWJhZ2VudFJlcXVlc3QSHwoLc3ViYWdlbnRfaWQYASABKAlSCnN1YmFnZW50SW'
    'QSFgoGcmVhc29uGAIgASgJUgZyZWFzb24SFAoFZm9yY2UYAyABKAhSBWZvcmNlEikKEGNsZWFu'
    'dXBfd29ya3RyZWUYBCABKAhSD2NsZWFudXBXb3JrdHJlZQ==');

@$core.Deprecated('Use cancelSubagentResponseDescriptor instead')
const CancelSubagentResponse$json = {
  '1': 'CancelSubagentResponse',
  '2': [
    {'1': 'cancelled', '3': 1, '4': 1, '5': 8, '10': 'cancelled'},
    {'1': 'final_status', '3': 2, '4': 1, '5': 9, '10': 'finalStatus'},
    {
      '1': 'tool_calls_executed',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'toolCallsExecuted'
    },
    {
      '1': 'tool_calls_auto_approved',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'toolCallsAutoApproved'
    },
  ],
};

/// Descriptor for `CancelSubagentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSubagentResponseDescriptor = $convert.base64Decode(
    'ChZDYW5jZWxTdWJhZ2VudFJlc3BvbnNlEhwKCWNhbmNlbGxlZBgBIAEoCFIJY2FuY2VsbGVkEi'
    'EKDGZpbmFsX3N0YXR1cxgCIAEoCVILZmluYWxTdGF0dXMSLgoTdG9vbF9jYWxsc19leGVjdXRl'
    'ZBgDIAEoBVIRdG9vbENhbGxzRXhlY3V0ZWQSNwoYdG9vbF9jYWxsc19hdXRvX2FwcHJvdmVkGA'
    'QgASgFUhV0b29sQ2FsbHNBdXRvQXBwcm92ZWQ=');

@$core.Deprecated('Use listSubagentsRequestDescriptor instead')
const ListSubagentsRequest$json = {
  '1': 'ListSubagentsRequest',
  '2': [
    {'1': 'parent_session_id', '3': 1, '4': 1, '5': 9, '10': 'parentSessionId'},
    {'1': 'status_filter', '3': 2, '4': 1, '5': 9, '10': 'statusFilter'},
  ],
};

/// Descriptor for `ListSubagentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSubagentsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0U3ViYWdlbnRzUmVxdWVzdBIqChFwYXJlbnRfc2Vzc2lvbl9pZBgBIAEoCVIPcGFyZW'
    '50U2Vzc2lvbklkEiMKDXN0YXR1c19maWx0ZXIYAiABKAlSDHN0YXR1c0ZpbHRlcg==');

@$core.Deprecated('Use listSubagentsResponseDescriptor instead')
const ListSubagentsResponse$json = {
  '1': 'ListSubagentsResponse',
  '2': [
    {
      '1': 'subagents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.SubagentInfo',
      '10': 'subagents'
    },
  ],
};

/// Descriptor for `ListSubagentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSubagentsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0U3ViYWdlbnRzUmVzcG9uc2USNgoJc3ViYWdlbnRzGAEgAygLMhguYmV0Y29kZS52MS'
    '5TdWJhZ2VudEluZm9SCXN1YmFnZW50cw==');

@$core.Deprecated('Use subagentInfoDescriptor instead')
const SubagentInfo$json = {
  '1': 'SubagentInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'parent_session_id', '3': 2, '4': 1, '5': 9, '10': 'parentSessionId'},
    {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'prompt', '3': 5, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'model', '3': 6, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'working_directory',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.SubagentStatus',
      '10': 'status'
    },
    {'1': 'auto_approve', '3': 9, '4': 1, '5': 8, '10': 'autoApprove'},
    {'1': 'max_turns', '3': 10, '4': 1, '5': 5, '10': 'maxTurns'},
    {'1': 'allowed_tools', '3': 11, '4': 3, '5': 9, '10': 'allowedTools'},
    {'1': 'result_summary', '3': 12, '4': 1, '5': 9, '10': 'resultSummary'},
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'completed_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
  ],
};

/// Descriptor for `SubagentInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentInfoDescriptor = $convert.base64Decode(
    'CgxTdWJhZ2VudEluZm8SDgoCaWQYASABKAlSAmlkEioKEXBhcmVudF9zZXNzaW9uX2lkGAIgAS'
    'gJUg9wYXJlbnRTZXNzaW9uSWQSHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklkEhIKBG5h'
    'bWUYBCABKAlSBG5hbWUSFgoGcHJvbXB0GAUgASgJUgZwcm9tcHQSFAoFbW9kZWwYBiABKAlSBW'
    '1vZGVsEisKEXdvcmtpbmdfZGlyZWN0b3J5GAcgASgJUhB3b3JraW5nRGlyZWN0b3J5EjIKBnN0'
    'YXR1cxgIIAEoDjIaLmJldGNvZGUudjEuU3ViYWdlbnRTdGF0dXNSBnN0YXR1cxIhCgxhdXRvX2'
    'FwcHJvdmUYCSABKAhSC2F1dG9BcHByb3ZlEhsKCW1heF90dXJucxgKIAEoBVIIbWF4VHVybnMS'
    'IwoNYWxsb3dlZF90b29scxgLIAMoCVIMYWxsb3dlZFRvb2xzEiUKDnJlc3VsdF9zdW1tYXJ5GA'
    'wgASgJUg1yZXN1bHRTdW1tYXJ5EjkKCmNyZWF0ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgljcmVhdGVkQXQSPQoMY29tcGxldGVkX2F0GA4gASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFILY29tcGxldGVkQXQ=');

@$core.Deprecated('Use subagentEventDescriptor instead')
const SubagentEvent$json = {
  '1': 'SubagentEvent',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'started',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentStarted',
      '9': 0,
      '10': 'started'
    },
    {
      '1': 'output',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentOutput',
      '9': 0,
      '10': 'output'
    },
    {
      '1': 'tool_use',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentToolUse',
      '9': 0,
      '10': 'toolUse'
    },
    {
      '1': 'permission_request',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentPermissionRequest',
      '9': 0,
      '10': 'permissionRequest'
    },
    {
      '1': 'completed',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentCompleted',
      '9': 0,
      '10': 'completed'
    },
    {
      '1': 'failed',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentFailed',
      '9': 0,
      '10': 'failed'
    },
    {
      '1': 'cancelled',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SubagentCancelled',
      '9': 0,
      '10': 'cancelled'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `SubagentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentEventDescriptor = $convert.base64Decode(
    'Cg1TdWJhZ2VudEV2ZW50Eh8KC3N1YmFnZW50X2lkGAEgASgJUgpzdWJhZ2VudElkEjgKCXRpbW'
    'VzdGFtcBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcBI3Cgdz'
    'dGFydGVkGAMgASgLMhsuYmV0Y29kZS52MS5TdWJhZ2VudFN0YXJ0ZWRIAFIHc3RhcnRlZBI0Cg'
    'ZvdXRwdXQYBCABKAsyGi5iZXRjb2RlLnYxLlN1YmFnZW50T3V0cHV0SABSBm91dHB1dBI4Cgh0'
    'b29sX3VzZRgFIAEoCzIbLmJldGNvZGUudjEuU3ViYWdlbnRUb29sVXNlSABSB3Rvb2xVc2USVg'
    'oScGVybWlzc2lvbl9yZXF1ZXN0GAYgASgLMiUuYmV0Y29kZS52MS5TdWJhZ2VudFBlcm1pc3Np'
    'b25SZXF1ZXN0SABSEXBlcm1pc3Npb25SZXF1ZXN0Ej0KCWNvbXBsZXRlZBgHIAEoCzIdLmJldG'
    'NvZGUudjEuU3ViYWdlbnRDb21wbGV0ZWRIAFIJY29tcGxldGVkEjQKBmZhaWxlZBgIIAEoCzIa'
    'LmJldGNvZGUudjEuU3ViYWdlbnRGYWlsZWRIAFIGZmFpbGVkEj0KCWNhbmNlbGxlZBgJIAEoCz'
    'IdLmJldGNvZGUudjEuU3ViYWdlbnRDYW5jZWxsZWRIAFIJY2FuY2VsbGVkQgcKBWV2ZW50');

@$core.Deprecated('Use subagentStartedDescriptor instead')
const SubagentStarted$json = {
  '1': 'SubagentStarted',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'model', '3': 2, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `SubagentStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentStartedDescriptor = $convert.base64Decode(
    'Cg9TdWJhZ2VudFN0YXJ0ZWQSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhQKBW1vZG'
    'VsGAIgASgJUgVtb2RlbA==');

@$core.Deprecated('Use subagentOutputDescriptor instead')
const SubagentOutput$json = {
  '1': 'SubagentOutput',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'is_complete', '3': 2, '4': 1, '5': 8, '10': 'isComplete'},
  ],
};

/// Descriptor for `SubagentOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentOutputDescriptor = $convert.base64Decode(
    'Cg5TdWJhZ2VudE91dHB1dBISCgR0ZXh0GAEgASgJUgR0ZXh0Eh8KC2lzX2NvbXBsZXRlGAIgAS'
    'gIUgppc0NvbXBsZXRl');

@$core.Deprecated('Use subagentToolUseDescriptor instead')
const SubagentToolUse$json = {
  '1': 'SubagentToolUse',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `SubagentToolUse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentToolUseDescriptor = $convert.base64Decode(
    'Cg9TdWJhZ2VudFRvb2xVc2USFwoHdG9vbF9pZBgBIAEoCVIGdG9vbElkEhsKCXRvb2xfbmFtZR'
    'gCIAEoCVIIdG9vbE5hbWUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use subagentPermissionRequestDescriptor instead')
const SubagentPermissionRequest$json = {
  '1': 'SubagentPermissionRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `SubagentPermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentPermissionRequestDescriptor = $convert.base64Decode(
    'ChlTdWJhZ2VudFBlcm1pc3Npb25SZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3'
    'RJZBIbCgl0b29sX25hbWUYAiABKAlSCHRvb2xOYW1lEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtk'
    'ZXNjcmlwdGlvbg==');

@$core.Deprecated('Use subagentCompletedDescriptor instead')
const SubagentCompleted$json = {
  '1': 'SubagentCompleted',
  '2': [
    {'1': 'exit_code', '3': 1, '4': 1, '5': 5, '10': 'exitCode'},
    {'1': 'result_summary', '3': 2, '4': 1, '5': 9, '10': 'resultSummary'},
  ],
};

/// Descriptor for `SubagentCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentCompletedDescriptor = $convert.base64Decode(
    'ChFTdWJhZ2VudENvbXBsZXRlZBIbCglleGl0X2NvZGUYASABKAVSCGV4aXRDb2RlEiUKDnJlc3'
    'VsdF9zdW1tYXJ5GAIgASgJUg1yZXN1bHRTdW1tYXJ5');

@$core.Deprecated('Use subagentFailedDescriptor instead')
const SubagentFailed$json = {
  '1': 'SubagentFailed',
  '2': [
    {'1': 'exit_code', '3': 1, '4': 1, '5': 5, '10': 'exitCode'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `SubagentFailed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentFailedDescriptor = $convert.base64Decode(
    'Cg5TdWJhZ2VudEZhaWxlZBIbCglleGl0X2NvZGUYASABKAVSCGV4aXRDb2RlEiMKDWVycm9yX2'
    '1lc3NhZ2UYAiABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use subagentCancelledDescriptor instead')
const SubagentCancelled$json = {
  '1': 'SubagentCancelled',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SubagentCancelled`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentCancelledDescriptor = $convert.base64Decode(
    'ChFTdWJhZ2VudENhbmNlbGxlZBIWCgZyZWFzb24YASABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use revokeAutoApproveRequestDescriptor instead')
const RevokeAutoApproveRequest$json = {
  '1': 'RevokeAutoApproveRequest',
  '2': [
    {'1': 'subagent_id', '3': 1, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'terminate_if_pending',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'terminateIfPending'
    },
  ],
};

/// Descriptor for `RevokeAutoApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeAutoApproveRequestDescriptor = $convert.base64Decode(
    'ChhSZXZva2VBdXRvQXBwcm92ZVJlcXVlc3QSHwoLc3ViYWdlbnRfaWQYASABKAlSCnN1YmFnZW'
    '50SWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24SMAoUdGVybWluYXRlX2lmX3BlbmRpbmcYAyAB'
    'KAhSEnRlcm1pbmF0ZUlmUGVuZGluZw==');

@$core.Deprecated('Use revokeAutoApproveResponseDescriptor instead')
const RevokeAutoApproveResponse$json = {
  '1': 'RevokeAutoApproveResponse',
  '2': [
    {'1': 'revoked', '3': 1, '4': 1, '5': 8, '10': 'revoked'},
    {
      '1': 'pending_tool_calls',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'pendingToolCalls'
    },
    {'1': 'subagent_status', '3': 3, '4': 1, '5': 9, '10': 'subagentStatus'},
  ],
};

/// Descriptor for `RevokeAutoApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeAutoApproveResponseDescriptor = $convert.base64Decode(
    'ChlSZXZva2VBdXRvQXBwcm92ZVJlc3BvbnNlEhgKB3Jldm9rZWQYASABKAhSB3Jldm9rZWQSLA'
    'oScGVuZGluZ190b29sX2NhbGxzGAIgASgFUhBwZW5kaW5nVG9vbENhbGxzEicKD3N1YmFnZW50'
    'X3N0YXR1cxgDIAEoCVIOc3ViYWdlbnRTdGF0dXM=');

@$core.Deprecated('Use createOrchestrationRequestDescriptor instead')
const CreateOrchestrationRequest$json = {
  '1': 'CreateOrchestrationRequest',
  '2': [
    {'1': 'parent_session_id', '3': 1, '4': 1, '5': 9, '10': 'parentSessionId'},
    {
      '1': 'steps',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.OrchestrationStep',
      '10': 'steps'
    },
    {
      '1': 'strategy',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.OrchestrationStrategy',
      '10': 'strategy'
    },
  ],
};

/// Descriptor for `CreateOrchestrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrchestrationRequestDescriptor = $convert.base64Decode(
    'ChpDcmVhdGVPcmNoZXN0cmF0aW9uUmVxdWVzdBIqChFwYXJlbnRfc2Vzc2lvbl9pZBgBIAEoCV'
    'IPcGFyZW50U2Vzc2lvbklkEjMKBXN0ZXBzGAIgAygLMh0uYmV0Y29kZS52MS5PcmNoZXN0cmF0'
    'aW9uU3RlcFIFc3RlcHMSPQoIc3RyYXRlZ3kYAyABKA4yIS5iZXRjb2RlLnYxLk9yY2hlc3RyYX'
    'Rpb25TdHJhdGVneVIIc3RyYXRlZ3k=');

@$core.Deprecated('Use createOrchestrationResponseDescriptor instead')
const CreateOrchestrationResponse$json = {
  '1': 'CreateOrchestrationResponse',
  '2': [
    {'1': 'orchestration_id', '3': 1, '4': 1, '5': 9, '10': 'orchestrationId'},
    {'1': 'total_steps', '3': 2, '4': 1, '5': 5, '10': 'totalSteps'},
  ],
};

/// Descriptor for `CreateOrchestrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrchestrationResponseDescriptor =
    $convert.base64Decode(
        'ChtDcmVhdGVPcmNoZXN0cmF0aW9uUmVzcG9uc2USKQoQb3JjaGVzdHJhdGlvbl9pZBgBIAEoCV'
        'IPb3JjaGVzdHJhdGlvbklkEh8KC3RvdGFsX3N0ZXBzGAIgASgFUgp0b3RhbFN0ZXBz');

@$core.Deprecated('Use orchestrationStepDescriptor instead')
const OrchestrationStep$json = {
  '1': 'OrchestrationStep',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'prompt', '3': 3, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'model', '3': 4, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'working_directory',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'allowed_tools', '3': 6, '4': 3, '5': 9, '10': 'allowedTools'},
    {'1': 'depends_on', '3': 7, '4': 3, '5': 9, '10': 'dependsOn'},
    {'1': 'max_turns', '3': 8, '4': 1, '5': 5, '10': 'maxTurns'},
    {'1': 'auto_approve', '3': 9, '4': 1, '5': 8, '10': 'autoApprove'},
  ],
};

/// Descriptor for `OrchestrationStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orchestrationStepDescriptor = $convert.base64Decode(
    'ChFPcmNoZXN0cmF0aW9uU3RlcBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IWCgZwcm9tcHQYAyABKAlSBnByb21wdBIUCgVtb2RlbBgEIAEoCVIFbW9kZWwSKwoRd29ya2lu'
    'Z19kaXJlY3RvcnkYBSABKAlSEHdvcmtpbmdEaXJlY3RvcnkSIwoNYWxsb3dlZF90b29scxgGIA'
    'MoCVIMYWxsb3dlZFRvb2xzEh0KCmRlcGVuZHNfb24YByADKAlSCWRlcGVuZHNPbhIbCgltYXhf'
    'dHVybnMYCCABKAVSCG1heFR1cm5zEiEKDGF1dG9fYXBwcm92ZRgJIAEoCFILYXV0b0FwcHJvdm'
    'U=');

@$core.Deprecated('Use watchOrchestrationRequestDescriptor instead')
const WatchOrchestrationRequest$json = {
  '1': 'WatchOrchestrationRequest',
  '2': [
    {'1': 'orchestration_id', '3': 1, '4': 1, '5': 9, '10': 'orchestrationId'},
  ],
};

/// Descriptor for `WatchOrchestrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchOrchestrationRequestDescriptor =
    $convert.base64Decode(
        'ChlXYXRjaE9yY2hlc3RyYXRpb25SZXF1ZXN0EikKEG9yY2hlc3RyYXRpb25faWQYASABKAlSD2'
        '9yY2hlc3RyYXRpb25JZA==');

@$core.Deprecated('Use orchestrationEventDescriptor instead')
const OrchestrationEvent$json = {
  '1': 'OrchestrationEvent',
  '2': [
    {'1': 'orchestration_id', '3': 1, '4': 1, '5': 9, '10': 'orchestrationId'},
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'step_started',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StepStarted',
      '9': 0,
      '10': 'stepStarted'
    },
    {
      '1': 'step_completed',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StepCompleted',
      '9': 0,
      '10': 'stepCompleted'
    },
    {
      '1': 'step_failed',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StepFailed',
      '9': 0,
      '10': 'stepFailed'
    },
    {
      '1': 'completed',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.OrchestrationCompleted',
      '9': 0,
      '10': 'completed'
    },
    {
      '1': 'failed',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.OrchestrationFailed',
      '9': 0,
      '10': 'failed'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `OrchestrationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orchestrationEventDescriptor = $convert.base64Decode(
    'ChJPcmNoZXN0cmF0aW9uRXZlbnQSKQoQb3JjaGVzdHJhdGlvbl9pZBgBIAEoCVIPb3JjaGVzdH'
    'JhdGlvbklkEjgKCXRpbWVzdGFtcBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXRpbWVzdGFtcBI8CgxzdGVwX3N0YXJ0ZWQYAyABKAsyFy5iZXRjb2RlLnYxLlN0ZXBTdGFydG'
    'VkSABSC3N0ZXBTdGFydGVkEkIKDnN0ZXBfY29tcGxldGVkGAQgASgLMhkuYmV0Y29kZS52MS5T'
    'dGVwQ29tcGxldGVkSABSDXN0ZXBDb21wbGV0ZWQSOQoLc3RlcF9mYWlsZWQYBSABKAsyFi5iZX'
    'Rjb2RlLnYxLlN0ZXBGYWlsZWRIAFIKc3RlcEZhaWxlZBJCCgljb21wbGV0ZWQYBiABKAsyIi5i'
    'ZXRjb2RlLnYxLk9yY2hlc3RyYXRpb25Db21wbGV0ZWRIAFIJY29tcGxldGVkEjkKBmZhaWxlZB'
    'gHIAEoCzIfLmJldGNvZGUudjEuT3JjaGVzdHJhdGlvbkZhaWxlZEgAUgZmYWlsZWRCBwoFZXZl'
    'bnQ=');

@$core.Deprecated('Use stepStartedDescriptor instead')
const StepStarted$json = {
  '1': 'StepStarted',
  '2': [
    {'1': 'step_id', '3': 1, '4': 1, '5': 9, '10': 'stepId'},
    {'1': 'subagent_id', '3': 2, '4': 1, '5': 9, '10': 'subagentId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `StepStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepStartedDescriptor = $convert.base64Decode(
    'CgtTdGVwU3RhcnRlZBIXCgdzdGVwX2lkGAEgASgJUgZzdGVwSWQSHwoLc3ViYWdlbnRfaWQYAi'
    'ABKAlSCnN1YmFnZW50SWQSEgoEbmFtZRgDIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use stepCompletedDescriptor instead')
const StepCompleted$json = {
  '1': 'StepCompleted',
  '2': [
    {'1': 'step_id', '3': 1, '4': 1, '5': 9, '10': 'stepId'},
    {'1': 'result_summary', '3': 2, '4': 1, '5': 9, '10': 'resultSummary'},
    {'1': 'completed_count', '3': 3, '4': 1, '5': 5, '10': 'completedCount'},
    {'1': 'total_count', '3': 4, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `StepCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepCompletedDescriptor = $convert.base64Decode(
    'Cg1TdGVwQ29tcGxldGVkEhcKB3N0ZXBfaWQYASABKAlSBnN0ZXBJZBIlCg5yZXN1bHRfc3VtbW'
    'FyeRgCIAEoCVINcmVzdWx0U3VtbWFyeRInCg9jb21wbGV0ZWRfY291bnQYAyABKAVSDmNvbXBs'
    'ZXRlZENvdW50Eh8KC3RvdGFsX2NvdW50GAQgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use stepFailedDescriptor instead')
const StepFailed$json = {
  '1': 'StepFailed',
  '2': [
    {'1': 'step_id', '3': 1, '4': 1, '5': 9, '10': 'stepId'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'blocked_steps', '3': 3, '4': 3, '5': 9, '10': 'blockedSteps'},
  ],
};

/// Descriptor for `StepFailed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepFailedDescriptor = $convert.base64Decode(
    'CgpTdGVwRmFpbGVkEhcKB3N0ZXBfaWQYASABKAlSBnN0ZXBJZBIjCg1lcnJvcl9tZXNzYWdlGA'
    'IgASgJUgxlcnJvck1lc3NhZ2USIwoNYmxvY2tlZF9zdGVwcxgDIAMoCVIMYmxvY2tlZFN0ZXBz');

@$core.Deprecated('Use orchestrationCompletedDescriptor instead')
const OrchestrationCompleted$json = {
  '1': 'OrchestrationCompleted',
  '2': [
    {'1': 'total_steps', '3': 1, '4': 1, '5': 5, '10': 'totalSteps'},
    {'1': 'succeeded', '3': 2, '4': 1, '5': 5, '10': 'succeeded'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `OrchestrationCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orchestrationCompletedDescriptor = $convert.base64Decode(
    'ChZPcmNoZXN0cmF0aW9uQ29tcGxldGVkEh8KC3RvdGFsX3N0ZXBzGAEgASgFUgp0b3RhbFN0ZX'
    'BzEhwKCXN1Y2NlZWRlZBgCIAEoBVIJc3VjY2VlZGVkEhYKBmZhaWxlZBgDIAEoBVIGZmFpbGVk');

@$core.Deprecated('Use orchestrationFailedDescriptor instead')
const OrchestrationFailed$json = {
  '1': 'OrchestrationFailed',
  '2': [
    {'1': 'error_message', '3': 1, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'completed_steps', '3': 2, '4': 1, '5': 5, '10': 'completedSteps'},
    {'1': 'failed_steps', '3': 3, '4': 1, '5': 5, '10': 'failedSteps'},
  ],
};

/// Descriptor for `OrchestrationFailed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orchestrationFailedDescriptor = $convert.base64Decode(
    'ChNPcmNoZXN0cmF0aW9uRmFpbGVkEiMKDWVycm9yX21lc3NhZ2UYASABKAlSDGVycm9yTWVzc2'
    'FnZRInCg9jb21wbGV0ZWRfc3RlcHMYAiABKAVSDmNvbXBsZXRlZFN0ZXBzEiEKDGZhaWxlZF9z'
    'dGVwcxgDIAEoBVILZmFpbGVkU3RlcHM=');
