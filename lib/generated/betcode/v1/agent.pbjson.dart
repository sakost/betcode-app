// This is a generated file - do not edit.
//
// Generated from betcode/v1/agent.proto.

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

@$core.Deprecated('Use agentRequestDescriptor instead')
const AgentRequest$json = {
  '1': 'AgentRequest',
  '2': [
    {
      '1': 'start',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StartConversation',
      '9': 0,
      '10': 'start'
    },
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.UserMessage',
      '9': 0,
      '10': 'message'
    },
    {
      '1': 'permission',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PermissionResponse',
      '9': 0,
      '10': 'permission'
    },
    {
      '1': 'question_response',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.UserQuestionResponse',
      '9': 0,
      '10': 'questionResponse'
    },
    {
      '1': 'cancel',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.CancelRequest',
      '9': 0,
      '10': 'cancel'
    },
    {
      '1': 'encrypted',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.EncryptedEnvelope',
      '9': 0,
      '10': 'encrypted'
    },
  ],
  '8': [
    {'1': 'request'},
  ],
};

/// Descriptor for `AgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentRequestDescriptor = $convert.base64Decode(
    'CgxBZ2VudFJlcXVlc3QSNQoFc3RhcnQYASABKAsyHS5iZXRjb2RlLnYxLlN0YXJ0Q29udmVyc2'
    'F0aW9uSABSBXN0YXJ0EjMKB21lc3NhZ2UYAiABKAsyFy5iZXRjb2RlLnYxLlVzZXJNZXNzYWdl'
    'SABSB21lc3NhZ2USQAoKcGVybWlzc2lvbhgDIAEoCzIeLmJldGNvZGUudjEuUGVybWlzc2lvbl'
    'Jlc3BvbnNlSABSCnBlcm1pc3Npb24STwoRcXVlc3Rpb25fcmVzcG9uc2UYBCABKAsyIC5iZXRj'
    'b2RlLnYxLlVzZXJRdWVzdGlvblJlc3BvbnNlSABSEHF1ZXN0aW9uUmVzcG9uc2USMwoGY2FuY2'
    'VsGAUgASgLMhkuYmV0Y29kZS52MS5DYW5jZWxSZXF1ZXN0SABSBmNhbmNlbBI9CgllbmNyeXB0'
    'ZWQYBiABKAsyHS5iZXRjb2RlLnYxLkVuY3J5cHRlZEVudmVsb3BlSABSCWVuY3J5cHRlZEIJCg'
    'dyZXF1ZXN0');

@$core.Deprecated('Use startConversationDescriptor instead')
const StartConversation$json = {
  '1': 'StartConversation',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'working_directory',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'model', '3': 3, '4': 1, '5': 9, '10': 'model'},
    {'1': 'allowed_tools', '3': 4, '4': 3, '5': 9, '10': 'allowedTools'},
    {'1': 'plan_mode', '3': 5, '4': 1, '5': 8, '10': 'planMode'},
    {'1': 'worktree_id', '3': 6, '4': 1, '5': 9, '10': 'worktreeId'},
    {
      '1': 'metadata',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.StartConversation.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [StartConversation_MetadataEntry$json],
};

@$core.Deprecated('Use startConversationDescriptor instead')
const StartConversation_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `StartConversation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startConversationDescriptor = $convert.base64Decode(
    'ChFTdGFydENvbnZlcnNhdGlvbhIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSKwoRd2'
    '9ya2luZ19kaXJlY3RvcnkYAiABKAlSEHdvcmtpbmdEaXJlY3RvcnkSFAoFbW9kZWwYAyABKAlS'
    'BW1vZGVsEiMKDWFsbG93ZWRfdG9vbHMYBCADKAlSDGFsbG93ZWRUb29scxIbCglwbGFuX21vZG'
    'UYBSABKAhSCHBsYW5Nb2RlEh8KC3dvcmt0cmVlX2lkGAYgASgJUgp3b3JrdHJlZUlkEkcKCG1l'
    'dGFkYXRhGAcgAygLMisuYmV0Y29kZS52MS5TdGFydENvbnZlcnNhdGlvbi5NZXRhZGF0YUVudH'
    'J5UghtZXRhZGF0YRo7Cg1NZXRhZGF0YUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVl'
    'GAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use userMessageDescriptor instead')
const UserMessage$json = {
  '1': 'UserMessage',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'attachments',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.Attachment',
      '10': 'attachments'
    },
    {'1': 'agent_id', '3': 3, '4': 1, '5': 9, '10': 'agentId'},
  ],
};

/// Descriptor for `UserMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMessageDescriptor = $convert.base64Decode(
    'CgtVc2VyTWVzc2FnZRIYCgdjb250ZW50GAEgASgJUgdjb250ZW50EjgKC2F0dGFjaG1lbnRzGA'
    'IgAygLMhYuYmV0Y29kZS52MS5BdHRhY2htZW50UgthdHRhY2htZW50cxIZCghhZ2VudF9pZBgD'
    'IAEoCVIHYWdlbnRJZA==');

@$core.Deprecated('Use permissionResponseDescriptor instead')
const PermissionResponse$json = {
  '1': 'PermissionResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'decision',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.PermissionDecision',
      '10': 'decision'
    },
    {
      '1': 'updated_input',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'updatedInput'
    },
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PermissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionResponseDescriptor = $convert.base64Decode(
    'ChJQZXJtaXNzaW9uUmVzcG9uc2USHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEjoKCG'
    'RlY2lzaW9uGAIgASgOMh4uYmV0Y29kZS52MS5QZXJtaXNzaW9uRGVjaXNpb25SCGRlY2lzaW9u'
    'EjwKDXVwZGF0ZWRfaW5wdXQYAyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugx1cGRhdG'
    'VkSW5wdXQSGAoHbWVzc2FnZRgEIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use userQuestionResponseDescriptor instead')
const UserQuestionResponse$json = {
  '1': 'UserQuestionResponse',
  '2': [
    {'1': 'question_id', '3': 1, '4': 1, '5': 9, '10': 'questionId'},
    {
      '1': 'answers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.UserQuestionResponse.AnswersEntry',
      '10': 'answers'
    },
  ],
  '3': [UserQuestionResponse_AnswersEntry$json],
};

@$core.Deprecated('Use userQuestionResponseDescriptor instead')
const UserQuestionResponse_AnswersEntry$json = {
  '1': 'AnswersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UserQuestionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userQuestionResponseDescriptor = $convert.base64Decode(
    'ChRVc2VyUXVlc3Rpb25SZXNwb25zZRIfCgtxdWVzdGlvbl9pZBgBIAEoCVIKcXVlc3Rpb25JZB'
    'JHCgdhbnN3ZXJzGAIgAygLMi0uYmV0Y29kZS52MS5Vc2VyUXVlc3Rpb25SZXNwb25zZS5BbnN3'
    'ZXJzRW50cnlSB2Fuc3dlcnMaOgoMQW5zd2Vyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBX'
    'ZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use cancelRequestDescriptor instead')
const CancelRequest$json = {
  '1': 'CancelRequest',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestDescriptor = $convert
    .base64Decode('Cg1DYW5jZWxSZXF1ZXN0EhYKBnJlYXNvbhgBIAEoCVIGcmVhc29u');

@$core.Deprecated('Use agentEventDescriptor instead')
const AgentEvent$json = {
  '1': 'AgentEvent',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 4, '10': 'sequence'},
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'parent_tool_use_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'parentToolUseId'
    },
    {
      '1': 'text_delta',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.TextDelta',
      '9': 0,
      '10': 'textDelta'
    },
    {
      '1': 'tool_call_start',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.ToolCallStart',
      '9': 0,
      '10': 'toolCallStart'
    },
    {
      '1': 'tool_call_result',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.ToolCallResult',
      '9': 0,
      '10': 'toolCallResult'
    },
    {
      '1': 'permission_request',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PermissionRequest',
      '9': 0,
      '10': 'permissionRequest'
    },
    {
      '1': 'user_question',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.UserQuestion',
      '9': 0,
      '10': 'userQuestion'
    },
    {
      '1': 'todo_update',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.TodoUpdate',
      '9': 0,
      '10': 'todoUpdate'
    },
    {
      '1': 'status_change',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StatusChange',
      '9': 0,
      '10': 'statusChange'
    },
    {
      '1': 'session_info',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SessionInfo',
      '9': 0,
      '10': 'sessionInfo'
    },
    {
      '1': 'error',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.ErrorEvent',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'usage',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.UsageReport',
      '9': 0,
      '10': 'usage'
    },
    {
      '1': 'plan_mode',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PlanModeChange',
      '9': 0,
      '10': 'planMode'
    },
    {
      '1': 'turn_complete',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.TurnComplete',
      '9': 0,
      '10': 'turnComplete'
    },
    {
      '1': 'user_input',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.UserInput',
      '9': 0,
      '10': 'userInput'
    },
    {
      '1': 'encrypted',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.EncryptedEnvelope',
      '9': 0,
      '10': 'encrypted'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `AgentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentEventDescriptor = $convert.base64Decode(
    'CgpBZ2VudEV2ZW50EhoKCHNlcXVlbmNlGAEgASgEUghzZXF1ZW5jZRI4Cgl0aW1lc3RhbXAYAi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASKwoScGFyZW50X3Rv'
    'b2xfdXNlX2lkGAMgASgJUg9wYXJlbnRUb29sVXNlSWQSNgoKdGV4dF9kZWx0YRgKIAEoCzIVLm'
    'JldGNvZGUudjEuVGV4dERlbHRhSABSCXRleHREZWx0YRJDCg90b29sX2NhbGxfc3RhcnQYCyAB'
    'KAsyGS5iZXRjb2RlLnYxLlRvb2xDYWxsU3RhcnRIAFINdG9vbENhbGxTdGFydBJGChB0b29sX2'
    'NhbGxfcmVzdWx0GAwgASgLMhouYmV0Y29kZS52MS5Ub29sQ2FsbFJlc3VsdEgAUg50b29sQ2Fs'
    'bFJlc3VsdBJOChJwZXJtaXNzaW9uX3JlcXVlc3QYDSABKAsyHS5iZXRjb2RlLnYxLlBlcm1pc3'
    'Npb25SZXF1ZXN0SABSEXBlcm1pc3Npb25SZXF1ZXN0Ej8KDXVzZXJfcXVlc3Rpb24YDiABKAsy'
    'GC5iZXRjb2RlLnYxLlVzZXJRdWVzdGlvbkgAUgx1c2VyUXVlc3Rpb24SOQoLdG9kb191cGRhdG'
    'UYDyABKAsyFi5iZXRjb2RlLnYxLlRvZG9VcGRhdGVIAFIKdG9kb1VwZGF0ZRI/Cg1zdGF0dXNf'
    'Y2hhbmdlGBAgASgLMhguYmV0Y29kZS52MS5TdGF0dXNDaGFuZ2VIAFIMc3RhdHVzQ2hhbmdlEj'
    'wKDHNlc3Npb25faW5mbxgRIAEoCzIXLmJldGNvZGUudjEuU2Vzc2lvbkluZm9IAFILc2Vzc2lv'
    'bkluZm8SLgoFZXJyb3IYEiABKAsyFi5iZXRjb2RlLnYxLkVycm9yRXZlbnRIAFIFZXJyb3ISLw'
    'oFdXNhZ2UYEyABKAsyFy5iZXRjb2RlLnYxLlVzYWdlUmVwb3J0SABSBXVzYWdlEjkKCXBsYW5f'
    'bW9kZRgUIAEoCzIaLmJldGNvZGUudjEuUGxhbk1vZGVDaGFuZ2VIAFIIcGxhbk1vZGUSPwoNdH'
    'Vybl9jb21wbGV0ZRgVIAEoCzIYLmJldGNvZGUudjEuVHVybkNvbXBsZXRlSABSDHR1cm5Db21w'
    'bGV0ZRI2Cgp1c2VyX2lucHV0GBYgASgLMhUuYmV0Y29kZS52MS5Vc2VySW5wdXRIAFIJdXNlck'
    'lucHV0Ej0KCWVuY3J5cHRlZBgXIAEoCzIdLmJldGNvZGUudjEuRW5jcnlwdGVkRW52ZWxvcGVI'
    'AFIJZW5jcnlwdGVkQgcKBWV2ZW50');

@$core.Deprecated('Use textDeltaDescriptor instead')
const TextDelta$json = {
  '1': 'TextDelta',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'is_complete', '3': 2, '4': 1, '5': 8, '10': 'isComplete'},
  ],
};

/// Descriptor for `TextDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textDeltaDescriptor = $convert.base64Decode(
    'CglUZXh0RGVsdGESEgoEdGV4dBgBIAEoCVIEdGV4dBIfCgtpc19jb21wbGV0ZRgCIAEoCFIKaX'
    'NDb21wbGV0ZQ==');

@$core.Deprecated('Use toolCallStartDescriptor instead')
const ToolCallStart$json = {
  '1': 'ToolCallStart',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {
      '1': 'input',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'input'
    },
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `ToolCallStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallStartDescriptor = $convert.base64Decode(
    'Cg1Ub29sQ2FsbFN0YXJ0EhcKB3Rvb2xfaWQYASABKAlSBnRvb2xJZBIbCgl0b29sX25hbWUYAi'
    'ABKAlSCHRvb2xOYW1lEi0KBWlucHV0GAMgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIF'
    'aW5wdXQSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use toolCallResultDescriptor instead')
const ToolCallResult$json = {
  '1': 'ToolCallResult',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'output', '3': 2, '4': 1, '5': 9, '10': 'output'},
    {'1': 'is_error', '3': 3, '4': 1, '5': 8, '10': 'isError'},
    {'1': 'duration_ms', '3': 4, '4': 1, '5': 13, '10': 'durationMs'},
  ],
};

/// Descriptor for `ToolCallResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallResultDescriptor = $convert.base64Decode(
    'Cg5Ub29sQ2FsbFJlc3VsdBIXCgd0b29sX2lkGAEgASgJUgZ0b29sSWQSFgoGb3V0cHV0GAIgAS'
    'gJUgZvdXRwdXQSGQoIaXNfZXJyb3IYAyABKAhSB2lzRXJyb3ISHwoLZHVyYXRpb25fbXMYBCAB'
    'KA1SCmR1cmF0aW9uTXM=');

@$core.Deprecated('Use permissionRequestDescriptor instead')
const PermissionRequest$json = {
  '1': 'PermissionRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'input',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'input'
    },
  ],
};

/// Descriptor for `PermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionRequestDescriptor = $convert.base64Decode(
    'ChFQZXJtaXNzaW9uUmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQSGwoJdG'
    '9vbF9uYW1lGAIgASgJUgh0b29sTmFtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRp'
    'b24SLQoFaW5wdXQYBCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgVpbnB1dA==');

@$core.Deprecated('Use userQuestionDescriptor instead')
const UserQuestion$json = {
  '1': 'UserQuestion',
  '2': [
    {'1': 'question_id', '3': 1, '4': 1, '5': 9, '10': 'questionId'},
    {'1': 'question', '3': 2, '4': 1, '5': 9, '10': 'question'},
    {
      '1': 'options',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.QuestionOption',
      '10': 'options'
    },
    {'1': 'multi_select', '3': 4, '4': 1, '5': 8, '10': 'multiSelect'},
  ],
};

/// Descriptor for `UserQuestion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userQuestionDescriptor = $convert.base64Decode(
    'CgxVc2VyUXVlc3Rpb24SHwoLcXVlc3Rpb25faWQYASABKAlSCnF1ZXN0aW9uSWQSGgoIcXVlc3'
    'Rpb24YAiABKAlSCHF1ZXN0aW9uEjQKB29wdGlvbnMYAyADKAsyGi5iZXRjb2RlLnYxLlF1ZXN0'
    'aW9uT3B0aW9uUgdvcHRpb25zEiEKDG11bHRpX3NlbGVjdBgEIAEoCFILbXVsdGlTZWxlY3Q=');

@$core.Deprecated('Use todoUpdateDescriptor instead')
const TodoUpdate$json = {
  '1': 'TodoUpdate',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.TodoItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `TodoUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List todoUpdateDescriptor = $convert.base64Decode(
    'CgpUb2RvVXBkYXRlEioKBWl0ZW1zGAEgAygLMhQuYmV0Y29kZS52MS5Ub2RvSXRlbVIFaXRlbX'
    'M=');

@$core.Deprecated('Use statusChangeDescriptor instead')
const StatusChange$json = {
  '1': 'StatusChange',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.AgentStatus',
      '10': 'status'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `StatusChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusChangeDescriptor = $convert.base64Decode(
    'CgxTdGF0dXNDaGFuZ2USLwoGc3RhdHVzGAEgASgOMhcuYmV0Y29kZS52MS5BZ2VudFN0YXR1c1'
    'IGc3RhdHVzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use sessionInfoDescriptor instead')
const SessionInfo$json = {
  '1': 'SessionInfo',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'model', '3': 2, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'working_directory',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'worktree_id', '3': 4, '4': 1, '5': 9, '10': 'worktreeId'},
    {'1': 'message_count', '3': 5, '4': 1, '5': 4, '10': 'messageCount'},
    {'1': 'is_resumed', '3': 6, '4': 1, '5': 8, '10': 'isResumed'},
    {'1': 'is_compacted', '3': 7, '4': 1, '5': 8, '10': 'isCompacted'},
    {
      '1': 'context_usage_percent',
      '3': 8,
      '4': 1,
      '5': 2,
      '10': 'contextUsagePercent'
    },
  ],
};

/// Descriptor for `SessionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionInfoDescriptor = $convert.base64Decode(
    'CgtTZXNzaW9uSW5mbxIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSFAoFbW9kZWwYAi'
    'ABKAlSBW1vZGVsEisKEXdvcmtpbmdfZGlyZWN0b3J5GAMgASgJUhB3b3JraW5nRGlyZWN0b3J5'
    'Eh8KC3dvcmt0cmVlX2lkGAQgASgJUgp3b3JrdHJlZUlkEiMKDW1lc3NhZ2VfY291bnQYBSABKA'
    'RSDG1lc3NhZ2VDb3VudBIdCgppc19yZXN1bWVkGAYgASgIUglpc1Jlc3VtZWQSIQoMaXNfY29t'
    'cGFjdGVkGAcgASgIUgtpc0NvbXBhY3RlZBIyChVjb250ZXh0X3VzYWdlX3BlcmNlbnQYCCABKA'
    'JSE2NvbnRleHRVc2FnZVBlcmNlbnQ=');

@$core.Deprecated('Use errorEventDescriptor instead')
const ErrorEvent$json = {
  '1': 'ErrorEvent',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'is_fatal', '3': 3, '4': 1, '5': 8, '10': 'isFatal'},
    {
      '1': 'details',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.ErrorEvent.DetailsEntry',
      '10': 'details'
    },
  ],
  '3': [ErrorEvent_DetailsEntry$json],
};

@$core.Deprecated('Use errorEventDescriptor instead')
const ErrorEvent_DetailsEntry$json = {
  '1': 'DetailsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ErrorEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorEventDescriptor = $convert.base64Decode(
    'CgpFcnJvckV2ZW50EhIKBGNvZGUYASABKAlSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2'
    'FnZRIZCghpc19mYXRhbBgDIAEoCFIHaXNGYXRhbBI9CgdkZXRhaWxzGAQgAygLMiMuYmV0Y29k'
    'ZS52MS5FcnJvckV2ZW50LkRldGFpbHNFbnRyeVIHZGV0YWlscxo6CgxEZXRhaWxzRW50cnkSEA'
    'oDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use usageReportDescriptor instead')
const UsageReport$json = {
  '1': 'UsageReport',
  '2': [
    {'1': 'input_tokens', '3': 1, '4': 1, '5': 13, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 2, '4': 1, '5': 13, '10': 'outputTokens'},
    {
      '1': 'cache_read_tokens',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'cacheReadTokens'
    },
    {
      '1': 'cache_creation_tokens',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'cacheCreationTokens'
    },
    {'1': 'model', '3': 5, '4': 1, '5': 9, '10': 'model'},
    {'1': 'cost_usd', '3': 6, '4': 1, '5': 1, '10': 'costUsd'},
    {'1': 'duration_ms', '3': 7, '4': 1, '5': 13, '10': 'durationMs'},
  ],
};

/// Descriptor for `UsageReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usageReportDescriptor = $convert.base64Decode(
    'CgtVc2FnZVJlcG9ydBIhCgxpbnB1dF90b2tlbnMYASABKA1SC2lucHV0VG9rZW5zEiMKDW91dH'
    'B1dF90b2tlbnMYAiABKA1SDG91dHB1dFRva2VucxIqChFjYWNoZV9yZWFkX3Rva2VucxgDIAEo'
    'DVIPY2FjaGVSZWFkVG9rZW5zEjIKFWNhY2hlX2NyZWF0aW9uX3Rva2VucxgEIAEoDVITY2FjaG'
    'VDcmVhdGlvblRva2VucxIUCgVtb2RlbBgFIAEoCVIFbW9kZWwSGQoIY29zdF91c2QYBiABKAFS'
    'B2Nvc3RVc2QSHwoLZHVyYXRpb25fbXMYByABKA1SCmR1cmF0aW9uTXM=');

@$core.Deprecated('Use planModeChangeDescriptor instead')
const PlanModeChange$json = {
  '1': 'PlanModeChange',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
    {'1': 'plan', '3': 2, '4': 1, '5': 9, '10': 'plan'},
  ],
};

/// Descriptor for `PlanModeChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planModeChangeDescriptor = $convert.base64Decode(
    'Cg5QbGFuTW9kZUNoYW5nZRIWCgZhY3RpdmUYASABKAhSBmFjdGl2ZRISCgRwbGFuGAIgASgJUg'
    'RwbGFu');

@$core.Deprecated('Use turnCompleteDescriptor instead')
const TurnComplete$json = {
  '1': 'TurnComplete',
  '2': [
    {'1': 'stop_reason', '3': 1, '4': 1, '5': 9, '10': 'stopReason'},
  ],
};

/// Descriptor for `TurnComplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnCompleteDescriptor = $convert.base64Decode(
    'CgxUdXJuQ29tcGxldGUSHwoLc3RvcF9yZWFzb24YASABKAlSCnN0b3BSZWFzb24=');

@$core.Deprecated('Use userInputDescriptor instead')
const UserInput$json = {
  '1': 'UserInput',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `UserInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInputDescriptor = $convert
    .base64Decode('CglVc2VySW5wdXQSGAoHY29udGVudBgBIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use encryptedEnvelopeDescriptor instead')
const EncryptedEnvelope$json = {
  '1': 'EncryptedEnvelope',
  '2': [
    {'1': 'ciphertext', '3': 1, '4': 1, '5': 12, '10': 'ciphertext'},
    {'1': 'nonce', '3': 2, '4': 1, '5': 12, '10': 'nonce'},
  ],
};

/// Descriptor for `EncryptedEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encryptedEnvelopeDescriptor = $convert.base64Decode(
    'ChFFbmNyeXB0ZWRFbnZlbG9wZRIeCgpjaXBoZXJ0ZXh0GAEgASgMUgpjaXBoZXJ0ZXh0EhQKBW'
    '5vbmNlGAIgASgMUgVub25jZQ==');

@$core.Deprecated('Use listSessionsRequestDescriptor instead')
const ListSessionsRequest$json = {
  '1': 'ListSessionsRequest',
  '2': [
    {
      '1': 'working_directory',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'worktree_id', '3': 2, '4': 1, '5': 9, '10': 'worktreeId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListSessionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSessionsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0U2Vzc2lvbnNSZXF1ZXN0EisKEXdvcmtpbmdfZGlyZWN0b3J5GAEgASgJUhB3b3JraW'
    '5nRGlyZWN0b3J5Eh8KC3dvcmt0cmVlX2lkGAIgASgJUgp3b3JrdHJlZUlkEhQKBWxpbWl0GAMg'
    'ASgNUgVsaW1pdBIWCgZvZmZzZXQYBCABKA1SBm9mZnNldA==');

@$core.Deprecated('Use listSessionsResponseDescriptor instead')
const ListSessionsResponse$json = {
  '1': 'ListSessionsResponse',
  '2': [
    {
      '1': 'sessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.SessionSummary',
      '10': 'sessions'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `ListSessionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSessionsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2Vzc2lvbnNSZXNwb25zZRI2CghzZXNzaW9ucxgBIAMoCzIaLmJldGNvZGUudjEuU2'
    'Vzc2lvblN1bW1hcnlSCHNlc3Npb25zEhQKBXRvdGFsGAIgASgNUgV0b3RhbA==');

@$core.Deprecated('Use sessionSummaryDescriptor instead')
const SessionSummary$json = {
  '1': 'SessionSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'model', '3': 2, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'working_directory',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'workingDirectory'
    },
    {'1': 'worktree_id', '3': 4, '4': 1, '5': 9, '10': 'worktreeId'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'message_count', '3': 6, '4': 1, '5': 13, '10': 'messageCount'},
    {
      '1': 'total_input_tokens',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'totalInputTokens'
    },
    {
      '1': 'total_output_tokens',
      '3': 8,
      '4': 1,
      '5': 13,
      '10': 'totalOutputTokens'
    },
    {'1': 'total_cost_usd', '3': 9, '4': 1, '5': 1, '10': 'totalCostUsd'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'last_message_preview',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'lastMessagePreview'
    },
    {'1': 'name', '3': 13, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SessionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionSummaryDescriptor = $convert.base64Decode(
    'Cg5TZXNzaW9uU3VtbWFyeRIOCgJpZBgBIAEoCVICaWQSFAoFbW9kZWwYAiABKAlSBW1vZGVsEi'
    'sKEXdvcmtpbmdfZGlyZWN0b3J5GAMgASgJUhB3b3JraW5nRGlyZWN0b3J5Eh8KC3dvcmt0cmVl'
    'X2lkGAQgASgJUgp3b3JrdHJlZUlkEhYKBnN0YXR1cxgFIAEoCVIGc3RhdHVzEiMKDW1lc3NhZ2'
    'VfY291bnQYBiABKA1SDG1lc3NhZ2VDb3VudBIsChJ0b3RhbF9pbnB1dF90b2tlbnMYByABKA1S'
    'EHRvdGFsSW5wdXRUb2tlbnMSLgoTdG90YWxfb3V0cHV0X3Rva2VucxgIIAEoDVIRdG90YWxPdX'
    'RwdXRUb2tlbnMSJAoOdG90YWxfY29zdF91c2QYCSABKAFSDHRvdGFsQ29zdFVzZBI5CgpjcmVh'
    'dGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCn'
    'VwZGF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQS'
    'MAoUbGFzdF9tZXNzYWdlX3ByZXZpZXcYDCABKAlSEmxhc3RNZXNzYWdlUHJldmlldxISCgRuYW'
    '1lGA0gASgJUgRuYW1l');

@$core.Deprecated('Use resumeSessionRequestDescriptor instead')
const ResumeSessionRequest$json = {
  '1': 'ResumeSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'from_sequence', '3': 2, '4': 1, '5': 4, '10': 'fromSequence'},
  ],
};

/// Descriptor for `ResumeSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeSessionRequestDescriptor = $convert.base64Decode(
    'ChRSZXN1bWVTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSIw'
    'oNZnJvbV9zZXF1ZW5jZRgCIAEoBFIMZnJvbVNlcXVlbmNl');

@$core.Deprecated('Use compactSessionRequestDescriptor instead')
const CompactSessionRequest$json = {
  '1': 'CompactSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CompactSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compactSessionRequestDescriptor = $convert.base64Decode(
    'ChVDb21wYWN0U2Vzc2lvblJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use compactSessionResponseDescriptor instead')
const CompactSessionResponse$json = {
  '1': 'CompactSessionResponse',
  '2': [
    {'1': 'messages_before', '3': 1, '4': 1, '5': 13, '10': 'messagesBefore'},
    {'1': 'messages_after', '3': 2, '4': 1, '5': 13, '10': 'messagesAfter'},
    {'1': 'tokens_saved', '3': 3, '4': 1, '5': 13, '10': 'tokensSaved'},
  ],
};

/// Descriptor for `CompactSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compactSessionResponseDescriptor = $convert.base64Decode(
    'ChZDb21wYWN0U2Vzc2lvblJlc3BvbnNlEicKD21lc3NhZ2VzX2JlZm9yZRgBIAEoDVIObWVzc2'
    'FnZXNCZWZvcmUSJQoObWVzc2FnZXNfYWZ0ZXIYAiABKA1SDW1lc3NhZ2VzQWZ0ZXISIQoMdG9r'
    'ZW5zX3NhdmVkGAMgASgNUgt0b2tlbnNTYXZlZA==');

@$core.Deprecated('Use cancelTurnRequestDescriptor instead')
const CancelTurnRequest$json = {
  '1': 'CancelTurnRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CancelTurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTurnRequestDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxUdXJuUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use cancelTurnResponseDescriptor instead')
const CancelTurnResponse$json = {
  '1': 'CancelTurnResponse',
  '2': [
    {'1': 'was_active', '3': 1, '4': 1, '5': 8, '10': 'wasActive'},
  ],
};

/// Descriptor for `CancelTurnResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTurnResponseDescriptor =
    $convert.base64Decode(
        'ChJDYW5jZWxUdXJuUmVzcG9uc2USHQoKd2FzX2FjdGl2ZRgBIAEoCFIJd2FzQWN0aXZl');

@$core.Deprecated('Use inputLockRequestDescriptor instead')
const InputLockRequest$json = {
  '1': 'InputLockRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `InputLockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputLockRequestDescriptor = $convert.base64Decode(
    'ChBJbnB1dExvY2tSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use inputLockResponseDescriptor instead')
const InputLockResponse$json = {
  '1': 'InputLockResponse',
  '2': [
    {'1': 'granted', '3': 1, '4': 1, '5': 8, '10': 'granted'},
    {'1': 'previous_holder', '3': 2, '4': 1, '5': 9, '10': 'previousHolder'},
  ],
};

/// Descriptor for `InputLockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputLockResponseDescriptor = $convert.base64Decode(
    'ChFJbnB1dExvY2tSZXNwb25zZRIYCgdncmFudGVkGAEgASgIUgdncmFudGVkEicKD3ByZXZpb3'
    'VzX2hvbGRlchgCIAEoCVIOcHJldmlvdXNIb2xkZXI=');

@$core.Deprecated('Use sessionGrantEntryDescriptor instead')
const SessionGrantEntry$json = {
  '1': 'SessionGrantEntry',
  '2': [
    {'1': 'tool_name', '3': 1, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'granted', '3': 2, '4': 1, '5': 8, '10': 'granted'},
  ],
};

/// Descriptor for `SessionGrantEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionGrantEntryDescriptor = $convert.base64Decode(
    'ChFTZXNzaW9uR3JhbnRFbnRyeRIbCgl0b29sX25hbWUYASABKAlSCHRvb2xOYW1lEhgKB2dyYW'
    '50ZWQYAiABKAhSB2dyYW50ZWQ=');

@$core.Deprecated('Use listSessionGrantsRequestDescriptor instead')
const ListSessionGrantsRequest$json = {
  '1': 'ListSessionGrantsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ListSessionGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSessionGrantsRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0U2Vzc2lvbkdyYW50c1JlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbk'
        'lk');

@$core.Deprecated('Use listSessionGrantsResponseDescriptor instead')
const ListSessionGrantsResponse$json = {
  '1': 'ListSessionGrantsResponse',
  '2': [
    {
      '1': 'grants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.SessionGrantEntry',
      '10': 'grants'
    },
  ],
};

/// Descriptor for `ListSessionGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSessionGrantsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0U2Vzc2lvbkdyYW50c1Jlc3BvbnNlEjUKBmdyYW50cxgBIAMoCzIdLmJldGNvZGUudj'
        'EuU2Vzc2lvbkdyYW50RW50cnlSBmdyYW50cw==');

@$core.Deprecated('Use clearSessionGrantsRequestDescriptor instead')
const ClearSessionGrantsRequest$json = {
  '1': 'ClearSessionGrantsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
  ],
};

/// Descriptor for `ClearSessionGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearSessionGrantsRequestDescriptor =
    $convert.base64Decode(
        'ChlDbGVhclNlc3Npb25HcmFudHNSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb2'
        '5JZBIbCgl0b29sX25hbWUYAiABKAlSCHRvb2xOYW1l');

@$core.Deprecated('Use clearSessionGrantsResponseDescriptor instead')
const ClearSessionGrantsResponse$json = {
  '1': 'ClearSessionGrantsResponse',
};

/// Descriptor for `ClearSessionGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearSessionGrantsResponseDescriptor =
    $convert.base64Decode('ChpDbGVhclNlc3Npb25HcmFudHNSZXNwb25zZQ==');

@$core.Deprecated('Use setSessionGrantRequestDescriptor instead')
const SetSessionGrantRequest$json = {
  '1': 'SetSessionGrantRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'granted', '3': 3, '4': 1, '5': 8, '10': 'granted'},
  ],
};

/// Descriptor for `SetSessionGrantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSessionGrantRequestDescriptor = $convert.base64Decode(
    'ChZTZXRTZXNzaW9uR3JhbnRSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZB'
    'IbCgl0b29sX25hbWUYAiABKAlSCHRvb2xOYW1lEhgKB2dyYW50ZWQYAyABKAhSB2dyYW50ZWQ=');

@$core.Deprecated('Use setSessionGrantResponseDescriptor instead')
const SetSessionGrantResponse$json = {
  '1': 'SetSessionGrantResponse',
};

/// Descriptor for `SetSessionGrantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSessionGrantResponseDescriptor =
    $convert.base64Decode('ChdTZXRTZXNzaW9uR3JhbnRSZXNwb25zZQ==');

@$core.Deprecated('Use renameSessionRequestDescriptor instead')
const RenameSessionRequest$json = {
  '1': 'RenameSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RenameSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameSessionRequestDescriptor = $convert.base64Decode(
    'ChRSZW5hbWVTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use renameSessionResponseDescriptor instead')
const RenameSessionResponse$json = {
  '1': 'RenameSessionResponse',
};

/// Descriptor for `RenameSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameSessionResponseDescriptor =
    $convert.base64Decode('ChVSZW5hbWVTZXNzaW9uUmVzcG9uc2U=');

@$core.Deprecated('Use deleteSessionRequestDescriptor instead')
const DeleteSessionRequest$json = {
  '1': 'DeleteSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `DeleteSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSessionRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use deleteSessionResponseDescriptor instead')
const DeleteSessionResponse$json = {
  '1': 'DeleteSessionResponse',
  '2': [
    {'1': 'deleted', '3': 1, '4': 1, '5': 8, '10': 'deleted'},
  ],
};

/// Descriptor for `DeleteSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSessionResponseDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVTZXNzaW9uUmVzcG9uc2USGAoHZGVsZXRlZBgBIAEoCFIHZGVsZXRlZA==');
