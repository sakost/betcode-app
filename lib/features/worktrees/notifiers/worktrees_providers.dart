import 'package:betcode_app/features/worktrees/notifiers/worktrees_notifier.dart';
import 'package:betcode_app/generated/betcode/v1/worktree.pb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the list of [WorktreeDetail] objects fetched from the daemon.
///
/// Use `ref.watch(worktreesProvider)` in widgets to reactively rebuild on
/// loading / data / error transitions.
final worktreesProvider =
    AsyncNotifierProvider<WorktreesNotifier, List<WorktreeDetail>>(
      WorktreesNotifier.new,
    );
