import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/commands.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/config.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/health.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/machine.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/version.pbgrpc.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pbgrpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the [AgentServiceClient] for conversation streaming, session
/// management, and input lock operations.
///
/// Watches `connectionStatusProvider` so the client is recreated with the
/// current `ClientChannel` whenever `GrpcClientManager.connect` replaces
/// the channel (e.g. during reconnection). Without this, stale clients
/// would hold a reference to the old (shut-down) channel and every RPC
/// would fail with "Channel shutting down".
final agentServiceProvider = Provider<AgentServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return AgentServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [AuthServiceClient] for login, registration, and token
/// management. Uses the channel directly without auth interceptor since
/// auth calls themselves are unauthenticated.
final authServiceProvider = Provider<AuthServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return AuthServiceClient(manager.channel);
});

/// Provides the [MachineServiceClient] for listing and switching machines.
final machineServiceProvider = Provider<MachineServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return MachineServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [WorktreeServiceClient] for worktree CRUD per machine.
final worktreeServiceProvider = Provider<WorktreeServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return WorktreeServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [GitRepoServiceClient] for repository registration and
/// configuration management.
final gitRepoServiceProvider = Provider<GitRepoServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return GitRepoServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [ConfigServiceClient] for settings, permissions, and MCP
/// server listing.
final configServiceProvider = Provider<ConfigServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return ConfigServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [GitLabServiceClient] for MR, pipeline, and issue views.
final gitlabServiceProvider = Provider<GitLabServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return GitLabServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [HealthClient] for daemon health checks.
final healthServiceProvider = Provider<HealthClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return HealthClient(manager.channel, interceptors: manager.interceptors);
});

/// Provides the [BetCodeHealthClient] for relay health checks.
final betcodeHealthServiceProvider = Provider<BetCodeHealthClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return BetCodeHealthClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [VersionServiceClient] for version negotiation and capability
/// discovery.
final versionServiceProvider = Provider<VersionServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return VersionServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});

/// Provides the [CommandServiceClient] for command registry, completion,
/// service command execution, and plugin management.
final commandServiceProvider = Provider<CommandServiceClient>((ref) {
  final manager = ref.watch(grpcClientManagerProvider);
  ref.watch(connectionStatusProvider);
  return CommandServiceClient(
    manager.channel,
    interceptors: manager.interceptors,
  );
});
