import 'package:betcode_app/features/conversation/notifiers/input_lock_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current [InputLockResponse] state, or null if no lock has
/// been requested yet.
final inputLockProvider =
    NotifierProvider<InputLockNotifier, InputLockResponse?>(
      InputLockNotifier.new,
    );
