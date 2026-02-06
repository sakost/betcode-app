// This is a generated file - do not edit.
//
// Generated from betcode/v1/worktree.proto.

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

import 'worktree.pb.dart' as $0;

export 'worktree.pb.dart';

/// WorktreeService manages git worktrees and their association with sessions.
@$pb.GrpcServiceName('betcode.v1.WorktreeService')
class WorktreeServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WorktreeServiceClient(super.channel, {super.options, super.interceptors});

  /// Create a new git worktree with optional setup script.
  $grpc.ResponseFuture<$0.WorktreeDetail> createWorktree(
    $0.CreateWorktreeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createWorktree, request, options: options);
  }

  /// Remove a worktree and its database record.
  $grpc.ResponseFuture<$0.RemoveWorktreeResponse> removeWorktree(
    $0.RemoveWorktreeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeWorktree, request, options: options);
  }

  /// List worktrees, optionally filtered by repo path.
  $grpc.ResponseFuture<$0.ListWorktreesResponse> listWorktrees(
    $0.ListWorktreesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listWorktrees, request, options: options);
  }

  /// Get a single worktree with status info.
  $grpc.ResponseFuture<$0.WorktreeDetail> getWorktree(
    $0.GetWorktreeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getWorktree, request, options: options);
  }

  // method descriptors

  static final _$createWorktree =
      $grpc.ClientMethod<$0.CreateWorktreeRequest, $0.WorktreeDetail>(
          '/betcode.v1.WorktreeService/CreateWorktree',
          ($0.CreateWorktreeRequest value) => value.writeToBuffer(),
          $0.WorktreeDetail.fromBuffer);
  static final _$removeWorktree =
      $grpc.ClientMethod<$0.RemoveWorktreeRequest, $0.RemoveWorktreeResponse>(
          '/betcode.v1.WorktreeService/RemoveWorktree',
          ($0.RemoveWorktreeRequest value) => value.writeToBuffer(),
          $0.RemoveWorktreeResponse.fromBuffer);
  static final _$listWorktrees =
      $grpc.ClientMethod<$0.ListWorktreesRequest, $0.ListWorktreesResponse>(
          '/betcode.v1.WorktreeService/ListWorktrees',
          ($0.ListWorktreesRequest value) => value.writeToBuffer(),
          $0.ListWorktreesResponse.fromBuffer);
  static final _$getWorktree =
      $grpc.ClientMethod<$0.GetWorktreeRequest, $0.WorktreeDetail>(
          '/betcode.v1.WorktreeService/GetWorktree',
          ($0.GetWorktreeRequest value) => value.writeToBuffer(),
          $0.WorktreeDetail.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.WorktreeService')
abstract class WorktreeServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.WorktreeService';

  WorktreeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateWorktreeRequest, $0.WorktreeDetail>(
        'CreateWorktree',
        createWorktree_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateWorktreeRequest.fromBuffer(value),
        ($0.WorktreeDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveWorktreeRequest,
            $0.RemoveWorktreeResponse>(
        'RemoveWorktree',
        removeWorktree_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveWorktreeRequest.fromBuffer(value),
        ($0.RemoveWorktreeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListWorktreesRequest, $0.ListWorktreesResponse>(
            'ListWorktrees',
            listWorktrees_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListWorktreesRequest.fromBuffer(value),
            ($0.ListWorktreesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetWorktreeRequest, $0.WorktreeDetail>(
        'GetWorktree',
        getWorktree_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetWorktreeRequest.fromBuffer(value),
        ($0.WorktreeDetail value) => value.writeToBuffer()));
  }

  $async.Future<$0.WorktreeDetail> createWorktree_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateWorktreeRequest> $request) async {
    return createWorktree($call, await $request);
  }

  $async.Future<$0.WorktreeDetail> createWorktree(
      $grpc.ServiceCall call, $0.CreateWorktreeRequest request);

  $async.Future<$0.RemoveWorktreeResponse> removeWorktree_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemoveWorktreeRequest> $request) async {
    return removeWorktree($call, await $request);
  }

  $async.Future<$0.RemoveWorktreeResponse> removeWorktree(
      $grpc.ServiceCall call, $0.RemoveWorktreeRequest request);

  $async.Future<$0.ListWorktreesResponse> listWorktrees_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListWorktreesRequest> $request) async {
    return listWorktrees($call, await $request);
  }

  $async.Future<$0.ListWorktreesResponse> listWorktrees(
      $grpc.ServiceCall call, $0.ListWorktreesRequest request);

  $async.Future<$0.WorktreeDetail> getWorktree_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetWorktreeRequest> $request) async {
    return getWorktree($call, await $request);
  }

  $async.Future<$0.WorktreeDetail> getWorktree(
      $grpc.ServiceCall call, $0.GetWorktreeRequest request);
}
