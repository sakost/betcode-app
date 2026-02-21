import 'dart:async';

import 'package:betcode_app/core/auth/auth_notifier.dart';
import 'package:betcode_app/core/auth/auth_state.dart';
import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/relay_notifier.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/core/router.dart';
import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_notifier.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/features/machines/notifiers/selected_machine_notifier.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/features/worktrees/notifiers/worktrees_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pb.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart' show Override;

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

class MockWorktreeServiceClient extends Mock implements WorktreeServiceClient {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

// ---------------------------------------------------------------------------
// Fake response stream
// ---------------------------------------------------------------------------

/// Wraps a [StreamController] as a [ResponseStream] for server-streaming
/// and bidi-stream RPC tests.
class FakeResponseStream<T> extends Fake implements ResponseStream<T> {
  FakeResponseStream(this.controller);

  final StreamController<T> controller;

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

// ---------------------------------------------------------------------------
// Test notifiers (reuse pattern from pump_helpers.dart)
// ---------------------------------------------------------------------------

class TestAuthenticatedNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState.authenticated(
      accessToken: 'tok',
      refreshToken: 'ref',
      userId: 'u1',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

class TestConnectedRelayNotifier extends RelayConfigNotifier {
  @override
  RelayConfig? build() {
    return const RelayConfig(host: 'test-relay', port: 443);
  }
}

class _FixedMachineNotifier extends SelectedMachineNotifier {
  _FixedMachineNotifier(this._value);
  final String? _value;
  @override
  String? build() => _value;
}

// ---------------------------------------------------------------------------
// Test data factories
// ---------------------------------------------------------------------------

MachineInfo makeTestMachine({
  String machineId = 'test-machine',
  String name = 'Test Machine',
}) {
  return MachineInfo(machineId: machineId, name: name);
}

WorktreeDetail makeTestWorktree({
  String id = 'wt-1',
  String name = 'main',
  String path = '/home/test/project',
}) {
  return WorktreeDetail(id: id, name: name, path: path);
}

pb.SessionSummary makeTestSession({
  String id = 'sess-1',
  String name = '',
  String model = 'opus',
  String status = 'idle',
  int messageCount = 5,
  double totalCostUsd = 0.0123,
  String lastMessagePreview = 'Hello world',
}) {
  return pb.SessionSummary(
    id: id,
    name: name,
    model: model,
    status: status,
    messageCount: messageCount,
    totalCostUsd: totalCostUsd,
    lastMessagePreview: lastMessagePreview,
  );
}

// ---------------------------------------------------------------------------
// App builder
// ---------------------------------------------------------------------------

/// Builds a fully-routed, authenticated integration test app.
///
/// Overrides auth, connection, machine, worktree, and gRPC service providers
/// so the router treats the user as logged in and the conversation screen
/// can render without hitting real gRPC.
Widget buildIntegrationApp({
  required MockAgentServiceClient mockAgentClient,
  MockSecureStorageService? mockStorage,
  MockWorktreeServiceClient? mockWorktreeClient,
  String? initialLocation,
  List<Override> overrides = const [],
}) {
  mockStorage ??= MockSecureStorageService();

  return ProviderScope(
    overrides: [
      // Auth & relay
      secureStorageProvider.overrideWithValue(mockStorage),
      authNotifierProvider.overrideWith(TestAuthenticatedNotifier.new),
      relayConfigNotifierProvider.overrideWith(TestConnectedRelayNotifier.new),

      // Connection status
      connectionStatusProvider.overrideWithValue(
        const AsyncData(GrpcConnectionStatus.connected),
      ),

      // Machine
      selectedMachineIdProvider.overrideWith(
        () => _FixedMachineNotifier('test-machine'),
      ),
      machinesProvider.overrideWith(
        () => FakeMachinesNotifier([makeTestMachine()]),
      ),

      // Worktrees
      worktreesProvider.overrideWith(
        () => FakeWorktreesNotifier([makeTestWorktree()]),
      ),

      // gRPC clients
      agentServiceProvider.overrideWithValue(mockAgentClient),
      if (mockWorktreeClient != null)
        worktreeServiceProvider.overrideWithValue(mockWorktreeClient),

      // Extra overrides
      ...overrides,
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        if (initialLocation != null) {
          router.go(initialLocation);
        }
        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.lightTheme,
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// Fixed notifiers for overrides
// ---------------------------------------------------------------------------

/// A fake [MachinesNotifier] that returns canned data without gRPC calls.
class FakeMachinesNotifier extends MachinesNotifier {
  FakeMachinesNotifier(this._machines);
  final List<MachineInfo> _machines;

  @override
  Future<List<MachineInfo>> build() async => _machines;
}

/// A fake [WorktreesNotifier] that returns canned data without gRPC calls.
class FakeWorktreesNotifier extends WorktreesNotifier {
  FakeWorktreesNotifier(this._worktrees);
  final List<WorktreeDetail> _worktrees;

  @override
  Future<List<WorktreeDetail>> build() async => _worktrees;
}

/// A fake [SessionsNotifier] that returns canned data without gRPC/DB calls.
class FakeSessionsNotifier extends SessionsNotifier {
  FakeSessionsNotifier(this._sessions);
  final List<pb.SessionSummary> _sessions;

  @override
  Future<List<pb.SessionSummary>> build() async => _sessions;
}

// ---------------------------------------------------------------------------
// Event emission helpers
// ---------------------------------------------------------------------------

void emitSessionInfo(
  StreamController<pb.AgentEvent> controller,
  String sessionId,
  int seq,
) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      sessionInfo: pb.SessionInfo(sessionId: sessionId),
    ),
  );
}

void emitTextDelta(
  StreamController<pb.AgentEvent> controller,
  String text,
  int seq, {
  bool isComplete = false,
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      textDelta: pb.TextDelta(text: text, isComplete: isComplete),
    ),
  );
}

void emitToolCallStart(
  StreamController<pb.AgentEvent> controller,
  String toolId,
  String toolName,
  int seq, {
  String description = '',
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      toolCallStart: pb.ToolCallStart(
        toolId: toolId,
        toolName: toolName,
        description: description,
      ),
    ),
  );
}

void emitToolCallResult(
  StreamController<pb.AgentEvent> controller,
  String toolId,
  String output,
  int seq, {
  bool isError = false,
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      toolCallResult: pb.ToolCallResult(
        toolId: toolId,
        output: output,
        isError: isError,
      ),
    ),
  );
}

void emitPermissionRequest(
  StreamController<pb.AgentEvent> controller,
  String requestId,
  String toolName,
  int seq, {
  String description = 'Tool needs permission',
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      permissionRequest: pb.PermissionRequest(
        requestId: requestId,
        toolName: toolName,
        description: description,
      ),
    ),
  );
}

void emitUserQuestion(
  StreamController<pb.AgentEvent> controller,
  String questionId,
  String question,
  List<QuestionOption> options,
  int seq, {
  bool multiSelect = false,
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      userQuestion: pb.UserQuestion(
        questionId: questionId,
        question: question,
        options: options,
        multiSelect: multiSelect,
      ),
    ),
  );
}

void emitTurnComplete(
  StreamController<pb.AgentEvent> controller,
  int seq,
) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      turnComplete: pb.TurnComplete(),
    ),
  );
}

void emitStatusChange(
  StreamController<pb.AgentEvent> controller,
  AgentStatus status,
  int seq,
) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      statusChange: pb.StatusChange(status: status),
    ),
  );
}

void emitErrorEvent(
  StreamController<pb.AgentEvent> controller,
  String message,
  int seq, {
  bool isFatal = false,
  String code = 'ERROR',
}) {
  controller.add(
    pb.AgentEvent(
      sequence: Int64(seq),
      error: pb.ErrorEvent(
        message: message,
        isFatal: isFatal,
        code: code,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Mock setup helpers
// ---------------------------------------------------------------------------

/// Sets up `mockClient.converse` to drain the request stream and return
/// `eventController` as the response stream.
void stubConverse(
  MockAgentServiceClient mockClient,
  StreamController<pb.AgentEvent> eventController,
) {
  when(() => mockClient.converse(any())).thenAnswer((inv) {
    (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen((_) {});
    return FakeResponseStream<pb.AgentEvent>(eventController);
  });
}

/// Sets up `mockClient.resumeSession` to return a stream backed by the
/// given `controller`.
void stubResumeSession(
  MockAgentServiceClient mockClient,
  StreamController<pb.AgentEvent> controller,
) {
  when(() => mockClient.resumeSession(any())).thenAnswer((_) {
    return FakeResponseStream<pb.AgentEvent>(controller);
  });
}

// ---------------------------------------------------------------------------
// Fallback value registration
// ---------------------------------------------------------------------------

/// Registers all fallback values needed by mocktail for gRPC mocks.
///
/// Call once in `setUpAll`.
void registerFallbackValues() {
  registerFallbackValue(const Stream<pb.AgentRequest>.empty());
  registerFallbackValue(pb.ResumeSessionRequest());
  registerFallbackValue(pb.ListSessionsRequest());
}
