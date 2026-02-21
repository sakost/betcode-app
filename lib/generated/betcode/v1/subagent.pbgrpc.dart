// This is a generated file - do not edit.
//
// Generated from betcode/v1/subagent.proto.

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

import 'subagent.pb.dart' as $0;

export 'subagent.pb.dart';

/// SubagentService provides daemon-orchestrated subagent management.
/// Unlike Level 1 (Claude-internal Task tool), Level 2 subagents are
/// independent Claude Code subprocesses managed by the daemon.
@$pb.GrpcServiceName('betcode.v1.SubagentService')
class SubagentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SubagentServiceClient(super.channel, {super.options, super.interceptors});

  /// Spawn a new subagent subprocess under a parent session.
  $grpc.ResponseFuture<$0.SpawnSubagentResponse> spawnSubagent(
    $0.SpawnSubagentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$spawnSubagent, request, options: options);
  }

  /// Watch a subagent's event stream.
  $grpc.ResponseStream<$0.SubagentEvent> watchSubagent(
    $0.WatchSubagentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchSubagent, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Send input to a running subagent.
  $grpc.ResponseFuture<$0.SendToSubagentResponse> sendToSubagent(
    $0.SendToSubagentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendToSubagent, request, options: options);
  }

  /// Cancel a running subagent.
  $grpc.ResponseFuture<$0.CancelSubagentResponse> cancelSubagent(
    $0.CancelSubagentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelSubagent, request, options: options);
  }

  /// List subagents for a parent session.
  $grpc.ResponseFuture<$0.ListSubagentsResponse> listSubagents(
    $0.ListSubagentsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSubagents, request, options: options);
  }

  /// Create a multi-step orchestration (parallel, sequential, or DAG).
  $grpc.ResponseFuture<$0.CreateOrchestrationResponse> createOrchestration(
    $0.CreateOrchestrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createOrchestration, request, options: options);
  }

  /// Watch orchestration progress events.
  $grpc.ResponseStream<$0.OrchestrationEvent> watchOrchestration(
    $0.WatchOrchestrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchOrchestration, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Revoke auto-approve permissions on a running subagent.
  $grpc.ResponseFuture<$0.RevokeAutoApproveResponse> revokeAutoApprove(
    $0.RevokeAutoApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revokeAutoApprove, request, options: options);
  }

  // method descriptors

  static final _$spawnSubagent =
      $grpc.ClientMethod<$0.SpawnSubagentRequest, $0.SpawnSubagentResponse>(
          '/betcode.v1.SubagentService/SpawnSubagent',
          ($0.SpawnSubagentRequest value) => value.writeToBuffer(),
          $0.SpawnSubagentResponse.fromBuffer);
  static final _$watchSubagent =
      $grpc.ClientMethod<$0.WatchSubagentRequest, $0.SubagentEvent>(
          '/betcode.v1.SubagentService/WatchSubagent',
          ($0.WatchSubagentRequest value) => value.writeToBuffer(),
          $0.SubagentEvent.fromBuffer);
  static final _$sendToSubagent =
      $grpc.ClientMethod<$0.SendToSubagentRequest, $0.SendToSubagentResponse>(
          '/betcode.v1.SubagentService/SendToSubagent',
          ($0.SendToSubagentRequest value) => value.writeToBuffer(),
          $0.SendToSubagentResponse.fromBuffer);
  static final _$cancelSubagent =
      $grpc.ClientMethod<$0.CancelSubagentRequest, $0.CancelSubagentResponse>(
          '/betcode.v1.SubagentService/CancelSubagent',
          ($0.CancelSubagentRequest value) => value.writeToBuffer(),
          $0.CancelSubagentResponse.fromBuffer);
  static final _$listSubagents =
      $grpc.ClientMethod<$0.ListSubagentsRequest, $0.ListSubagentsResponse>(
          '/betcode.v1.SubagentService/ListSubagents',
          ($0.ListSubagentsRequest value) => value.writeToBuffer(),
          $0.ListSubagentsResponse.fromBuffer);
  static final _$createOrchestration = $grpc.ClientMethod<
          $0.CreateOrchestrationRequest, $0.CreateOrchestrationResponse>(
      '/betcode.v1.SubagentService/CreateOrchestration',
      ($0.CreateOrchestrationRequest value) => value.writeToBuffer(),
      $0.CreateOrchestrationResponse.fromBuffer);
  static final _$watchOrchestration =
      $grpc.ClientMethod<$0.WatchOrchestrationRequest, $0.OrchestrationEvent>(
          '/betcode.v1.SubagentService/WatchOrchestration',
          ($0.WatchOrchestrationRequest value) => value.writeToBuffer(),
          $0.OrchestrationEvent.fromBuffer);
  static final _$revokeAutoApprove = $grpc.ClientMethod<
          $0.RevokeAutoApproveRequest, $0.RevokeAutoApproveResponse>(
      '/betcode.v1.SubagentService/RevokeAutoApprove',
      ($0.RevokeAutoApproveRequest value) => value.writeToBuffer(),
      $0.RevokeAutoApproveResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.SubagentService')
abstract class SubagentServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.SubagentService';

  SubagentServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SpawnSubagentRequest, $0.SpawnSubagentResponse>(
            'SpawnSubagent',
            spawnSubagent_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SpawnSubagentRequest.fromBuffer(value),
            ($0.SpawnSubagentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchSubagentRequest, $0.SubagentEvent>(
        'WatchSubagent',
        watchSubagent_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchSubagentRequest.fromBuffer(value),
        ($0.SubagentEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendToSubagentRequest,
            $0.SendToSubagentResponse>(
        'SendToSubagent',
        sendToSubagent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendToSubagentRequest.fromBuffer(value),
        ($0.SendToSubagentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelSubagentRequest,
            $0.CancelSubagentResponse>(
        'CancelSubagent',
        cancelSubagent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelSubagentRequest.fromBuffer(value),
        ($0.CancelSubagentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListSubagentsRequest, $0.ListSubagentsResponse>(
            'ListSubagents',
            listSubagents_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListSubagentsRequest.fromBuffer(value),
            ($0.ListSubagentsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateOrchestrationRequest,
            $0.CreateOrchestrationResponse>(
        'CreateOrchestration',
        createOrchestration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateOrchestrationRequest.fromBuffer(value),
        ($0.CreateOrchestrationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchOrchestrationRequest,
            $0.OrchestrationEvent>(
        'WatchOrchestration',
        watchOrchestration_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchOrchestrationRequest.fromBuffer(value),
        ($0.OrchestrationEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RevokeAutoApproveRequest,
            $0.RevokeAutoApproveResponse>(
        'RevokeAutoApprove',
        revokeAutoApprove_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RevokeAutoApproveRequest.fromBuffer(value),
        ($0.RevokeAutoApproveResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SpawnSubagentResponse> spawnSubagent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SpawnSubagentRequest> $request) async {
    return spawnSubagent($call, await $request);
  }

  $async.Future<$0.SpawnSubagentResponse> spawnSubagent(
      $grpc.ServiceCall call, $0.SpawnSubagentRequest request);

  $async.Stream<$0.SubagentEvent> watchSubagent_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchSubagentRequest> $request) async* {
    yield* watchSubagent($call, await $request);
  }

  $async.Stream<$0.SubagentEvent> watchSubagent(
      $grpc.ServiceCall call, $0.WatchSubagentRequest request);

  $async.Future<$0.SendToSubagentResponse> sendToSubagent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendToSubagentRequest> $request) async {
    return sendToSubagent($call, await $request);
  }

  $async.Future<$0.SendToSubagentResponse> sendToSubagent(
      $grpc.ServiceCall call, $0.SendToSubagentRequest request);

  $async.Future<$0.CancelSubagentResponse> cancelSubagent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelSubagentRequest> $request) async {
    return cancelSubagent($call, await $request);
  }

  $async.Future<$0.CancelSubagentResponse> cancelSubagent(
      $grpc.ServiceCall call, $0.CancelSubagentRequest request);

  $async.Future<$0.ListSubagentsResponse> listSubagents_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSubagentsRequest> $request) async {
    return listSubagents($call, await $request);
  }

  $async.Future<$0.ListSubagentsResponse> listSubagents(
      $grpc.ServiceCall call, $0.ListSubagentsRequest request);

  $async.Future<$0.CreateOrchestrationResponse> createOrchestration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateOrchestrationRequest> $request) async {
    return createOrchestration($call, await $request);
  }

  $async.Future<$0.CreateOrchestrationResponse> createOrchestration(
      $grpc.ServiceCall call, $0.CreateOrchestrationRequest request);

  $async.Stream<$0.OrchestrationEvent> watchOrchestration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchOrchestrationRequest> $request) async* {
    yield* watchOrchestration($call, await $request);
  }

  $async.Stream<$0.OrchestrationEvent> watchOrchestration(
      $grpc.ServiceCall call, $0.WatchOrchestrationRequest request);

  $async.Future<$0.RevokeAutoApproveResponse> revokeAutoApprove_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RevokeAutoApproveRequest> $request) async {
    return revokeAutoApprove($call, await $request);
  }

  $async.Future<$0.RevokeAutoApproveResponse> revokeAutoApprove(
      $grpc.ServiceCall call, $0.RevokeAutoApproveRequest request);
}
