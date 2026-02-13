import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/grpc/connection_state.dart';
import '../../../core/grpc/grpc_providers.dart';
import '../../../core/grpc/service_providers.dart';
import '../../../generated/betcode/v1/git_repo.pb.dart';

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
    state = await AsyncValue.guard(() => _fetchRepos());
  }

  /// Registers a new git repository via gRPC and refreshes the list.
  Future<void> registerRepo({
    required String repoPath,
    String? name,
    String? worktreeMode,
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
            worktreeMode: worktreeMode ?? '',
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
}
