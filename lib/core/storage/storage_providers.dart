import 'package:betcode_app/core/storage/database.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:drift/backends.dart' show QueryExecutor;
import 'package:drift/drift.dart' show QueryExecutor;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
