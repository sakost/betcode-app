// This is a generated file - do not edit.
//
// Generated from betcode/v1/version.proto.

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

import 'version.pb.dart' as $0;

export 'version.pb.dart';

/// VersionService provides version discovery and capability negotiation.
@$pb.GrpcServiceName('betcode.v1.VersionService')
class VersionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VersionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetVersionResponse> getVersion(
    $0.GetVersionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }

  $grpc.ResponseFuture<$0.NegotiateResponse> negotiateCapabilities(
    $0.NegotiateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$negotiateCapabilities, request, options: options);
  }

  // method descriptors

  static final _$getVersion =
      $grpc.ClientMethod<$0.GetVersionRequest, $0.GetVersionResponse>(
          '/betcode.v1.VersionService/GetVersion',
          ($0.GetVersionRequest value) => value.writeToBuffer(),
          $0.GetVersionResponse.fromBuffer);
  static final _$negotiateCapabilities =
      $grpc.ClientMethod<$0.NegotiateRequest, $0.NegotiateResponse>(
          '/betcode.v1.VersionService/NegotiateCapabilities',
          ($0.NegotiateRequest value) => value.writeToBuffer(),
          $0.NegotiateResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.VersionService')
abstract class VersionServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.VersionService';

  VersionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetVersionRequest, $0.GetVersionResponse>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetVersionRequest.fromBuffer(value),
        ($0.GetVersionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NegotiateRequest, $0.NegotiateResponse>(
        'NegotiateCapabilities',
        negotiateCapabilities_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NegotiateRequest.fromBuffer(value),
        ($0.NegotiateResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetVersionResponse> getVersion_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVersionRequest> $request) async {
    return getVersion($call, await $request);
  }

  $async.Future<$0.GetVersionResponse> getVersion(
      $grpc.ServiceCall call, $0.GetVersionRequest request);

  $async.Future<$0.NegotiateResponse> negotiateCapabilities_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.NegotiateRequest> $request) async {
    return negotiateCapabilities($call, await $request);
  }

  $async.Future<$0.NegotiateResponse> negotiateCapabilities(
      $grpc.ServiceCall call, $0.NegotiateRequest request);
}
