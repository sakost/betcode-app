import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages input lock requests for a conversation session.
///
/// The input lock prevents multiple clients from sending messages to the same
/// session simultaneously. The daemon grants exclusive access to one client
/// at a time.
class InputLockNotifier extends Notifier<InputLockResponse?> {
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  InputLockResponse? build() => null;

  /// Requests exclusive input lock for a session.
  ///
  /// Updates [state] with the response so widgets can react to the lock
  /// status. Returns the response for callers that need the result
  /// immediately.
  Future<InputLockResponse> requestInputLock(String sessionId) async {
    final client = ref.read(agentServiceProvider);
    final response = await client
        .requestInputLock(InputLockRequest(sessionId: sessionId))
        .timeout(_mutationTimeout);
    state = response;
    return response;
  }
}
