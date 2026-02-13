// This is a generated file - do not edit.
//
// Generated from betcode/v1/git_repo.proto.

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

import 'git_repo.pb.dart' as $0;

export 'git_repo.pb.dart';

/// GitRepoService manages registered git repositories and their configuration.
@$pb.GrpcServiceName('betcode.v1.GitRepoService')
class GitRepoServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  GitRepoServiceClient(super.channel, {super.options, super.interceptors});

  /// Register a new git repository.
  $grpc.ResponseFuture<$0.GitRepoDetail> registerRepo(
    $0.RegisterRepoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerRepo, request, options: options);
  }

  /// Remove a registered repository.
  $grpc.ResponseFuture<$0.UnregisterRepoResponse> unregisterRepo(
    $0.UnregisterRepoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unregisterRepo, request, options: options);
  }

  /// List all registered repositories.
  $grpc.ResponseFuture<$0.ListReposResponse> listRepos(
    $0.ListReposRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRepos, request, options: options);
  }

  /// Get a single repository by ID.
  $grpc.ResponseFuture<$0.GitRepoDetail> getRepo(
    $0.GetRepoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRepo, request, options: options);
  }

  /// Update repository configuration.
  $grpc.ResponseFuture<$0.GitRepoDetail> updateRepo(
    $0.UpdateRepoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRepo, request, options: options);
  }

  /// Scan a directory for git repositories and register them.
  $grpc.ResponseFuture<$0.ListReposResponse> scanRepos(
    $0.ScanReposRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scanRepos, request, options: options);
  }

  // method descriptors

  static final _$registerRepo =
      $grpc.ClientMethod<$0.RegisterRepoRequest, $0.GitRepoDetail>(
          '/betcode.v1.GitRepoService/RegisterRepo',
          ($0.RegisterRepoRequest value) => value.writeToBuffer(),
          $0.GitRepoDetail.fromBuffer);
  static final _$unregisterRepo =
      $grpc.ClientMethod<$0.UnregisterRepoRequest, $0.UnregisterRepoResponse>(
          '/betcode.v1.GitRepoService/UnregisterRepo',
          ($0.UnregisterRepoRequest value) => value.writeToBuffer(),
          $0.UnregisterRepoResponse.fromBuffer);
  static final _$listRepos =
      $grpc.ClientMethod<$0.ListReposRequest, $0.ListReposResponse>(
          '/betcode.v1.GitRepoService/ListRepos',
          ($0.ListReposRequest value) => value.writeToBuffer(),
          $0.ListReposResponse.fromBuffer);
  static final _$getRepo =
      $grpc.ClientMethod<$0.GetRepoRequest, $0.GitRepoDetail>(
          '/betcode.v1.GitRepoService/GetRepo',
          ($0.GetRepoRequest value) => value.writeToBuffer(),
          $0.GitRepoDetail.fromBuffer);
  static final _$updateRepo =
      $grpc.ClientMethod<$0.UpdateRepoRequest, $0.GitRepoDetail>(
          '/betcode.v1.GitRepoService/UpdateRepo',
          ($0.UpdateRepoRequest value) => value.writeToBuffer(),
          $0.GitRepoDetail.fromBuffer);
  static final _$scanRepos =
      $grpc.ClientMethod<$0.ScanReposRequest, $0.ListReposResponse>(
          '/betcode.v1.GitRepoService/ScanRepos',
          ($0.ScanReposRequest value) => value.writeToBuffer(),
          $0.ListReposResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.GitRepoService')
abstract class GitRepoServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.GitRepoService';

  GitRepoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRepoRequest, $0.GitRepoDetail>(
        'RegisterRepo',
        registerRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterRepoRequest.fromBuffer(value),
        ($0.GitRepoDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnregisterRepoRequest,
            $0.UnregisterRepoResponse>(
        'UnregisterRepo',
        unregisterRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UnregisterRepoRequest.fromBuffer(value),
        ($0.UnregisterRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListReposRequest, $0.ListReposResponse>(
        'ListRepos',
        listRepos_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListReposRequest.fromBuffer(value),
        ($0.ListReposResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRepoRequest, $0.GitRepoDetail>(
        'GetRepo',
        getRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRepoRequest.fromBuffer(value),
        ($0.GitRepoDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateRepoRequest, $0.GitRepoDetail>(
        'UpdateRepo',
        updateRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateRepoRequest.fromBuffer(value),
        ($0.GitRepoDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScanReposRequest, $0.ListReposResponse>(
        'ScanRepos',
        scanRepos_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScanReposRequest.fromBuffer(value),
        ($0.ListReposResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GitRepoDetail> registerRepo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRepoRequest> $request) async {
    return registerRepo($call, await $request);
  }

  $async.Future<$0.GitRepoDetail> registerRepo(
      $grpc.ServiceCall call, $0.RegisterRepoRequest request);

  $async.Future<$0.UnregisterRepoResponse> unregisterRepo_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UnregisterRepoRequest> $request) async {
    return unregisterRepo($call, await $request);
  }

  $async.Future<$0.UnregisterRepoResponse> unregisterRepo(
      $grpc.ServiceCall call, $0.UnregisterRepoRequest request);

  $async.Future<$0.ListReposResponse> listRepos_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListReposRequest> $request) async {
    return listRepos($call, await $request);
  }

  $async.Future<$0.ListReposResponse> listRepos(
      $grpc.ServiceCall call, $0.ListReposRequest request);

  $async.Future<$0.GitRepoDetail> getRepo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRepoRequest> $request) async {
    return getRepo($call, await $request);
  }

  $async.Future<$0.GitRepoDetail> getRepo(
      $grpc.ServiceCall call, $0.GetRepoRequest request);

  $async.Future<$0.GitRepoDetail> updateRepo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateRepoRequest> $request) async {
    return updateRepo($call, await $request);
  }

  $async.Future<$0.GitRepoDetail> updateRepo(
      $grpc.ServiceCall call, $0.UpdateRepoRequest request);

  $async.Future<$0.ListReposResponse> scanRepos_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScanReposRequest> $request) async {
    return scanRepos($call, await $request);
  }

  $async.Future<$0.ListReposResponse> scanRepos(
      $grpc.ServiceCall call, $0.ScanReposRequest request);
}
