import 'dart:async';

import 'package:grpc/grpc.dart';

import '../../generated/betcode/v1/agent.pbgrpc.dart';
import '../../generated/betcode/v1/worktree.pbgrpc.dart';
import '../storage/database.dart';

/// Routes sync queue items to the appropriate gRPC service based on
/// [SyncQueueData.requestType].
///
/// Each dispatch deserializes the protobuf payload and sends it via the
/// correct service client. An idempotency key is included in gRPC metadata
/// so the server can safely deduplicate replayed requests.
class SyncDispatcher {
  SyncDispatcher({
    required AgentServiceClient agentClient,
    required WorktreeServiceClient worktreeClient,
  }) : _agentClient = agentClient,
       _worktreeClient = worktreeClient;

  final AgentServiceClient _agentClient;
  final WorktreeServiceClient _worktreeClient;

  /// Dispatch a queued item to the appropriate gRPC service.
  ///
  /// Throws [ArgumentError] if [item.requestType] is not recognized.
  Future<void> dispatch(SyncQueueData item) async {
    final options = CallOptions(
      metadata: {'x-idempotency-key': item.idempotencyKey},
    );

    switch (item.requestType) {
      case 'user_message':
        await _dispatchAgentRequest(
          AgentRequest(message: UserMessage.fromBuffer(item.payload)),
          options,
        );
      case 'permission_response':
        await _dispatchAgentRequest(
          AgentRequest(permission: PermissionResponse.fromBuffer(item.payload)),
          options,
        );
      case 'question_response':
        await _dispatchAgentRequest(
          AgentRequest(
            questionResponse: UserQuestionResponse.fromBuffer(item.payload),
          ),
          options,
        );
      case 'cancel_request':
        await _dispatchAgentRequest(
          AgentRequest(cancel: CancelRequest.fromBuffer(item.payload)),
          options,
        );
      case 'create_worktree':
        await _worktreeClient.createWorktree(
          CreateWorktreeRequest.fromBuffer(item.payload),
          options: options,
        );
      case 'delete_worktree':
        await _worktreeClient.removeWorktree(
          RemoveWorktreeRequest.fromBuffer(item.payload),
          options: options,
        );
      default:
        throw ArgumentError.value(
          item.requestType,
          'requestType',
          'Unknown sync queue request type',
        );
    }
  }

  /// Send a single [AgentRequest] via a short-lived converse stream.
  ///
  /// Creates a stream with the single request, sends it to the server,
  /// and cancels the response stream immediately since the sync queue
  /// only cares about delivering the request, not processing the
  /// conversation response (that is handled by the conversation notifier).
  Future<void> _dispatchAgentRequest(
    AgentRequest request,
    CallOptions options,
  ) async {
    final controller = StreamController<AgentRequest>();
    controller.add(request);
    // Don't await close() — it waits for a listener to consume the done event,
    // but the stream hasn't been subscribed to yet at this point.
    unawaited(controller.close());

    final responseStream = _agentClient.converse(
      controller.stream,
      options: options,
    );

    // We don't need the response for sync dispatch — just ensure the request
    // is delivered. Cancel to release the stream resources.
    await responseStream.cancel();
  }
}
