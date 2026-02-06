// This is a generated file - do not edit.
//
// Generated from betcode/v1/config.proto.

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

@$core.Deprecated('Use mcpServerStatusDescriptor instead')
const McpServerStatus$json = {
  '1': 'McpServerStatus',
  '2': [
    {'1': 'MCP_SERVER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MCP_SERVER_STATUS_RUNNING', '2': 1},
    {'1': 'MCP_SERVER_STATUS_STOPPED', '2': 2},
    {'1': 'MCP_SERVER_STATUS_STARTING', '2': 3},
    {'1': 'MCP_SERVER_STATUS_ERROR', '2': 4},
  ],
};

/// Descriptor for `McpServerStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mcpServerStatusDescriptor = $convert.base64Decode(
    'Cg9NY3BTZXJ2ZXJTdGF0dXMSIQodTUNQX1NFUlZFUl9TVEFUVVNfVU5TUEVDSUZJRUQQABIdCh'
    'lNQ1BfU0VSVkVSX1NUQVRVU19SVU5OSU5HEAESHQoZTUNQX1NFUlZFUl9TVEFUVVNfU1RPUFBF'
    'RBACEh4KGk1DUF9TRVJWRVJfU1RBVFVTX1NUQVJUSU5HEAMSGwoXTUNQX1NFUlZFUl9TVEFUVV'
    'NfRVJST1IQBA==');

@$core.Deprecated('Use permissionActionDescriptor instead')
const PermissionAction$json = {
  '1': 'PermissionAction',
  '2': [
    {'1': 'PERMISSION_ACTION_UNSPECIFIED', '2': 0},
    {'1': 'PERMISSION_ACTION_ALLOW', '2': 1},
    {'1': 'PERMISSION_ACTION_DENY', '2': 2},
    {'1': 'PERMISSION_ACTION_ASK', '2': 3},
    {'1': 'PERMISSION_ACTION_ASK_SESSION', '2': 4},
  ],
};

/// Descriptor for `PermissionAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List permissionActionDescriptor = $convert.base64Decode(
    'ChBQZXJtaXNzaW9uQWN0aW9uEiEKHVBFUk1JU1NJT05fQUNUSU9OX1VOU1BFQ0lGSUVEEAASGw'
    'oXUEVSTUlTU0lPTl9BQ1RJT05fQUxMT1cQARIaChZQRVJNSVNTSU9OX0FDVElPTl9ERU5ZEAIS'
    'GQoVUEVSTUlTU0lPTl9BQ1RJT05fQVNLEAMSIQodUEVSTUlTU0lPTl9BQ1RJT05fQVNLX1NFU1'
    'NJT04QBA==');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
  '2': [
    {'1': 'scope', '3': 1, '4': 1, '5': 9, '10': 'scope'},
  ],
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor = $convert
    .base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3QSFAoFc2NvcGUYASABKAlSBXNjb3Bl');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {
      '1': 'daemon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.DaemonSettings',
      '10': 'daemon'
    },
    {
      '1': 'sessions',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.SessionSettings',
      '10': 'sessions'
    },
    {
      '1': 'permissions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PermissionSettings',
      '10': 'permissions'
    },
    {
      '1': 'feature_flags',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.Settings.FeatureFlagsEntry',
      '10': 'featureFlags'
    },
  ],
  '3': [Settings_FeatureFlagsEntry$json],
};

@$core.Deprecated('Use settingsDescriptor instead')
const Settings_FeatureFlagsEntry$json = {
  '1': 'FeatureFlagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxIyCgZkYWVtb24YASABKAsyGi5iZXRjb2RlLnYxLkRhZW1vblNldHRpbmdzUg'
    'ZkYWVtb24SNwoIc2Vzc2lvbnMYAiABKAsyGy5iZXRjb2RlLnYxLlNlc3Npb25TZXR0aW5nc1II'
    'c2Vzc2lvbnMSQAoLcGVybWlzc2lvbnMYAyABKAsyHi5iZXRjb2RlLnYxLlBlcm1pc3Npb25TZX'
    'R0aW5nc1ILcGVybWlzc2lvbnMSSwoNZmVhdHVyZV9mbGFncxgEIAMoCzImLmJldGNvZGUudjEu'
    'U2V0dGluZ3MuRmVhdHVyZUZsYWdzRW50cnlSDGZlYXR1cmVGbGFncxo/ChFGZWF0dXJlRmxhZ3'
    'NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCFIFdmFsdWU6AjgB');

@$core.Deprecated('Use daemonSettingsDescriptor instead')
const DaemonSettings$json = {
  '1': 'DaemonSettings',
  '2': [
    {'1': 'max_subprocesses', '3': 1, '4': 1, '5': 13, '10': 'maxSubprocesses'},
    {'1': 'socket_path', '3': 2, '4': 1, '5': 9, '10': 'socketPath'},
    {'1': 'port', '3': 3, '4': 1, '5': 13, '10': 'port'},
    {'1': 'database_path', '3': 4, '4': 1, '5': 9, '10': 'databasePath'},
    {'1': 'log_level', '3': 5, '4': 1, '5': 9, '10': 'logLevel'},
    {
      '1': 'max_payload_bytes',
      '3': 6,
      '4': 1,
      '5': 13,
      '10': 'maxPayloadBytes'
    },
  ],
};

/// Descriptor for `DaemonSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List daemonSettingsDescriptor = $convert.base64Decode(
    'Cg5EYWVtb25TZXR0aW5ncxIpChBtYXhfc3VicHJvY2Vzc2VzGAEgASgNUg9tYXhTdWJwcm9jZX'
    'NzZXMSHwoLc29ja2V0X3BhdGgYAiABKAlSCnNvY2tldFBhdGgSEgoEcG9ydBgDIAEoDVIEcG9y'
    'dBIjCg1kYXRhYmFzZV9wYXRoGAQgASgJUgxkYXRhYmFzZVBhdGgSGwoJbG9nX2xldmVsGAUgAS'
    'gJUghsb2dMZXZlbBIqChFtYXhfcGF5bG9hZF9ieXRlcxgGIAEoDVIPbWF4UGF5bG9hZEJ5dGVz');

@$core.Deprecated('Use sessionSettingsDescriptor instead')
const SessionSettings$json = {
  '1': 'SessionSettings',
  '2': [
    {'1': 'default_model', '3': 1, '4': 1, '5': 9, '10': 'defaultModel'},
    {'1': 'auto_compact', '3': 2, '4': 1, '5': 8, '10': 'autoCompact'},
    {
      '1': 'auto_compact_threshold',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'autoCompactThreshold'
    },
    {
      '1': 'max_messages_per_session',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'maxMessagesPerSession'
    },
  ],
};

/// Descriptor for `SessionSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionSettingsDescriptor = $convert.base64Decode(
    'Cg9TZXNzaW9uU2V0dGluZ3MSIwoNZGVmYXVsdF9tb2RlbBgBIAEoCVIMZGVmYXVsdE1vZGVsEi'
    'EKDGF1dG9fY29tcGFjdBgCIAEoCFILYXV0b0NvbXBhY3QSNAoWYXV0b19jb21wYWN0X3RocmVz'
    'aG9sZBgDIAEoDVIUYXV0b0NvbXBhY3RUaHJlc2hvbGQSNwoYbWF4X21lc3NhZ2VzX3Blcl9zZX'
    'NzaW9uGAQgASgNUhVtYXhNZXNzYWdlc1BlclNlc3Npb24=');

@$core.Deprecated('Use permissionSettingsDescriptor instead')
const PermissionSettings$json = {
  '1': 'PermissionSettings',
  '2': [
    {
      '1': 'connected_timeout_secs',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'connectedTimeoutSecs'
    },
    {
      '1': 'disconnected_timeout_secs',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'disconnectedTimeoutSecs'
    },
    {
      '1': 'enable_auto_approve',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'enableAutoApprove'
    },
    {
      '1': 'auto_approve_directories',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'autoApproveDirectories'
    },
    {
      '1': 'activity_refresh_enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'activityRefreshEnabled'
    },
  ],
};

/// Descriptor for `PermissionSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionSettingsDescriptor = $convert.base64Decode(
    'ChJQZXJtaXNzaW9uU2V0dGluZ3MSNAoWY29ubmVjdGVkX3RpbWVvdXRfc2VjcxgBIAEoDVIUY2'
    '9ubmVjdGVkVGltZW91dFNlY3MSOgoZZGlzY29ubmVjdGVkX3RpbWVvdXRfc2VjcxgCIAEoDVIX'
    'ZGlzY29ubmVjdGVkVGltZW91dFNlY3MSLgoTZW5hYmxlX2F1dG9fYXBwcm92ZRgDIAEoCFIRZW'
    '5hYmxlQXV0b0FwcHJvdmUSOAoYYXV0b19hcHByb3ZlX2RpcmVjdG9yaWVzGAQgAygJUhZhdXRv'
    'QXBwcm92ZURpcmVjdG9yaWVzEjgKGGFjdGl2aXR5X3JlZnJlc2hfZW5hYmxlZBgFIAEoCFIWYW'
    'N0aXZpdHlSZWZyZXNoRW5hYmxlZA==');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.Settings',
      '10': 'settings'
    },
    {'1': 'scope', '3': 2, '4': 1, '5': 9, '10': 'scope'},
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSMAoIc2V0dGluZ3MYASABKAsyFC5iZXRjb2RlLnYxLl'
    'NldHRpbmdzUghzZXR0aW5ncxIUCgVzY29wZRgCIAEoCVIFc2NvcGU=');

@$core.Deprecated('Use listMcpServersRequestDescriptor instead')
const ListMcpServersRequest$json = {
  '1': 'ListMcpServersRequest',
  '2': [
    {'1': 'status_filter', '3': 1, '4': 1, '5': 9, '10': 'statusFilter'},
  ],
};

/// Descriptor for `ListMcpServersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMcpServersRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0TWNwU2VydmVyc1JlcXVlc3QSIwoNc3RhdHVzX2ZpbHRlchgBIAEoCVIMc3RhdHVzRm'
    'lsdGVy');

@$core.Deprecated('Use listMcpServersResponseDescriptor instead')
const ListMcpServersResponse$json = {
  '1': 'ListMcpServersResponse',
  '2': [
    {
      '1': 'servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.McpServerInfo',
      '10': 'servers'
    },
  ],
};

/// Descriptor for `ListMcpServersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMcpServersResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0TWNwU2VydmVyc1Jlc3BvbnNlEjMKB3NlcnZlcnMYASADKAsyGS5iZXRjb2RlLnYxLk'
        '1jcFNlcnZlckluZm9SB3NlcnZlcnM=');

@$core.Deprecated('Use mcpServerInfoDescriptor instead')
const McpServerInfo$json = {
  '1': 'McpServerInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'server_type', '3': 2, '4': 1, '5': 9, '10': 'serverType'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.McpServerStatus',
      '10': 'status'
    },
    {'1': 'tools', '3': 5, '4': 3, '5': 9, '10': 'tools'},
    {'1': 'error_message', '3': 6, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `McpServerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mcpServerInfoDescriptor = $convert.base64Decode(
    'Cg1NY3BTZXJ2ZXJJbmZvEhIKBG5hbWUYASABKAlSBG5hbWUSHwoLc2VydmVyX3R5cGUYAiABKA'
    'lSCnNlcnZlclR5cGUSGgoIZW5kcG9pbnQYAyABKAlSCGVuZHBvaW50EjMKBnN0YXR1cxgEIAEo'
    'DjIbLmJldGNvZGUudjEuTWNwU2VydmVyU3RhdHVzUgZzdGF0dXMSFAoFdG9vbHMYBSADKAlSBX'
    'Rvb2xzEiMKDWVycm9yX21lc3NhZ2UYBiABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use getPermissionsRequestDescriptor instead')
const GetPermissionsRequest$json = {
  '1': 'GetPermissionsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `GetPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPermissionsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRQZXJtaXNzaW9uc1JlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use permissionRulesDescriptor instead')
const PermissionRules$json = {
  '1': 'PermissionRules',
  '2': [
    {
      '1': 'rules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.PermissionRule',
      '10': 'rules'
    },
    {'1': 'denied_tools', '3': 2, '4': 3, '5': 9, '10': 'deniedTools'},
    {'1': 'require_approval', '3': 3, '4': 3, '5': 9, '10': 'requireApproval'},
  ],
};

/// Descriptor for `PermissionRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionRulesDescriptor = $convert.base64Decode(
    'Cg9QZXJtaXNzaW9uUnVsZXMSMAoFcnVsZXMYASADKAsyGi5iZXRjb2RlLnYxLlBlcm1pc3Npb2'
    '5SdWxlUgVydWxlcxIhCgxkZW5pZWRfdG9vbHMYAiADKAlSC2RlbmllZFRvb2xzEikKEHJlcXVp'
    'cmVfYXBwcm92YWwYAyADKAlSD3JlcXVpcmVBcHByb3ZhbA==');

@$core.Deprecated('Use permissionRuleDescriptor instead')
const PermissionRule$json = {
  '1': 'PermissionRule',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'tool_pattern', '3': 2, '4': 1, '5': 9, '10': 'toolPattern'},
    {'1': 'path_pattern', '3': 3, '4': 1, '5': 9, '10': 'pathPattern'},
    {
      '1': 'action',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.PermissionAction',
      '10': 'action'
    },
    {'1': 'priority', '3': 5, '4': 1, '5': 13, '10': 'priority'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'source', '3': 7, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `PermissionRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionRuleDescriptor = $convert.base64Decode(
    'Cg5QZXJtaXNzaW9uUnVsZRIOCgJpZBgBIAEoCVICaWQSIQoMdG9vbF9wYXR0ZXJuGAIgASgJUg'
    't0b29sUGF0dGVybhIhCgxwYXRoX3BhdHRlcm4YAyABKAlSC3BhdGhQYXR0ZXJuEjQKBmFjdGlv'
    'bhgEIAEoDjIcLmJldGNvZGUudjEuUGVybWlzc2lvbkFjdGlvblIGYWN0aW9uEhoKCHByaW9yaX'
    'R5GAUgASgNUghwcmlvcml0eRIgCgtkZXNjcmlwdGlvbhgGIAEoCVILZGVzY3JpcHRpb24SFgoG'
    'c291cmNlGAcgASgJUgZzb3VyY2U=');
