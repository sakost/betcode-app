// This is a generated file - do not edit.
//
// Generated from betcode/v1/health.proto.

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

@$core.Deprecated('Use servingStatusDescriptor instead')
const ServingStatus$json = {
  '1': 'ServingStatus',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'SERVING', '2': 1},
    {'1': 'NOT_SERVING', '2': 2},
    {'1': 'SERVICE_UNKNOWN', '2': 3},
  ],
};

/// Descriptor for `ServingStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List servingStatusDescriptor = $convert.base64Decode(
    'Cg1TZXJ2aW5nU3RhdHVzEgsKB1VOS05PV04QABILCgdTRVJWSU5HEAESDwoLTk9UX1NFUlZJTk'
    'cQAhITCg9TRVJWSUNFX1VOS05PV04QAw==');

@$core.Deprecated('Use healthCheckRequestDescriptor instead')
const HealthCheckRequest$json = {
  '1': 'HealthCheckRequest',
  '2': [
    {'1': 'service', '3': 1, '4': 1, '5': 9, '10': 'service'},
  ],
};

/// Descriptor for `HealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckRequestDescriptor =
    $convert.base64Decode(
        'ChJIZWFsdGhDaGVja1JlcXVlc3QSGAoHc2VydmljZRgBIAEoCVIHc2VydmljZQ==');

@$core.Deprecated('Use healthCheckResponseDescriptor instead')
const HealthCheckResponse$json = {
  '1': 'HealthCheckResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.ServingStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `HealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckResponseDescriptor = $convert.base64Decode(
    'ChNIZWFsdGhDaGVja1Jlc3BvbnNlEjEKBnN0YXR1cxgBIAEoDjIZLmJldGNvZGUudjEuU2Vydm'
    'luZ1N0YXR1c1IGc3RhdHVz');

@$core.Deprecated('Use healthDetailsRequestDescriptor instead')
const HealthDetailsRequest$json = {
  '1': 'HealthDetailsRequest',
};

/// Descriptor for `HealthDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthDetailsRequestDescriptor =
    $convert.base64Decode('ChRIZWFsdGhEZXRhaWxzUmVxdWVzdA==');

@$core.Deprecated('Use healthDetailsResponseDescriptor instead')
const HealthDetailsResponse$json = {
  '1': 'HealthDetailsResponse',
  '2': [
    {
      '1': 'overall_status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.ServingStatus',
      '10': 'overallStatus'
    },
    {
      '1': 'components',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.ComponentHealth',
      '10': 'components'
    },
    {
      '1': 'metadata',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.HealthDetailsResponse.MetadataEntry',
      '10': 'metadata'
    },
    {'1': 'degraded', '3': 4, '4': 1, '5': 8, '10': 'degraded'},
    {'1': 'degraded_reason', '3': 5, '4': 1, '5': 9, '10': 'degradedReason'},
  ],
  '3': [HealthDetailsResponse_MetadataEntry$json],
};

@$core.Deprecated('Use healthDetailsResponseDescriptor instead')
const HealthDetailsResponse_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `HealthDetailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthDetailsResponseDescriptor = $convert.base64Decode(
    'ChVIZWFsdGhEZXRhaWxzUmVzcG9uc2USQAoOb3ZlcmFsbF9zdGF0dXMYASABKA4yGS5iZXRjb2'
    'RlLnYxLlNlcnZpbmdTdGF0dXNSDW92ZXJhbGxTdGF0dXMSOwoKY29tcG9uZW50cxgCIAMoCzIb'
    'LmJldGNvZGUudjEuQ29tcG9uZW50SGVhbHRoUgpjb21wb25lbnRzEksKCG1ldGFkYXRhGAMgAy'
    'gLMi8uYmV0Y29kZS52MS5IZWFsdGhEZXRhaWxzUmVzcG9uc2UuTWV0YWRhdGFFbnRyeVIIbWV0'
    'YWRhdGESGgoIZGVncmFkZWQYBCABKAhSCGRlZ3JhZGVkEicKD2RlZ3JhZGVkX3JlYXNvbhgFIA'
    'EoCVIOZGVncmFkZWRSZWFzb24aOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIU'
    'CgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use componentHealthDescriptor instead')
const ComponentHealth$json = {
  '1': 'ComponentHealth',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.ServingStatus',
      '10': 'status'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'last_check',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCheck'
    },
  ],
};

/// Descriptor for `ComponentHealth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List componentHealthDescriptor = $convert.base64Decode(
    'Cg9Db21wb25lbnRIZWFsdGgSEgoEbmFtZRgBIAEoCVIEbmFtZRIxCgZzdGF0dXMYAiABKA4yGS'
    '5iZXRjb2RlLnYxLlNlcnZpbmdTdGF0dXNSBnN0YXR1cxIYCgdtZXNzYWdlGAMgASgJUgdtZXNz'
    'YWdlEjkKCmxhc3RfY2hlY2sYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglsYX'
    'N0Q2hlY2s=');
