import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/betcode/v1/git_repo.pb.dart';
import 'git_repos_notifier.dart';

/// Provides the list of [GitRepoDetail] objects fetched from the daemon.
///
/// Use `ref.watch(gitReposProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final gitReposProvider =
    AsyncNotifierProvider<GitReposNotifier, List<GitRepoDetail>>(
      GitReposNotifier.new,
    );
