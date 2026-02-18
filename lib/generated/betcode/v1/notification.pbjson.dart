// This is a generated file - do not edit.
//
// Generated from betcode/v1/notification.proto.

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

@$core.Deprecated('Use devicePlatformDescriptor instead')
const DevicePlatform$json = {
  '1': 'DevicePlatform',
  '2': [
    {'1': 'DEVICE_PLATFORM_UNSPECIFIED', '2': 0},
    {'1': 'DEVICE_PLATFORM_ANDROID', '2': 1},
    {'1': 'DEVICE_PLATFORM_IOS', '2': 2},
  ],
};

/// Descriptor for `DevicePlatform`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List devicePlatformDescriptor = $convert.base64Decode(
    'Cg5EZXZpY2VQbGF0Zm9ybRIfChtERVZJQ0VfUExBVEZPUk1fVU5TUEVDSUZJRUQQABIbChdERV'
    'ZJQ0VfUExBVEZPUk1fQU5EUk9JRBABEhcKE0RFVklDRV9QTEFURk9STV9JT1MQAg==');

@$core.Deprecated('Use registerDeviceRequestDescriptor instead')
const RegisterDeviceRequest$json = {
  '1': 'RegisterDeviceRequest',
  '2': [
    {'1': 'device_token', '3': 1, '4': 1, '5': 9, '10': 'deviceToken'},
    {
      '1': 'platform',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.DevicePlatform',
      '10': 'platform'
    },
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `RegisterDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDeviceRequestDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlckRldmljZVJlcXVlc3QSIQoMZGV2aWNlX3Rva2VuGAEgASgJUgtkZXZpY2VUb2'
    'tlbhI2CghwbGF0Zm9ybRgCIAEoDjIaLmJldGNvZGUudjEuRGV2aWNlUGxhdGZvcm1SCHBsYXRm'
    'b3JtEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use registerDeviceResponseDescriptor instead')
const RegisterDeviceResponse$json = {
  '1': 'RegisterDeviceResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RegisterDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWdpc3RlckRldmljZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use unregisterDeviceRequestDescriptor instead')
const UnregisterDeviceRequest$json = {
  '1': 'UnregisterDeviceRequest',
  '2': [
    {'1': 'device_token', '3': 1, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `UnregisterDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChdVbnJlZ2lzdGVyRGV2aWNlUmVxdWVzdBIhCgxkZXZpY2VfdG9rZW4YASABKAlSC2RldmljZV'
        'Rva2Vu');

@$core.Deprecated('Use unregisterDeviceResponseDescriptor instead')
const UnregisterDeviceResponse$json = {
  '1': 'UnregisterDeviceResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UnregisterDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChhVbnJlZ2lzdGVyRGV2aWNlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');
