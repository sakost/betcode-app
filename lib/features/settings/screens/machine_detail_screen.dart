import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Machine detail subpage shown from Settings.
///
/// Displays MCP servers, available models, worktrees, and metadata
/// for the currently selected machine.
class MachineDetailScreen extends ConsumerWidget {
  const MachineDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Machine')),
      body: const Center(child: Text('Machine details')),
    );
  }
}
