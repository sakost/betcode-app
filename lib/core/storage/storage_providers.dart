import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'secure_storage.dart';

/// Provides the single [AppDatabase] instance for the lifetime of the app.
///
/// Override this in tests with a custom [QueryExecutor] if needed.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => AppDatabase.defaults(),
);

/// Provides the [SecureStorageService] for JWT token management.
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);
