import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_display.dart';
import '../notifiers/sessions_providers.dart';
import '../widgets/rename_session_dialog.dart';
import '../widgets/session_card.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/sessions/new'),
        child: const Icon(Icons.add),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(sessionsProvider.notifier).refresh(),
        ),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'No sessions yet',
              subtitle: 'Start a conversation to see your sessions here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(sessionsProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return SessionCard(
                  session: session,
                  onTap: () => context.go('/sessions/${session.id}'),
                  onRename: (currentName) =>
                      _onRename(context, ref, session.id, currentName),
                  onDelete: () => _onDelete(context),
                );
              },
            ),
          );
        },
      ),
    );
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
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rename failed: $e')),
      );
    }
  }

  void _onDelete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete coming soon')),
    );
  }
}
