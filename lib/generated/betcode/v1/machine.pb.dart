// This is a generated file - do not edit.
//
// Generated from betcode/v1/machine.proto.

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

import 'machine.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'machine.pbenum.dart';

class MachineInfo extends $pb.GeneratedMessage {
  factory MachineInfo({
    $core.String? machineId,
    $core.String? name,
    $core.String? ownerId,
    MachineStatus? status,
    $1.Timestamp? registeredAt,
    $1.Timestamp? lastSeen,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    if (name != null) result.name = name;
    if (ownerId != null) result.ownerId = ownerId;
    if (status != null) result.status = status;
    if (registeredAt != null) result.registeredAt = registeredAt;
    if (lastSeen != null) result.lastSeen = lastSeen;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  MachineInfo._();

  factory MachineInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MachineInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MachineInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'ownerId')
    ..aE<MachineStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: MachineStatus.values)
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'registeredAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'lastSeen',
        subBuilder: $1.Timestamp.create)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'MachineInfo.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MachineInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MachineInfo copyWith(void Function(MachineInfo) updates) =>
      super.copyWith((message) => updates(message as MachineInfo))
          as MachineInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MachineInfo create() => MachineInfo._();
  @$core.override
  MachineInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MachineInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MachineInfo>(create);
  static MachineInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerId() => $_clearField(3);

  @$pb.TagNumber(4)
  MachineStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(MachineStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get registeredAt => $_getN(4);
  @$pb.TagNumber(5)
  set registeredAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRegisteredAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegisteredAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureRegisteredAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Timestamp get lastSeen => $_getN(5);
  @$pb.TagNumber(6)
  set lastSeen($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastSeen() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSeen() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureLastSeen() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(6);
}

class RegisterMachineRequest extends $pb.GeneratedMessage {
  factory RegisterMachineRequest({
    $core.String? machineId,
    $core.String? name,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    if (name != null) result.name = name;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  RegisterMachineRequest._();

  factory RegisterMachineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterMachineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterMachineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'RegisterMachineRequest.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMachineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMachineRequest copyWith(
          void Function(RegisterMachineRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterMachineRequest))
          as RegisterMachineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterMachineRequest create() => RegisterMachineRequest._();
  @$core.override
  RegisterMachineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterMachineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterMachineRequest>(create);
  static RegisterMachineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(2);
}

class RegisterMachineResponse extends $pb.GeneratedMessage {
  factory RegisterMachineResponse({
    MachineInfo? machine,
  }) {
    final result = create();
    if (machine != null) result.machine = machine;
    return result;
  }

  RegisterMachineResponse._();

  factory RegisterMachineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterMachineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterMachineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<MachineInfo>(1, _omitFieldNames ? '' : 'machine',
        subBuilder: MachineInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMachineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMachineResponse copyWith(
          void Function(RegisterMachineResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterMachineResponse))
          as RegisterMachineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterMachineResponse create() => RegisterMachineResponse._();
  @$core.override
  RegisterMachineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterMachineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterMachineResponse>(create);
  static RegisterMachineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MachineInfo get machine => $_getN(0);
  @$pb.TagNumber(1)
  set machine(MachineInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMachine() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachine() => $_clearField(1);
  @$pb.TagNumber(1)
  MachineInfo ensureMachine() => $_ensure(0);
}

class ListMachinesRequest extends $pb.GeneratedMessage {
  factory ListMachinesRequest({
    MachineStatus? statusFilter,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListMachinesRequest._();

  factory ListMachinesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMachinesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMachinesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<MachineStatus>(1, _omitFieldNames ? '' : 'statusFilter',
        enumValues: MachineStatus.values)
    ..aI(2, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMachinesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMachinesRequest copyWith(void Function(ListMachinesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMachinesRequest))
          as ListMachinesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMachinesRequest create() => ListMachinesRequest._();
  @$core.override
  ListMachinesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMachinesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMachinesRequest>(create);
  static ListMachinesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MachineStatus get statusFilter => $_getN(0);
  @$pb.TagNumber(1)
  set statusFilter(MachineStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatusFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatusFilter() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ListMachinesResponse extends $pb.GeneratedMessage {
  factory ListMachinesResponse({
    $core.Iterable<MachineInfo>? machines,
    $core.int? total,
  }) {
    final result = create();
    if (machines != null) result.machines.addAll(machines);
    if (total != null) result.total = total;
    return result;
  }

  ListMachinesResponse._();

  factory ListMachinesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMachinesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMachinesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<MachineInfo>(1, _omitFieldNames ? '' : 'machines',
        subBuilder: MachineInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMachinesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMachinesResponse copyWith(void Function(ListMachinesResponse) updates) =>
      super.copyWith((message) => updates(message as ListMachinesResponse))
          as ListMachinesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMachinesResponse create() => ListMachinesResponse._();
  @$core.override
  ListMachinesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMachinesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMachinesResponse>(create);
  static ListMachinesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MachineInfo> get machines => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class RemoveMachineRequest extends $pb.GeneratedMessage {
  factory RemoveMachineRequest({
    $core.String? machineId,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    return result;
  }

  RemoveMachineRequest._();

  factory RemoveMachineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveMachineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveMachineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveMachineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveMachineRequest copyWith(void Function(RemoveMachineRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveMachineRequest))
          as RemoveMachineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveMachineRequest create() => RemoveMachineRequest._();
  @$core.override
  RemoveMachineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveMachineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveMachineRequest>(create);
  static RemoveMachineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);
}

class RemoveMachineResponse extends $pb.GeneratedMessage {
  factory RemoveMachineResponse({
    $core.bool? removed,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    return result;
  }

  RemoveMachineResponse._();

  factory RemoveMachineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveMachineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveMachineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'removed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveMachineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveMachineResponse copyWith(
          void Function(RemoveMachineResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveMachineResponse))
          as RemoveMachineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveMachineResponse create() => RemoveMachineResponse._();
  @$core.override
  RemoveMachineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveMachineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveMachineResponse>(create);
  static RemoveMachineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get removed => $_getBF(0);
  @$pb.TagNumber(1)
  set removed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);
}

class GetMachineRequest extends $pb.GeneratedMessage {
  factory GetMachineRequest({
    $core.String? machineId,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    return result;
  }

  GetMachineRequest._();

  factory GetMachineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMachineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMachineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMachineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMachineRequest copyWith(void Function(GetMachineRequest) updates) =>
      super.copyWith((message) => updates(message as GetMachineRequest))
          as GetMachineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMachineRequest create() => GetMachineRequest._();
  @$core.override
  GetMachineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMachineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMachineRequest>(create);
  static GetMachineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);
}

class GetMachineResponse extends $pb.GeneratedMessage {
  factory GetMachineResponse({
    MachineInfo? machine,
  }) {
    final result = create();
    if (machine != null) result.machine = machine;
    return result;
  }

  GetMachineResponse._();

  factory GetMachineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMachineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMachineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOM<MachineInfo>(1, _omitFieldNames ? '' : 'machine',
        subBuilder: MachineInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMachineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMachineResponse copyWith(void Function(GetMachineResponse) updates) =>
      super.copyWith((message) => updates(message as GetMachineResponse))
          as GetMachineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMachineResponse create() => GetMachineResponse._();
  @$core.override
  GetMachineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMachineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMachineResponse>(create);
  static GetMachineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MachineInfo get machine => $_getN(0);
  @$pb.TagNumber(1)
  set machine(MachineInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMachine() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachine() => $_clearField(1);
  @$pb.TagNumber(1)
  MachineInfo ensureMachine() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
