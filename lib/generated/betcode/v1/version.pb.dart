// This is a generated file - do not edit.
//
// Generated from betcode/v1/version.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'version.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'version.pbenum.dart';

class GetVersionRequest extends $pb.GeneratedMessage {
  factory GetVersionRequest() => create();

  GetVersionRequest._();

  factory GetVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVersionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVersionRequest copyWith(void Function(GetVersionRequest) updates) =>
      super.copyWith((message) => updates(message as GetVersionRequest))
          as GetVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVersionRequest create() => GetVersionRequest._();
  @$core.override
  GetVersionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVersionRequest>(create);
  static GetVersionRequest? _defaultInstance;
}

class GetVersionResponse extends $pb.GeneratedMessage {
  factory GetVersionResponse({
    $core.String? apiVersion,
    $core.String? serverVersion,
    $core.Iterable<$core.String>? features,
    ClaudeCodeInfo? claudeCode,
    VersionConstraints? constraints,
  }) {
    final result = create();
    if (apiVersion != null) result.apiVersion = apiVersion;
    if (serverVersion != null) result.serverVersion = serverVersion;
    if (features != null) result.features.addAll(features);
    if (claudeCode != null) result.claudeCode = claudeCode;
    if (constraints != null) result.constraints = constraints;
    return result;
  }

  GetVersionResponse._();

  factory GetVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVersionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'apiVersion')
    ..aOS(2, _omitFieldNames ? '' : 'serverVersion')
    ..pPS(3, _omitFieldNames ? '' : 'features')
    ..aOM<ClaudeCodeInfo>(4, _omitFieldNames ? '' : 'claudeCode',
        subBuilder: ClaudeCodeInfo.create)
    ..aOM<VersionConstraints>(5, _omitFieldNames ? '' : 'constraints',
        subBuilder: VersionConstraints.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVersionResponse copyWith(void Function(GetVersionResponse) updates) =>
      super.copyWith((message) => updates(message as GetVersionResponse))
          as GetVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVersionResponse create() => GetVersionResponse._();
  @$core.override
  GetVersionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVersionResponse>(create);
  static GetVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get apiVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set apiVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApiVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get features => $_getList(2);

  @$pb.TagNumber(4)
  ClaudeCodeInfo get claudeCode => $_getN(3);
  @$pb.TagNumber(4)
  set claudeCode(ClaudeCodeInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClaudeCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearClaudeCode() => $_clearField(4);
  @$pb.TagNumber(4)
  ClaudeCodeInfo ensureClaudeCode() => $_ensure(3);

  @$pb.TagNumber(5)
  VersionConstraints get constraints => $_getN(4);
  @$pb.TagNumber(5)
  set constraints(VersionConstraints value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConstraints() => $_has(4);
  @$pb.TagNumber(5)
  void clearConstraints() => $_clearField(5);
  @$pb.TagNumber(5)
  VersionConstraints ensureConstraints() => $_ensure(4);
}

class ClaudeCodeInfo extends $pb.GeneratedMessage {
  factory ClaudeCodeInfo({
    $core.String? version,
    $core.String? apiVersion,
    CompatibilityLevel? compatibility,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (apiVersion != null) result.apiVersion = apiVersion;
    if (compatibility != null) result.compatibility = compatibility;
    return result;
  }

  ClaudeCodeInfo._();

  factory ClaudeCodeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClaudeCodeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaudeCodeInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'apiVersion')
    ..aE<CompatibilityLevel>(3, _omitFieldNames ? '' : 'compatibility',
        enumValues: CompatibilityLevel.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaudeCodeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaudeCodeInfo copyWith(void Function(ClaudeCodeInfo) updates) =>
      super.copyWith((message) => updates(message as ClaudeCodeInfo))
          as ClaudeCodeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClaudeCodeInfo create() => ClaudeCodeInfo._();
  @$core.override
  ClaudeCodeInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClaudeCodeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaudeCodeInfo>(create);
  static ClaudeCodeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  CompatibilityLevel get compatibility => $_getN(2);
  @$pb.TagNumber(3)
  set compatibility(CompatibilityLevel value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCompatibility() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompatibility() => $_clearField(3);
}

class VersionConstraints extends $pb.GeneratedMessage {
  factory VersionConstraints({
    $core.String? minClientVersion,
    $core.String? recommendedClient,
    $core.Iterable<$core.String>? deprecatedFeatures,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        featureReplacements,
  }) {
    final result = create();
    if (minClientVersion != null) result.minClientVersion = minClientVersion;
    if (recommendedClient != null) result.recommendedClient = recommendedClient;
    if (deprecatedFeatures != null)
      result.deprecatedFeatures.addAll(deprecatedFeatures);
    if (featureReplacements != null)
      result.featureReplacements.addEntries(featureReplacements);
    return result;
  }

  VersionConstraints._();

  factory VersionConstraints.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VersionConstraints.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VersionConstraints',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'minClientVersion')
    ..aOS(2, _omitFieldNames ? '' : 'recommendedClient')
    ..pPS(3, _omitFieldNames ? '' : 'deprecatedFeatures')
    ..m<$core.String, $core.String>(
        4, _omitFieldNames ? '' : 'featureReplacements',
        entryClassName: 'VersionConstraints.FeatureReplacementsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VersionConstraints clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VersionConstraints copyWith(void Function(VersionConstraints) updates) =>
      super.copyWith((message) => updates(message as VersionConstraints))
          as VersionConstraints;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VersionConstraints create() => VersionConstraints._();
  @$core.override
  VersionConstraints createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VersionConstraints getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VersionConstraints>(create);
  static VersionConstraints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get minClientVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set minClientVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinClientVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinClientVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recommendedClient => $_getSZ(1);
  @$pb.TagNumber(2)
  set recommendedClient($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecommendedClient() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecommendedClient() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get deprecatedFeatures => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get featureReplacements => $_getMap(3);
}

class NegotiateRequest extends $pb.GeneratedMessage {
  factory NegotiateRequest({
    $core.String? clientVersion,
    $core.String? clientType,
    $core.Iterable<$core.String>? requestedFeatures,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        clientCapabilities,
  }) {
    final result = create();
    if (clientVersion != null) result.clientVersion = clientVersion;
    if (clientType != null) result.clientType = clientType;
    if (requestedFeatures != null)
      result.requestedFeatures.addAll(requestedFeatures);
    if (clientCapabilities != null)
      result.clientCapabilities.addEntries(clientCapabilities);
    return result;
  }

  NegotiateRequest._();

  factory NegotiateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NegotiateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NegotiateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientVersion')
    ..aOS(2, _omitFieldNames ? '' : 'clientType')
    ..pPS(3, _omitFieldNames ? '' : 'requestedFeatures')
    ..m<$core.String, $core.String>(
        4, _omitFieldNames ? '' : 'clientCapabilities',
        entryClassName: 'NegotiateRequest.ClientCapabilitiesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateRequest copyWith(void Function(NegotiateRequest) updates) =>
      super.copyWith((message) => updates(message as NegotiateRequest))
          as NegotiateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateRequest create() => NegotiateRequest._();
  @$core.override
  NegotiateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NegotiateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateRequest>(create);
  static NegotiateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientType => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientType() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientType() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get requestedFeatures => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get clientCapabilities => $_getMap(3);
}

class NegotiateResponse extends $pb.GeneratedMessage {
  factory NegotiateResponse({
    $core.bool? accepted,
    $core.String? rejectionReason,
    $core.String? upgradeUrl,
    $core.Iterable<$core.String>? grantedFeatures,
    $core.Iterable<$core.String>? warnings,
    CapabilitySet? capabilities,
  }) {
    final result = create();
    if (accepted != null) result.accepted = accepted;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (upgradeUrl != null) result.upgradeUrl = upgradeUrl;
    if (grantedFeatures != null) result.grantedFeatures.addAll(grantedFeatures);
    if (warnings != null) result.warnings.addAll(warnings);
    if (capabilities != null) result.capabilities = capabilities;
    return result;
  }

  NegotiateResponse._();

  factory NegotiateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NegotiateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NegotiateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'rejectionReason')
    ..aOS(3, _omitFieldNames ? '' : 'upgradeUrl')
    ..pPS(4, _omitFieldNames ? '' : 'grantedFeatures')
    ..pPS(5, _omitFieldNames ? '' : 'warnings')
    ..aOM<CapabilitySet>(6, _omitFieldNames ? '' : 'capabilities',
        subBuilder: CapabilitySet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateResponse copyWith(void Function(NegotiateResponse) updates) =>
      super.copyWith((message) => updates(message as NegotiateResponse))
          as NegotiateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateResponse create() => NegotiateResponse._();
  @$core.override
  NegotiateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NegotiateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateResponse>(create);
  static NegotiateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rejectionReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set rejectionReason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRejectionReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejectionReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get upgradeUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set upgradeUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpgradeUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpgradeUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get grantedFeatures => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get warnings => $_getList(4);

  @$pb.TagNumber(6)
  CapabilitySet get capabilities => $_getN(5);
  @$pb.TagNumber(6)
  set capabilities(CapabilitySet value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCapabilities() => $_has(5);
  @$pb.TagNumber(6)
  void clearCapabilities() => $_clearField(6);
  @$pb.TagNumber(6)
  CapabilitySet ensureCapabilities() => $_ensure(5);
}

class CapabilitySet extends $pb.GeneratedMessage {
  factory CapabilitySet({
    $core.bool? streamingSupported,
    $core.bool? compressionSupported,
    $core.int? maxMessageSize,
    $core.Iterable<$core.String>? availableTools,
    $core.Iterable<$core.String>? availableModels,
    $core.bool? subagentsEnabled,
    $core.bool? worktreesEnabled,
    $core.Iterable<$core.MapEntry<$core.String, $core.bool>>? featureFlags,
  }) {
    final result = create();
    if (streamingSupported != null)
      result.streamingSupported = streamingSupported;
    if (compressionSupported != null)
      result.compressionSupported = compressionSupported;
    if (maxMessageSize != null) result.maxMessageSize = maxMessageSize;
    if (availableTools != null) result.availableTools.addAll(availableTools);
    if (availableModels != null) result.availableModels.addAll(availableModels);
    if (subagentsEnabled != null) result.subagentsEnabled = subagentsEnabled;
    if (worktreesEnabled != null) result.worktreesEnabled = worktreesEnabled;
    if (featureFlags != null) result.featureFlags.addEntries(featureFlags);
    return result;
  }

  CapabilitySet._();

  factory CapabilitySet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CapabilitySet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapabilitySet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'streamingSupported')
    ..aOB(2, _omitFieldNames ? '' : 'compressionSupported')
    ..aI(3, _omitFieldNames ? '' : 'maxMessageSize',
        fieldType: $pb.PbFieldType.OU3)
    ..pPS(4, _omitFieldNames ? '' : 'availableTools')
    ..pPS(5, _omitFieldNames ? '' : 'availableModels')
    ..aOB(6, _omitFieldNames ? '' : 'subagentsEnabled')
    ..aOB(7, _omitFieldNames ? '' : 'worktreesEnabled')
    ..m<$core.String, $core.bool>(8, _omitFieldNames ? '' : 'featureFlags',
        entryClassName: 'CapabilitySet.FeatureFlagsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilitySet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilitySet copyWith(void Function(CapabilitySet) updates) =>
      super.copyWith((message) => updates(message as CapabilitySet))
          as CapabilitySet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CapabilitySet create() => CapabilitySet._();
  @$core.override
  CapabilitySet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CapabilitySet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapabilitySet>(create);
  static CapabilitySet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get streamingSupported => $_getBF(0);
  @$pb.TagNumber(1)
  set streamingSupported($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreamingSupported() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamingSupported() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get compressionSupported => $_getBF(1);
  @$pb.TagNumber(2)
  set compressionSupported($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompressionSupported() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompressionSupported() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxMessageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxMessageSize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxMessageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxMessageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get availableTools => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get availableModels => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get subagentsEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set subagentsEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubagentsEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubagentsEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get worktreesEnabled => $_getBF(6);
  @$pb.TagNumber(7)
  set worktreesEnabled($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorktreesEnabled() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorktreesEnabled() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.bool> get featureFlags => $_getMap(7);
}

class FeatureFlag extends $pb.GeneratedMessage {
  factory FeatureFlag({
    $core.String? name,
    $core.String? description,
    FeatureStage? stage,
    $core.String? introducedVersion,
    $core.String? minClientVersion,
    $core.String? deprecatedVersion,
    $core.String? removalVersion,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (stage != null) result.stage = stage;
    if (introducedVersion != null) result.introducedVersion = introducedVersion;
    if (minClientVersion != null) result.minClientVersion = minClientVersion;
    if (deprecatedVersion != null) result.deprecatedVersion = deprecatedVersion;
    if (removalVersion != null) result.removalVersion = removalVersion;
    return result;
  }

  FeatureFlag._();

  factory FeatureFlag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FeatureFlag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeatureFlag',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aE<FeatureStage>(3, _omitFieldNames ? '' : 'stage',
        enumValues: FeatureStage.values)
    ..aOS(4, _omitFieldNames ? '' : 'introducedVersion')
    ..aOS(5, _omitFieldNames ? '' : 'minClientVersion')
    ..aOS(6, _omitFieldNames ? '' : 'deprecatedVersion')
    ..aOS(7, _omitFieldNames ? '' : 'removalVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeatureFlag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeatureFlag copyWith(void Function(FeatureFlag) updates) =>
      super.copyWith((message) => updates(message as FeatureFlag))
          as FeatureFlag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureFlag create() => FeatureFlag._();
  @$core.override
  FeatureFlag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FeatureFlag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FeatureFlag>(create);
  static FeatureFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  FeatureStage get stage => $_getN(2);
  @$pb.TagNumber(3)
  set stage(FeatureStage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStage() => $_has(2);
  @$pb.TagNumber(3)
  void clearStage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get introducedVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set introducedVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIntroducedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntroducedVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get minClientVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set minClientVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinClientVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinClientVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get deprecatedVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set deprecatedVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeprecatedVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeprecatedVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get removalVersion => $_getSZ(6);
  @$pb.TagNumber(7)
  set removalVersion($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRemovalVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemovalVersion() => $_clearField(7);
}

class DeprecationWarning extends $pb.GeneratedMessage {
  factory DeprecationWarning({
    $core.String? feature,
    $core.String? replacement,
    $core.String? removalVersion,
    $core.String? migrationUrl,
    Severity? severity,
  }) {
    final result = create();
    if (feature != null) result.feature = feature;
    if (replacement != null) result.replacement = replacement;
    if (removalVersion != null) result.removalVersion = removalVersion;
    if (migrationUrl != null) result.migrationUrl = migrationUrl;
    if (severity != null) result.severity = severity;
    return result;
  }

  DeprecationWarning._();

  factory DeprecationWarning.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeprecationWarning.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeprecationWarning',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'feature')
    ..aOS(2, _omitFieldNames ? '' : 'replacement')
    ..aOS(3, _omitFieldNames ? '' : 'removalVersion')
    ..aOS(4, _omitFieldNames ? '' : 'migrationUrl')
    ..aE<Severity>(5, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeprecationWarning clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeprecationWarning copyWith(void Function(DeprecationWarning) updates) =>
      super.copyWith((message) => updates(message as DeprecationWarning))
          as DeprecationWarning;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeprecationWarning create() => DeprecationWarning._();
  @$core.override
  DeprecationWarning createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeprecationWarning getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeprecationWarning>(create);
  static DeprecationWarning? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get feature => $_getSZ(0);
  @$pb.TagNumber(1)
  set feature($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFeature() => $_has(0);
  @$pb.TagNumber(1)
  void clearFeature() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get replacement => $_getSZ(1);
  @$pb.TagNumber(2)
  set replacement($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplacement() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplacement() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get removalVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set removalVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemovalVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemovalVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get migrationUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set migrationUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMigrationUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearMigrationUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  Severity get severity => $_getN(4);
  @$pb.TagNumber(5)
  set severity(Severity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSeverity() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeverity() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
