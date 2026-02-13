// This is a generated file - do not edit.
//
// Generated from betcode/v1/plugin.proto.

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

@$core.Deprecated('Use pluginRegisterRequestDescriptor instead')
const PluginRegisterRequest$json = {
  '1': 'PluginRegisterRequest',
};

/// Descriptor for `PluginRegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginRegisterRequestDescriptor =
    $convert.base64Decode('ChVQbHVnaW5SZWdpc3RlclJlcXVlc3Q=');

@$core.Deprecated('Use commandDefinitionDescriptor instead')
const CommandDefinition$json = {
  '1': 'CommandDefinition',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'args_schema', '3': 3, '4': 1, '5': 9, '10': 'argsSchema'},
  ],
};

/// Descriptor for `CommandDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDefinitionDescriptor = $convert.base64Decode(
    'ChFDb21tYW5kRGVmaW5pdGlvbhISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGA'
    'IgASgJUgtkZXNjcmlwdGlvbhIfCgthcmdzX3NjaGVtYRgDIAEoCVIKYXJnc1NjaGVtYQ==');

@$core.Deprecated('Use pluginRegisterResponseDescriptor instead')
const PluginRegisterResponse$json = {
  '1': 'PluginRegisterResponse',
  '2': [
    {
      '1': 'commands',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.CommandDefinition',
      '10': 'commands'
    },
  ],
};

/// Descriptor for `PluginRegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginRegisterResponseDescriptor =
    $convert.base64Decode(
        'ChZQbHVnaW5SZWdpc3RlclJlc3BvbnNlEjkKCGNvbW1hbmRzGAEgAygLMh0uYmV0Y29kZS52MS'
        '5Db21tYW5kRGVmaW5pdGlvblIIY29tbWFuZHM=');

@$core.Deprecated('Use pluginExecuteRequestDescriptor instead')
const PluginExecuteRequest$json = {
  '1': 'PluginExecuteRequest',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 9, '10': 'command'},
    {'1': 'args', '3': 2, '4': 1, '5': 9, '10': 'args'},
  ],
};

/// Descriptor for `PluginExecuteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginExecuteRequestDescriptor = $convert.base64Decode(
    'ChRQbHVnaW5FeGVjdXRlUmVxdWVzdBIYCgdjb21tYW5kGAEgASgJUgdjb21tYW5kEhIKBGFyZ3'
    'MYAiABKAlSBGFyZ3M=');

@$core.Deprecated('Use pluginExecuteResponseDescriptor instead')
const PluginExecuteResponse$json = {
  '1': 'PluginExecuteResponse',
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

/// Descriptor for `PluginExecuteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginExecuteResponseDescriptor = $convert.base64Decode(
    'ChVQbHVnaW5FeGVjdXRlUmVzcG9uc2USIQoLc3Rkb3V0X2xpbmUYASABKAlIAFIKc3Rkb3V0TG'
    'luZRIhCgtzdGRlcnJfbGluZRgCIAEoCUgAUgpzdGRlcnJMaW5lEh0KCWV4aXRfY29kZRgDIAEo'
    'BUgAUghleGl0Q29kZRIWCgVlcnJvchgEIAEoCUgAUgVlcnJvckIICgZvdXRwdXQ=');

@$core.Deprecated('Use pluginHealthCheckRequestDescriptor instead')
const PluginHealthCheckRequest$json = {
  '1': 'PluginHealthCheckRequest',
};

/// Descriptor for `PluginHealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginHealthCheckRequestDescriptor =
    $convert.base64Decode('ChhQbHVnaW5IZWFsdGhDaGVja1JlcXVlc3Q=');

@$core.Deprecated('Use pluginHealthCheckResponseDescriptor instead')
const PluginHealthCheckResponse$json = {
  '1': 'PluginHealthCheckResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 8, '10': 'status'},
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'message',
      '17': true
    },
  ],
  '8': [
    {'1': '_message'},
  ],
};

/// Descriptor for `PluginHealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pluginHealthCheckResponseDescriptor =
    $convert.base64Decode(
        'ChlQbHVnaW5IZWFsdGhDaGVja1Jlc3BvbnNlEhYKBnN0YXR1cxgBIAEoCFIGc3RhdHVzEh0KB2'
        '1lc3NhZ2UYAiABKAlIAFIHbWVzc2FnZYgBAUIKCghfbWVzc2FnZQ==');
