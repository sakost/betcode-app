import 'package:flutter/material.dart';

/// A reusable scaffold that shows a centered [CircularProgressIndicator].
///
/// If [title] is provided, an [AppBar] with that title is displayed.
/// Useful as a placeholder screen while async data is loading.
class LoadingScaffold extends StatelessWidget {
  /// Creates a [LoadingScaffold] with an optional AppBar [title].
  const LoadingScaffold({super.key, this.title});

  /// Optional title shown in the AppBar. When null, no AppBar is rendered.
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
