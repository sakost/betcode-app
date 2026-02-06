// This is a generated file - do not edit.
//
// Generated from betcode/v1/gitlab.proto.

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

@$core.Deprecated('Use mergeRequestStateDescriptor instead')
const MergeRequestState$json = {
  '1': 'MergeRequestState',
  '2': [
    {'1': 'MERGE_REQUEST_STATE_UNSPECIFIED', '2': 0},
    {'1': 'MERGE_REQUEST_STATE_OPENED', '2': 1},
    {'1': 'MERGE_REQUEST_STATE_CLOSED', '2': 2},
    {'1': 'MERGE_REQUEST_STATE_MERGED', '2': 3},
    {'1': 'MERGE_REQUEST_STATE_LOCKED', '2': 4},
  ],
};

/// Descriptor for `MergeRequestState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mergeRequestStateDescriptor = $convert.base64Decode(
    'ChFNZXJnZVJlcXVlc3RTdGF0ZRIjCh9NRVJHRV9SRVFVRVNUX1NUQVRFX1VOU1BFQ0lGSUVEEA'
    'ASHgoaTUVSR0VfUkVRVUVTVF9TVEFURV9PUEVORUQQARIeChpNRVJHRV9SRVFVRVNUX1NUQVRF'
    'X0NMT1NFRBACEh4KGk1FUkdFX1JFUVVFU1RfU1RBVEVfTUVSR0VEEAMSHgoaTUVSR0VfUkVRVU'
    'VTVF9TVEFURV9MT0NLRUQQBA==');

@$core.Deprecated('Use pipelineStatusDescriptor instead')
const PipelineStatus$json = {
  '1': 'PipelineStatus',
  '2': [
    {'1': 'PIPELINE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PIPELINE_STATUS_CREATED', '2': 1},
    {'1': 'PIPELINE_STATUS_WAITING_FOR_RESOURCE', '2': 2},
    {'1': 'PIPELINE_STATUS_PREPARING', '2': 3},
    {'1': 'PIPELINE_STATUS_PENDING', '2': 4},
    {'1': 'PIPELINE_STATUS_RUNNING', '2': 5},
    {'1': 'PIPELINE_STATUS_SUCCESS', '2': 6},
    {'1': 'PIPELINE_STATUS_FAILED', '2': 7},
    {'1': 'PIPELINE_STATUS_CANCELED', '2': 8},
    {'1': 'PIPELINE_STATUS_SKIPPED', '2': 9},
    {'1': 'PIPELINE_STATUS_MANUAL', '2': 10},
    {'1': 'PIPELINE_STATUS_SCHEDULED', '2': 11},
  ],
};

/// Descriptor for `PipelineStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pipelineStatusDescriptor = $convert.base64Decode(
    'Cg5QaXBlbGluZVN0YXR1cxIfChtQSVBFTElORV9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdQSV'
    'BFTElORV9TVEFUVVNfQ1JFQVRFRBABEigKJFBJUEVMSU5FX1NUQVRVU19XQUlUSU5HX0ZPUl9S'
    'RVNPVVJDRRACEh0KGVBJUEVMSU5FX1NUQVRVU19QUkVQQVJJTkcQAxIbChdQSVBFTElORV9TVE'
    'FUVVNfUEVORElORxAEEhsKF1BJUEVMSU5FX1NUQVRVU19SVU5OSU5HEAUSGwoXUElQRUxJTkVf'
    'U1RBVFVTX1NVQ0NFU1MQBhIaChZQSVBFTElORV9TVEFUVVNfRkFJTEVEEAcSHAoYUElQRUxJTk'
    'VfU1RBVFVTX0NBTkNFTEVEEAgSGwoXUElQRUxJTkVfU1RBVFVTX1NLSVBQRUQQCRIaChZQSVBF'
    'TElORV9TVEFUVVNfTUFOVUFMEAoSHQoZUElQRUxJTkVfU1RBVFVTX1NDSEVEVUxFRBAL');

@$core.Deprecated('Use mergeStatusDescriptor instead')
const MergeStatus$json = {
  '1': 'MergeStatus',
  '2': [
    {'1': 'MERGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MERGE_STATUS_CAN_BE_MERGED', '2': 1},
    {'1': 'MERGE_STATUS_CANNOT_BE_MERGED', '2': 2},
    {'1': 'MERGE_STATUS_CHECKING', '2': 3},
    {'1': 'MERGE_STATUS_UNCHECKED', '2': 4},
  ],
};

/// Descriptor for `MergeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mergeStatusDescriptor = $convert.base64Decode(
    'CgtNZXJnZVN0YXR1cxIcChhNRVJHRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIeChpNRVJHRV9TVE'
    'FUVVNfQ0FOX0JFX01FUkdFRBABEiEKHU1FUkdFX1NUQVRVU19DQU5OT1RfQkVfTUVSR0VEEAIS'
    'GQoVTUVSR0VfU1RBVFVTX0NIRUNLSU5HEAMSGgoWTUVSR0VfU1RBVFVTX1VOQ0hFQ0tFRBAE');

@$core.Deprecated('Use issueStateDescriptor instead')
const IssueState$json = {
  '1': 'IssueState',
  '2': [
    {'1': 'ISSUE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ISSUE_STATE_OPENED', '2': 1},
    {'1': 'ISSUE_STATE_CLOSED', '2': 2},
  ],
};

/// Descriptor for `IssueState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List issueStateDescriptor = $convert.base64Decode(
    'CgpJc3N1ZVN0YXRlEhsKF0lTU1VFX1NUQVRFX1VOU1BFQ0lGSUVEEAASFgoSSVNTVUVfU1RBVE'
    'VfT1BFTkVEEAESFgoSSVNTVUVfU1RBVEVfQ0xPU0VEEAI=');

@$core.Deprecated('Use mergeRequestInfoDescriptor instead')
const MergeRequestInfo$json = {
  '1': 'MergeRequestInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'iid', '3': 2, '4': 1, '5': 4, '10': 'iid'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.MergeRequestState',
      '10': 'state'
    },
    {'1': 'source_branch', '3': 6, '4': 1, '5': 9, '10': 'sourceBranch'},
    {'1': 'target_branch', '3': 7, '4': 1, '5': 9, '10': 'targetBranch'},
    {'1': 'author', '3': 8, '4': 1, '5': 9, '10': 'author'},
    {'1': 'labels', '3': 9, '4': 3, '5': 9, '10': 'labels'},
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
    {'1': 'web_url', '3': 12, '4': 1, '5': 9, '10': 'webUrl'},
    {'1': 'draft', '3': 13, '4': 1, '5': 8, '10': 'draft'},
    {
      '1': 'merge_status',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.MergeStatus',
      '10': 'mergeStatus'
    },
    {'1': 'assignee', '3': 15, '4': 1, '5': 9, '10': 'assignee'},
    {'1': 'assignees', '3': 16, '4': 3, '5': 9, '10': 'assignees'},
    {'1': 'reviewers', '3': 17, '4': 3, '5': 9, '10': 'reviewers'},
    {'1': 'milestone', '3': 18, '4': 1, '5': 9, '10': 'milestone'},
  ],
};

/// Descriptor for `MergeRequestInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mergeRequestInfoDescriptor = $convert.base64Decode(
    'ChBNZXJnZVJlcXVlc3RJbmZvEg4KAmlkGAEgASgEUgJpZBIQCgNpaWQYAiABKARSA2lpZBIUCg'
    'V0aXRsZRgDIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEjMK'
    'BXN0YXRlGAUgASgOMh0uYmV0Y29kZS52MS5NZXJnZVJlcXVlc3RTdGF0ZVIFc3RhdGUSIwoNc2'
    '91cmNlX2JyYW5jaBgGIAEoCVIMc291cmNlQnJhbmNoEiMKDXRhcmdldF9icmFuY2gYByABKAlS'
    'DHRhcmdldEJyYW5jaBIWCgZhdXRob3IYCCABKAlSBmF1dGhvchIWCgZsYWJlbHMYCSADKAlSBm'
    'xhYmVscxI5CgpjcmVhdGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJ'
    'Y3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgl1cGRhdGVkQXQSFwoHd2ViX3VybBgMIAEoCVIGd2ViVXJsEhQKBWRyYWZ0GA0gASgIUgVk'
    'cmFmdBI6CgxtZXJnZV9zdGF0dXMYDiABKA4yFy5iZXRjb2RlLnYxLk1lcmdlU3RhdHVzUgttZX'
    'JnZVN0YXR1cxIaCghhc3NpZ25lZRgPIAEoCVIIYXNzaWduZWUSHAoJYXNzaWduZWVzGBAgAygJ'
    'Uglhc3NpZ25lZXMSHAoJcmV2aWV3ZXJzGBEgAygJUglyZXZpZXdlcnMSHAoJbWlsZXN0b25lGB'
    'IgASgJUgltaWxlc3RvbmU=');

@$core.Deprecated('Use listMergeRequestsRequestDescriptor instead')
const ListMergeRequestsRequest$json = {
  '1': 'ListMergeRequestsRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {
      '1': 'state_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.MergeRequestState',
      '10': 'stateFilter'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListMergeRequestsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMergeRequestsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0TWVyZ2VSZXF1ZXN0c1JlcXVlc3QSGAoHcHJvamVjdBgBIAEoCVIHcHJvamVjdBJACg'
    'xzdGF0ZV9maWx0ZXIYAiABKA4yHS5iZXRjb2RlLnYxLk1lcmdlUmVxdWVzdFN0YXRlUgtzdGF0'
    'ZUZpbHRlchIUCgVsaW1pdBgDIAEoDVIFbGltaXQSFgoGb2Zmc2V0GAQgASgNUgZvZmZzZXQ=');

@$core.Deprecated('Use listMergeRequestsResponseDescriptor instead')
const ListMergeRequestsResponse$json = {
  '1': 'ListMergeRequestsResponse',
  '2': [
    {
      '1': 'merge_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.MergeRequestInfo',
      '10': 'mergeRequests'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `ListMergeRequestsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMergeRequestsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0TWVyZ2VSZXF1ZXN0c1Jlc3BvbnNlEkMKDm1lcmdlX3JlcXVlc3RzGAEgAygLMhwuYm'
    'V0Y29kZS52MS5NZXJnZVJlcXVlc3RJbmZvUg1tZXJnZVJlcXVlc3RzEhQKBXRvdGFsGAIgASgN'
    'UgV0b3RhbA==');

@$core.Deprecated('Use getMergeRequestRequestDescriptor instead')
const GetMergeRequestRequest$json = {
  '1': 'GetMergeRequestRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {'1': 'iid', '3': 2, '4': 1, '5': 4, '10': 'iid'},
  ],
};

/// Descriptor for `GetMergeRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMergeRequestRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRNZXJnZVJlcXVlc3RSZXF1ZXN0EhgKB3Byb2plY3QYASABKAlSB3Byb2plY3QSEAoDaW'
        'lkGAIgASgEUgNpaWQ=');

@$core.Deprecated('Use getMergeRequestResponseDescriptor instead')
const GetMergeRequestResponse$json = {
  '1': 'GetMergeRequestResponse',
  '2': [
    {
      '1': 'merge_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.MergeRequestInfo',
      '10': 'mergeRequest'
    },
  ],
};

/// Descriptor for `GetMergeRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMergeRequestResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRNZXJnZVJlcXVlc3RSZXNwb25zZRJBCg1tZXJnZV9yZXF1ZXN0GAEgASgLMhwuYmV0Y2'
        '9kZS52MS5NZXJnZVJlcXVlc3RJbmZvUgxtZXJnZVJlcXVlc3Q=');

@$core.Deprecated('Use pipelineInfoDescriptor instead')
const PipelineInfo$json = {
  '1': 'PipelineInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.PipelineStatus',
      '10': 'status'
    },
    {'1': 'ref_name', '3': 3, '4': 1, '5': 9, '10': 'refName'},
    {'1': 'sha', '3': 4, '4': 1, '5': 9, '10': 'sha'},
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'web_url', '3': 8, '4': 1, '5': 9, '10': 'webUrl'},
  ],
};

/// Descriptor for `PipelineInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pipelineInfoDescriptor = $convert.base64Decode(
    'CgxQaXBlbGluZUluZm8SDgoCaWQYASABKARSAmlkEjIKBnN0YXR1cxgCIAEoDjIaLmJldGNvZG'
    'UudjEuUGlwZWxpbmVTdGF0dXNSBnN0YXR1cxIZCghyZWZfbmFtZRgDIAEoCVIHcmVmTmFtZRIQ'
    'CgNzaGEYBCABKAlSA3NoYRIWCgZzb3VyY2UYBSABKAlSBnNvdXJjZRI5CgpjcmVhdGVkX2F0GA'
    'YgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRf'
    'YXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSFwoHd2ViX3'
    'VybBgIIAEoCVIGd2ViVXJs');

@$core.Deprecated('Use listPipelinesRequestDescriptor instead')
const ListPipelinesRequest$json = {
  '1': 'ListPipelinesRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.PipelineStatus',
      '10': 'statusFilter'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListPipelinesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPipelinesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UGlwZWxpbmVzUmVxdWVzdBIYCgdwcm9qZWN0GAEgASgJUgdwcm9qZWN0Ej8KDXN0YX'
    'R1c19maWx0ZXIYAiABKA4yGi5iZXRjb2RlLnYxLlBpcGVsaW5lU3RhdHVzUgxzdGF0dXNGaWx0'
    'ZXISFAoFbGltaXQYAyABKA1SBWxpbWl0EhYKBm9mZnNldBgEIAEoDVIGb2Zmc2V0');

@$core.Deprecated('Use listPipelinesResponseDescriptor instead')
const ListPipelinesResponse$json = {
  '1': 'ListPipelinesResponse',
  '2': [
    {
      '1': 'pipelines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.PipelineInfo',
      '10': 'pipelines'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `ListPipelinesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPipelinesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UGlwZWxpbmVzUmVzcG9uc2USNgoJcGlwZWxpbmVzGAEgAygLMhguYmV0Y29kZS52MS'
    '5QaXBlbGluZUluZm9SCXBpcGVsaW5lcxIUCgV0b3RhbBgCIAEoDVIFdG90YWw=');

@$core.Deprecated('Use getPipelineRequestDescriptor instead')
const GetPipelineRequest$json = {
  '1': 'GetPipelineRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {'1': 'pipeline_id', '3': 2, '4': 1, '5': 4, '10': 'pipelineId'},
  ],
};

/// Descriptor for `GetPipelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineRequestDescriptor = $convert.base64Decode(
    'ChJHZXRQaXBlbGluZVJlcXVlc3QSGAoHcHJvamVjdBgBIAEoCVIHcHJvamVjdBIfCgtwaXBlbG'
    'luZV9pZBgCIAEoBFIKcGlwZWxpbmVJZA==');

@$core.Deprecated('Use getPipelineResponseDescriptor instead')
const GetPipelineResponse$json = {
  '1': 'GetPipelineResponse',
  '2': [
    {
      '1': 'pipeline',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.PipelineInfo',
      '10': 'pipeline'
    },
  ],
};

/// Descriptor for `GetPipelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQaXBlbGluZVJlc3BvbnNlEjQKCHBpcGVsaW5lGAEgASgLMhguYmV0Y29kZS52MS5QaX'
    'BlbGluZUluZm9SCHBpcGVsaW5l');

@$core.Deprecated('Use issueInfoDescriptor instead')
const IssueInfo$json = {
  '1': 'IssueInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'iid', '3': 2, '4': 1, '5': 4, '10': 'iid'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.IssueState',
      '10': 'state'
    },
    {'1': 'author', '3': 6, '4': 1, '5': 9, '10': 'author'},
    {'1': 'labels', '3': 7, '4': 3, '5': 9, '10': 'labels'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'web_url', '3': 10, '4': 1, '5': 9, '10': 'webUrl'},
    {'1': 'confidential', '3': 11, '4': 1, '5': 8, '10': 'confidential'},
    {'1': 'assignee', '3': 12, '4': 1, '5': 9, '10': 'assignee'},
    {'1': 'assignees', '3': 13, '4': 3, '5': 9, '10': 'assignees'},
    {'1': 'milestone', '3': 14, '4': 1, '5': 9, '10': 'milestone'},
  ],
};

/// Descriptor for `IssueInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueInfoDescriptor = $convert.base64Decode(
    'CglJc3N1ZUluZm8SDgoCaWQYASABKARSAmlkEhAKA2lpZBgCIAEoBFIDaWlkEhQKBXRpdGxlGA'
    'MgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SLAoFc3RhdGUY'
    'BSABKA4yFi5iZXRjb2RlLnYxLklzc3VlU3RhdGVSBXN0YXRlEhYKBmF1dGhvchgGIAEoCVIGYX'
    'V0aG9yEhYKBmxhYmVscxgHIAMoCVIGbGFiZWxzEjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgJIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBIXCgd3ZWJfdXJsGAogASgJUgZ3'
    'ZWJVcmwSIgoMY29uZmlkZW50aWFsGAsgASgIUgxjb25maWRlbnRpYWwSGgoIYXNzaWduZWUYDC'
    'ABKAlSCGFzc2lnbmVlEhwKCWFzc2lnbmVlcxgNIAMoCVIJYXNzaWduZWVzEhwKCW1pbGVzdG9u'
    'ZRgOIAEoCVIJbWlsZXN0b25l');

@$core.Deprecated('Use listIssuesRequestDescriptor instead')
const ListIssuesRequest$json = {
  '1': 'ListIssuesRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {
      '1': 'state_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.IssueState',
      '10': 'stateFilter'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListIssuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIssuesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0SXNzdWVzUmVxdWVzdBIYCgdwcm9qZWN0GAEgASgJUgdwcm9qZWN0EjkKDHN0YXRlX2'
    'ZpbHRlchgCIAEoDjIWLmJldGNvZGUudjEuSXNzdWVTdGF0ZVILc3RhdGVGaWx0ZXISFAoFbGlt'
    'aXQYAyABKA1SBWxpbWl0EhYKBm9mZnNldBgEIAEoDVIGb2Zmc2V0');

@$core.Deprecated('Use listIssuesResponseDescriptor instead')
const ListIssuesResponse$json = {
  '1': 'ListIssuesResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.IssueInfo',
      '10': 'issues'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `ListIssuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIssuesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0SXNzdWVzUmVzcG9uc2USLQoGaXNzdWVzGAEgAygLMhUuYmV0Y29kZS52MS5Jc3N1ZU'
    'luZm9SBmlzc3VlcxIUCgV0b3RhbBgCIAEoDVIFdG90YWw=');

@$core.Deprecated('Use getIssueRequestDescriptor instead')
const GetIssueRequest$json = {
  '1': 'GetIssueRequest',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 9, '10': 'project'},
    {'1': 'iid', '3': 2, '4': 1, '5': 4, '10': 'iid'},
  ],
};

/// Descriptor for `GetIssueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIssueRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRJc3N1ZVJlcXVlc3QSGAoHcHJvamVjdBgBIAEoCVIHcHJvamVjdBIQCgNpaWQYAiABKA'
    'RSA2lpZA==');

@$core.Deprecated('Use getIssueResponseDescriptor instead')
const GetIssueResponse$json = {
  '1': 'GetIssueResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.IssueInfo',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `GetIssueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIssueResponseDescriptor = $convert.base64Decode(
    'ChBHZXRJc3N1ZVJlc3BvbnNlEisKBWlzc3VlGAEgASgLMhUuYmV0Y29kZS52MS5Jc3N1ZUluZm'
    '9SBWlzc3Vl');
