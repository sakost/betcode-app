// This is a generated file - do not edit.
//
// Generated from betcode/v1/worktree.proto.

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

@$core.Deprecated('Use createWorktreeRequestDescriptor instead')
const CreateWorktreeRequest$json = {
  '1': 'CreateWorktreeRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'repo_id', '3': 2, '4': 1, '5': 9, '10': 'repoId'},
    {'1': 'branch', '3': 3, '4': 1, '5': 9, '10': 'branch'},
    {'1': 'setup_script', '3': 4, '4': 1, '5': 9, '10': 'setupScript'},
  ],
};

/// Descriptor for `CreateWorktreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWorktreeRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVXb3JrdHJlZVJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIXCgdyZXBvX2lkGA'
    'IgASgJUgZyZXBvSWQSFgoGYnJhbmNoGAMgASgJUgZicmFuY2gSIQoMc2V0dXBfc2NyaXB0GAQg'
    'ASgJUgtzZXR1cFNjcmlwdA==');

@$core.Deprecated('Use removeWorktreeRequestDescriptor instead')
const RemoveWorktreeRequest$json = {
  '1': 'RemoveWorktreeRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `RemoveWorktreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeWorktreeRequestDescriptor = $convert
    .base64Decode('ChVSZW1vdmVXb3JrdHJlZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use listWorktreesRequestDescriptor instead')
const ListWorktreesRequest$json = {
  '1': 'ListWorktreesRequest',
  '2': [
    {'1': 'repo_id', '3': 1, '4': 1, '5': 9, '10': 'repoId'},
  ],
};

/// Descriptor for `ListWorktreesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorktreesRequestDescriptor =
    $convert.base64Decode(
        'ChRMaXN0V29ya3RyZWVzUmVxdWVzdBIXCgdyZXBvX2lkGAEgASgJUgZyZXBvSWQ=');

@$core.Deprecated('Use getWorktreeRequestDescriptor instead')
const GetWorktreeRequest$json = {
  '1': 'GetWorktreeRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetWorktreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorktreeRequestDescriptor =
    $convert.base64Decode('ChJHZXRXb3JrdHJlZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use removeWorktreeResponseDescriptor instead')
const RemoveWorktreeResponse$json = {
  '1': 'RemoveWorktreeResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
  ],
};

/// Descriptor for `RemoveWorktreeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeWorktreeResponseDescriptor =
    $convert.base64Decode(
        'ChZSZW1vdmVXb3JrdHJlZVJlc3BvbnNlEhgKB3JlbW92ZWQYASABKAhSB3JlbW92ZWQ=');

@$core.Deprecated('Use listWorktreesResponseDescriptor instead')
const ListWorktreesResponse$json = {
  '1': 'ListWorktreesResponse',
  '2': [
    {
      '1': 'worktrees',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.WorktreeDetail',
      '10': 'worktrees'
    },
  ],
};

/// Descriptor for `ListWorktreesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorktreesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0V29ya3RyZWVzUmVzcG9uc2USOAoJd29ya3RyZWVzGAEgAygLMhouYmV0Y29kZS52MS'
    '5Xb3JrdHJlZURldGFpbFIJd29ya3RyZWVz');

@$core.Deprecated('Use worktreeDetailDescriptor instead')
const WorktreeDetail$json = {
  '1': 'WorktreeDetail',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'branch', '3': 4, '4': 1, '5': 9, '10': 'branch'},
    {'1': 'repo_id', '3': 5, '4': 1, '5': 9, '10': 'repoId'},
    {'1': 'setup_script', '3': 6, '4': 1, '5': 9, '10': 'setupScript'},
    {'1': 'exists_on_disk', '3': 7, '4': 1, '5': 8, '10': 'existsOnDisk'},
    {'1': 'session_count', '3': 8, '4': 1, '5': 13, '10': 'sessionCount'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'last_active',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActive'
    },
  ],
};

/// Descriptor for `WorktreeDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List worktreeDetailDescriptor = $convert.base64Decode(
    'Cg5Xb3JrdHJlZURldGFpbBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCg'
    'RwYXRoGAMgASgJUgRwYXRoEhYKBmJyYW5jaBgEIAEoCVIGYnJhbmNoEhcKB3JlcG9faWQYBSAB'
    'KAlSBnJlcG9JZBIhCgxzZXR1cF9zY3JpcHQYBiABKAlSC3NldHVwU2NyaXB0EiQKDmV4aXN0c1'
    '9vbl9kaXNrGAcgASgIUgxleGlzdHNPbkRpc2sSIwoNc2Vzc2lvbl9jb3VudBgIIAEoDVIMc2Vz'
    'c2lvbkNvdW50EjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgljcmVhdGVkQXQSOwoLbGFzdF9hY3RpdmUYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgpsYXN0QWN0aXZl');
