import 'dart:async';

import 'package:betcode_app/core/grpc/app_exceptions.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/features/sessions/widgets/confirm_delete_dialog.dart';
import 'package:betcode_app/features/sessions/widgets/rename_session_dialog.dart';
import 'package:betcode_app/features/sessions/widgets/session_card.dart';
import 'package:betcode_app/features/sessions/widgets/worktree_picker_dialog.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:betcode_app/shared/widgets/async_list_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onNewSession(context),
        child: const Icon(Icons.add),
      ),
      body: AsyncListScaffold<SessionSummary>(
        asyncValue: sessionsAsync,
        onRefresh: () => ref.read(sessionsProvider.notifier).refresh(),
        emptyIcon: Icons.history,
        emptyTitle: 'No sessions yet',
        emptySubtitle: 'Start a conversation to see your sessions here.',
        itemBuilder: (context, session) => SessionCard(
          session: session,
          onTap: () => context.go('/sessions/${session.id}'),
          onRename: (currentName) =>
              _onRename(context, ref, session.id, currentName),
          onDelete: () => _onDelete(context, ref, session.id),
        ),
      ),
    );
  }

  Future<void> _onNewSession(BuildContext context) async {
    final worktree = await WorktreePickerDialog.show(context);
    if (worktree == null || !context.mounted) return;
    context.go('/sessions/new', extra: worktree.path);
  }

  Future<void> _onRename(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String currentName,
  ) async {
    final newName = await RenameSessionDialog.show(
      context,
      currentName: currentName,
    );
    if (newName == null) return;
    try {
      await ref
          .read(sessionsProvider.notifier)
          .renameSession(sessionId: sessionId, name: newName);
    } on AppException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rename failed: $e')),
      );
    }
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
  ) async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (confirmed != true) return;
    try {
      await ref.read(sessionsProvider.notifier).deleteSession(sessionId);
    } on SessionNotFoundError catch (_) {
      // Session already gone — just refresh the list.
      unawaited(ref.read(sessionsProvider.notifier).refresh());
    } on AppException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }
}
