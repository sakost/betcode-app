// This is a generated file - do not edit.
//
// Generated from betcode/v1/tunnel.proto.

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

import 'tunnel.pb.dart' as $0;

export 'tunnel.pb.dart';

/// TunnelService manages the persistent tunnel between relay and daemon.
@$pb.GrpcServiceName('betcode.v1.TunnelService')
class TunnelServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TunnelServiceClient(super.channel, {super.options, super.interceptors});

  /// OpenTunnel establishes a bidirectional stream for proxied requests.
  /// Daemon connects and keeps this stream open for the lifetime of the connection.
  $grpc.ResponseStream<$0.TunnelFrame> openTunnel(
    $async.Stream<$0.TunnelFrame> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$openTunnel, request, options: options);
  }

  /// Register announces a daemon's machine to the relay.
  $grpc.ResponseFuture<$0.TunnelRegisterResponse> register(
    $0.TunnelRegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  /// Heartbeat keeps the tunnel alive and reports daemon health.
  $grpc.ResponseFuture<$0.TunnelHeartbeat> heartbeat(
    $0.TunnelHeartbeat request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$heartbeat, request, options: options);
  }

  // method descriptors

  static final _$openTunnel =
      $grpc.ClientMethod<$0.TunnelFrame, $0.TunnelFrame>(
          '/betcode.v1.TunnelService/OpenTunnel',
          ($0.TunnelFrame value) => value.writeToBuffer(),
          $0.TunnelFrame.fromBuffer);
  static final _$register =
      $grpc.ClientMethod<$0.TunnelRegisterRequest, $0.TunnelRegisterResponse>(
          '/betcode.v1.TunnelService/Register',
          ($0.TunnelRegisterRequest value) => value.writeToBuffer(),
          $0.TunnelRegisterResponse.fromBuffer);
  static final _$heartbeat =
      $grpc.ClientMethod<$0.TunnelHeartbeat, $0.TunnelHeartbeat>(
          '/betcode.v1.TunnelService/Heartbeat',
          ($0.TunnelHeartbeat value) => value.writeToBuffer(),
          $0.TunnelHeartbeat.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.TunnelService')
abstract class TunnelServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.TunnelService';

  TunnelServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TunnelFrame, $0.TunnelFrame>(
        'OpenTunnel',
        openTunnel,
        true,
        true,
        ($core.List<$core.int> value) => $0.TunnelFrame.fromBuffer(value),
        ($0.TunnelFrame value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TunnelRegisterRequest,
            $0.TunnelRegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TunnelRegisterRequest.fromBuffer(value),
        ($0.TunnelRegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TunnelHeartbeat, $0.TunnelHeartbeat>(
        'Heartbeat',
        heartbeat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TunnelHeartbeat.fromBuffer(value),
        ($0.TunnelHeartbeat value) => value.writeToBuffer()));
  }

  $async.Stream<$0.TunnelFrame> openTunnel(
      $grpc.ServiceCall call, $async.Stream<$0.TunnelFrame> request);

  $async.Future<$0.TunnelRegisterResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TunnelRegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.TunnelRegisterResponse> register(
      $grpc.ServiceCall call, $0.TunnelRegisterRequest request);

  $async.Future<$0.TunnelHeartbeat> heartbeat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TunnelHeartbeat> $request) async {
    return heartbeat($call, await $request);
  }

  $async.Future<$0.TunnelHeartbeat> heartbeat(
      $grpc.ServiceCall call, $0.TunnelHeartbeat request);
}
