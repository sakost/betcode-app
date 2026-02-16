import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of registered git repositories fetched via gRPC.
///
/// On [build], fetches all repos and returns them. Callers can
/// pull-to-refresh via [refresh], register new repos, or unregister existing
/// ones.
///
/// Watches [connectionStatusProvider] so the provider auto-refreshes when
/// the gRPC connection state changes.
class GitReposNotifier extends AsyncNotifier<List<GitRepoDetail>> {
  static const _rpcTimeout = Duration(seconds: 10);
  static const _mutationTimeout = Duration(seconds: 30);

  @override
  Future<List<GitRepoDetail>> build() async {
    final status = await ref.watch(connectionStatusProvider.future);
    if (status != GrpcConnectionStatus.connected) {
      throw StateError('Not connected to daemon');
    }
    final machineId = ref.watch(selectedMachineIdProvider);
    if (machineId == null) return [];
    return _fetchRepos();
  }

  Future<List<GitRepoDetail>> _fetchRepos() async {
    final client = ref.read(gitRepoServiceProvider);
    final response = await client
        .listRepos(ListReposRequest())
        .timeout(_rpcTimeout);
    return response.repos.toList();
  }

  /// Re-fetches repos from the daemon and replaces the current state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchRepos);
  }

  /// Registers a new git repository via gRPC and refreshes the list.
  Future<void> registerRepo({
    required String repoPath,
    String? name,
    WorktreeMode worktreeMode = WorktreeMode.WORKTREE_MODE_UNSPECIFIED,
    String? localSubfolder,
    String? customPath,
    String? setupScript,
    bool autoGitignore = true,
  }) async {
    final client = ref.read(gitRepoServiceProvider);
    await client
        .registerRepo(
          RegisterRepoRequest(
            repoPath: repoPath,
            name: name ?? '',
            worktreeMode: worktreeMode,
            localSubfolder: localSubfolder ?? '',
            customPath: customPath ?? '',
            setupScript: setupScript ?? '',
            autoGitignore: autoGitignore,
          ),
        )
        .timeout(_mutationTimeout);
    await refresh();
  }

  /// Unregisters a repository by ID via gRPC and refreshes the list.
  Future<void> unregisterRepo(String id, {bool removeWorktrees = false}) async {
    final client = ref.read(gitRepoServiceProvider);
    await client
        .unregisterRepo(
          UnregisterRepoRequest(id: id, removeWorktrees: removeWorktrees),
        )
        .timeout(_mutationTimeout);
    await refresh();
  }

  /// Fetches a single repository by ID.
  Future<GitRepoDetail> getRepo(String id) async {
    final client = ref.read(gitRepoServiceProvider);
    return client.getRepo(GetRepoRequest(id: id)).timeout(_rpcTimeout);
  }

  /// Updates a repository's configuration and refreshes the list.
  ///
  /// Only fields that are explicitly provided (non-null) are set on the
  /// request. Omitted fields stay at their protobuf defaults, allowing
  /// the daemon to distinguish "not specified" from "set to empty/false".
  Future<GitRepoDetail> updateRepo({
    required String id,
    String? name,
    WorktreeMode? worktreeMode,
    String? localSubfolder,
    String? customPath,
    String? setupScript,
    bool? autoGitignore,
  }) async {
    final client = ref.read(gitRepoServiceProvider);
    final request = UpdateRepoRequest(id: id);
    if (name != null) request.name = name;
    if (worktreeMode != null) request.worktreeMode = worktreeMode;
    if (localSubfolder != null) request.localSubfolder = localSubfolder;
    if (customPath != null) request.customPath = customPath;
    if (setupScript != null) request.setupScript = setupScript;
    if (autoGitignore != null) request.autoGitignore = autoGitignore;
    final result = await client.updateRepo(request).timeout(_mutationTimeout);
    await refresh();
    return result;
  }

  /// Scans a directory for git repositories and returns them.
  Future<List<GitRepoDetail>> scanRepos({
    required String scanPath,
    int maxDepth = 3,
  }) async {
    final client = ref.read(gitRepoServiceProvider);
    final response = await client
        .scanRepos(ScanReposRequest(scanPath: scanPath, maxDepth: maxDepth))
        .timeout(_mutationTimeout);
    await refresh();
    return response.repos.toList();
  }
}
