// This is a generated file - do not edit.
//
// Generated from betcode/v1/health.proto.

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

import 'health.pb.dart' as $0;

export 'health.pb.dart';

/// Standard gRPC health check (compatible with grpc.health.v1).
@$pb.GrpcServiceName('betcode.v1.Health')
class HealthClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HealthClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.HealthCheckResponse> check(
    $0.HealthCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$check, request, options: options);
  }

  $grpc.ResponseStream<$0.HealthCheckResponse> watch(
    $0.HealthCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$watch, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$check =
      $grpc.ClientMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
          '/betcode.v1.Health/Check',
          ($0.HealthCheckRequest value) => value.writeToBuffer(),
          $0.HealthCheckResponse.fromBuffer);
  static final _$watch =
      $grpc.ClientMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
          '/betcode.v1.Health/Watch',
          ($0.HealthCheckRequest value) => value.writeToBuffer(),
          $0.HealthCheckResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.Health')
abstract class HealthServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.Health';

  HealthServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
            'Check',
            check_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HealthCheckRequest.fromBuffer(value),
            ($0.HealthCheckResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
            'Watch',
            watch_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.HealthCheckRequest.fromBuffer(value),
            ($0.HealthCheckResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HealthCheckResponse> check_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HealthCheckRequest> $request) async {
    return check($call, await $request);
  }

  $async.Future<$0.HealthCheckResponse> check(
      $grpc.ServiceCall call, $0.HealthCheckRequest request);

  $async.Stream<$0.HealthCheckResponse> watch_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HealthCheckRequest> $request) async* {
    yield* watch($call, await $request);
  }

  $async.Stream<$0.HealthCheckResponse> watch(
      $grpc.ServiceCall call, $0.HealthCheckRequest request);
}

/// BetCode-specific health details.
@$pb.GrpcServiceName('betcode.v1.BetCodeHealth')
class BetCodeHealthClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BetCodeHealthClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.HealthDetailsResponse> getHealthDetails(
    $0.HealthDetailsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHealthDetails, request, options: options);
  }

  // method descriptors

  static final _$getHealthDetails =
      $grpc.ClientMethod<$0.HealthDetailsRequest, $0.HealthDetailsResponse>(
          '/betcode.v1.BetCodeHealth/GetHealthDetails',
          ($0.HealthDetailsRequest value) => value.writeToBuffer(),
          $0.HealthDetailsResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.BetCodeHealth')
abstract class BetCodeHealthServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.BetCodeHealth';

  BetCodeHealthServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.HealthDetailsRequest, $0.HealthDetailsResponse>(
            'GetHealthDetails',
            getHealthDetails_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HealthDetailsRequest.fromBuffer(value),
            ($0.HealthDetailsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HealthDetailsResponse> getHealthDetails_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HealthDetailsRequest> $request) async {
    return getHealthDetails($call, await $request);
  }

  $async.Future<$0.HealthDetailsResponse> getHealthDetails(
      $grpc.ServiceCall call, $0.HealthDetailsRequest request);
}
