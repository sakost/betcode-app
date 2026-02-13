// This is a generated file - do not edit.
//
// Generated from betcode/v1/tunnel.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'tunnel.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'tunnel.pbenum.dart';

enum TunnelFrame_Payload { streamData, error, control, notSet }

/// TunnelFrame is the envelope for all messages sent through the tunnel.
class TunnelFrame extends $pb.GeneratedMessage {
  factory TunnelFrame({
    $core.String? requestId,
    FrameType? frameType,
    $1.Timestamp? timestamp,
    StreamPayload? streamData,
    TunnelError? error,
    TunnelControl? control,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (frameType != null) result.frameType = frameType;
    if (timestamp != null) result.timestamp = timestamp;
    if (streamData != null) result.streamData = streamData;
    if (error != null) result.error = error;
    if (control != null) result.control = control;
    return result;
  }

  TunnelFrame._();

  factory TunnelFrame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelFrame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TunnelFrame_Payload>
      _TunnelFrame_PayloadByTag = {
    10: TunnelFrame_Payload.streamData,
    11: TunnelFrame_Payload.error,
    12: TunnelFrame_Payload.control,
    0: TunnelFrame_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelFrame',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12])
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aE<FrameType>(2, _omitFieldNames ? '' : 'frameType',
        enumValues: FrameType.values)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aOM<StreamPayload>(10, _omitFieldNames ? '' : 'streamData',
        subBuilder: StreamPayload.create)
    ..aOM<TunnelError>(11, _omitFieldNames ? '' : 'error',
        subBuilder: TunnelError.create)
    ..aOM<TunnelControl>(12, _omitFieldNames ? '' : 'control',
        subBuilder: TunnelControl.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelFrame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelFrame copyWith(void Function(TunnelFrame) updates) =>
      super.copyWith((message) => updates(message as TunnelFrame))
          as TunnelFrame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelFrame create() => TunnelFrame._();
  @$core.override
  TunnelFrame createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelFrame getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelFrame>(create);
  static TunnelFrame? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  TunnelFrame_Payload whichPayload() =>
      _TunnelFrame_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  FrameType get frameType => $_getN(1);
  @$pb.TagNumber(2)
  set frameType(FrameType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrameType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrameType() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureTimestamp() => $_ensure(2);

  @$pb.TagNumber(10)
  StreamPayload get streamData => $_getN(3);
  @$pb.TagNumber(10)
  set streamData(StreamPayload value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStreamData() => $_has(3);
  @$pb.TagNumber(10)
  void clearStreamData() => $_clearField(10);
  @$pb.TagNumber(10)
  StreamPayload ensureStreamData() => $_ensure(3);

  @$pb.TagNumber(11)
  TunnelError get error => $_getN(4);
  @$pb.TagNumber(11)
  set error(TunnelError value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(11)
  void clearError() => $_clearField(11);
  @$pb.TagNumber(11)
  TunnelError ensureError() => $_ensure(4);

  @$pb.TagNumber(12)
  TunnelControl get control => $_getN(5);
  @$pb.TagNumber(12)
  set control(TunnelControl value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasControl() => $_has(5);
  @$pb.TagNumber(12)
  void clearControl() => $_clearField(12);
  @$pb.TagNumber(12)
  TunnelControl ensureControl() => $_ensure(5);
}

/// EncryptedPayload wraps E2E encrypted content.
/// The relay cannot decrypt this — only the CLI and daemon share the session key.
class EncryptedPayload extends $pb.GeneratedMessage {
  factory EncryptedPayload({
    $core.List<$core.int>? ciphertext,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? ephemeralPubkey,
  }) {
    final result = create();
    if (ciphertext != null) result.ciphertext = ciphertext;
    if (nonce != null) result.nonce = nonce;
    if (ephemeralPubkey != null) result.ephemeralPubkey = ephemeralPubkey;
    return result;
  }

  EncryptedPayload._();

  factory EncryptedPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EncryptedPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EncryptedPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'ciphertext', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'ephemeralPubkey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncryptedPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncryptedPayload copyWith(void Function(EncryptedPayload) updates) =>
      super.copyWith((message) => updates(message as EncryptedPayload))
          as EncryptedPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncryptedPayload create() => EncryptedPayload._();
  @$core.override
  EncryptedPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EncryptedPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptedPayload>(create);
  static EncryptedPayload? _defaultInstance;

  /// ChaCha20-Poly1305 encrypted data (includes 16-byte AEAD tag).
  @$pb.TagNumber(1)
  $core.List<$core.int> get ciphertext => $_getN(0);
  @$pb.TagNumber(1)
  set ciphertext($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCiphertext() => $_has(0);
  @$pb.TagNumber(1)
  void clearCiphertext() => $_clearField(1);

  /// 12-byte nonce used for this encryption.
  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);

  /// Sender's ephemeral X25519 public key (included in first message only).
  @$pb.TagNumber(3)
  $core.List<$core.int> get ephemeralPubkey => $_getN(2);
  @$pb.TagNumber(3)
  set ephemeralPubkey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEphemeralPubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearEphemeralPubkey() => $_clearField(3);
}

/// StreamPayload carries the serialized gRPC request/response through the tunnel.
class StreamPayload extends $pb.GeneratedMessage {
  factory StreamPayload({
    $core.String? method,
    EncryptedPayload? encrypted,
    $fixnum.Int64? sequence,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (method != null) result.method = method;
    if (encrypted != null) result.encrypted = encrypted;
    if (sequence != null) result.sequence = sequence;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  StreamPayload._();

  factory StreamPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'method')
    ..aOM<EncryptedPayload>(2, _omitFieldNames ? '' : 'encrypted',
        subBuilder: EncryptedPayload.create)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'StreamPayload.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamPayload copyWith(void Function(StreamPayload) updates) =>
      super.copyWith((message) => updates(message as StreamPayload))
          as StreamPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamPayload create() => StreamPayload._();
  @$core.override
  StreamPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamPayload>(create);
  static StreamPayload? _defaultInstance;

  /// The gRPC service method being proxied (e.g. "betcode.v1.AgentService/Converse").
  @$pb.TagNumber(1)
  $core.String get method => $_getSZ(0);
  @$pb.TagNumber(1)
  set method($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMethod() => $_has(0);
  @$pb.TagNumber(1)
  void clearMethod() => $_clearField(1);

  /// E2E encrypted protobuf bytes of the request or response.
  @$pb.TagNumber(2)
  EncryptedPayload get encrypted => $_getN(1);
  @$pb.TagNumber(2)
  set encrypted(EncryptedPayload value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEncrypted() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncrypted() => $_clearField(2);
  @$pb.TagNumber(2)
  EncryptedPayload ensureEncrypted() => $_ensure(1);

  /// Sequence number for ordering within a stream.
  @$pb.TagNumber(3)
  $fixnum.Int64 get sequence => $_getI64(2);
  @$pb.TagNumber(3)
  set sequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearSequence() => $_clearField(3);

  /// Metadata headers to forward.
  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(3);
}

/// TunnelError reports an error within the tunnel.
class TunnelError extends $pb.GeneratedMessage {
  factory TunnelError({
    TunnelErrorCode? code,
    $core.String? message,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? details,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (details != null) result.details.addEntries(details);
    return result;
  }

  TunnelError._();

  factory TunnelError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<TunnelErrorCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: TunnelErrorCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'details',
        entryClassName: 'TunnelError.DetailsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelError copyWith(void Function(TunnelError) updates) =>
      super.copyWith((message) => updates(message as TunnelError))
          as TunnelError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelError create() => TunnelError._();
  @$core.override
  TunnelError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelError>(create);
  static TunnelError? _defaultInstance;

  @$pb.TagNumber(1)
  TunnelErrorCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(TunnelErrorCode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get details => $_getMap(2);
}

/// TunnelControl carries tunnel management messages.
class TunnelControl extends $pb.GeneratedMessage {
  factory TunnelControl({
    TunnelControlType? controlType,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? params,
  }) {
    final result = create();
    if (controlType != null) result.controlType = controlType;
    if (params != null) result.params.addEntries(params);
    return result;
  }

  TunnelControl._();

  factory TunnelControl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelControl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelControl',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<TunnelControlType>(1, _omitFieldNames ? '' : 'controlType',
        enumValues: TunnelControlType.values)
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'params',
        entryClassName: 'TunnelControl.ParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelControl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelControl copyWith(void Function(TunnelControl) updates) =>
      super.copyWith((message) => updates(message as TunnelControl))
          as TunnelControl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelControl create() => TunnelControl._();
  @$core.override
  TunnelControl createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelControl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelControl>(create);
  static TunnelControl? _defaultInstance;

  @$pb.TagNumber(1)
  TunnelControlType get controlType => $_getN(0);
  @$pb.TagNumber(1)
  set controlType(TunnelControlType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasControlType() => $_has(0);
  @$pb.TagNumber(1)
  void clearControlType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get params => $_getMap(1);
}

/// KeyExchangeRequest is sent by the CLI to initiate a key exchange with a daemon.
class KeyExchangeRequest extends $pb.GeneratedMessage {
  factory KeyExchangeRequest({
    $core.String? machineId,
    $core.List<$core.int>? identityPubkey,
    $core.String? fingerprint,
    $core.List<$core.int>? ephemeralPubkey,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    if (identityPubkey != null) result.identityPubkey = identityPubkey;
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (ephemeralPubkey != null) result.ephemeralPubkey = ephemeralPubkey;
    return result;
  }

  KeyExchangeRequest._();

  factory KeyExchangeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KeyExchangeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeyExchangeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'identityPubkey', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'fingerprint')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'ephemeralPubkey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyExchangeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyExchangeRequest copyWith(void Function(KeyExchangeRequest) updates) =>
      super.copyWith((message) => updates(message as KeyExchangeRequest))
          as KeyExchangeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyExchangeRequest create() => KeyExchangeRequest._();
  @$core.override
  KeyExchangeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KeyExchangeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyExchangeRequest>(create);
  static KeyExchangeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get identityPubkey => $_getN(1);
  @$pb.TagNumber(2)
  set identityPubkey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdentityPubkey() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdentityPubkey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fingerprint => $_getSZ(2);
  @$pb.TagNumber(3)
  set fingerprint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFingerprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearFingerprint() => $_clearField(3);

  /// Client's ephemeral X25519 public key for this session.
  @$pb.TagNumber(4)
  $core.List<$core.int> get ephemeralPubkey => $_getN(3);
  @$pb.TagNumber(4)
  set ephemeralPubkey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEphemeralPubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearEphemeralPubkey() => $_clearField(4);
}

/// KeyExchangeResponse carries the daemon's identity info back to the CLI.
class KeyExchangeResponse extends $pb.GeneratedMessage {
  factory KeyExchangeResponse({
    $core.List<$core.int>? daemonIdentityPubkey,
    $core.String? daemonFingerprint,
    $core.List<$core.int>? daemonEphemeralPubkey,
  }) {
    final result = create();
    if (daemonIdentityPubkey != null)
      result.daemonIdentityPubkey = daemonIdentityPubkey;
    if (daemonFingerprint != null) result.daemonFingerprint = daemonFingerprint;
    if (daemonEphemeralPubkey != null)
      result.daemonEphemeralPubkey = daemonEphemeralPubkey;
    return result;
  }

  KeyExchangeResponse._();

  factory KeyExchangeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KeyExchangeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeyExchangeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'daemonIdentityPubkey', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'daemonFingerprint')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'daemonEphemeralPubkey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyExchangeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyExchangeResponse copyWith(void Function(KeyExchangeResponse) updates) =>
      super.copyWith((message) => updates(message as KeyExchangeResponse))
          as KeyExchangeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyExchangeResponse create() => KeyExchangeResponse._();
  @$core.override
  KeyExchangeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KeyExchangeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyExchangeResponse>(create);
  static KeyExchangeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get daemonIdentityPubkey => $_getN(0);
  @$pb.TagNumber(1)
  set daemonIdentityPubkey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDaemonIdentityPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaemonIdentityPubkey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get daemonFingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set daemonFingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDaemonFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearDaemonFingerprint() => $_clearField(2);

  /// Daemon's ephemeral X25519 public key for this session.
  @$pb.TagNumber(3)
  $core.List<$core.int> get daemonEphemeralPubkey => $_getN(2);
  @$pb.TagNumber(3)
  set daemonEphemeralPubkey($core.List<$core.int> value) =>
      $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDaemonEphemeralPubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearDaemonEphemeralPubkey() => $_clearField(3);
}

class TunnelRegisterRequest extends $pb.GeneratedMessage {
  factory TunnelRegisterRequest({
    $core.String? machineId,
    $core.String? machineName,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? capabilities,
    $core.List<$core.int>? identityPubkey,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    if (machineName != null) result.machineName = machineName;
    if (capabilities != null) result.capabilities.addEntries(capabilities);
    if (identityPubkey != null) result.identityPubkey = identityPubkey;
    return result;
  }

  TunnelRegisterRequest._();

  factory TunnelRegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelRegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelRegisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..aOS(2, _omitFieldNames ? '' : 'machineName')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'capabilities',
        entryClassName: 'TunnelRegisterRequest.CapabilitiesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'identityPubkey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelRegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelRegisterRequest copyWith(
          void Function(TunnelRegisterRequest) updates) =>
      super.copyWith((message) => updates(message as TunnelRegisterRequest))
          as TunnelRegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelRegisterRequest create() => TunnelRegisterRequest._();
  @$core.override
  TunnelRegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelRegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelRegisterRequest>(create);
  static TunnelRegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get machineName => $_getSZ(1);
  @$pb.TagNumber(2)
  set machineName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMachineName() => $_has(1);
  @$pb.TagNumber(2)
  void clearMachineName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get capabilities => $_getMap(2);

  /// Daemon's X25519 identity public key (32 bytes) for E2E encryption.
  @$pb.TagNumber(4)
  $core.List<$core.int> get identityPubkey => $_getN(3);
  @$pb.TagNumber(4)
  set identityPubkey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdentityPubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdentityPubkey() => $_clearField(4);
}

class TunnelRegisterResponse extends $pb.GeneratedMessage {
  factory TunnelRegisterResponse({
    $core.bool? accepted,
    $core.String? relayId,
    $fixnum.Int64? heartbeatIntervalSecs,
  }) {
    final result = create();
    if (accepted != null) result.accepted = accepted;
    if (relayId != null) result.relayId = relayId;
    if (heartbeatIntervalSecs != null)
      result.heartbeatIntervalSecs = heartbeatIntervalSecs;
    return result;
  }

  TunnelRegisterResponse._();

  factory TunnelRegisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelRegisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelRegisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'relayId')
    ..aInt64(3, _omitFieldNames ? '' : 'heartbeatIntervalSecs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelRegisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelRegisterResponse copyWith(
          void Function(TunnelRegisterResponse) updates) =>
      super.copyWith((message) => updates(message as TunnelRegisterResponse))
          as TunnelRegisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelRegisterResponse create() => TunnelRegisterResponse._();
  @$core.override
  TunnelRegisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelRegisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelRegisterResponse>(create);
  static TunnelRegisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get relayId => $_getSZ(1);
  @$pb.TagNumber(2)
  set relayId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRelayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get heartbeatIntervalSecs => $_getI64(2);
  @$pb.TagNumber(3)
  set heartbeatIntervalSecs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeartbeatIntervalSecs() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeartbeatIntervalSecs() => $_clearField(3);
}

class TunnelHeartbeat extends $pb.GeneratedMessage {
  factory TunnelHeartbeat({
    $core.String? machineId,
    $1.Timestamp? timestamp,
    $core.int? activeSessions,
    $core.double? cpuUsagePercent,
    $core.double? memoryUsagePercent,
  }) {
    final result = create();
    if (machineId != null) result.machineId = machineId;
    if (timestamp != null) result.timestamp = timestamp;
    if (activeSessions != null) result.activeSessions = activeSessions;
    if (cpuUsagePercent != null) result.cpuUsagePercent = cpuUsagePercent;
    if (memoryUsagePercent != null)
      result.memoryUsagePercent = memoryUsagePercent;
    return result;
  }

  TunnelHeartbeat._();

  factory TunnelHeartbeat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TunnelHeartbeat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TunnelHeartbeat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machineId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'activeSessions',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(4, _omitFieldNames ? '' : 'cpuUsagePercent',
        fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'memoryUsagePercent',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelHeartbeat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TunnelHeartbeat copyWith(void Function(TunnelHeartbeat) updates) =>
      super.copyWith((message) => updates(message as TunnelHeartbeat))
          as TunnelHeartbeat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TunnelHeartbeat create() => TunnelHeartbeat._();
  @$core.override
  TunnelHeartbeat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TunnelHeartbeat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TunnelHeartbeat>(create);
  static TunnelHeartbeat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set machineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get activeSessions => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeSessions($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveSessions() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveSessions() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cpuUsagePercent => $_getN(3);
  @$pb.TagNumber(4)
  set cpuUsagePercent($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCpuUsagePercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearCpuUsagePercent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get memoryUsagePercent => $_getN(4);
  @$pb.TagNumber(5)
  set memoryUsagePercent($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMemoryUsagePercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearMemoryUsagePercent() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
