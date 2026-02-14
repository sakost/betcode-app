import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'empty_state.dart';
import 'error_display.dart';

/// Generic scaffold for screens that display an async list.
///
/// Handles loading, error, empty, and data states with RefreshIndicator.
class AsyncListScaffold<T> extends StatelessWidget {
  const AsyncListScaffold({
    super.key,
    required this.asyncValue,
    required this.itemBuilder,
    required this.onRefresh,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptySubtitle,
  });

  final AsyncValue<List<T>> asyncValue;
  final Widget Function(BuildContext, T) itemBuilder;
  final Future<void> Function() onRefresh;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptySubtitle;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: () => onRefresh(),
      ),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: emptySubtitle,
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
          ),
        );
      },
    );
  }
}
