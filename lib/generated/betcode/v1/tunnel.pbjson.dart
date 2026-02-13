// This is a generated file - do not edit.
//
// Generated from betcode/v1/tunnel.proto.

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

@$core.Deprecated('Use frameTypeDescriptor instead')
const FrameType$json = {
  '1': 'FrameType',
  '2': [
    {'1': 'FRAME_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FRAME_TYPE_REQUEST', '2': 1},
    {'1': 'FRAME_TYPE_RESPONSE', '2': 2},
    {'1': 'FRAME_TYPE_STREAM_DATA', '2': 3},
    {'1': 'FRAME_TYPE_STREAM_END', '2': 4},
    {'1': 'FRAME_TYPE_ERROR', '2': 5},
    {'1': 'FRAME_TYPE_CONTROL', '2': 6},
  ],
};

/// Descriptor for `FrameType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List frameTypeDescriptor = $convert.base64Decode(
    'CglGcmFtZVR5cGUSGgoWRlJBTUVfVFlQRV9VTlNQRUNJRklFRBAAEhYKEkZSQU1FX1RZUEVfUk'
    'VRVUVTVBABEhcKE0ZSQU1FX1RZUEVfUkVTUE9OU0UQAhIaChZGUkFNRV9UWVBFX1NUUkVBTV9E'
    'QVRBEAMSGQoVRlJBTUVfVFlQRV9TVFJFQU1fRU5EEAQSFAoQRlJBTUVfVFlQRV9FUlJPUhAFEh'
    'YKEkZSQU1FX1RZUEVfQ09OVFJPTBAG');

@$core.Deprecated('Use tunnelErrorCodeDescriptor instead')
const TunnelErrorCode$json = {
  '1': 'TunnelErrorCode',
  '2': [
    {'1': 'TUNNEL_ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'TUNNEL_ERROR_CODE_INTERNAL', '2': 1},
    {'1': 'TUNNEL_ERROR_CODE_TIMEOUT', '2': 2},
    {'1': 'TUNNEL_ERROR_CODE_NOT_FOUND', '2': 3},
    {'1': 'TUNNEL_ERROR_CODE_UNAUTHORIZED', '2': 4},
    {'1': 'TUNNEL_ERROR_CODE_UNAVAILABLE', '2': 5},
  ],
};

/// Descriptor for `TunnelErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tunnelErrorCodeDescriptor = $convert.base64Decode(
    'Cg9UdW5uZWxFcnJvckNvZGUSIQodVFVOTkVMX0VSUk9SX0NPREVfVU5TUEVDSUZJRUQQABIeCh'
    'pUVU5ORUxfRVJST1JfQ09ERV9JTlRFUk5BTBABEh0KGVRVTk5FTF9FUlJPUl9DT0RFX1RJTUVP'
    'VVQQAhIfChtUVU5ORUxfRVJST1JfQ09ERV9OT1RfRk9VTkQQAxIiCh5UVU5ORUxfRVJST1JfQ0'
    '9ERV9VTkFVVEhPUklaRUQQBBIhCh1UVU5ORUxfRVJST1JfQ09ERV9VTkFWQUlMQUJMRRAF');

@$core.Deprecated('Use tunnelControlTypeDescriptor instead')
const TunnelControlType$json = {
  '1': 'TunnelControlType',
  '2': [
    {'1': 'TUNNEL_CONTROL_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TUNNEL_CONTROL_TYPE_DRAIN', '2': 1},
    {'1': 'TUNNEL_CONTROL_TYPE_DRAIN_ACK', '2': 2},
    {'1': 'TUNNEL_CONTROL_TYPE_PING', '2': 3},
    {'1': 'TUNNEL_CONTROL_TYPE_PONG', '2': 4},
    {'1': 'TUNNEL_CONTROL_TYPE_KEY_EXCHANGE', '2': 10},
  ],
};

/// Descriptor for `TunnelControlType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tunnelControlTypeDescriptor = $convert.base64Decode(
    'ChFUdW5uZWxDb250cm9sVHlwZRIjCh9UVU5ORUxfQ09OVFJPTF9UWVBFX1VOU1BFQ0lGSUVEEA'
    'ASHQoZVFVOTkVMX0NPTlRST0xfVFlQRV9EUkFJThABEiEKHVRVTk5FTF9DT05UUk9MX1RZUEVf'
    'RFJBSU5fQUNLEAISHAoYVFVOTkVMX0NPTlRST0xfVFlQRV9QSU5HEAMSHAoYVFVOTkVMX0NPTl'
    'RST0xfVFlQRV9QT05HEAQSJAogVFVOTkVMX0NPTlRST0xfVFlQRV9LRVlfRVhDSEFOR0UQCg==');

@$core.Deprecated('Use tunnelFrameDescriptor instead')
const TunnelFrame$json = {
  '1': 'TunnelFrame',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'frame_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.FrameType',
      '10': 'frameType'
    },
    {
      '1': 'timestamp',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'stream_data',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.StreamPayload',
      '9': 0,
      '10': 'streamData'
    },
    {
      '1': 'error',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.TunnelError',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'control',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.TunnelControl',
      '9': 0,
      '10': 'control'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `TunnelFrame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelFrameDescriptor = $convert.base64Decode(
    'CgtUdW5uZWxGcmFtZRIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQSNAoKZnJhbWVfdH'
    'lwZRgCIAEoDjIVLmJldGNvZGUudjEuRnJhbWVUeXBlUglmcmFtZVR5cGUSOAoJdGltZXN0YW1w'
    'GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEjwKC3N0cmVhbV'
    '9kYXRhGAogASgLMhkuYmV0Y29kZS52MS5TdHJlYW1QYXlsb2FkSABSCnN0cmVhbURhdGESLwoF'
    'ZXJyb3IYCyABKAsyFy5iZXRjb2RlLnYxLlR1bm5lbEVycm9ySABSBWVycm9yEjUKB2NvbnRyb2'
    'wYDCABKAsyGS5iZXRjb2RlLnYxLlR1bm5lbENvbnRyb2xIAFIHY29udHJvbEIJCgdwYXlsb2Fk');

@$core.Deprecated('Use encryptedPayloadDescriptor instead')
const EncryptedPayload$json = {
  '1': 'EncryptedPayload',
  '2': [
    {'1': 'ciphertext', '3': 1, '4': 1, '5': 12, '10': 'ciphertext'},
    {'1': 'nonce', '3': 2, '4': 1, '5': 12, '10': 'nonce'},
    {'1': 'ephemeral_pubkey', '3': 3, '4': 1, '5': 12, '10': 'ephemeralPubkey'},
  ],
};

/// Descriptor for `EncryptedPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encryptedPayloadDescriptor = $convert.base64Decode(
    'ChBFbmNyeXB0ZWRQYXlsb2FkEh4KCmNpcGhlcnRleHQYASABKAxSCmNpcGhlcnRleHQSFAoFbm'
    '9uY2UYAiABKAxSBW5vbmNlEikKEGVwaGVtZXJhbF9wdWJrZXkYAyABKAxSD2VwaGVtZXJhbFB1'
    'YmtleQ==');

@$core.Deprecated('Use streamPayloadDescriptor instead')
const StreamPayload$json = {
  '1': 'StreamPayload',
  '2': [
    {'1': 'method', '3': 1, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'encrypted',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.EncryptedPayload',
      '10': 'encrypted'
    },
    {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
    {
      '1': 'metadata',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.StreamPayload.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [StreamPayload_MetadataEntry$json],
};

@$core.Deprecated('Use streamPayloadDescriptor instead')
const StreamPayload_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `StreamPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamPayloadDescriptor = $convert.base64Decode(
    'Cg1TdHJlYW1QYXlsb2FkEhYKBm1ldGhvZBgBIAEoCVIGbWV0aG9kEjoKCWVuY3J5cHRlZBgCIA'
    'EoCzIcLmJldGNvZGUudjEuRW5jcnlwdGVkUGF5bG9hZFIJZW5jcnlwdGVkEhoKCHNlcXVlbmNl'
    'GAMgASgEUghzZXF1ZW5jZRJDCghtZXRhZGF0YRgEIAMoCzInLmJldGNvZGUudjEuU3RyZWFtUG'
    'F5bG9hZC5NZXRhZGF0YUVudHJ5UghtZXRhZGF0YRo7Cg1NZXRhZGF0YUVudHJ5EhAKA2tleRgB'
    'IAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use tunnelErrorDescriptor instead')
const TunnelError$json = {
  '1': 'TunnelError',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.TunnelErrorCode',
      '10': 'code'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'details',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.TunnelError.DetailsEntry',
      '10': 'details'
    },
  ],
  '3': [TunnelError_DetailsEntry$json],
};

@$core.Deprecated('Use tunnelErrorDescriptor instead')
const TunnelError_DetailsEntry$json = {
  '1': 'DetailsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TunnelError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelErrorDescriptor = $convert.base64Decode(
    'CgtUdW5uZWxFcnJvchIvCgRjb2RlGAEgASgOMhsuYmV0Y29kZS52MS5UdW5uZWxFcnJvckNvZG'
    'VSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRI+CgdkZXRhaWxzGAMgAygLMiQuYmV0'
    'Y29kZS52MS5UdW5uZWxFcnJvci5EZXRhaWxzRW50cnlSB2RldGFpbHMaOgoMRGV0YWlsc0VudH'
    'J5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use tunnelControlDescriptor instead')
const TunnelControl$json = {
  '1': 'TunnelControl',
  '2': [
    {
      '1': 'control_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.TunnelControlType',
      '10': 'controlType'
    },
    {
      '1': 'params',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.TunnelControl.ParamsEntry',
      '10': 'params'
    },
  ],
  '3': [TunnelControl_ParamsEntry$json],
};

@$core.Deprecated('Use tunnelControlDescriptor instead')
const TunnelControl_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TunnelControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelControlDescriptor = $convert.base64Decode(
    'Cg1UdW5uZWxDb250cm9sEkAKDGNvbnRyb2xfdHlwZRgBIAEoDjIdLmJldGNvZGUudjEuVHVubm'
    'VsQ29udHJvbFR5cGVSC2NvbnRyb2xUeXBlEj0KBnBhcmFtcxgCIAMoCzIlLmJldGNvZGUudjEu'
    'VHVubmVsQ29udHJvbC5QYXJhbXNFbnRyeVIGcGFyYW1zGjkKC1BhcmFtc0VudHJ5EhAKA2tleR'
    'gBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use keyExchangeRequestDescriptor instead')
const KeyExchangeRequest$json = {
  '1': 'KeyExchangeRequest',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
    {'1': 'identity_pubkey', '3': 2, '4': 1, '5': 12, '10': 'identityPubkey'},
    {'1': 'fingerprint', '3': 3, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'ephemeral_pubkey', '3': 4, '4': 1, '5': 12, '10': 'ephemeralPubkey'},
  ],
};

/// Descriptor for `KeyExchangeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keyExchangeRequestDescriptor = $convert.base64Decode(
    'ChJLZXlFeGNoYW5nZVJlcXVlc3QSHQoKbWFjaGluZV9pZBgBIAEoCVIJbWFjaGluZUlkEicKD2'
    'lkZW50aXR5X3B1YmtleRgCIAEoDFIOaWRlbnRpdHlQdWJrZXkSIAoLZmluZ2VycHJpbnQYAyAB'
    'KAlSC2ZpbmdlcnByaW50EikKEGVwaGVtZXJhbF9wdWJrZXkYBCABKAxSD2VwaGVtZXJhbFB1Ym'
    'tleQ==');

@$core.Deprecated('Use keyExchangeResponseDescriptor instead')
const KeyExchangeResponse$json = {
  '1': 'KeyExchangeResponse',
  '2': [
    {
      '1': 'daemon_identity_pubkey',
      '3': 1,
      '4': 1,
      '5': 12,
      '10': 'daemonIdentityPubkey'
    },
    {
      '1': 'daemon_fingerprint',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'daemonFingerprint'
    },
    {
      '1': 'daemon_ephemeral_pubkey',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'daemonEphemeralPubkey'
    },
  ],
};

/// Descriptor for `KeyExchangeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keyExchangeResponseDescriptor = $convert.base64Decode(
    'ChNLZXlFeGNoYW5nZVJlc3BvbnNlEjQKFmRhZW1vbl9pZGVudGl0eV9wdWJrZXkYASABKAxSFG'
    'RhZW1vbklkZW50aXR5UHVia2V5Ei0KEmRhZW1vbl9maW5nZXJwcmludBgCIAEoCVIRZGFlbW9u'
    'RmluZ2VycHJpbnQSNgoXZGFlbW9uX2VwaGVtZXJhbF9wdWJrZXkYAyABKAxSFWRhZW1vbkVwaG'
    'VtZXJhbFB1YmtleQ==');

@$core.Deprecated('Use tunnelRegisterRequestDescriptor instead')
const TunnelRegisterRequest$json = {
  '1': 'TunnelRegisterRequest',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
    {'1': 'machine_name', '3': 2, '4': 1, '5': 9, '10': 'machineName'},
    {
      '1': 'capabilities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.TunnelRegisterRequest.CapabilitiesEntry',
      '10': 'capabilities'
    },
    {'1': 'identity_pubkey', '3': 4, '4': 1, '5': 12, '10': 'identityPubkey'},
  ],
  '3': [TunnelRegisterRequest_CapabilitiesEntry$json],
};

@$core.Deprecated('Use tunnelRegisterRequestDescriptor instead')
const TunnelRegisterRequest_CapabilitiesEntry$json = {
  '1': 'CapabilitiesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TunnelRegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelRegisterRequestDescriptor = $convert.base64Decode(
    'ChVUdW5uZWxSZWdpc3RlclJlcXVlc3QSHQoKbWFjaGluZV9pZBgBIAEoCVIJbWFjaGluZUlkEi'
    'EKDG1hY2hpbmVfbmFtZRgCIAEoCVILbWFjaGluZU5hbWUSVwoMY2FwYWJpbGl0aWVzGAMgAygL'
    'MjMuYmV0Y29kZS52MS5UdW5uZWxSZWdpc3RlclJlcXVlc3QuQ2FwYWJpbGl0aWVzRW50cnlSDG'
    'NhcGFiaWxpdGllcxInCg9pZGVudGl0eV9wdWJrZXkYBCABKAxSDmlkZW50aXR5UHVia2V5Gj8K'
    'EUNhcGFiaWxpdGllc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YW'
    'x1ZToCOAE=');

@$core.Deprecated('Use tunnelRegisterResponseDescriptor instead')
const TunnelRegisterResponse$json = {
  '1': 'TunnelRegisterResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'relay_id', '3': 2, '4': 1, '5': 9, '10': 'relayId'},
    {
      '1': 'heartbeat_interval_secs',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'heartbeatIntervalSecs'
    },
  ],
};

/// Descriptor for `TunnelRegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelRegisterResponseDescriptor = $convert.base64Decode(
    'ChZUdW5uZWxSZWdpc3RlclJlc3BvbnNlEhoKCGFjY2VwdGVkGAEgASgIUghhY2NlcHRlZBIZCg'
    'hyZWxheV9pZBgCIAEoCVIHcmVsYXlJZBI2ChdoZWFydGJlYXRfaW50ZXJ2YWxfc2VjcxgDIAEo'
    'A1IVaGVhcnRiZWF0SW50ZXJ2YWxTZWNz');

@$core.Deprecated('Use tunnelHeartbeatDescriptor instead')
const TunnelHeartbeat$json = {
  '1': 'TunnelHeartbeat',
  '2': [
    {'1': 'machine_id', '3': 1, '4': 1, '5': 9, '10': 'machineId'},
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'active_sessions', '3': 3, '4': 1, '5': 13, '10': 'activeSessions'},
    {'1': 'cpu_usage_percent', '3': 4, '4': 1, '5': 2, '10': 'cpuUsagePercent'},
    {
      '1': 'memory_usage_percent',
      '3': 5,
      '4': 1,
      '5': 2,
      '10': 'memoryUsagePercent'
    },
  ],
};

/// Descriptor for `TunnelHeartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tunnelHeartbeatDescriptor = $convert.base64Decode(
    'Cg9UdW5uZWxIZWFydGJlYXQSHQoKbWFjaGluZV9pZBgBIAEoCVIJbWFjaGluZUlkEjgKCXRpbW'
    'VzdGFtcBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcBInCg9h'
    'Y3RpdmVfc2Vzc2lvbnMYAyABKA1SDmFjdGl2ZVNlc3Npb25zEioKEWNwdV91c2FnZV9wZXJjZW'
    '50GAQgASgCUg9jcHVVc2FnZVBlcmNlbnQSMAoUbWVtb3J5X3VzYWdlX3BlcmNlbnQYBSABKAJS'
    'Em1lbW9yeVVzYWdlUGVyY2VudA==');
