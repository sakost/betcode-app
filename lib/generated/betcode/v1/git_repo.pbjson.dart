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

@$core.Deprecated('Use registerRepoRequestDescriptor instead')
const RegisterRepoRequest$json = {
  '1': 'RegisterRepoRequest',
  '2': [
    {'1': 'repo_path', '3': 1, '4': 1, '5': 9, '10': 'repoPath'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'worktree_mode', '3': 3, '4': 1, '5': 9, '10': 'worktreeMode'},
    {'1': 'local_subfolder', '3': 4, '4': 1, '5': 9, '10': 'localSubfolder'},
    {'1': 'custom_path', '3': 5, '4': 1, '5': 9, '10': 'customPath'},
    {'1': 'setup_script', '3': 6, '4': 1, '5': 9, '10': 'setupScript'},
    {'1': 'auto_gitignore', '3': 7, '4': 1, '5': 8, '10': 'autoGitignore'},
  ],
};

/// Descriptor for `RegisterRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRepoRequestDescriptor = $convert.base64Decode(
    'ChNSZWdpc3RlclJlcG9SZXF1ZXN0EhsKCXJlcG9fcGF0aBgBIAEoCVIIcmVwb1BhdGgSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZRIjCg13b3JrdHJlZV9tb2RlGAMgASgJUgx3b3JrdHJlZU1vZGUSJwoP'
    'bG9jYWxfc3ViZm9sZGVyGAQgASgJUg5sb2NhbFN1YmZvbGRlchIfCgtjdXN0b21fcGF0aBgFIA'
    'EoCVIKY3VzdG9tUGF0aBIhCgxzZXR1cF9zY3JpcHQYBiABKAlSC3NldHVwU2NyaXB0EiUKDmF1'
    'dG9fZ2l0aWdub3JlGAcgASgIUg1hdXRvR2l0aWdub3Jl');

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
};

/// Descriptor for `ListReposRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposRequestDescriptor =
    $convert.base64Decode('ChBMaXN0UmVwb3NSZXF1ZXN0');

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
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'worktree_mode', '3': 3, '4': 1, '5': 9, '10': 'worktreeMode'},
    {'1': 'local_subfolder', '3': 4, '4': 1, '5': 9, '10': 'localSubfolder'},
    {'1': 'custom_path', '3': 5, '4': 1, '5': 9, '10': 'customPath'},
    {'1': 'setup_script', '3': 6, '4': 1, '5': 9, '10': 'setupScript'},
    {'1': 'auto_gitignore', '3': 7, '4': 1, '5': 8, '10': 'autoGitignore'},
  ],
};

/// Descriptor for `UpdateRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRepoRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSZXBvUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IjCg13b3JrdHJlZV9tb2RlGAMgASgJUgx3b3JrdHJlZU1vZGUSJwoPbG9jYWxfc3ViZm9sZGVy'
    'GAQgASgJUg5sb2NhbFN1YmZvbGRlchIfCgtjdXN0b21fcGF0aBgFIAEoCVIKY3VzdG9tUGF0aB'
    'IhCgxzZXR1cF9zY3JpcHQYBiABKAlSC3NldHVwU2NyaXB0EiUKDmF1dG9fZ2l0aWdub3JlGAcg'
    'ASgIUg1hdXRvR2l0aWdub3Jl');

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
  ],
};

/// Descriptor for `ListReposResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UmVwb3NSZXNwb25zZRIvCgVyZXBvcxgBIAMoCzIZLmJldGNvZGUudjEuR2l0UmVwb0'
    'RldGFpbFIFcmVwb3M=');

@$core.Deprecated('Use gitRepoDetailDescriptor instead')
const GitRepoDetail$json = {
  '1': 'GitRepoDetail',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'repo_path', '3': 3, '4': 1, '5': 9, '10': 'repoPath'},
    {'1': 'worktree_mode', '3': 4, '4': 1, '5': 9, '10': 'worktreeMode'},
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
    'JlcG9fcGF0aBgDIAEoCVIIcmVwb1BhdGgSIwoNd29ya3RyZWVfbW9kZRgEIAEoCVIMd29ya3Ry'
    'ZWVNb2RlEicKD2xvY2FsX3N1YmZvbGRlchgFIAEoCVIObG9jYWxTdWJmb2xkZXISHwoLY3VzdG'
    '9tX3BhdGgYBiABKAlSCmN1c3RvbVBhdGgSIQoMc2V0dXBfc2NyaXB0GAcgASgJUgtzZXR1cFNj'
    'cmlwdBIlCg5hdXRvX2dpdGlnbm9yZRgIIAEoCFINYXV0b0dpdGlnbm9yZRIlCg53b3JrdHJlZV'
    '9jb3VudBgJIAEoDVINd29ya3RyZWVDb3VudBI5CgpjcmVhdGVkX2F0GAogASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjsKC2xhc3RfYWN0aXZlGAsgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbGFzdEFjdGl2ZQ==');
