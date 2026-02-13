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

import 'package:protobuf/protobuf.dart' as $pb;

/// FrameType identifies the purpose of a tunnel frame.
class FrameType extends $pb.ProtobufEnum {
  static const FrameType FRAME_TYPE_UNSPECIFIED =
      FrameType._(0, _omitEnumNames ? '' : 'FRAME_TYPE_UNSPECIFIED');

  /// Request from relay to daemon (wraps a client gRPC call).
  static const FrameType FRAME_TYPE_REQUEST =
      FrameType._(1, _omitEnumNames ? '' : 'FRAME_TYPE_REQUEST');

  /// Response from daemon to relay (wraps a gRPC response).
  static const FrameType FRAME_TYPE_RESPONSE =
      FrameType._(2, _omitEnumNames ? '' : 'FRAME_TYPE_RESPONSE');

  /// Streaming data chunk (for bidi-streaming proxied calls).
  static const FrameType FRAME_TYPE_STREAM_DATA =
      FrameType._(3, _omitEnumNames ? '' : 'FRAME_TYPE_STREAM_DATA');

  /// End of stream marker.
  static const FrameType FRAME_TYPE_STREAM_END =
      FrameType._(4, _omitEnumNames ? '' : 'FRAME_TYPE_STREAM_END');

  /// Error frame.
  static const FrameType FRAME_TYPE_ERROR =
      FrameType._(5, _omitEnumNames ? '' : 'FRAME_TYPE_ERROR');

  /// Control frame (tunnel management).
  static const FrameType FRAME_TYPE_CONTROL =
      FrameType._(6, _omitEnumNames ? '' : 'FRAME_TYPE_CONTROL');

  static const $core.List<FrameType> values = <FrameType>[
    FRAME_TYPE_UNSPECIFIED,
    FRAME_TYPE_REQUEST,
    FRAME_TYPE_RESPONSE,
    FRAME_TYPE_STREAM_DATA,
    FRAME_TYPE_STREAM_END,
    FRAME_TYPE_ERROR,
    FRAME_TYPE_CONTROL,
  ];

  static final $core.List<FrameType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static FrameType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FrameType._(super.value, super.name);
}

/// TunnelErrorCode categorizes tunnel errors.
class TunnelErrorCode extends $pb.ProtobufEnum {
  static const TunnelErrorCode TUNNEL_ERROR_CODE_UNSPECIFIED =
      TunnelErrorCode._(
          0, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_UNSPECIFIED');
  static const TunnelErrorCode TUNNEL_ERROR_CODE_INTERNAL =
      TunnelErrorCode._(1, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_INTERNAL');
  static const TunnelErrorCode TUNNEL_ERROR_CODE_TIMEOUT =
      TunnelErrorCode._(2, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_TIMEOUT');
  static const TunnelErrorCode TUNNEL_ERROR_CODE_NOT_FOUND =
      TunnelErrorCode._(3, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_NOT_FOUND');
  static const TunnelErrorCode TUNNEL_ERROR_CODE_UNAUTHORIZED =
      TunnelErrorCode._(
          4, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_UNAUTHORIZED');
  static const TunnelErrorCode TUNNEL_ERROR_CODE_UNAVAILABLE =
      TunnelErrorCode._(
          5, _omitEnumNames ? '' : 'TUNNEL_ERROR_CODE_UNAVAILABLE');

  static const $core.List<TunnelErrorCode> values = <TunnelErrorCode>[
    TUNNEL_ERROR_CODE_UNSPECIFIED,
    TUNNEL_ERROR_CODE_INTERNAL,
    TUNNEL_ERROR_CODE_TIMEOUT,
    TUNNEL_ERROR_CODE_NOT_FOUND,
    TUNNEL_ERROR_CODE_UNAUTHORIZED,
    TUNNEL_ERROR_CODE_UNAVAILABLE,
  ];

  static final $core.List<TunnelErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TunnelErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TunnelErrorCode._(super.value, super.name);
}

/// TunnelControlType identifies tunnel control operations.
class TunnelControlType extends $pb.ProtobufEnum {
  static const TunnelControlType TUNNEL_CONTROL_TYPE_UNSPECIFIED =
      TunnelControlType._(
          0, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_UNSPECIFIED');

  /// Sent by relay to request tunnel drain (graceful shutdown).
  static const TunnelControlType TUNNEL_CONTROL_TYPE_DRAIN =
      TunnelControlType._(1, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_DRAIN');

  /// Sent by daemon to acknowledge drain.
  static const TunnelControlType TUNNEL_CONTROL_TYPE_DRAIN_ACK =
      TunnelControlType._(
          2, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_DRAIN_ACK');

  /// Ping/pong for tunnel-level keepalive.
  static const TunnelControlType TUNNEL_CONTROL_TYPE_PING =
      TunnelControlType._(3, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_PING');
  static const TunnelControlType TUNNEL_CONTROL_TYPE_PONG =
      TunnelControlType._(4, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_PONG');

  /// E2E key exchange: carries ephemeral public keys for session key derivation.
  static const TunnelControlType TUNNEL_CONTROL_TYPE_KEY_EXCHANGE =
      TunnelControlType._(
          10, _omitEnumNames ? '' : 'TUNNEL_CONTROL_TYPE_KEY_EXCHANGE');

  static const $core.List<TunnelControlType> values = <TunnelControlType>[
    TUNNEL_CONTROL_TYPE_UNSPECIFIED,
    TUNNEL_CONTROL_TYPE_DRAIN,
    TUNNEL_CONTROL_TYPE_DRAIN_ACK,
    TUNNEL_CONTROL_TYPE_PING,
    TUNNEL_CONTROL_TYPE_PONG,
    TUNNEL_CONTROL_TYPE_KEY_EXCHANGE,
  ];

  static final $core.Map<$core.int, TunnelControlType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static TunnelControlType? valueOf($core.int value) => _byValue[value];

  const TunnelControlType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
