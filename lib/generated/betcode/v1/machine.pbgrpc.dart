// This is a generated file - do not edit.
//
// Generated from betcode/v1/machine.proto.

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

import 'machine.pb.dart' as $0;

export 'machine.pb.dart';

/// MachineService manages daemon machine registrations.
@$pb.GrpcServiceName('betcode.v1.MachineService')
class MachineServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MachineServiceClient(super.channel, {super.options, super.interceptors});

  /// Register a new machine for the authenticated user.
  $grpc.ResponseFuture<$0.RegisterMachineResponse> registerMachine(
    $0.RegisterMachineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerMachine, request, options: options);
  }

  /// List all machines owned by the authenticated user.
  $grpc.ResponseFuture<$0.ListMachinesResponse> listMachines(
    $0.ListMachinesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMachines, request, options: options);
  }

  /// Remove a machine registration.
  $grpc.ResponseFuture<$0.RemoveMachineResponse> removeMachine(
    $0.RemoveMachineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeMachine, request, options: options);
  }

  /// Get details for a specific machine.
  $grpc.ResponseFuture<$0.GetMachineResponse> getMachine(
    $0.GetMachineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMachine, request, options: options);
  }

  // method descriptors

  static final _$registerMachine =
      $grpc.ClientMethod<$0.RegisterMachineRequest, $0.RegisterMachineResponse>(
          '/betcode.v1.MachineService/RegisterMachine',
          ($0.RegisterMachineRequest value) => value.writeToBuffer(),
          $0.RegisterMachineResponse.fromBuffer);
  static final _$listMachines =
      $grpc.ClientMethod<$0.ListMachinesRequest, $0.ListMachinesResponse>(
          '/betcode.v1.MachineService/ListMachines',
          ($0.ListMachinesRequest value) => value.writeToBuffer(),
          $0.ListMachinesResponse.fromBuffer);
  static final _$removeMachine =
      $grpc.ClientMethod<$0.RemoveMachineRequest, $0.RemoveMachineResponse>(
          '/betcode.v1.MachineService/RemoveMachine',
          ($0.RemoveMachineRequest value) => value.writeToBuffer(),
          $0.RemoveMachineResponse.fromBuffer);
  static final _$getMachine =
      $grpc.ClientMethod<$0.GetMachineRequest, $0.GetMachineResponse>(
          '/betcode.v1.MachineService/GetMachine',
          ($0.GetMachineRequest value) => value.writeToBuffer(),
          $0.GetMachineResponse.fromBuffer);
}

@$pb.GrpcServiceName('betcode.v1.MachineService')
abstract class MachineServiceBase extends $grpc.Service {
  $core.String get $name => 'betcode.v1.MachineService';

  MachineServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterMachineRequest,
            $0.RegisterMachineResponse>(
        'RegisterMachine',
        registerMachine_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterMachineRequest.fromBuffer(value),
        ($0.RegisterMachineResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListMachinesRequest, $0.ListMachinesResponse>(
            'ListMachines',
            listMachines_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMachinesRequest.fromBuffer(value),
            ($0.ListMachinesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RemoveMachineRequest, $0.RemoveMachineResponse>(
            'RemoveMachine',
            removeMachine_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RemoveMachineRequest.fromBuffer(value),
            ($0.RemoveMachineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMachineRequest, $0.GetMachineResponse>(
        'GetMachine',
        getMachine_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMachineRequest.fromBuffer(value),
        ($0.GetMachineResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterMachineResponse> registerMachine_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterMachineRequest> $request) async {
    return registerMachine($call, await $request);
  }

  $async.Future<$0.RegisterMachineResponse> registerMachine(
      $grpc.ServiceCall call, $0.RegisterMachineRequest request);

  $async.Future<$0.ListMachinesResponse> listMachines_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMachinesRequest> $request) async {
    return listMachines($call, await $request);
  }

  $async.Future<$0.ListMachinesResponse> listMachines(
      $grpc.ServiceCall call, $0.ListMachinesRequest request);

  $async.Future<$0.RemoveMachineResponse> removeMachine_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemoveMachineRequest> $request) async {
    return removeMachine($call, await $request);
  }

  $async.Future<$0.RemoveMachineResponse> removeMachine(
      $grpc.ServiceCall call, $0.RemoveMachineRequest request);

  $async.Future<$0.GetMachineResponse> getMachine_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMachineRequest> $request) async {
    return getMachine($call, await $request);
  }

  $async.Future<$0.GetMachineResponse> getMachine(
      $grpc.ServiceCall call, $0.GetMachineRequest request);
}
