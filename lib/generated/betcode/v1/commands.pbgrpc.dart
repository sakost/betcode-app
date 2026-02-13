// This is a generated file - do not edit.
//
// Generated from betcode/v1/commands.proto.

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

import 'commands.pb.dart' as $0;

export 'commands.pb.dart';

/// CommandService provides command registry, completion data, service command
/// execution, and plugin management.
@$pb.GrpcServiceName('betcode.v1.CommandService')
class CommandServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CommandServiceClient(super.channel, {super.options, super.interceptors});

  /// Registry
  $grpc.ResponseFuture<$0.GetCommandRegistryResponse> getCommandRegistry(
    $0.GetCommandRegistryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCommandRegistry, request, options: options);
  }

  /// Completion
  $grpc.ResponseFuture<$0.ListAgentsResponse> listAgents(
    $0.ListAgentsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAgents, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPathResponse> listPath(
    $0.ListPathRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPath, request, options: options);
  }

  /// Service command execution
  $grpc.ResponseStream<$0.ServiceCommandOutput> executeServiceCommand(
    $0.ExecuteServiceCommandRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$executeServiceCommand, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Plugin management
  $grpc.ResponseFuture<$0.ListPluginsResponse> listPlugins(
    $0.ListPluginsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPlugins, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPluginStatusResponse> getPluginStatus(
    $0.GetPluginStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPluginStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddPluginResponse> addPlugin(
    $0.AddPluginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addPlugin, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemovePluginResponse> removePlugin(
    $0.RemovePluginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removePlugin, request, options: options);
  }

  $grpc.ResponseFuture<$0.EnablePluginResponse> enablePlugin(
    $0.EnablePluginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$enablePlugin, request, options: options);
  }

  $grpc.ResponseFuture<$0.DisablePluginResponse> disablePlugin(
    $0.DisablePluginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disablePlugin, request, options: options);
  }

  // method descriptors

  static final _$getCommandRegistry = $grpc.ClientMethod<
          $0.GetCommandRegistryRequest, $0.GetCommandRegistryResponse>(
      '/betcode.v1.CommandService/GetCommandRegistry',
      ($0.GetCommandRegistryRequest value) => value.writeToBuffer(),
      $0.GetCommandRegistryResponse.fromBuffer);
  static final _$listAgents =
      $grpc.ClientMethod<$0.ListAgentsRequest, $0.ListAgentsResponse>(
          '/betcode.v1.CommandService/ListAgents',
          ($0.ListAgentsRequest value) => value.writeToBuffer(),
          $0.ListAgentsResponse.fromBuffer);
  static final _$listPath =
      $grpc.ClientMethod<$0.ListPathRequest, $0.ListPathResponse>(
          '/betcode.v1.CommandService/ListPath',
          ($0.ListPathRequest value) => value.writeToBuffer(),
          $0.ListPathResponse.fromBuffer);
  static final _$executeServiceCommand = $grpc.ClientMethod<
          $0.ExecuteServiceCommandRequest, $0.ServiceCommandOutput>(
      '/betcode.v1.CommandService/ExecuteServiceCommand',
      ($0.ExecuteServiceCommandRequest value) => value.writeToBuffer(),
      $0.ServiceCommandOutput.fromBuffer);
  static final _$listPlugins =
      $grpc.ClientMethod<$0.ListPluginsRequest, $0.ListPluginsResponse>(
          '/betcode.v1.CommandService/ListPlugins',
          ($0.ListPluginsRequest value) => value.writeToBuffer(),
          $0.ListPluginsResponse.fromBuffer);
  static final _$getPluginStatus =
      $grpc.ClientMethod<$0.GetPluginStatusRequest, $0.GetPluginStatusResponse>(
          '/betcode.v1.CommandService/GetPluginStatus',
          ($0.GetPluginStatusRequest value) => value.writeToBuffer(),
          $0.GetPluginStatusResponse.fromBuffer);
  static final _$addPlugin =
      $grpc.ClientMethod<$0.AddPluginRequest, $0.AddPluginResponse>(
          '/betcode.v1.CommandService/AddPlugin',
          ($0.AddPluginRequest value) => value.writeToBuffer(),
          $0.AddPluginResponse.fromBuffer);
  static final _$removePlugin =
      $grpc.ClientMethod<$0.RemovePluginRequest, $0.RemovePluginResponse>(
          '/betcode.v1.CommandService/RemovePlugin',
          ($0.RemovePluginRequest value) => value.writeToBuffer(),
          $0.RemovePluginResponse.fromBuffer);
  static final _$enablePlugin =
      $grpc.ClientMethod<$0.EnablePluginRequest, $0.EnablePluginResponse>(
          '/betcode.v1.CommandService/EnablePlugin',
          ($0.EnablePluginRequest value) => value.writeToBuffer(),
          $0.EnablePluginResponse.fromBuffer);
  static final _$disablePlugin =
      $grpc.ClientMethod<$0.DisablePluginRequest, $0.DisablePluginResponse>(
          '/betcode.v1.CommandService/DisablePlugin',
          ($0.DisablePluginRequest value) => value.writeToBuffer(),
          $0.DisablePluginResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.CommandService')
abstract class CommandServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.CommandService';

  CommandServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetCommandRegistryRequest,
            $0.GetCommandRegistryResponse>(
        'GetCommandRegistry',
        getCommandRegistry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCommandRegistryRequest.fromBuffer(value),
        ($0.GetCommandRegistryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAgentsRequest, $0.ListAgentsResponse>(
        'ListAgents',
        listAgents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListAgentsRequest.fromBuffer(value),
        ($0.ListAgentsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPathRequest, $0.ListPathResponse>(
        'ListPath',
        listPath_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListPathRequest.fromBuffer(value),
        ($0.ListPathResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecuteServiceCommandRequest,
            $0.ServiceCommandOutput>(
        'ExecuteServiceCommand',
        executeServiceCommand_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.ExecuteServiceCommandRequest.fromBuffer(value),
        ($0.ServiceCommandOutput value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPluginsRequest, $0.ListPluginsResponse>(
            'ListPlugins',
            listPlugins_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPluginsRequest.fromBuffer(value),
            ($0.ListPluginsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPluginStatusRequest,
            $0.GetPluginStatusResponse>(
        'GetPluginStatus',
        getPluginStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPluginStatusRequest.fromBuffer(value),
        ($0.GetPluginStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddPluginRequest, $0.AddPluginResponse>(
        'AddPlugin',
        addPlugin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddPluginRequest.fromBuffer(value),
        ($0.AddPluginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RemovePluginRequest, $0.RemovePluginResponse>(
            'RemovePlugin',
            removePlugin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RemovePluginRequest.fromBuffer(value),
            ($0.RemovePluginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.EnablePluginRequest, $0.EnablePluginResponse>(
            'EnablePlugin',
            enablePlugin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.EnablePluginRequest.fromBuffer(value),
            ($0.EnablePluginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DisablePluginRequest, $0.DisablePluginResponse>(
            'DisablePlugin',
            disablePlugin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DisablePluginRequest.fromBuffer(value),
            ($0.DisablePluginResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetCommandRegistryResponse> getCommandRegistry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCommandRegistryRequest> $request) async {
    return getCommandRegistry($call, await $request);
  }

  $async.Future<$0.GetCommandRegistryResponse> getCommandRegistry(
      $grpc.ServiceCall call, $0.GetCommandRegistryRequest request);

  $async.Future<$0.ListAgentsResponse> listAgents_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListAgentsRequest> $request) async {
    return listAgents($call, await $request);
  }

  $async.Future<$0.ListAgentsResponse> listAgents(
      $grpc.ServiceCall call, $0.ListAgentsRequest request);

  $async.Future<$0.ListPathResponse> listPath_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListPathRequest> $request) async {
    return listPath($call, await $request);
  }

  $async.Future<$0.ListPathResponse> listPath(
      $grpc.ServiceCall call, $0.ListPathRequest request);

  $async.Stream<$0.ServiceCommandOutput> executeServiceCommand_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExecuteServiceCommandRequest> $request) async* {
    yield* executeServiceCommand($call, await $request);
  }

  $async.Stream<$0.ServiceCommandOutput> executeServiceCommand(
      $grpc.ServiceCall call, $0.ExecuteServiceCommandRequest request);

  $async.Future<$0.ListPluginsResponse> listPlugins_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListPluginsRequest> $request) async {
    return listPlugins($call, await $request);
  }

  $async.Future<$0.ListPluginsResponse> listPlugins(
      $grpc.ServiceCall call, $0.ListPluginsRequest request);

  $async.Future<$0.GetPluginStatusResponse> getPluginStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPluginStatusRequest> $request) async {
    return getPluginStatus($call, await $request);
  }

  $async.Future<$0.GetPluginStatusResponse> getPluginStatus(
      $grpc.ServiceCall call, $0.GetPluginStatusRequest request);

  $async.Future<$0.AddPluginResponse> addPlugin_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddPluginRequest> $request) async {
    return addPlugin($call, await $request);
  }

  $async.Future<$0.AddPluginResponse> addPlugin(
      $grpc.ServiceCall call, $0.AddPluginRequest request);

  $async.Future<$0.RemovePluginResponse> removePlugin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemovePluginRequest> $request) async {
    return removePlugin($call, await $request);
  }

  $async.Future<$0.RemovePluginResponse> removePlugin(
      $grpc.ServiceCall call, $0.RemovePluginRequest request);

  $async.Future<$0.EnablePluginResponse> enablePlugin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EnablePluginRequest> $request) async {
    return enablePlugin($call, await $request);
  }

  $async.Future<$0.EnablePluginResponse> enablePlugin(
      $grpc.ServiceCall call, $0.EnablePluginRequest request);

  $async.Future<$0.DisablePluginResponse> disablePlugin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DisablePluginRequest> $request) async {
    return disablePlugin($call, await $request);
  }

  $async.Future<$0.DisablePluginResponse> disablePlugin(
      $grpc.ServiceCall call, $0.DisablePluginRequest request);
}
