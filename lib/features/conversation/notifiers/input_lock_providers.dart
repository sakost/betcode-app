import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/agent.pb.dart';
import 'input_lock_notifier.dart';

/// Provides the current [InputLockResponse] state, or null if no lock has
/// been requested yet.
final inputLockProvider =
    NotifierProvider<InputLockNotifier, InputLockResponse?>(
      InputLockNotifier.new,
    );
