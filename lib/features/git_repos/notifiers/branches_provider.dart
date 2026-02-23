import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/git_repo.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [BranchInfo] for a given repository ID.
///
/// Fetches branches via gRPC `GitRepoServiceClient.listBranches`.
/// Use `ref.watch(branchesProvider(repoId))` to reactively load branches
/// when a repo is selected (e.g. in the create-worktree dialog).
// ignore: specify_nonobvious_property_types, the family provider type is not publicly exported
final branchesProvider = FutureProvider.family<List<BranchInfo>, String>(
  (ref, repoId) async {
    final client = ref.watch(gitRepoServiceProvider);
    final resp = await client.listBranches(
      ListBranchesRequest(repoId: repoId),
    );
    return resp.branches.toList();
  },
);
