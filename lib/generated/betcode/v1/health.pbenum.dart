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

class ServingStatus extends $pb.ProtobufEnum {
  static const ServingStatus UNKNOWN =
      ServingStatus._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const ServingStatus SERVING =
      ServingStatus._(1, _omitEnumNames ? '' : 'SERVING');
  static const ServingStatus NOT_SERVING =
      ServingStatus._(2, _omitEnumNames ? '' : 'NOT_SERVING');
  static const ServingStatus SERVICE_UNKNOWN =
      ServingStatus._(3, _omitEnumNames ? '' : 'SERVICE_UNKNOWN');

  static const $core.List<ServingStatus> values = <ServingStatus>[
    UNKNOWN,
    SERVING,
    NOT_SERVING,
    SERVICE_UNKNOWN,
  ];

  static final $core.List<ServingStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ServingStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ServingStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
