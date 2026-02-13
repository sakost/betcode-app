// This is a generated file - do not edit.
//
// Generated from betcode/v1/commands.proto.

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

@$core.Deprecated('Use commandCategoryDescriptor instead')
const CommandCategory$json = {
  '1': 'CommandCategory',
  '2': [
    {'1': 'COMMAND_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'COMMAND_CATEGORY_SERVICE', '2': 1},
    {'1': 'COMMAND_CATEGORY_CLAUDE_CODE', '2': 2},
    {'1': 'COMMAND_CATEGORY_PLUGIN', '2': 3},
  ],
};

/// Descriptor for `CommandCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commandCategoryDescriptor = $convert.base64Decode(
    'Cg9Db21tYW5kQ2F0ZWdvcnkSIAocQ09NTUFORF9DQVRFR09SWV9VTlNQRUNJRklFRBAAEhwKGE'
    'NPTU1BTkRfQ0FURUdPUllfU0VSVklDRRABEiAKHENPTU1BTkRfQ0FURUdPUllfQ0xBVURFX0NP'
    'REUQAhIbChdDT01NQU5EX0NBVEVHT1JZX1BMVUdJThAD');

@$core.Deprecated('Use executionModeDescriptor instead')
const ExecutionMode$json = {
  '1': 'ExecutionMode',
  '2': [
    {'1': 'EXECUTION_MODE_UNSPECIFIED', '2': 0},
    {'1': 'EXECUTION_MODE_LOCAL', '2': 1},
    {'1': 'EXECUTION_MODE_PASSTHROUGH', '2': 2},
    {'1': 'EXECUTION_MODE_PLUGIN', '2': 3},
  ],
};

/// Descriptor for `ExecutionMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List executionModeDescriptor = $convert.base64Decode(
    'Cg1FeGVjdXRpb25Nb2RlEh4KGkVYRUNVVElPTl9NT0RFX1VOU1BFQ0lGSUVEEAASGAoURVhFQ1'
    'VUSU9OX01PREVfTE9DQUwQARIeChpFWEVDVVRJT05fTU9ERV9QQVNTVEhST1VHSBACEhkKFUVY'
    'RUNVVElPTl9NT0RFX1BMVUdJThAD');

@$core.Deprecated('Use agentKindDescriptor instead')
const AgentKind$json = {
  '1': 'AgentKind',
  '2': [
    {'1': 'AGENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_KIND_CLAUDE_INTERNAL', '2': 1},
    {'1': 'AGENT_KIND_DAEMON_ORCHESTRATED', '2': 2},
    {'1': 'AGENT_KIND_TEAM_MEMBER', '2': 3},
  ],
};

/// Descriptor for `AgentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentKindDescriptor = $convert.base64Decode(
    'CglBZ2VudEtpbmQSGgoWQUdFTlRfS0lORF9VTlNQRUNJRklFRBAAEh4KGkFHRU5UX0tJTkRfQ0'
    'xBVURFX0lOVEVSTkFMEAESIgoeQUdFTlRfS0lORF9EQUVNT05fT1JDSEVTVFJBVEVEEAISGgoW'
    'QUdFTlRfS0lORF9URUFNX01FTUJFUhAD');

@$core.Deprecated('Use commandAgentStatusDescriptor instead')
const CommandAgentStatus$json = {
  '1': 'CommandAgentStatus',
  '2': [
    {'1': 'COMMAND_AGENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'COMMAND_AGENT_STATUS_IDLE', '2': 1},
    {'1': 'COMMAND_AGENT_STATUS_WORKING', '2': 2},
    {'1': 'COMMAND_AGENT_STATUS_DONE', '2': 3},
    {'1': 'COMMAND_AGENT_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `CommandAgentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commandAgentStatusDescriptor = $convert.base64Decode(
    'ChJDb21tYW5kQWdlbnRTdGF0dXMSJAogQ09NTUFORF9BR0VOVF9TVEFUVVNfVU5TUEVDSUZJRU'
    'QQABIdChlDT01NQU5EX0FHRU5UX1NUQVRVU19JRExFEAESIAocQ09NTUFORF9BR0VOVF9TVEFU'
    'VVNfV09SS0lORxACEh0KGUNPTU1BTkRfQUdFTlRfU1RBVFVTX0RPTkUQAxIfChtDT01NQU5EX0'
    'FHRU5UX1NUQVRVU19GQUlMRUQQBA==');

@$core.Deprecated('Use pathKindDescriptor instead')
const PathKind$json = {
  '1': 'PathKind',
  '2': [
    {'1': 'PATH_KIND_UNSPECIFIED', '2': 0},
    {'1': 'PATH_KIND_FILE', '2': 1},
    {'1': 'PATH_KIND_DIRECTORY', '2': 2},
    {'1': 'PATH_KIND_SYMLINK', '2': 3},
  ],
};

/// Descriptor for `PathKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pathKindDescriptor = $convert.base64Decode(
    'CghQYXRoS2luZBIZChVQQVRIX0tJTkRfVU5TUEVDSUZJRUQQABISCg5QQVRIX0tJTkRfRklMRR'
    'ABEhcKE1BBVEhfS0lORF9ESVJFQ1RPUlkQAhIVChFQQVRIX0tJTkRfU1lNTElOSxAD');

@$core.Deprecated('Use commandEntryDescriptor instead')
const CommandEntry$json = {
  '1': 'CommandEntry',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'category',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.CommandCategory',
      '10': 'category'
    },
    {
      '1': 'execution_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.ExecutionMode',
      '10': 'executionMode'
    },
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'args_schema',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'argsSchema',
      '17': true
    },
  ],
  '8': [
    {'1': '_args_schema'},
  ],
};

/// Descriptor for `CommandEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandEntryDescriptor = $convert.base64Decode(
    'CgxDb21tYW5kRW50cnkSEgoEbmFtZRgBIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgCIAEoCV'
    'ILZGVzY3JpcHRpb24SNwoIY2F0ZWdvcnkYAyABKA4yGy5iZXRjb2RlLnYxLkNvbW1hbmRDYXRl'
    'Z29yeVIIY2F0ZWdvcnkSQAoOZXhlY3V0aW9uX21vZGUYBCABKA4yGS5iZXRjb2RlLnYxLkV4ZW'
    'N1dGlvbk1vZGVSDWV4ZWN1dGlvbk1vZGUSFgoGc291cmNlGAUgASgJUgZzb3VyY2USJAoLYXJn'
    'c19zY2hlbWEYBiABKAlIAFIKYXJnc1NjaGVtYYgBAUIOCgxfYXJnc19zY2hlbWE=');

@$core.Deprecated('Use agentInfoDescriptor instead')
const AgentInfo$json = {
  '1': 'AgentInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.AgentKind',
      '10': 'kind'
    },
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.CommandAgentStatus',
      '10': 'status'
    },
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'session_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'sessionId',
      '17': true
    },
  ],
  '8': [
    {'1': '_session_id'},
  ],
};

/// Descriptor for `AgentInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentInfoDescriptor = $convert.base64Decode(
    'CglBZ2VudEluZm8SEgoEbmFtZRgBIAEoCVIEbmFtZRIpCgRraW5kGAIgASgOMhUuYmV0Y29kZS'
    '52MS5BZ2VudEtpbmRSBGtpbmQSNgoGc3RhdHVzGAMgASgOMh4uYmV0Y29kZS52MS5Db21tYW5k'
    'QWdlbnRTdGF0dXNSBnN0YXR1cxIWCgZzb3VyY2UYBCABKAlSBnNvdXJjZRIiCgpzZXNzaW9uX2'
    'lkGAUgASgJSABSCXNlc3Npb25JZIgBAUINCgtfc2Vzc2lvbl9pZA==');

@$core.Deprecated('Use pathEntryDescriptor instead')
const PathEntry$json = {
  '1': 'PathEntry',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.PathKind',
      '10': 'kind'
    },
    {'1': 'size', '3': 3, '4': 1, '5': 4, '10': 'size'},
    {'1': 'modified_at', '3': 4, '4': 1, '5': 3, '10': 'modifiedAt'},
  ],
};

/// Descriptor for `PathEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathEntryDescriptor = $convert.base64Decode(
    'CglQYXRoRW50cnkSEgoEcGF0aBgBIAEoCVIEcGF0aBIoCgRraW5kGAIgASgOMhQuYmV0Y29kZS'
    '52MS5QYXRoS2luZFIEa2luZBISCgRzaXplGAMgASgEUgRzaXplEh8KC21vZGlmaWVkX2F0GAQg'
    'ASgDUgptb2RpZmllZEF0');

@$core.Deprecated('Use serviceCommandOutputDescriptor instead')
const ServiceCommandOutput$json = {
  '1': 'ServiceCommandOutput',
  '2': [
    {'1': 'stdout_line', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'stdoutLine'},
    {'1': 'stderr_line', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'stderrLine'},
    {'1': 'exit_code', '3': 3, '4': 1, '5': 5, '9': 0, '10': 'exitCode'},
    {'1': 'error', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'output'},
  ],
};

/// Descriptor for `ServiceCommandOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceCommandOutputDescriptor = $convert.base64Decode(
    'ChRTZXJ2aWNlQ29tbWFuZE91dHB1dBIhCgtzdGRvdXRfbGluZRgBIAEoCUgAUgpzdGRvdXRMaW'
    '5lEiEKC3N0ZGVycl9saW5lGAIgASgJSABSCnN0ZGVyckxpbmUSHQoJZXhpdF9jb2RlGAMgASgF'
    'SABSCGV4aXRDb2RlEhYKBWVycm9yGAQgASgJSABSBWVycm9yQggKBm91dHB1dA==');

@$core.Deprecated('Use pluginInfoDescriptor instead')
const PluginInfo$json = {
  '1': 'PluginInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'enabled', '3': 3, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'socket_path', '3': 4, '4': 1, '5': 9, '10': 'socketPath'},
    {'1': 'command_count', '3': 5, '4': 1, '5': 13, '10': 'commandCount'},
    {
      '1': 'health_message',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'healthMessage',
      '17': true
    },
    {
      '1': 'healthy',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'healthy',
      '17': true
    },
  ],
  '8': [
    {'1': '_health_message'},
    {'1': '_healthy'},
  ],
};

/// Descriptor for `PluginInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginInfoDescriptor = $convert.base64Decode(
    'CgpQbHVnaW5JbmZvEhIKBG5hbWUYASABKAlSBG5hbWUSFgoGc3RhdHVzGAIgASgJUgZzdGF0dX'
    'MSGAoHZW5hYmxlZBgDIAEoCFIHZW5hYmxlZBIfCgtzb2NrZXRfcGF0aBgEIAEoCVIKc29ja2V0'
    'UGF0aBIjCg1jb21tYW5kX2NvdW50GAUgASgNUgxjb21tYW5kQ291bnQSKgoOaGVhbHRoX21lc3'
    'NhZ2UYBiABKAlIAFINaGVhbHRoTWVzc2FnZYgBARIdCgdoZWFsdGh5GAcgASgISAFSB2hlYWx0'
    'aHmIAQFCEQoPX2hlYWx0aF9tZXNzYWdlQgoKCF9oZWFsdGh5');

@$core.Deprecated('Use getCommandRegistryRequestDescriptor instead')
const GetCommandRegistryRequest$json = {
  '1': 'GetCommandRegistryRequest',
};

/// Descriptor for `GetCommandRegistryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommandRegistryRequestDescriptor =
    $convert.base64Decode('ChlHZXRDb21tYW5kUmVnaXN0cnlSZXF1ZXN0');

@$core.Deprecated('Use getCommandRegistryResponseDescriptor instead')
const GetCommandRegistryResponse$json = {
  '1': 'GetCommandRegistryResponse',
  '2': [
    {
      '1': 'commands',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.CommandEntry',
      '10': 'commands'
    },
  ],
};

/// Descriptor for `GetCommandRegistryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommandRegistryResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRDb21tYW5kUmVnaXN0cnlSZXNwb25zZRI0Cghjb21tYW5kcxgBIAMoCzIYLmJldGNvZG'
        'UudjEuQ29tbWFuZEVudHJ5Ughjb21tYW5kcw==');

@$core.Deprecated('Use listAgentsRequestDescriptor instead')
const ListAgentsRequest$json = {
  '1': 'ListAgentsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'max_results', '3': 2, '4': 1, '5': 13, '10': 'maxResults'},
  ],
};

/// Descriptor for `ListAgentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAgentsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWdlbnRzUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSHwoLbWF4X3Jlc3VsdH'
    'MYAiABKA1SCm1heFJlc3VsdHM=');

@$core.Deprecated('Use listAgentsResponseDescriptor instead')
const ListAgentsResponse$json = {
  '1': 'ListAgentsResponse',
  '2': [
    {
      '1': 'agents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.AgentInfo',
      '10': 'agents'
    },
  ],
};

/// Descriptor for `ListAgentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAgentsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWdlbnRzUmVzcG9uc2USLQoGYWdlbnRzGAEgAygLMhUuYmV0Y29kZS52MS5BZ2VudE'
    'luZm9SBmFnZW50cw==');

@$core.Deprecated('Use listPathRequestDescriptor instead')
const ListPathRequest$json = {
  '1': 'ListPathRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'max_results', '3': 2, '4': 1, '5': 13, '10': 'maxResults'},
  ],
};

/// Descriptor for `ListPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPathRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0UGF0aFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5Eh8KC21heF9yZXN1bHRzGA'
    'IgASgNUgptYXhSZXN1bHRz');

@$core.Deprecated('Use listPathResponseDescriptor instead')
const ListPathResponse$json = {
  '1': 'ListPathResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.PathEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ListPathResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPathResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0UGF0aFJlc3BvbnNlEi8KB2VudHJpZXMYASADKAsyFS5iZXRjb2RlLnYxLlBhdGhFbn'
    'RyeVIHZW50cmllcw==');

@$core.Deprecated('Use executeServiceCommandRequestDescriptor instead')
const ExecuteServiceCommandRequest$json = {
  '1': 'ExecuteServiceCommandRequest',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 9, '10': 'command'},
    {'1': 'args', '3': 2, '4': 3, '5': 9, '10': 'args'},
  ],
};

/// Descriptor for `ExecuteServiceCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeServiceCommandRequestDescriptor =
    $convert.base64Decode(
        'ChxFeGVjdXRlU2VydmljZUNvbW1hbmRSZXF1ZXN0EhgKB2NvbW1hbmQYASABKAlSB2NvbW1hbm'
        'QSEgoEYXJncxgCIAMoCVIEYXJncw==');

@$core.Deprecated('Use listPluginsRequestDescriptor instead')
const ListPluginsRequest$json = {
  '1': 'ListPluginsRequest',
};

/// Descriptor for `ListPluginsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPluginsRequestDescriptor =
    $convert.base64Decode('ChJMaXN0UGx1Z2luc1JlcXVlc3Q=');

@$core.Deprecated('Use listPluginsResponseDescriptor instead')
const ListPluginsResponse$json = {
  '1': 'ListPluginsResponse',
  '2': [
    {
      '1': 'plugins',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.PluginInfo',
      '10': 'plugins'
    },
  ],
};

/// Descriptor for `ListPluginsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPluginsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0UGx1Z2luc1Jlc3BvbnNlEjAKB3BsdWdpbnMYASADKAsyFi5iZXRjb2RlLnYxLlBsdW'
    'dpbkluZm9SB3BsdWdpbnM=');

@$core.Deprecated('Use getPluginStatusRequestDescriptor instead')
const GetPluginStatusRequest$json = {
  '1': 'GetPluginStatusRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `GetPluginStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPluginStatusRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRQbHVnaW5TdGF0dXNSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use getPluginStatusResponseDescriptor instead')
const GetPluginStatusResponse$json = {
  '1': 'GetPluginStatusResponse',
  '2': [
    {
      '1': 'plugin',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PluginInfo',
      '10': 'plugin'
    },
  ],
};

/// Descriptor for `GetPluginStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPluginStatusResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRQbHVnaW5TdGF0dXNSZXNwb25zZRIuCgZwbHVnaW4YASABKAsyFi5iZXRjb2RlLnYxLl'
        'BsdWdpbkluZm9SBnBsdWdpbg==');

@$core.Deprecated('Use addPluginRequestDescriptor instead')
const AddPluginRequest$json = {
  '1': 'AddPluginRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'socket_path', '3': 2, '4': 1, '5': 9, '10': 'socketPath'},
  ],
};

/// Descriptor for `AddPluginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPluginRequestDescriptor = $convert.base64Decode(
    'ChBBZGRQbHVnaW5SZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSHwoLc29ja2V0X3BhdGgYAi'
    'ABKAlSCnNvY2tldFBhdGg=');

@$core.Deprecated('Use addPluginResponseDescriptor instead')
const AddPluginResponse$json = {
  '1': 'AddPluginResponse',
  '2': [
    {
      '1': 'plugin',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PluginInfo',
      '10': 'plugin'
    },
  ],
};

/// Descriptor for `AddPluginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPluginResponseDescriptor = $convert.base64Decode(
    'ChFBZGRQbHVnaW5SZXNwb25zZRIuCgZwbHVnaW4YASABKAsyFi5iZXRjb2RlLnYxLlBsdWdpbk'
    'luZm9SBnBsdWdpbg==');

@$core.Deprecated('Use removePluginRequestDescriptor instead')
const RemovePluginRequest$json = {
  '1': 'RemovePluginRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RemovePluginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePluginRequestDescriptor = $convert
    .base64Decode('ChNSZW1vdmVQbHVnaW5SZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use removePluginResponseDescriptor instead')
const RemovePluginResponse$json = {
  '1': 'RemovePluginResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
  ],
};

/// Descriptor for `RemovePluginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePluginResponseDescriptor =
    $convert.base64Decode(
        'ChRSZW1vdmVQbHVnaW5SZXNwb25zZRIYCgdyZW1vdmVkGAEgASgIUgdyZW1vdmVk');

@$core.Deprecated('Use enablePluginRequestDescriptor instead')
const EnablePluginRequest$json = {
  '1': 'EnablePluginRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `EnablePluginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enablePluginRequestDescriptor = $convert
    .base64Decode('ChNFbmFibGVQbHVnaW5SZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use enablePluginResponseDescriptor instead')
const EnablePluginResponse$json = {
  '1': 'EnablePluginResponse',
  '2': [
    {
      '1': 'plugin',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PluginInfo',
      '10': 'plugin'
    },
  ],
};

/// Descriptor for `EnablePluginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enablePluginResponseDescriptor = $convert.base64Decode(
    'ChRFbmFibGVQbHVnaW5SZXNwb25zZRIuCgZwbHVnaW4YASABKAsyFi5iZXRjb2RlLnYxLlBsdW'
    'dpbkluZm9SBnBsdWdpbg==');

@$core.Deprecated('Use disablePluginRequestDescriptor instead')
const DisablePluginRequest$json = {
  '1': 'DisablePluginRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `DisablePluginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disablePluginRequestDescriptor = $convert
    .base64Decode('ChREaXNhYmxlUGx1Z2luUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1l');

@$core.Deprecated('Use disablePluginResponseDescriptor instead')
const DisablePluginResponse$json = {
  '1': 'DisablePluginResponse',
  '2': [
    {
      '1': 'plugin',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PluginInfo',
      '10': 'plugin'
    },
  ],
};

/// Descriptor for `DisablePluginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disablePluginResponseDescriptor = $convert.base64Decode(
    'ChVEaXNhYmxlUGx1Z2luUmVzcG9uc2USLgoGcGx1Z2luGAEgASgLMhYuYmV0Y29kZS52MS5QbH'
    'VnaW5JbmZvUgZwbHVnaW4=');
