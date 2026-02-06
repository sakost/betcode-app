// This is a generated file - do not edit.
//
// Generated from betcode/v1/config.proto.

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

import 'config.pb.dart' as $0;

export 'config.pb.dart';

/// ConfigService provides configuration management.
@$pb.GrpcServiceName('betcode.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConfigServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Settings> getSettings(
    $0.GetSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.Settings> updateSettings(
    $0.UpdateSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListMcpServersResponse> listMcpServers(
    $0.ListMcpServersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMcpServers, request, options: options);
  }

  $grpc.ResponseFuture<$0.PermissionRules> getPermissions(
    $0.GetPermissionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPermissions, request, options: options);
  }

  // method descriptors

  static final _$getSettings =
      $grpc.ClientMethod<$0.GetSettingsRequest, $0.Settings>(
          '/betcode.v1.ConfigService/GetSettings',
          ($0.GetSettingsRequest value) => value.writeToBuffer(),
          $0.Settings.fromBuffer);
  static final _$updateSettings =
      $grpc.ClientMethod<$0.UpdateSettingsRequest, $0.Settings>(
          '/betcode.v1.ConfigService/UpdateSettings',
          ($0.UpdateSettingsRequest value) => value.writeToBuffer(),
          $0.Settings.fromBuffer);
  static final _$listMcpServers =
      $grpc.ClientMethod<$0.ListMcpServersRequest, $0.ListMcpServersResponse>(
          '/betcode.v1.ConfigService/ListMcpServers',
          ($0.ListMcpServersRequest value) => value.writeToBuffer(),
          $0.ListMcpServersResponse.fromBuffer);
  static final _$getPermissions =
      $grpc.ClientMethod<$0.GetPermissionsRequest, $0.PermissionRules>(
          '/betcode.v1.ConfigService/GetPermissions',
          ($0.GetPermissionsRequest value) => value.writeToBuffer(),
          $0.PermissionRules.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetSettingsRequest, $0.Settings>(
        'GetSettings',
        getSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSettingsRequest.fromBuffer(value),
        ($0.Settings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSettingsRequest, $0.Settings>(
        'UpdateSettings',
        updateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSettingsRequest.fromBuffer(value),
        ($0.Settings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListMcpServersRequest,
            $0.ListMcpServersResponse>(
        'ListMcpServers',
        listMcpServers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListMcpServersRequest.fromBuffer(value),
        ($0.ListMcpServersResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPermissionsRequest, $0.PermissionRules>(
            'GetPermissions',
            getPermissions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPermissionsRequest.fromBuffer(value),
            ($0.PermissionRules value) => value.writeToBuffer()));
  }

  $async.Future<$0.Settings> getSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsRequest> $request) async {
    return getSettings($call, await $request);
  }

  $async.Future<$0.Settings> getSettings(
      $grpc.ServiceCall call, $0.GetSettingsRequest request);

  $async.Future<$0.Settings> updateSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateSettingsRequest> $request) async {
    return updateSettings($call, await $request);
  }

  $async.Future<$0.Settings> updateSettings(
      $grpc.ServiceCall call, $0.UpdateSettingsRequest request);

  $async.Future<$0.ListMcpServersResponse> listMcpServers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMcpServersRequest> $request) async {
    return listMcpServers($call, await $request);
  }

  $async.Future<$0.ListMcpServersResponse> listMcpServers(
      $grpc.ServiceCall call, $0.ListMcpServersRequest request);

  $async.Future<$0.PermissionRules> getPermissions_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPermissionsRequest> $request) async {
    return getPermissions($call, await $request);
  }

  $async.Future<$0.PermissionRules> getPermissions(
      $grpc.ServiceCall call, $0.GetPermissionsRequest request);
}
