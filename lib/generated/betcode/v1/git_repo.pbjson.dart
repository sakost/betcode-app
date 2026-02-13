// This is a generated file - do not edit.
//
// Generated from betcode/v1/git_repo.proto.

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

@$core.Deprecated('Use worktreeModeDescriptor instead')
const WorktreeMode$json = {
  '1': 'WorktreeMode',
  '2': [
    {'1': 'WORKTREE_MODE_UNSPECIFIED', '2': 0},
    {'1': 'WORKTREE_MODE_GLOBAL', '2': 1},
    {'1': 'WORKTREE_MODE_LOCAL', '2': 2},
    {'1': 'WORKTREE_MODE_CUSTOM', '2': 3},
  ],
};

/// Descriptor for `WorktreeMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List worktreeModeDescriptor = $convert.base64Decode(
    'CgxXb3JrdHJlZU1vZGUSHQoZV09SS1RSRUVfTU9ERV9VTlNQRUNJRklFRBAAEhgKFFdPUktUUk'
    'VFX01PREVfR0xPQkFMEAESFwoTV09SS1RSRUVfTU9ERV9MT0NBTBACEhgKFFdPUktUUkVFX01P'
    'REVfQ1VTVE9NEAM=');

@$core.Deprecated('Use registerRepoRequestDescriptor instead')
const RegisterRepoRequest$json = {
  '1': 'RegisterRepoRequest',
  '2': [
    {'1': 'repo_path', '3': 1, '4': 1, '5': 9, '10': 'repoPath'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'worktree_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.WorktreeMode',
      '10': 'worktreeMode'
    },
    {'1': 'local_subfolder', '3': 4, '4': 1, '5': 9, '10': 'localSubfolder'},
    {'1': 'custom_path', '3': 5, '4': 1, '5': 9, '10': 'customPath'},
    {'1': 'setup_script', '3': 6, '4': 1, '5': 9, '10': 'setupScript'},
    {'1': 'auto_gitignore', '3': 7, '4': 1, '5': 8, '10': 'autoGitignore'},
  ],
};

/// Descriptor for `RegisterRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRepoRequestDescriptor = $convert.base64Decode(
    'ChNSZWdpc3RlclJlcG9SZXF1ZXN0EhsKCXJlcG9fcGF0aBgBIAEoCVIIcmVwb1BhdGgSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZRI9Cg13b3JrdHJlZV9tb2RlGAMgASgOMhguYmV0Y29kZS52MS5Xb3Jr'
    'dHJlZU1vZGVSDHdvcmt0cmVlTW9kZRInCg9sb2NhbF9zdWJmb2xkZXIYBCABKAlSDmxvY2FsU3'
    'ViZm9sZGVyEh8KC2N1c3RvbV9wYXRoGAUgASgJUgpjdXN0b21QYXRoEiEKDHNldHVwX3Njcmlw'
    'dBgGIAEoCVILc2V0dXBTY3JpcHQSJQoOYXV0b19naXRpZ25vcmUYByABKAhSDWF1dG9HaXRpZ2'
    '5vcmU=');

@$core.Deprecated('Use unregisterRepoRequestDescriptor instead')
const UnregisterRepoRequest$json = {
  '1': 'UnregisterRepoRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'remove_worktrees', '3': 2, '4': 1, '5': 8, '10': 'removeWorktrees'},
  ],
};

/// Descriptor for `UnregisterRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterRepoRequestDescriptor = $convert.base64Decode(
    'ChVVbnJlZ2lzdGVyUmVwb1JlcXVlc3QSDgoCaWQYASABKAlSAmlkEikKEHJlbW92ZV93b3JrdH'
    'JlZXMYAiABKAhSD3JlbW92ZVdvcmt0cmVlcw==');

@$core.Deprecated('Use listReposRequestDescriptor instead')
const ListReposRequest$json = {
  '1': 'ListReposRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 2, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListReposRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UmVwb3NSZXF1ZXN0EhQKBWxpbWl0GAEgASgNUgVsaW1pdBIWCgZvZmZzZXQYAiABKA'
    '1SBm9mZnNldA==');

@$core.Deprecated('Use getRepoRequestDescriptor instead')
const GetRepoRequest$json = {
  '1': 'GetRepoRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRepoRequestDescriptor =
    $convert.base64Decode('Cg5HZXRSZXBvUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use updateRepoRequestDescriptor instead')
const UpdateRepoRequest$json = {
  '1': 'UpdateRepoRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {
      '1': 'worktree_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.WorktreeMode',
      '9': 1,
      '10': 'worktreeMode',
      '17': true
    },
    {
      '1': 'local_subfolder',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'localSubfolder',
      '17': true
    },
    {
      '1': 'custom_path',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'customPath',
      '17': true
    },
    {
      '1': 'setup_script',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'setupScript',
      '17': true
    },
    {
      '1': 'auto_gitignore',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 5,
      '10': 'autoGitignore',
      '17': true
    },
  ],
  '8': [
    {'1': '_name'},
    {'1': '_worktree_mode'},
    {'1': '_local_subfolder'},
    {'1': '_custom_path'},
    {'1': '_setup_script'},
    {'1': '_auto_gitignore'},
  ],
};

/// Descriptor for `UpdateRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRepoRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSZXBvUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSFwoEbmFtZRgCIAEoCUgAUgRuYW'
    '1liAEBEkIKDXdvcmt0cmVlX21vZGUYAyABKA4yGC5iZXRjb2RlLnYxLldvcmt0cmVlTW9kZUgB'
    'Ugx3b3JrdHJlZU1vZGWIAQESLAoPbG9jYWxfc3ViZm9sZGVyGAQgASgJSAJSDmxvY2FsU3ViZm'
    '9sZGVyiAEBEiQKC2N1c3RvbV9wYXRoGAUgASgJSANSCmN1c3RvbVBhdGiIAQESJgoMc2V0dXBf'
    'c2NyaXB0GAYgASgJSARSC3NldHVwU2NyaXB0iAEBEioKDmF1dG9fZ2l0aWdub3JlGAcgASgISA'
    'VSDWF1dG9HaXRpZ25vcmWIAQFCBwoFX25hbWVCEAoOX3dvcmt0cmVlX21vZGVCEgoQX2xvY2Fs'
    'X3N1YmZvbGRlckIOCgxfY3VzdG9tX3BhdGhCDwoNX3NldHVwX3NjcmlwdEIRCg9fYXV0b19naX'
    'RpZ25vcmU=');

@$core.Deprecated('Use scanReposRequestDescriptor instead')
const ScanReposRequest$json = {
  '1': 'ScanReposRequest',
  '2': [
    {'1': 'scan_path', '3': 1, '4': 1, '5': 9, '10': 'scanPath'},
    {'1': 'max_depth', '3': 2, '4': 1, '5': 13, '10': 'maxDepth'},
  ],
};

/// Descriptor for `ScanReposRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanReposRequestDescriptor = $convert.base64Decode(
    'ChBTY2FuUmVwb3NSZXF1ZXN0EhsKCXNjYW5fcGF0aBgBIAEoCVIIc2NhblBhdGgSGwoJbWF4X2'
    'RlcHRoGAIgASgNUghtYXhEZXB0aA==');

@$core.Deprecated('Use unregisterRepoResponseDescriptor instead')
const UnregisterRepoResponse$json = {
  '1': 'UnregisterRepoResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
    {
      '1': 'worktrees_removed',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'worktreesRemoved'
    },
  ],
};

/// Descriptor for `UnregisterRepoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterRepoResponseDescriptor =
    $convert.base64Decode(
        'ChZVbnJlZ2lzdGVyUmVwb1Jlc3BvbnNlEhgKB3JlbW92ZWQYASABKAhSB3JlbW92ZWQSKwoRd2'
        '9ya3RyZWVzX3JlbW92ZWQYAiABKA1SEHdvcmt0cmVlc1JlbW92ZWQ=');

@$core.Deprecated('Use listReposResponseDescriptor instead')
const ListReposResponse$json = {
  '1': 'ListReposResponse',
  '2': [
    {
      '1': 'repos',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.GitRepoDetail',
      '10': 'repos'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 13, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListReposResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UmVwb3NSZXNwb25zZRIvCgVyZXBvcxgBIAMoCzIZLmJldGNvZGUudjEuR2l0UmVwb0'
    'RldGFpbFIFcmVwb3MSHwoLdG90YWxfY291bnQYAiABKA1SCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use gitRepoDetailDescriptor instead')
const GitRepoDetail$json = {
  '1': 'GitRepoDetail',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'repo_path', '3': 3, '4': 1, '5': 9, '10': 'repoPath'},
    {
      '1': 'worktree_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.WorktreeMode',
      '10': 'worktreeMode'
    },
    {'1': 'local_subfolder', '3': 5, '4': 1, '5': 9, '10': 'localSubfolder'},
    {'1': 'custom_path', '3': 6, '4': 1, '5': 9, '10': 'customPath'},
    {'1': 'setup_script', '3': 7, '4': 1, '5': 9, '10': 'setupScript'},
    {'1': 'auto_gitignore', '3': 8, '4': 1, '5': 8, '10': 'autoGitignore'},
    {'1': 'worktree_count', '3': 9, '4': 1, '5': 13, '10': 'worktreeCount'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'last_active',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActive'
    },
  ],
};

/// Descriptor for `GitRepoDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gitRepoDetailDescriptor = $convert.base64Decode(
    'Cg1HaXRSZXBvRGV0YWlsEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhsKCX'
    'JlcG9fcGF0aBgDIAEoCVIIcmVwb1BhdGgSPQoNd29ya3RyZWVfbW9kZRgEIAEoDjIYLmJldGNv'
    'ZGUudjEuV29ya3RyZWVNb2RlUgx3b3JrdHJlZU1vZGUSJwoPbG9jYWxfc3ViZm9sZGVyGAUgAS'
    'gJUg5sb2NhbFN1YmZvbGRlchIfCgtjdXN0b21fcGF0aBgGIAEoCVIKY3VzdG9tUGF0aBIhCgxz'
    'ZXR1cF9zY3JpcHQYByABKAlSC3NldHVwU2NyaXB0EiUKDmF1dG9fZ2l0aWdub3JlGAggASgIUg'
    '1hdXRvR2l0aWdub3JlEiUKDndvcmt0cmVlX2NvdW50GAkgASgNUg13b3JrdHJlZUNvdW50EjkK'
    'CmNyZWF0ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQX'
    'QSOwoLbGFzdF9hY3RpdmUYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpsYXN0'
    'QWN0aXZl');
