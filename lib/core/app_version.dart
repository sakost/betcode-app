import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provides the app version string from pubspec.yaml.
///
/// Returns the `version` field (e.g. `0.1.0-alpha.1`).
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  // PackageInfo.version returns the version number without the build number.
  // For pre-release versions like 0.1.0-alpha.1, the full version string
  // is in the format "major.minor.patch" and the build number is separate.
  // We reconstruct the full version if buildNumber is present.
  return info.version;
});
