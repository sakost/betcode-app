// This is a generated file - do not edit.
//
// Generated from betcode/v1/notification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'notification.pb.dart' as $0;

export 'notification.pb.dart';

/// NotificationService manages device registrations for push notifications.
@$pb.GrpcServiceName('betcode.v1.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  /// Register a device token for push notifications.
  $grpc.ResponseFuture<$0.RegisterDeviceResponse> registerDevice(
    $0.RegisterDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerDevice, request, options: options);
  }

  /// Unregister a device token to stop receiving push notifications.
  $grpc.ResponseFuture<$0.UnregisterDeviceResponse> unregisterDevice(
    $0.UnregisterDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unregisterDevice, request, options: options);
  }

  // method descriptors

  static final _$registerDevice =
      $grpc.ClientMethod<$0.RegisterDeviceRequest, $0.RegisterDeviceResponse>(
          '/betcode.v1.NotificationService/RegisterDevice',
          ($0.RegisterDeviceRequest value) => value.writeToBuffer(),
          $0.RegisterDeviceResponse.fromBuffer);
  static final _$unregisterDevice = $grpc.ClientMethod<
          $0.UnregisterDeviceRequest, $0.UnregisterDeviceResponse>(
      '/betcode.v1.NotificationService/UnregisterDevice',
      ($0.UnregisterDeviceRequest value) => value.writeToBuffer(),
      $0.UnregisterDeviceResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterDeviceRequest,
            $0.RegisterDeviceResponse>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterDeviceRequest.fromBuffer(value),
        ($0.RegisterDeviceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnregisterDeviceRequest,
            $0.UnregisterDeviceResponse>(
        'UnregisterDevice',
        unregisterDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UnregisterDeviceRequest.fromBuffer(value),
        ($0.UnregisterDeviceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterDeviceResponse> registerDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterDeviceRequest> $request) async {
    return registerDevice($call, await $request);
  }

  $async.Future<$0.RegisterDeviceResponse> registerDevice(
      $grpc.ServiceCall call, $0.RegisterDeviceRequest request);

  $async.Future<$0.UnregisterDeviceResponse> unregisterDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UnregisterDeviceRequest> $request) async {
    return unregisterDevice($call, await $request);
  }

  $async.Future<$0.UnregisterDeviceResponse> unregisterDevice(
      $grpc.ServiceCall call, $0.UnregisterDeviceRequest request);
}
