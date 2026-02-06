// This is a generated file - do not edit.
//
// Generated from betcode/v1/health.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'health.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'health.pbenum.dart';

class HealthCheckRequest extends $pb.GeneratedMessage {
  factory HealthCheckRequest({
    $core.String? service,
  }) {
    final result = create();
    if (service != null) result.service = service;
    return result;
  }

  HealthCheckRequest._();

  factory HealthCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'service')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest copyWith(void Function(HealthCheckRequest) updates) =>
      super.copyWith((message) => updates(message as HealthCheckRequest))
          as HealthCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest create() => HealthCheckRequest._();
  @$core.override
  HealthCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckRequest>(create);
  static HealthCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get service => $_getSZ(0);
  @$pb.TagNumber(1)
  set service($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => $_clearField(1);
}

class HealthCheckResponse extends $pb.GeneratedMessage {
  factory HealthCheckResponse({
    ServingStatus? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  HealthCheckResponse._();

  factory HealthCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<ServingStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: ServingStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse copyWith(void Function(HealthCheckResponse) updates) =>
      super.copyWith((message) => updates(message as HealthCheckResponse))
          as HealthCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse create() => HealthCheckResponse._();
  @$core.override
  HealthCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckResponse>(create);
  static HealthCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServingStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(ServingStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class HealthDetailsRequest extends $pb.GeneratedMessage {
  factory HealthDetailsRequest() => create();

  HealthDetailsRequest._();

  factory HealthDetailsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthDetailsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthDetailsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetailsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetailsRequest copyWith(void Function(HealthDetailsRequest) updates) =>
      super.copyWith((message) => updates(message as HealthDetailsRequest))
          as HealthDetailsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthDetailsRequest create() => HealthDetailsRequest._();
  @$core.override
  HealthDetailsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthDetailsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthDetailsRequest>(create);
  static HealthDetailsRequest? _defaultInstance;
}

class HealthDetailsResponse extends $pb.GeneratedMessage {
  factory HealthDetailsResponse({
    ServingStatus? overallStatus,
    $core.Iterable<ComponentHealth>? components,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
    $core.bool? degraded,
    $core.String? degradedReason,
  }) {
    final result = create();
    if (overallStatus != null) result.overallStatus = overallStatus;
    if (components != null) result.components.addAll(components);
    if (metadata != null) result.metadata.addEntries(metadata);
    if (degraded != null) result.degraded = degraded;
    if (degradedReason != null) result.degradedReason = degradedReason;
    return result;
  }

  HealthDetailsResponse._();

  factory HealthDetailsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthDetailsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthDetailsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<ServingStatus>(1, _omitFieldNames ? '' : 'overallStatus',
        enumValues: ServingStatus.values)
    ..pPM<ComponentHealth>(2, _omitFieldNames ? '' : 'components',
        subBuilder: ComponentHealth.create)
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'HealthDetailsResponse.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..aOB(4, _omitFieldNames ? '' : 'degraded')
    ..aOS(5, _omitFieldNames ? '' : 'degradedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetailsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetailsResponse copyWith(
          void Function(HealthDetailsResponse) updates) =>
      super.copyWith((message) => updates(message as HealthDetailsResponse))
          as HealthDetailsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthDetailsResponse create() => HealthDetailsResponse._();
  @$core.override
  HealthDetailsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthDetailsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthDetailsResponse>(create);
  static HealthDetailsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServingStatus get overallStatus => $_getN(0);
  @$pb.TagNumber(1)
  set overallStatus(ServingStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOverallStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearOverallStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ComponentHealth> get components => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(2);

  @$pb.TagNumber(4)
  $core.bool get degraded => $_getBF(3);
  @$pb.TagNumber(4)
  set degraded($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDegraded() => $_has(3);
  @$pb.TagNumber(4)
  void clearDegraded() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get degradedReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set degradedReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDegradedReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearDegradedReason() => $_clearField(5);
}

class ComponentHealth extends $pb.GeneratedMessage {
  factory ComponentHealth({
    $core.String? name,
    ServingStatus? status,
    $core.String? message,
    $1.Timestamp? lastCheck,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (message != null) result.message = message;
    if (lastCheck != null) result.lastCheck = lastCheck;
    return result;
  }

  ComponentHealth._();

  factory ComponentHealth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComponentHealth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComponentHealth',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<ServingStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ServingStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'lastCheck',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComponentHealth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComponentHealth copyWith(void Function(ComponentHealth) updates) =>
      super.copyWith((message) => updates(message as ComponentHealth))
          as ComponentHealth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComponentHealth create() => ComponentHealth._();
  @$core.override
  ComponentHealth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComponentHealth getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComponentHealth>(create);
  static ComponentHealth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  ServingStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ServingStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get lastCheck => $_getN(3);
  @$pb.TagNumber(4)
  set lastCheck($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastCheck() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastCheck() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureLastCheck() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
