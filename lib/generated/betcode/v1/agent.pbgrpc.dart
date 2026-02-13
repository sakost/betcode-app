// This is a generated file - do not edit.
//
// Generated from betcode/v1/agent.proto.

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

import 'agent.pb.dart' as $0;
import 'tunnel.pb.dart' as $1;

export 'agent.pb.dart';

/// AgentService provides the primary interface for AI agent interaction.
@$pb.GrpcServiceName('betcode.v1.AgentService')
class AgentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AgentServiceClient(super.channel, {super.options, super.interceptors});

  /// Bidirectional streaming conversation with Claude.
  $grpc.ResponseStream<$0.AgentEvent> converse(
    $async.Stream<$0.AgentRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$converse, request, options: options);
  }

  /// List all sessions, optionally filtered.
  $grpc.ResponseFuture<$0.ListSessionsResponse> listSessions(
    $0.ListSessionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSessions, request, options: options);
  }

  /// Resume a session and replay events from a sequence number.
  $grpc.ResponseStream<$0.AgentEvent> resumeSession(
    $0.ResumeSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$resumeSession, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Trigger context compaction for a session.
  $grpc.ResponseFuture<$0.CompactSessionResponse> compactSession(
    $0.CompactSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$compactSession, request, options: options);
  }

  /// Cancel the current turn in a session.
  $grpc.ResponseFuture<$0.CancelTurnResponse> cancelTurn(
    $0.CancelTurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelTurn, request, options: options);
  }

  /// Request exclusive input lock for a session.
  $grpc.ResponseFuture<$0.InputLockResponse> requestInputLock(
    $0.InputLockRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestInputLock, request, options: options);
  }

  /// Exchange ephemeral keys for E2E encryption with a daemon.
  $grpc.ResponseFuture<$1.KeyExchangeResponse> exchangeKeys(
    $1.KeyExchangeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exchangeKeys, request, options: options);
  }

  // method descriptors

  static final _$converse = $grpc.ClientMethod<$0.AgentRequest, $0.AgentEvent>(
      '/betcode.v1.AgentService/Converse',
      ($0.AgentRequest value) => value.writeToBuffer(),
      $0.AgentEvent.fromBuffer);
  static final _$listSessions =
      $grpc.ClientMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
          '/betcode.v1.AgentService/ListSessions',
          ($0.ListSessionsRequest value) => value.writeToBuffer(),
          $0.ListSessionsResponse.fromBuffer);
  static final _$resumeSession =
      $grpc.ClientMethod<$0.ResumeSessionRequest, $0.AgentEvent>(
          '/betcode.v1.AgentService/ResumeSession',
          ($0.ResumeSessionRequest value) => value.writeToBuffer(),
          $0.AgentEvent.fromBuffer);
  static final _$compactSession =
      $grpc.ClientMethod<$0.CompactSessionRequest, $0.CompactSessionResponse>(
          '/betcode.v1.AgentService/CompactSession',
          ($0.CompactSessionRequest value) => value.writeToBuffer(),
          $0.CompactSessionResponse.fromBuffer);
  static final _$cancelTurn =
      $grpc.ClientMethod<$0.CancelTurnRequest, $0.CancelTurnResponse>(
          '/betcode.v1.AgentService/CancelTurn',
          ($0.CancelTurnRequest value) => value.writeToBuffer(),
          $0.CancelTurnResponse.fromBuffer);
  static final _$requestInputLock =
      $grpc.ClientMethod<$0.InputLockRequest, $0.InputLockResponse>(
          '/betcode.v1.AgentService/RequestInputLock',
          ($0.InputLockRequest value) => value.writeToBuffer(),
          $0.InputLockResponse.fromBuffer);
  static final _$exchangeKeys =
      $grpc.ClientMethod<$1.KeyExchangeRequest, $1.KeyExchangeResponse>(
          '/betcode.v1.AgentService/ExchangeKeys',
          ($1.KeyExchangeRequest value) => value.writeToBuffer(),
          $1.KeyExchangeResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.AgentService')
abstract class AgentServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.AgentService';

  AgentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AgentRequest, $0.AgentEvent>(
        'Converse',
        converse,
        true,
        true,
        ($core.List<$core.int> value) => $0.AgentRequest.fromBuffer(value),
        ($0.AgentEvent value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
            'ListSessions',
            listSessions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListSessionsRequest.fromBuffer(value),
            ($0.ListSessionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResumeSessionRequest, $0.AgentEvent>(
        'ResumeSession',
        resumeSession_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.ResumeSessionRequest.fromBuffer(value),
        ($0.AgentEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompactSessionRequest,
            $0.CompactSessionResponse>(
        'CompactSession',
        compactSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompactSessionRequest.fromBuffer(value),
        ($0.CompactSessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelTurnRequest, $0.CancelTurnResponse>(
        'CancelTurn',
        cancelTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelTurnRequest.fromBuffer(value),
        ($0.CancelTurnResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InputLockRequest, $0.InputLockResponse>(
        'RequestInputLock',
        requestInputLock_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InputLockRequest.fromBuffer(value),
        ($0.InputLockResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.KeyExchangeRequest, $1.KeyExchangeResponse>(
            'ExchangeKeys',
            exchangeKeys_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.KeyExchangeRequest.fromBuffer(value),
            ($1.KeyExchangeResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.AgentEvent> converse(
      $grpc.ServiceCall call, $async.Stream<$0.AgentRequest> request);

  $async.Future<$0.ListSessionsResponse> listSessions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSessionsRequest> $request) async {
    return listSessions($call, await $request);
  }

  $async.Future<$0.ListSessionsResponse> listSessions(
      $grpc.ServiceCall call, $0.ListSessionsRequest request);

  $async.Stream<$0.AgentEvent> resumeSession_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResumeSessionRequest> $request) async* {
    yield* resumeSession($call, await $request);
  }

  $async.Stream<$0.AgentEvent> resumeSession(
      $grpc.ServiceCall call, $0.ResumeSessionRequest request);

  $async.Future<$0.CompactSessionResponse> compactSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompactSessionRequest> $request) async {
    return compactSession($call, await $request);
  }

  $async.Future<$0.CompactSessionResponse> compactSession(
      $grpc.ServiceCall call, $0.CompactSessionRequest request);

  $async.Future<$0.CancelTurnResponse> cancelTurn_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CancelTurnRequest> $request) async {
    return cancelTurn($call, await $request);
  }

  $async.Future<$0.CancelTurnResponse> cancelTurn(
      $grpc.ServiceCall call, $0.CancelTurnRequest request);

  $async.Future<$0.InputLockResponse> requestInputLock_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InputLockRequest> $request) async {
    return requestInputLock($call, await $request);
  }

  $async.Future<$0.InputLockResponse> requestInputLock(
      $grpc.ServiceCall call, $0.InputLockRequest request);

  $async.Future<$1.KeyExchangeResponse> exchangeKeys_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.KeyExchangeRequest> $request) async {
    return exchangeKeys($call, await $request);
  }

  $async.Future<$1.KeyExchangeResponse> exchangeKeys(
      $grpc.ServiceCall call, $1.KeyExchangeRequest request);
}
