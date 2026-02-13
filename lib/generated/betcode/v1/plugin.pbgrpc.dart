// This is a generated file - do not edit.
//
// Generated from betcode/v1/plugin.proto.

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

import 'plugin.pb.dart' as $0;

export 'plugin.pb.dart';

/// PluginService is the interface that external plugins implement.
/// The daemon connects to each plugin's Unix socket and calls these RPCs.
@$pb.GrpcServiceName('betcode.v1.PluginService')
class PluginServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PluginServiceClient(super.channel, {super.options, super.interceptors});

  /// Register returns the plugin's command definitions.
  $grpc.ResponseFuture<$0.PluginRegisterResponse> register(
    $0.PluginRegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  /// Execute runs a plugin command, streaming output back.
  $grpc.ResponseStream<$0.PluginExecuteResponse> execute(
    $0.PluginExecuteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$execute, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// HealthCheck verifies the plugin is alive and functioning.
  $grpc.ResponseFuture<$0.PluginHealthCheckResponse> pluginHealthCheck(
    $0.PluginHealthCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pluginHealthCheck, request, options: options);
  }

  // method descriptors

  static final _$register =
      $grpc.ClientMethod<$0.PluginRegisterRequest, $0.PluginRegisterResponse>(
          '/betcode.v1.PluginService/Register',
          ($0.PluginRegisterRequest value) => value.writeToBuffer(),
          $0.PluginRegisterResponse.fromBuffer);
  static final _$execute =
      $grpc.ClientMethod<$0.PluginExecuteRequest, $0.PluginExecuteResponse>(
          '/betcode.v1.PluginService/Execute',
          ($0.PluginExecuteRequest value) => value.writeToBuffer(),
          $0.PluginExecuteResponse.fromBuffer);
  static final _$pluginHealthCheck = $grpc.ClientMethod<
          $0.PluginHealthCheckRequest, $0.PluginHealthCheckResponse>(
      '/betcode.v1.PluginService/PluginHealthCheck',
      ($0.PluginHealthCheckRequest value) => value.writeToBuffer(),
      $0.PluginHealthCheckResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.PluginService')
abstract class PluginServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.PluginService';

  PluginServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PluginRegisterRequest,
            $0.PluginRegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PluginRegisterRequest.fromBuffer(value),
        ($0.PluginRegisterResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PluginExecuteRequest, $0.PluginExecuteResponse>(
            'Execute',
            execute_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.PluginExecuteRequest.fromBuffer(value),
            ($0.PluginExecuteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PluginHealthCheckRequest,
            $0.PluginHealthCheckResponse>(
        'PluginHealthCheck',
        pluginHealthCheck_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PluginHealthCheckRequest.fromBuffer(value),
        ($0.PluginHealthCheckResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.PluginRegisterResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PluginRegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.PluginRegisterResponse> register(
      $grpc.ServiceCall call, $0.PluginRegisterRequest request);

  $async.Stream<$0.PluginExecuteResponse> execute_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PluginExecuteRequest> $request) async* {
    yield* execute($call, await $request);
  }

  $async.Stream<$0.PluginExecuteResponse> execute(
      $grpc.ServiceCall call, $0.PluginExecuteRequest request);

  $async.Future<$0.PluginHealthCheckResponse> pluginHealthCheck_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PluginHealthCheckRequest> $request) async {
    return pluginHealthCheck($call, await $request);
  }

  $async.Future<$0.PluginHealthCheckResponse> pluginHealthCheck(
      $grpc.ServiceCall call, $0.PluginHealthCheckRequest request);
}
