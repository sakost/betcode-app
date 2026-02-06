// This is a generated file - do not edit.
//
// Generated from betcode/v1/machine.proto.

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

@$core.Deprecated('Use machineStatusDescriptor instead')
const MachineStatus$json = {
  '1': 'MachineStatus',
  '2': [
    {'1': 'MACHINE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MACHINE_STATUS_ONLINE', '2': 1},
    {'1': 'MACHINE_STATUS_OFFLINE', '2': 2},
  ],
};

/// Descriptor for `MachineStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List machineStatusDescriptor = $convert.base64Decode(
    'Cg1NYWNoaW5lU3RhdHVzEh4KGk1BQ0hJTkVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVTUFDSE'
    'lORV9TVEFUVVNfT05MSU5FEAESGgoWTUFDSElORV9TVEFUVVNfT0ZGTElORRAC');

@$core.Deprecated('Use machineInfoDescriptor instead')
const MachineInfo$json = {
  '1': 'MachineInfo',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.MachineStatus',
      '10': 'status'
    },
    {
      '1': 'registered_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'registeredAt'
    },
    {
      '1': 'last_seen',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSeen'
    },
    {
      '1': 'metadata',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.MachineInfo.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [MachineInfo_MetadataEntry$json],
};

@$core.Deprecated('Use machineInfoDescriptor instead')
const MachineInfo_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MachineInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List machineInfoDescriptor = $convert.base64Decode(
    'CgtNYWNoaW5lSW5mbxIdCgptYWNoaW5lX2lkGAEgASgJUgltYWNoaW5lSWQSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZRIZCghvd25lcl9pZBgDIAEoCVIHb3duZXJJZBIxCgZzdGF0dXMYBCABKA4yGS5i'
    'ZXRjb2RlLnYxLk1hY2hpbmVTdGF0dXNSBnN0YXR1cxI/Cg1yZWdpc3RlcmVkX2F0GAUgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMcmVnaXN0ZXJlZEF0EjcKCWxhc3Rfc2VlbhgG'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGxhc3RTZWVuEkEKCG1ldGFkYXRhGA'
    'cgAygLMiUuYmV0Y29kZS52MS5NYWNoaW5lSW5mby5NZXRhZGF0YUVudHJ5UghtZXRhZGF0YRo7'
    'Cg1NZXRhZGF0YUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZT'
    'oCOAE=');

@$core.Deprecated('Use registerMachineRequestDescriptor instead')
const RegisterMachineRequest$json = {
  '1': 'RegisterMachineRequest',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'metadata',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.RegisterMachineRequest.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [RegisterMachineRequest_MetadataEntry$json],
};

@$core.Deprecated('Use registerMachineRequestDescriptor instead')
const RegisterMachineRequest_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RegisterMachineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerMachineRequestDescriptor = $convert.base64Decode(
    'ChZSZWdpc3Rlck1hY2hpbmVSZXF1ZXN0Eh0KCm1hY2hpbmVfaWQYASABKAlSCW1hY2hpbmVJZB'
    'ISCgRuYW1lGAIgASgJUgRuYW1lEkwKCG1ldGFkYXRhGAMgAygLMjAuYmV0Y29kZS52MS5SZWdp'
    'c3Rlck1hY2hpbmVSZXF1ZXN0Lk1ldGFkYXRhRW50cnlSCG1ldGFkYXRhGjsKDU1ldGFkYXRhRW'
    '50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use registerMachineResponseDescriptor instead')
const RegisterMachineResponse$json = {
  '1': 'RegisterMachineResponse',
  '2': [
    {
      '1': 'machine',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.MachineInfo',
      '10': 'machine'
    },
  ],
};

/// Descriptor for `RegisterMachineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerMachineResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWdpc3Rlck1hY2hpbmVSZXNwb25zZRIxCgdtYWNoaW5lGAEgASgLMhcuYmV0Y29kZS52MS'
        '5NYWNoaW5lSW5mb1IHbWFjaGluZQ==');

@$core.Deprecated('Use listMachinesRequestDescriptor instead')
const ListMachinesRequest$json = {
  '1': 'ListMachinesRequest',
  '2': [
    {
      '1': 'status_filter',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.MachineStatus',
      '10': 'statusFilter'
    },
    {'1': 'limit', '3': 2, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'offset', '3': 3, '4': 1, '5': 13, '10': 'offset'},
  ],
};

/// Descriptor for `ListMachinesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMachinesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0TWFjaGluZXNSZXF1ZXN0Ej4KDXN0YXR1c19maWx0ZXIYASABKA4yGS5iZXRjb2RlLn'
    'YxLk1hY2hpbmVTdGF0dXNSDHN0YXR1c0ZpbHRlchIUCgVsaW1pdBgCIAEoDVIFbGltaXQSFgoG'
    'b2Zmc2V0GAMgASgNUgZvZmZzZXQ=');

@$core.Deprecated('Use listMachinesResponseDescriptor instead')
const ListMachinesResponse$json = {
  '1': 'ListMachinesResponse',
  '2': [
    {
      '1': 'machines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.MachineInfo',
      '10': 'machines'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `ListMachinesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMachinesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0TWFjaGluZXNSZXNwb25zZRIzCghtYWNoaW5lcxgBIAMoCzIXLmJldGNvZGUudjEuTW'
    'FjaGluZUluZm9SCG1hY2hpbmVzEhQKBXRvdGFsGAIgASgNUgV0b3RhbA==');

@$core.Deprecated('Use removeMachineRequestDescriptor instead')
const RemoveMachineRequest$json = {
  '1': 'RemoveMachineRequest',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
  ],
};

/// Descriptor for `RemoveMachineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeMachineRequestDescriptor = $convert.base64Decode(
    'ChRSZW1vdmVNYWNoaW5lUmVxdWVzdBIdCgptYWNoaW5lX2lkGAEgASgJUgltYWNoaW5lSWQ=');

@$core.Deprecated('Use removeMachineResponseDescriptor instead')
const RemoveMachineResponse$json = {
  '1': 'RemoveMachineResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
  ],
};

/// Descriptor for `RemoveMachineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeMachineResponseDescriptor =
    $convert.base64Decode(
        'ChVSZW1vdmVNYWNoaW5lUmVzcG9uc2USGAoHcmVtb3ZlZBgBIAEoCFIHcmVtb3ZlZA==');

@$core.Deprecated('Use getMachineRequestDescriptor instead')
const GetMachineRequest$json = {
  '1': 'GetMachineRequest',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
  ],
};

/// Descriptor for `GetMachineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMachineRequestDescriptor = $convert.base64Decode(
    'ChFHZXRNYWNoaW5lUmVxdWVzdBIdCgptYWNoaW5lX2lkGAEgASgJUgltYWNoaW5lSWQ=');

@$core.Deprecated('Use getMachineResponseDescriptor instead')
const GetMachineResponse$json = {
  '1': 'GetMachineResponse',
  '2': [
    {
      '1': 'machine',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.MachineInfo',
      '10': 'machine'
    },
  ],
};

/// Descriptor for `GetMachineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMachineResponseDescriptor = $convert.base64Decode(
    'ChJHZXRNYWNoaW5lUmVzcG9uc2USMQoHbWFjaGluZRgBIAEoCzIXLmJldGNvZGUudjEuTWFjaG'
    'luZUluZm9SB21hY2hpbmU=');
