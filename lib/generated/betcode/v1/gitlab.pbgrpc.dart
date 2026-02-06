// This is a generated file - do not edit.
//
// Generated from betcode/v1/gitlab.proto.

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

import 'gitlab.pb.dart' as $0;

export 'gitlab.pb.dart';

/// GitLabService provides access to GitLab project data.
@$pb.GrpcServiceName('betcode.v1.GitLabService')
class GitLabServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  GitLabServiceClient(super.channel, {super.options, super.interceptors});

  /// List merge requests for a project.
  $grpc.ResponseFuture<$0.ListMergeRequestsResponse> listMergeRequests(
    $0.ListMergeRequestsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMergeRequests, request, options: options);
  }

  /// Get a single merge request by IID.
  $grpc.ResponseFuture<$0.GetMergeRequestResponse> getMergeRequest(
    $0.GetMergeRequestRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMergeRequest, request, options: options);
  }

  /// List pipelines for a project.
  $grpc.ResponseFuture<$0.ListPipelinesResponse> listPipelines(
    $0.ListPipelinesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPipelines, request, options: options);
  }

  /// Get a single pipeline by ID.
  $grpc.ResponseFuture<$0.GetPipelineResponse> getPipeline(
    $0.GetPipelineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPipeline, request, options: options);
  }

  /// List issues for a project.
  $grpc.ResponseFuture<$0.ListIssuesResponse> listIssues(
    $0.ListIssuesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listIssues, request, options: options);
  }

  /// Get a single issue by IID.
  $grpc.ResponseFuture<$0.GetIssueResponse> getIssue(
    $0.GetIssueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getIssue, request, options: options);
  }

  // method descriptors

  static final _$listMergeRequests = $grpc.ClientMethod<
          $0.ListMergeRequestsRequest, $0.ListMergeRequestsResponse>(
      '/betcode.v1.GitLabService/ListMergeRequests',
      ($0.ListMergeRequestsRequest value) => value.writeToBuffer(),
      $0.ListMergeRequestsResponse.fromBuffer);
  static final _$getMergeRequest =
      $grpc.ClientMethod<$0.GetMergeRequestRequest, $0.GetMergeRequestResponse>(
          '/betcode.v1.GitLabService/GetMergeRequest',
          ($0.GetMergeRequestRequest value) => value.writeToBuffer(),
          $0.GetMergeRequestResponse.fromBuffer);
  static final _$listPipelines =
      $grpc.ClientMethod<$0.ListPipelinesRequest, $0.ListPipelinesResponse>(
          '/betcode.v1.GitLabService/ListPipelines',
          ($0.ListPipelinesRequest value) => value.writeToBuffer(),
          $0.ListPipelinesResponse.fromBuffer);
  static final _$getPipeline =
      $grpc.ClientMethod<$0.GetPipelineRequest, $0.GetPipelineResponse>(
          '/betcode.v1.GitLabService/GetPipeline',
          ($0.GetPipelineRequest value) => value.writeToBuffer(),
          $0.GetPipelineResponse.fromBuffer);
  static final _$listIssues =
      $grpc.ClientMethod<$0.ListIssuesRequest, $0.ListIssuesResponse>(
          '/betcode.v1.GitLabService/ListIssues',
          ($0.ListIssuesRequest value) => value.writeToBuffer(),
          $0.ListIssuesResponse.fromBuffer);
  static final _$getIssue =
      $grpc.ClientMethod<$0.GetIssueRequest, $0.GetIssueResponse>(
          '/betcode.v1.GitLabService/GetIssue',
          ($0.GetIssueRequest value) => value.writeToBuffer(),
          $0.GetIssueResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.GitLabService')
abstract class GitLabServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.GitLabService';

  GitLabServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListMergeRequestsRequest,
            $0.ListMergeRequestsResponse>(
        'ListMergeRequests',
        listMergeRequests_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListMergeRequestsRequest.fromBuffer(value),
        ($0.ListMergeRequestsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMergeRequestRequest,
            $0.GetMergeRequestResponse>(
        'GetMergeRequest',
        getMergeRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMergeRequestRequest.fromBuffer(value),
        ($0.GetMergeRequestResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPipelinesRequest, $0.ListPipelinesResponse>(
            'ListPipelines',
            listPipelines_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPipelinesRequest.fromBuffer(value),
            ($0.ListPipelinesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPipelineRequest, $0.GetPipelineResponse>(
            'GetPipeline',
            getPipeline_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPipelineRequest.fromBuffer(value),
            ($0.GetPipelineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListIssuesRequest, $0.ListIssuesResponse>(
        'ListIssues',
        listIssues_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListIssuesRequest.fromBuffer(value),
        ($0.ListIssuesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetIssueRequest, $0.GetIssueResponse>(
        'GetIssue',
        getIssue_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetIssueRequest.fromBuffer(value),
        ($0.GetIssueResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListMergeRequestsResponse> listMergeRequests_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMergeRequestsRequest> $request) async {
    return listMergeRequests($call, await $request);
  }

  $async.Future<$0.ListMergeRequestsResponse> listMergeRequests(
      $grpc.ServiceCall call, $0.ListMergeRequestsRequest request);

  $async.Future<$0.GetMergeRequestResponse> getMergeRequest_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMergeRequestRequest> $request) async {
    return getMergeRequest($call, await $request);
  }

  $async.Future<$0.GetMergeRequestResponse> getMergeRequest(
      $grpc.ServiceCall call, $0.GetMergeRequestRequest request);

  $async.Future<$0.ListPipelinesResponse> listPipelines_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPipelinesRequest> $request) async {
    return listPipelines($call, await $request);
  }

  $async.Future<$0.ListPipelinesResponse> listPipelines(
      $grpc.ServiceCall call, $0.ListPipelinesRequest request);

  $async.Future<$0.GetPipelineResponse> getPipeline_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPipelineRequest> $request) async {
    return getPipeline($call, await $request);
  }

  $async.Future<$0.GetPipelineResponse> getPipeline(
      $grpc.ServiceCall call, $0.GetPipelineRequest request);

  $async.Future<$0.ListIssuesResponse> listIssues_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListIssuesRequest> $request) async {
    return listIssues($call, await $request);
  }

  $async.Future<$0.ListIssuesResponse> listIssues(
      $grpc.ServiceCall call, $0.ListIssuesRequest request);

  $async.Future<$0.GetIssueResponse> getIssue_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetIssueRequest> $request) async {
    return getIssue($call, await $request);
  }

  $async.Future<$0.GetIssueResponse> getIssue(
      $grpc.ServiceCall call, $0.GetIssueRequest request);
}
