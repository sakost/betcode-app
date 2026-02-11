import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitLabScreen extends ConsumerWidget {
  const GitLabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitLab')),
      body: const Center(child: Text('GitLab integration')),
    );
  }
}
