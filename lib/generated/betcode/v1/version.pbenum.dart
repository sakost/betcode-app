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

class CompatibilityLevel extends $pb.ProtobufEnum {
  static const CompatibilityLevel COMPATIBILITY_UNKNOWN =
      CompatibilityLevel._(0, _omitEnumNames ? '' : 'COMPATIBILITY_UNKNOWN');
  static const CompatibilityLevel FULLY_COMPATIBLE =
      CompatibilityLevel._(1, _omitEnumNames ? '' : 'FULLY_COMPATIBLE');
  static const CompatibilityLevel LIKELY_COMPATIBLE =
      CompatibilityLevel._(2, _omitEnumNames ? '' : 'LIKELY_COMPATIBLE');
  static const CompatibilityLevel DEGRADED =
      CompatibilityLevel._(3, _omitEnumNames ? '' : 'DEGRADED');
  static const CompatibilityLevel INCOMPATIBLE =
      CompatibilityLevel._(4, _omitEnumNames ? '' : 'INCOMPATIBLE');

  static const $core.List<CompatibilityLevel> values = <CompatibilityLevel>[
    COMPATIBILITY_UNKNOWN,
    FULLY_COMPATIBLE,
    LIKELY_COMPATIBLE,
    DEGRADED,
    INCOMPATIBLE,
  ];

  static final $core.List<CompatibilityLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CompatibilityLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CompatibilityLevel._(super.value, super.name);
}

class FeatureStage extends $pb.ProtobufEnum {
  static const FeatureStage FEATURE_STAGE_UNKNOWN =
      FeatureStage._(0, _omitEnumNames ? '' : 'FEATURE_STAGE_UNKNOWN');
  static const FeatureStage ALPHA =
      FeatureStage._(1, _omitEnumNames ? '' : 'ALPHA');
  static const FeatureStage BETA =
      FeatureStage._(2, _omitEnumNames ? '' : 'BETA');
  static const FeatureStage STABLE =
      FeatureStage._(3, _omitEnumNames ? '' : 'STABLE');
  static const FeatureStage DEPRECATED =
      FeatureStage._(4, _omitEnumNames ? '' : 'DEPRECATED');
  static const FeatureStage REMOVED =
      FeatureStage._(5, _omitEnumNames ? '' : 'REMOVED');

  static const $core.List<FeatureStage> values = <FeatureStage>[
    FEATURE_STAGE_UNKNOWN,
    ALPHA,
    BETA,
    STABLE,
    DEPRECATED,
    REMOVED,
  ];

  static final $core.List<FeatureStage?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FeatureStage? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FeatureStage._(super.value, super.name);
}

class Severity extends $pb.ProtobufEnum {
  static const Severity SEVERITY_UNKNOWN =
      Severity._(0, _omitEnumNames ? '' : 'SEVERITY_UNKNOWN');
  static const Severity INFO = Severity._(1, _omitEnumNames ? '' : 'INFO');
  static const Severity WARNING =
      Severity._(2, _omitEnumNames ? '' : 'WARNING');
  static const Severity URGENT = Severity._(3, _omitEnumNames ? '' : 'URGENT');

  static const $core.List<Severity> values = <Severity>[
    SEVERITY_UNKNOWN,
    INFO,
    WARNING,
    URGENT,
  ];

  static final $core.List<Severity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Severity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Severity._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
