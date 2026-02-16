import 'package:betcode_app/shared/widgets/empty_state.dart';
import 'package:betcode_app/shared/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic scaffold for screens that display an async list.
///
/// Handles loading, error, empty, and data states with RefreshIndicator.
class AsyncListScaffold<T> extends StatelessWidget {
  /// Creates an [AsyncListScaffold] for the given [asyncValue].
  const AsyncListScaffold({
    required this.asyncValue,
    required this.itemBuilder,
    required this.onRefresh,
    required this.emptyIcon,
    required this.emptyTitle,
    super.key,
    this.emptySubtitle,
  });

  /// The async list data to display (loading / error / data).
  final AsyncValue<List<T>> asyncValue;

  /// Builds a widget for each item in the list.
  final Widget Function(BuildContext, T) itemBuilder;

  /// Callback invoked on pull-to-refresh and on error retry.
  final Future<void> Function() onRefresh;

  /// Icon shown in the empty-state placeholder.
  final IconData emptyIcon;

  /// Title shown in the empty-state placeholder.
  final String emptyTitle;

  /// Optional subtitle shown below the empty-state title.
  final String? emptySubtitle;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplay(
        error: error,
        stackTrace: stackTrace,
        onRetry: onRefresh,
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
