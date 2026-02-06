// This is a generated file - do not edit.
//
// Generated from betcode/v1/version.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use compatibilityLevelDescriptor instead')
const CompatibilityLevel$json = {
  '1': 'CompatibilityLevel',
  '2': [
    {'1': 'COMPATIBILITY_UNKNOWN', '2': 0},
    {'1': 'FULLY_COMPATIBLE', '2': 1},
    {'1': 'LIKELY_COMPATIBLE', '2': 2},
    {'1': 'DEGRADED', '2': 3},
    {'1': 'INCOMPATIBLE', '2': 4},
  ],
};

/// Descriptor for `CompatibilityLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List compatibilityLevelDescriptor = $convert.base64Decode(
    'ChJDb21wYXRpYmlsaXR5TGV2ZWwSGQoVQ09NUEFUSUJJTElUWV9VTktOT1dOEAASFAoQRlVMTF'
    'lfQ09NUEFUSUJMRRABEhUKEUxJS0VMWV9DT01QQVRJQkxFEAISDAoIREVHUkFERUQQAxIQCgxJ'
    'TkNPTVBBVElCTEUQBA==');

@$core.Deprecated('Use featureStageDescriptor instead')
const FeatureStage$json = {
  '1': 'FeatureStage',
  '2': [
    {'1': 'FEATURE_STAGE_UNKNOWN', '2': 0},
    {'1': 'ALPHA', '2': 1},
    {'1': 'BETA', '2': 2},
    {'1': 'STABLE', '2': 3},
    {'1': 'DEPRECATED', '2': 4},
    {'1': 'REMOVED', '2': 5},
  ],
};

/// Descriptor for `FeatureStage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List featureStageDescriptor = $convert.base64Decode(
    'CgxGZWF0dXJlU3RhZ2USGQoVRkVBVFVSRV9TVEFHRV9VTktOT1dOEAASCQoFQUxQSEEQARIICg'
    'RCRVRBEAISCgoGU1RBQkxFEAMSDgoKREVQUkVDQVRFRBAEEgsKB1JFTU9WRUQQBQ==');

@$core.Deprecated('Use severityDescriptor instead')
const Severity$json = {
  '1': 'Severity',
  '2': [
    {'1': 'SEVERITY_UNKNOWN', '2': 0},
    {'1': 'INFO', '2': 1},
    {'1': 'WARNING', '2': 2},
    {'1': 'URGENT', '2': 3},
  ],
};

/// Descriptor for `Severity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List severityDescriptor = $convert.base64Decode(
    'CghTZXZlcml0eRIUChBTRVZFUklUWV9VTktOT1dOEAASCAoESU5GTxABEgsKB1dBUk5JTkcQAh'
    'IKCgZVUkdFTlQQAw==');

@$core.Deprecated('Use getVersionRequestDescriptor instead')
const GetVersionRequest$json = {
  '1': 'GetVersionRequest',
};

/// Descriptor for `GetVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVersionRequestDescriptor =
    $convert.base64Decode('ChFHZXRWZXJzaW9uUmVxdWVzdA==');

@$core.Deprecated('Use getVersionResponseDescriptor instead')
const GetVersionResponse$json = {
  '1': 'GetVersionResponse',
  '2': [
    {'1': 'api_version', '3': 1, '4': 1, '5': 9, '10': 'apiVersion'},
    {'1': 'server_version', '3': 2, '4': 1, '5': 9, '10': 'serverVersion'},
    {'1': 'features', '3': 3, '4': 3, '5': 9, '10': 'features'},
    {
      '1': 'claude_code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.ClaudeCodeInfo',
      '10': 'claudeCode'
    },
    {
      '1': 'constraints',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.VersionConstraints',
      '10': 'constraints'
    },
  ],
};

/// Descriptor for `GetVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVersionResponseDescriptor = $convert.base64Decode(
    'ChJHZXRWZXJzaW9uUmVzcG9uc2USHwoLYXBpX3ZlcnNpb24YASABKAlSCmFwaVZlcnNpb24SJQ'
    'oOc2VydmVyX3ZlcnNpb24YAiABKAlSDXNlcnZlclZlcnNpb24SGgoIZmVhdHVyZXMYAyADKAlS'
    'CGZlYXR1cmVzEjsKC2NsYXVkZV9jb2RlGAQgASgLMhouYmV0Y29kZS52MS5DbGF1ZGVDb2RlSW'
    '5mb1IKY2xhdWRlQ29kZRJACgtjb25zdHJhaW50cxgFIAEoCzIeLmJldGNvZGUudjEuVmVyc2lv'
    'bkNvbnN0cmFpbnRzUgtjb25zdHJhaW50cw==');

@$core.Deprecated('Use claudeCodeInfoDescriptor instead')
const ClaudeCodeInfo$json = {
  '1': 'ClaudeCodeInfo',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'api_version', '3': 2, '4': 1, '5': 9, '10': 'apiVersion'},
    {
      '1': 'compatibility',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.CompatibilityLevel',
      '10': 'compatibility'
    },
  ],
};

/// Descriptor for `ClaudeCodeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claudeCodeInfoDescriptor = $convert.base64Decode(
    'Cg5DbGF1ZGVDb2RlSW5mbxIYCgd2ZXJzaW9uGAEgASgJUgd2ZXJzaW9uEh8KC2FwaV92ZXJzaW'
    '9uGAIgASgJUgphcGlWZXJzaW9uEkQKDWNvbXBhdGliaWxpdHkYAyABKA4yHi5iZXRjb2RlLnYx'
    'LkNvbXBhdGliaWxpdHlMZXZlbFINY29tcGF0aWJpbGl0eQ==');

@$core.Deprecated('Use versionConstraintsDescriptor instead')
const VersionConstraints$json = {
  '1': 'VersionConstraints',
  '2': [
    {
      '1': 'min_client_version',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'minClientVersion'
    },
    {
      '1': 'recommended_client',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'recommendedClient'
    },
    {
      '1': 'deprecated_features',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'deprecatedFeatures'
    },
    {
      '1': 'feature_replacements',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.VersionConstraints.FeatureReplacementsEntry',
      '10': 'featureReplacements'
    },
  ],
  '3': [VersionConstraints_FeatureReplacementsEntry$json],
};

@$core.Deprecated('Use versionConstraintsDescriptor instead')
const VersionConstraints_FeatureReplacementsEntry$json = {
  '1': 'FeatureReplacementsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `VersionConstraints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List versionConstraintsDescriptor = $convert.base64Decode(
    'ChJWZXJzaW9uQ29uc3RyYWludHMSLAoSbWluX2NsaWVudF92ZXJzaW9uGAEgASgJUhBtaW5DbG'
    'llbnRWZXJzaW9uEi0KEnJlY29tbWVuZGVkX2NsaWVudBgCIAEoCVIRcmVjb21tZW5kZWRDbGll'
    'bnQSLwoTZGVwcmVjYXRlZF9mZWF0dXJlcxgDIAMoCVISZGVwcmVjYXRlZEZlYXR1cmVzEmoKFG'
    'ZlYXR1cmVfcmVwbGFjZW1lbnRzGAQgAygLMjcuYmV0Y29kZS52MS5WZXJzaW9uQ29uc3RyYWlu'
    'dHMuRmVhdHVyZVJlcGxhY2VtZW50c0VudHJ5UhNmZWF0dXJlUmVwbGFjZW1lbnRzGkYKGEZlYX'
    'R1cmVSZXBsYWNlbWVudHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIF'
    'dmFsdWU6AjgB');

@$core.Deprecated('Use negotiateRequestDescriptor instead')
const NegotiateRequest$json = {
  '1': 'NegotiateRequest',
  '2': [
    {'1': 'client_version', '3': 1, '4': 1, '5': 9, '10': 'clientVersion'},
    {'1': 'client_type', '3': 2, '4': 1, '5': 9, '10': 'clientType'},
    {
      '1': 'requested_features',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'requestedFeatures'
    },
    {
      '1': 'client_capabilities',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.NegotiateRequest.ClientCapabilitiesEntry',
      '10': 'clientCapabilities'
    },
  ],
  '3': [NegotiateRequest_ClientCapabilitiesEntry$json],
};

@$core.Deprecated('Use negotiateRequestDescriptor instead')
const NegotiateRequest_ClientCapabilitiesEntry$json = {
  '1': 'ClientCapabilitiesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `NegotiateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateRequestDescriptor = $convert.base64Decode(
    'ChBOZWdvdGlhdGVSZXF1ZXN0EiUKDmNsaWVudF92ZXJzaW9uGAEgASgJUg1jbGllbnRWZXJzaW'
    '9uEh8KC2NsaWVudF90eXBlGAIgASgJUgpjbGllbnRUeXBlEi0KEnJlcXVlc3RlZF9mZWF0dXJl'
    'cxgDIAMoCVIRcmVxdWVzdGVkRmVhdHVyZXMSZQoTY2xpZW50X2NhcGFiaWxpdGllcxgEIAMoCz'
    'I0LmJldGNvZGUudjEuTmVnb3RpYXRlUmVxdWVzdC5DbGllbnRDYXBhYmlsaXRpZXNFbnRyeVIS'
    'Y2xpZW50Q2FwYWJpbGl0aWVzGkUKF0NsaWVudENhcGFiaWxpdGllc0VudHJ5EhAKA2tleRgBIA'
    'EoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use negotiateResponseDescriptor instead')
const NegotiateResponse$json = {
  '1': 'NegotiateResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'rejection_reason', '3': 2, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'upgrade_url', '3': 3, '4': 1, '5': 9, '10': 'upgradeUrl'},
    {'1': 'granted_features', '3': 4, '4': 3, '5': 9, '10': 'grantedFeatures'},
    {'1': 'warnings', '3': 5, '4': 3, '5': 9, '10': 'warnings'},
    {
      '1': 'capabilities',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.betcode.v1.CapabilitySet',
      '10': 'capabilities'
    },
  ],
};

/// Descriptor for `NegotiateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateResponseDescriptor = $convert.base64Decode(
    'ChFOZWdvdGlhdGVSZXNwb25zZRIaCghhY2NlcHRlZBgBIAEoCFIIYWNjZXB0ZWQSKQoQcmVqZW'
    'N0aW9uX3JlYXNvbhgCIAEoCVIPcmVqZWN0aW9uUmVhc29uEh8KC3VwZ3JhZGVfdXJsGAMgASgJ'
    'Ugp1cGdyYWRlVXJsEikKEGdyYW50ZWRfZmVhdHVyZXMYBCADKAlSD2dyYW50ZWRGZWF0dXJlcx'
    'IaCgh3YXJuaW5ncxgFIAMoCVIId2FybmluZ3MSPQoMY2FwYWJpbGl0aWVzGAYgASgLMhkuYmV0'
    'Y29kZS52MS5DYXBhYmlsaXR5U2V0UgxjYXBhYmlsaXRpZXM=');

@$core.Deprecated('Use capabilitySetDescriptor instead')
const CapabilitySet$json = {
  '1': 'CapabilitySet',
  '2': [
    {
      '1': 'streaming_supported',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'streamingSupported'
    },
    {
      '1': 'compression_supported',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'compressionSupported'
    },
    {'1': 'max_message_size', '3': 3, '4': 1, '5': 13, '10': 'maxMessageSize'},
    {'1': 'available_tools', '3': 4, '4': 3, '5': 9, '10': 'availableTools'},
    {'1': 'available_models', '3': 5, '4': 3, '5': 9, '10': 'availableModels'},
    {
      '1': 'subagents_enabled',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'subagentsEnabled'
    },
    {
      '1': 'worktrees_enabled',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'worktreesEnabled'
    },
    {
      '1': 'feature_flags',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.betcode.v1.CapabilitySet.FeatureFlagsEntry',
      '10': 'featureFlags'
    },
  ],
  '3': [CapabilitySet_FeatureFlagsEntry$json],
};

@$core.Deprecated('Use capabilitySetDescriptor instead')
const CapabilitySet_FeatureFlagsEntry$json = {
  '1': 'FeatureFlagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CapabilitySet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capabilitySetDescriptor = $convert.base64Decode(
    'Cg1DYXBhYmlsaXR5U2V0Ei8KE3N0cmVhbWluZ19zdXBwb3J0ZWQYASABKAhSEnN0cmVhbWluZ1'
    'N1cHBvcnRlZBIzChVjb21wcmVzc2lvbl9zdXBwb3J0ZWQYAiABKAhSFGNvbXByZXNzaW9uU3Vw'
    'cG9ydGVkEigKEG1heF9tZXNzYWdlX3NpemUYAyABKA1SDm1heE1lc3NhZ2VTaXplEicKD2F2YW'
    'lsYWJsZV90b29scxgEIAMoCVIOYXZhaWxhYmxlVG9vbHMSKQoQYXZhaWxhYmxlX21vZGVscxgF'
    'IAMoCVIPYXZhaWxhYmxlTW9kZWxzEisKEXN1YmFnZW50c19lbmFibGVkGAYgASgIUhBzdWJhZ2'
    'VudHNFbmFibGVkEisKEXdvcmt0cmVlc19lbmFibGVkGAcgASgIUhB3b3JrdHJlZXNFbmFibGVk'
    'ElAKDWZlYXR1cmVfZmxhZ3MYCCADKAsyKy5iZXRjb2RlLnYxLkNhcGFiaWxpdHlTZXQuRmVhdH'
    'VyZUZsYWdzRW50cnlSDGZlYXR1cmVGbGFncxo/ChFGZWF0dXJlRmxhZ3NFbnRyeRIQCgNrZXkY'
    'ASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCFIFdmFsdWU6AjgB');

@$core.Deprecated('Use featureFlagDescriptor instead')
const FeatureFlag$json = {
  '1': 'FeatureFlag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'stage',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.FeatureStage',
      '10': 'stage'
    },
    {
      '1': 'introduced_version',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'introducedVersion'
    },
    {
      '1': 'min_client_version',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'minClientVersion'
    },
    {
      '1': 'deprecated_version',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'deprecatedVersion'
    },
    {'1': 'removal_version', '3': 7, '4': 1, '5': 9, '10': 'removalVersion'},
  ],
};

/// Descriptor for `FeatureFlag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureFlagDescriptor = $convert.base64Decode(
    'CgtGZWF0dXJlRmxhZxISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAIgASgJUg'
    'tkZXNjcmlwdGlvbhIuCgVzdGFnZRgDIAEoDjIYLmJldGNvZGUudjEuRmVhdHVyZVN0YWdlUgVz'
    'dGFnZRItChJpbnRyb2R1Y2VkX3ZlcnNpb24YBCABKAlSEWludHJvZHVjZWRWZXJzaW9uEiwKEm'
    '1pbl9jbGllbnRfdmVyc2lvbhgFIAEoCVIQbWluQ2xpZW50VmVyc2lvbhItChJkZXByZWNhdGVk'
    'X3ZlcnNpb24YBiABKAlSEWRlcHJlY2F0ZWRWZXJzaW9uEicKD3JlbW92YWxfdmVyc2lvbhgHIA'
    'EoCVIOcmVtb3ZhbFZlcnNpb24=');

@$core.Deprecated('Use deprecationWarningDescriptor instead')
const DeprecationWarning$json = {
  '1': 'DeprecationWarning',
  '2': [
    {'1': 'feature', '3': 1, '4': 1, '5': 9, '10': 'feature'},
    {'1': 'replacement', '3': 2, '4': 1, '5': 9, '10': 'replacement'},
    {'1': 'removal_version', '3': 3, '4': 1, '5': 9, '10': 'removalVersion'},
    {'1': 'migration_url', '3': 4, '4': 1, '5': 9, '10': 'migrationUrl'},
    {
      '1': 'severity',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.betcode.v1.Severity',
      '10': 'severity'
    },
  ],
};

/// Descriptor for `DeprecationWarning`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deprecationWarningDescriptor = $convert.base64Decode(
    'ChJEZXByZWNhdGlvbldhcm5pbmcSGAoHZmVhdHVyZRgBIAEoCVIHZmVhdHVyZRIgCgtyZXBsYW'
    'NlbWVudBgCIAEoCVILcmVwbGFjZW1lbnQSJwoPcmVtb3ZhbF92ZXJzaW9uGAMgASgJUg5yZW1v'
    'dmFsVmVyc2lvbhIjCg1taWdyYXRpb25fdXJsGAQgASgJUgxtaWdyYXRpb25VcmwSMAoIc2V2ZX'
    'JpdHkYBSABKA4yFC5iZXRjb2RlLnYxLlNldmVyaXR5UghzZXZlcml0eQ==');
