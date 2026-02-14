# Remaining Features Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement session rename (long-press context menu) and rich input system (command palette, @ mentions, file attachment) — the last two features from the UI/UX improvements design doc.

**Architecture:** Session rename adds a context menu to SessionCard with rename/delete actions, wired to existing `RenameSession` gRPC RPC. Rich input replaces the simple InputBar with an enhanced version supporting `/` command palette (overlay popup), `@` agent mentions (autocomplete from active agents), and file attachments (paperclip button mapping to `Attachment` proto field).

**Tech Stack:** Flutter, Riverpod, go_router, gRPC/protobuf, freezed, flutter_test/mocktail

---

## Feature A: Session Rename (Task 1–5)

### Task 1: Add `renameSession` method to SessionsNotifier

**Files:**
- Modify: `lib/features/sessions/notifiers/sessions_notifier.dart`
- Test: `test/features/sessions/notifiers/sessions_notifier_test.dart`

**Step 1: Write the failing test**

The test file may or may not exist. If it doesn't, create it. The test verifies that `renameSession` calls the gRPC service and refreshes the list.

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_notifier.dart';
import 'package:betcode_app/features/sessions/notifiers/sessions_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

void main() {
  late MockAgentServiceClient mockClient;

  setUp(() {
    mockClient = MockAgentServiceClient();
    registerFallbackValue(RenameSessionRequest());
    registerFallbackValue(ListSessionsRequest());
  });

  group('SessionsNotifier.renameSession', () {
    test('calls gRPC renameSession and refreshes list', () async {
      when(() => mockClient.renameSession(any()))
          .thenAnswer((_) async => RenameSessionResponse());
      when(() => mockClient.listSessions(any()))
          .thenAnswer((_) async => ListSessionsResponse(sessions: []));

      final container = ProviderContainer(
        overrides: [
          agentServiceProvider.overrideWithValue(mockClient),
          connectionStatusProvider.overrideWith(
            (ref) => Future.value(GrpcConnectionStatus.connected),
          ),
          selectedMachineIdProvider.overrideWithValue('m1'),
        ],
      );
      addTearDown(container.dispose);

      // Wait for build() to complete.
      await container.read(sessionsProvider.future);
      final notifier = container.read(sessionsProvider.notifier);

      await notifier.renameSession(sessionId: 'sess-1', name: 'My Session');

      final captured = verify(() => mockClient.renameSession(captureAny()))
          .captured
          .single as RenameSessionRequest;
      expect(captured.sessionId, 'sess-1');
      expect(captured.name, 'My Session');
      // listSessions called twice: once in build(), once in refresh after rename
      verify(() => mockClient.listSessions(any())).called(2);
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/sessions/notifiers/sessions_notifier_test.dart -v`
Expected: FAIL — `renameSession` method does not exist yet.

**Step 3: Write minimal implementation**

Add to `SessionsNotifier` in `lib/features/sessions/notifiers/sessions_notifier.dart`, after the `refresh()` method:

```dart
static const _mutationTimeout = Duration(seconds: 30);

/// Renames a session via gRPC and refreshes the list.
Future<void> renameSession({
  required String sessionId,
  required String name,
}) async {
  final client = ref.read(agentServiceProvider);
  await client
      .renameSession(RenameSessionRequest(sessionId: sessionId, name: name))
      .timeout(_mutationTimeout);
  await refresh();
}
```

Add the import for `service_providers.dart` if not already present:
```dart
import '../../../core/grpc/service_providers.dart';
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/sessions/notifiers/sessions_notifier_test.dart -v`
Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/sessions/notifiers/sessions_notifier.dart \
        test/features/sessions/notifiers/sessions_notifier_test.dart
git commit -m "feat: add renameSession method to SessionsNotifier"
```

---

### Task 2: Create RenameSessionDialog widget

**Files:**
- Create: `lib/features/sessions/widgets/rename_session_dialog.dart`
- Test: `test/features/sessions/widgets/rename_session_dialog_test.dart`

**Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/sessions/widgets/rename_session_dialog.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('RenameSessionDialog', () {
    testWidgets('shows text field pre-filled with current name', (t) async {
      await t.pumpWidget(
        _app(const RenameSessionDialog(currentName: 'Old Name')),
      );
      final field = t.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller?.text, 'Old Name');
    });

    testWidgets('shows empty field when currentName is empty', (t) async {
      await t.pumpWidget(
        _app(const RenameSessionDialog(currentName: '')),
      );
      final field = t.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller?.text, isEmpty);
    });

    testWidgets('Rename button disabled when field is empty', (t) async {
      await t.pumpWidget(
        _app(const RenameSessionDialog(currentName: '')),
      );
      final btn = t.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rename'),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets('Rename button enabled with text', (t) async {
      await t.pumpWidget(
        _app(const RenameSessionDialog(currentName: '')),
      );
      await t.enterText(find.byType(TextFormField), 'New Name');
      await t.pump();
      final btn = t.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rename'),
      );
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('Cancel returns null', (t) async {
      String? result = 'sentinel';
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await RenameSessionDialog.show(ctx, currentName: '');
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();
      expect(result, isNull);
    });

    testWidgets('Rename returns trimmed text', (t) async {
      String? result;
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await RenameSessionDialog.show(
                    ctx,
                    currentName: 'Old',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextFormField), '  New Name  ');
      await t.pump();
      await t.tap(find.text('Rename'));
      await t.pumpAndSettle();
      expect(result, 'New Name');
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/sessions/widgets/rename_session_dialog_test.dart -v`
Expected: FAIL — file does not exist.

**Step 3: Write minimal implementation**

Create `lib/features/sessions/widgets/rename_session_dialog.dart`:

```dart
import 'package:flutter/material.dart';

/// Dialog that prompts the user to rename a session.
///
/// Returns the new name (trimmed) or `null` if cancelled.
class RenameSessionDialog extends StatefulWidget {
  const RenameSessionDialog({super.key, required this.currentName});

  final String currentName;

  /// Convenience method to show the dialog and return the result.
  static Future<String?> show(
    BuildContext context, {
    required String currentName,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => RenameSessionDialog(currentName: currentName),
    );
  }

  @override
  State<RenameSessionDialog> createState() => _RenameSessionDialogState();
}

class _RenameSessionDialogState extends State<RenameSessionDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid => _controller.text.trim().isNotEmpty;

  void _submit() {
    if (_isValid) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Session'),
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Session name',
          hintText: 'Enter a name for this session',
        ),
        onFieldSubmitted: _isValid ? (_) => _submit() : null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isValid ? _submit : null,
          child: const Text('Rename'),
        ),
      ],
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/sessions/widgets/rename_session_dialog_test.dart -v`
Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/sessions/widgets/rename_session_dialog.dart \
        test/features/sessions/widgets/rename_session_dialog_test.dart
git commit -m "feat: add RenameSessionDialog widget"
```

---

### Task 3: Add long-press context menu to SessionCard

**Files:**
- Modify: `lib/features/sessions/widgets/session_card.dart`
- Test: `test/features/sessions/widgets/session_card_test.dart` (create if needed)

**Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import 'package:betcode_app/features/sessions/widgets/session_card.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: child));

SessionSummary _makeSession({String name = '', String id = 'sess-1'}) {
  return SessionSummary(
    id: id,
    model: 'opus-4',
    status: 'idle',
    messageCount: 5,
    totalCostUsd: 0.01,
    lastMessagePreview: 'Hello world',
    name: name,
    updatedAt: Timestamp.fromDateTime(DateTime(2026, 2, 14)),
  );
}

void main() {
  group('SessionCard - context menu', () {
    testWidgets('long-press shows Rename and Delete options', (t) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: _makeSession(),
            onTap: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('displays session name when set', (t) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: _makeSession(name: 'My Session'),
            onTap: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      expect(find.text('My Session'), findsOneWidget);
    });

    testWidgets('displays last_message_preview when name is empty', (t) async {
      await t.pumpWidget(
        _app(
          SessionCard(
            session: _makeSession(name: ''),
            onTap: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('tapping Rename calls onRename with current name', (t) async {
      String? renamed;
      await t.pumpWidget(
        _app(
          SessionCard(
            session: _makeSession(name: 'Old'),
            onTap: () {},
            onRename: (n) => renamed = n,
            onDelete: () {},
          ),
        ),
      );
      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();
      await t.tap(find.text('Rename'));
      await t.pumpAndSettle();
      // onRename is called with current name; the dialog is shown by parent
      expect(renamed, 'Old');
    });

    testWidgets('tapping Delete calls onDelete', (t) async {
      bool deleted = false;
      await t.pumpWidget(
        _app(
          SessionCard(
            session: _makeSession(),
            onTap: () {},
            onRename: (_) {},
            onDelete: () => deleted = true,
          ),
        ),
      );
      await t.longPress(find.byType(SessionCard));
      await t.pumpAndSettle();
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      expect(deleted, isTrue);
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/sessions/widgets/session_card_test.dart -v`
Expected: FAIL — SessionCard doesn't have onRename/onDelete params.

**Step 3: Modify SessionCard**

Update `lib/features/sessions/widgets/session_card.dart`:

1. Add constructor parameters: `onTap`, `onRename`, `onDelete`
2. Display `session.name` when non-empty, else `session.lastMessagePreview` as the title
3. Wrap InkWell's `onTap` and add `onLongPress` that shows `showMenu` with Rename/Delete

Key changes to the `SessionCard` class:

```dart
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final SessionSummary session;
  final VoidCallback onTap;
  final ValueChanged<String> onRename; // passes current name
  final VoidCallback onDelete;
```

Title display logic:
```dart
Text(
  session.name.isNotEmpty ? session.name : session.lastMessagePreview,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
),
```

Long-press handler:
```dart
onLongPress: () async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final position = box.localToGlobal(Offset.zero);
  final result = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + box.size.height,
      position.dx + box.size.width,
      position.dy + box.size.height,
    ),
    items: [
      const PopupMenuItem(value: 'rename', child: Text('Rename')),
      const PopupMenuItem(value: 'delete', child: Text('Delete')),
    ],
  );
  if (result == 'rename') onRename(session.name);
  if (result == 'delete') onDelete();
},
```

**Step 4: Update SessionsScreen** to pass the new callbacks. In `sessions_screen.dart`, update the `SessionCard` builder to pass:
- `onTap: () => context.go('/sessions/${session.id}')`
- `onRename: (currentName) => _onRename(context, ref, session.id, currentName)`
- `onDelete: () => _onDelete(context, ref, session.id)`

Add helper methods `_onRename` and `_onDelete` to SessionsScreen.

**Step 5: Run tests**

Run: `flutter test test/features/sessions/`
Expected: PASS

**Step 6: Commit**

```bash
git add lib/features/sessions/widgets/session_card.dart \
        lib/features/sessions/screens/sessions_screen.dart \
        test/features/sessions/widgets/session_card_test.dart
git commit -m "feat: add long-press context menu with rename/delete to SessionCard"
```

---

### Task 4: Wire rename flow in SessionsScreen

**Files:**
- Modify: `lib/features/sessions/screens/sessions_screen.dart`
- Modify: `lib/features/sessions/sessions.dart` (add barrel export)

**Step 1: Wire the rename dialog into SessionsScreen**

In `_onRename`, show `RenameSessionDialog`, then call `sessionsProvider.notifier.renameSession()`:

```dart
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
  if (newName == null || !context.mounted) return;
  try {
    await ref
        .read(sessionsProvider.notifier)
        .renameSession(sessionId: sessionId, name: newName);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rename: $e')),
      );
    }
  }
}
```

**Step 2: Add barrel export**

In `lib/features/sessions/widgets/widgets.dart` (or equivalent), export the new dialog:
```dart
export 'rename_session_dialog.dart';
```

**Step 3: Run all session tests**

Run: `flutter test test/features/sessions/`
Expected: PASS

**Step 4: Commit**

```bash
git add lib/features/sessions/
git commit -m "feat: wire session rename dialog into SessionsScreen"
```

---

### Task 5: Show session name in ConversationScreen AppBar

**Files:**
- Modify: `lib/features/conversation/screens/conversation_screen.dart`

**Step 1: Update AppBar title**

In `_buildActiveState`, the AppBar currently shows `const Text('Conversation')`. Update it to show the session name when available. The session name would need to come from the sessions list or be stored in the conversation state.

Simplest approach: read the session name from `sessionsProvider` in the conversation screen:

```dart
// In _buildActiveState:
final sessions = ref.watch(sessionsProvider).value;
final session = sessions?.where((s) => s.id == active.sessionId).firstOrNull;
final title = session?.name.isNotEmpty == true
    ? session!.name
    : 'Conversation';
```

Then use `Text(title)` in the AppBar.

**Step 2: Run all tests**

Run: `flutter test`
Expected: PASS

**Step 3: Commit**

```bash
git add lib/features/conversation/screens/conversation_screen.dart
git commit -m "feat: show session name in conversation AppBar"
```

---

## Feature B: Rich Input System (Task 6–11)

### Task 6: Create command definitions model

**Files:**
- Create: `lib/features/conversation/models/input_command.dart`
- Test: `test/features/conversation/models/input_command_test.dart`

**Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/input_command.dart';

void main() {
  group('InputCommand', () {
    test('allCommands returns non-empty list', () {
      expect(InputCommand.allCommands, isNotEmpty);
    });

    test('filter by prefix returns matching commands', () {
      final results = InputCommand.filter('can');
      expect(results.every((c) => c.name.contains('can')), isTrue);
    });

    test('filter with empty string returns all commands', () {
      expect(InputCommand.filter(''), InputCommand.allCommands);
    });

    test('each command has name, description, and category', () {
      for (final cmd in InputCommand.allCommands) {
        expect(cmd.name, isNotEmpty);
        expect(cmd.description, isNotEmpty);
        expect(cmd.category, isNotEmpty);
      }
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/conversation/models/input_command_test.dart -v`
Expected: FAIL

**Step 3: Write minimal implementation**

Create `lib/features/conversation/models/input_command.dart`:

```dart
/// A slash command available in the input bar command palette.
class InputCommand {
  const InputCommand({
    required this.name,
    required this.description,
    required this.category,
  });

  final String name;
  final String description;
  final String category;

  static const allCommands = <InputCommand>[
    // App
    InputCommand(name: 'exit', description: 'End session', category: 'App'),
    InputCommand(name: 'clear', description: 'Clear display', category: 'App'),
    InputCommand(name: 'compact', description: 'Compact context', category: 'App'),
    // Claude
    InputCommand(name: 'plan', description: 'Toggle plan mode', category: 'Claude'),
    InputCommand(name: 'model', description: 'Switch model', category: 'Claude'),
    // Agent
    InputCommand(name: 'cancel', description: 'Cancel current turn', category: 'Agent'),
    InputCommand(name: 'retry', description: 'Retry last turn', category: 'Agent'),
  ];

  /// Returns commands whose name contains [query] (case-insensitive).
  static List<InputCommand> filter(String query) {
    if (query.isEmpty) return allCommands;
    final lower = query.toLowerCase();
    return allCommands.where((c) => c.name.toLowerCase().contains(lower)).toList();
  }
}
```

**Step 4: Run test, commit**

Run: `flutter test test/features/conversation/models/input_command_test.dart -v`
Expected: PASS

```bash
git add lib/features/conversation/models/input_command.dart \
        test/features/conversation/models/input_command_test.dart
git commit -m "feat: add InputCommand model for slash command palette"
```

---

### Task 7: Build CommandPaletteOverlay widget

**Files:**
- Create: `lib/features/conversation/widgets/command_palette.dart`
- Test: `test/features/conversation/widgets/command_palette_test.dart`

**Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/input_command.dart';
import 'package:betcode_app/features/conversation/widgets/command_palette.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('CommandPalette', () {
    testWidgets('shows all commands when query is empty', (t) async {
      await t.pumpWidget(
        _app(
          CommandPalette(
            query: '',
            onCommandSelected: (_) {},
          ),
        ),
      );
      for (final cmd in InputCommand.allCommands) {
        expect(find.text('/${cmd.name}'), findsOneWidget);
      }
    });

    testWidgets('filters commands by query', (t) async {
      await t.pumpWidget(
        _app(
          CommandPalette(
            query: 'can',
            onCommandSelected: (_) {},
          ),
        ),
      );
      expect(find.text('/cancel'), findsOneWidget);
      expect(find.text('/exit'), findsNothing);
    });

    testWidgets('shows description for each command', (t) async {
      await t.pumpWidget(
        _app(
          CommandPalette(query: 'exit', onCommandSelected: (_) {}),
        ),
      );
      expect(find.text('End session'), findsOneWidget);
    });

    testWidgets('shows category tag', (t) async {
      await t.pumpWidget(
        _app(
          CommandPalette(query: 'exit', onCommandSelected: (_) {}),
        ),
      );
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('tapping command calls onCommandSelected', (t) async {
      InputCommand? selected;
      await t.pumpWidget(
        _app(
          CommandPalette(
            query: 'exit',
            onCommandSelected: (c) => selected = c,
          ),
        ),
      );
      await t.tap(find.text('/exit'));
      expect(selected?.name, 'exit');
    });

    testWidgets('returns SizedBox.shrink when no matches', (t) async {
      await t.pumpWidget(
        _app(
          CommandPalette(
            query: 'zzzzz',
            onCommandSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
```

**Step 2: Run test to verify it fails, then implement**

Create `lib/features/conversation/widgets/command_palette.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/input_command.dart';

/// Dropdown overlay showing filtered slash commands.
///
/// Renders above the input bar when the user types `/` at the start of input.
class CommandPalette extends StatelessWidget {
  const CommandPalette({
    super.key,
    required this.query,
    required this.onCommandSelected,
  });

  /// The text after `/` used to filter commands.
  final String query;
  final ValueChanged<InputCommand> onCommandSelected;

  @override
  Widget build(BuildContext context) {
    final commands = InputCommand.filter(query);
    if (commands.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: commands.length,
          itemBuilder: (context, index) {
            final cmd = commands[index];
            return ListTile(
              dense: true,
              title: Text(
                '/${cmd.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(cmd.description),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cmd.category,
                  style: theme.textTheme.labelSmall,
                ),
              ),
              onTap: () => onCommandSelected(cmd),
            );
          },
        ),
      ),
    );
  }
}
```

**Step 3: Run test, commit**

```bash
git add lib/features/conversation/widgets/command_palette.dart \
        test/features/conversation/widgets/command_palette_test.dart
git commit -m "feat: add CommandPalette overlay widget"
```

---

### Task 8: Build AgentMentionOverlay widget

**Files:**
- Create: `lib/features/conversation/widgets/agent_mention_overlay.dart`
- Test: `test/features/conversation/widgets/agent_mention_overlay_test.dart`

**Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/widgets/agent_mention_overlay.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

final _agents = {
  'a1': const AgentInfo(
    id: 'a1',
    name: 'researcher',
    status: AgentStatus.AGENT_STATUS_THINKING,
  ),
  'a2': const AgentInfo(
    id: 'a2',
    name: 'coder',
    status: AgentStatus.AGENT_STATUS_IDLE,
  ),
};

void main() {
  group('AgentMentionOverlay', () {
    testWidgets('shows all agents when query is empty', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.text('@researcher'), findsOneWidget);
      expect(find.text('@coder'), findsOneWidget);
    });

    testWidgets('filters agents by query', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'res',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.text('@researcher'), findsOneWidget);
      expect(find.text('@coder'), findsNothing);
    });

    testWidgets('tapping agent calls onAgentSelected', (t) async {
      AgentInfo? selected;
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: '',
            onAgentSelected: (a) => selected = a,
          ),
        ),
      );
      await t.tap(find.text('@coder'));
      expect(selected?.id, 'a2');
    });

    testWidgets('returns SizedBox.shrink when agents is empty', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: const {},
            query: '',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when no matches', (t) async {
      await t.pumpWidget(
        _app(
          AgentMentionOverlay(
            agents: _agents,
            query: 'zzz',
            onAgentSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
```

**Step 2: Implement**

Create `lib/features/conversation/widgets/agent_mention_overlay.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/conversation_state.dart';

/// Autocomplete overlay for @-mentioning active agents.
class AgentMentionOverlay extends StatelessWidget {
  const AgentMentionOverlay({
    super.key,
    required this.agents,
    required this.query,
    required this.onAgentSelected,
  });

  final Map<String, AgentInfo> agents;
  final String query;
  final ValueChanged<AgentInfo> onAgentSelected;

  @override
  Widget build(BuildContext context) {
    final filtered = agents.values.where((a) {
      if (query.isEmpty) return true;
      return a.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final agent = filtered[index];
            return ListTile(
              dense: true,
              title: Text(
                '@${agent.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => onAgentSelected(agent),
            );
          },
        ),
      ),
    );
  }
}
```

**Step 3: Run test, commit**

```bash
git add lib/features/conversation/widgets/agent_mention_overlay.dart \
        test/features/conversation/widgets/agent_mention_overlay_test.dart
git commit -m "feat: add AgentMentionOverlay widget for @ mentions"
```

---

### Task 9: Enhance InputBar with command palette and @ mentions

**Files:**
- Modify: `lib/features/conversation/widgets/input_bar.dart`
- Test: `test/features/conversation/widgets/input_bar_test.dart` (new file for enhanced InputBar tests)

**Step 1: Write failing tests for new behavior**

Create `test/features/conversation/widgets/input_bar_test.dart` with focused tests:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/widgets/input_bar.dart';
import 'package:betcode_app/generated/betcode/v1/common.pb.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

final _agents = {
  'a1': const AgentInfo(
    id: 'a1',
    name: 'researcher',
    status: AgentStatus.AGENT_STATUS_IDLE,
  ),
};

void main() {
  group('InputBar - command palette', () {
    testWidgets('typing / shows CommandPalette', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {})),
      );
      await t.enterText(find.byType(TextField), '/');
      await t.pump();
      expect(find.text('/exit'), findsOneWidget);
    });

    testWidgets('typing /can filters to cancel', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {})),
      );
      await t.enterText(find.byType(TextField), '/can');
      await t.pump();
      expect(find.text('/cancel'), findsOneWidget);
      expect(find.text('/exit'), findsNothing);
    });

    testWidgets('selecting command calls onSubmit with /command', (t) async {
      String? submitted;
      await t.pumpWidget(
        _app(InputBar(onSubmit: (s) => submitted = s)),
      );
      await t.enterText(find.byType(TextField), '/');
      await t.pump();
      await t.tap(find.text('/exit'));
      await t.pump();
      expect(submitted, '/exit');
    });

    testWidgets('no palette when / is not at start', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {})),
      );
      await t.enterText(find.byType(TextField), 'hello /');
      await t.pump();
      expect(find.text('/exit'), findsNothing);
    });
  });

  group('InputBar - @ mentions', () {
    testWidgets('typing @ shows agent mention overlay', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {}, agents: _agents)),
      );
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      expect(find.text('@researcher'), findsOneWidget);
    });

    testWidgets('no overlay when agents is empty', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {}, agents: const {})),
      );
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      expect(find.text('@researcher'), findsNothing);
    });

    testWidgets('selecting agent inserts @name into text field', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {}, agents: _agents)),
      );
      await t.enterText(find.byType(TextField), '@');
      await t.pump();
      await t.tap(find.text('@researcher'));
      await t.pump();
      final field = t.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, contains('@researcher'));
    });
  });

  group('InputBar - attachment button', () {
    testWidgets('shows paperclip button', (t) async {
      await t.pumpWidget(
        _app(InputBar(onSubmit: (_) {})),
      );
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });
  });
}
```

**Step 2: Implement enhanced InputBar**

Key changes to `lib/features/conversation/widgets/input_bar.dart`:

1. Add optional `agents` parameter (`Map<String, AgentInfo>?`)
2. Add optional `onAgentSelected` callback
3. Track overlay state: `_showCommandPalette`, `_showMentionOverlay`
4. Listen to text changes to detect `/` at position 0 or `@` trigger
5. Build overlays in a Column above the text field row
6. Add paperclip IconButton on the left side of the row

```dart
class InputBar extends StatefulWidget {
  const InputBar({
    super.key,
    required this.onSubmit,
    this.enabled = true,
    this.onCancel,
    this.hintText,
    this.agents,
    this.onAgentSelected,
  });

  final ValueChanged<String> onSubmit;
  final bool enabled;
  final VoidCallback? onCancel;
  final String? hintText;
  final Map<String, AgentInfo>? agents;
  final ValueChanged<String?>? onAgentSelected;
  // ...
```

The overlay detection logic in `_onTextChanged`:
```dart
void _onTextChanged() {
  final text = _controller.text;
  setState(() {
    _showCommandPalette = text.startsWith('/');
    _commandQuery = _showCommandPalette ? text.substring(1) : '';

    // Detect @ at current cursor position (simplified: last @ in text)
    final atIndex = text.lastIndexOf('@');
    _showMentionOverlay = atIndex >= 0 &&
        (atIndex == 0 || text[atIndex - 1] == ' ') &&
        text.indexOf(' ', atIndex) == -1;
    _mentionQuery = _showMentionOverlay
        ? text.substring(atIndex + 1)
        : '';
  });
}
```

**Step 3: Run tests, commit**

Run: `flutter test test/features/conversation/widgets/input_bar_test.dart -v`
Expected: PASS

```bash
git add lib/features/conversation/widgets/input_bar.dart \
        test/features/conversation/widgets/input_bar_test.dart
git commit -m "feat: enhance InputBar with command palette, @ mentions, and attachment button"
```

---

### Task 10: Wire enhanced InputBar into ConversationScreen

**Files:**
- Modify: `lib/features/conversation/screens/conversation_screen.dart`

**Step 1: Update InputBar usage in _buildActiveState**

Pass the agents map and onAgentSelected callback:

```dart
InputBar(
  enabled: isIdle,
  agents: active.agents,
  onAgentSelected: (agentId) => ref
      .read(conversationProvider(widget.sessionId).notifier)
      .setSelectedAgent(agentId),
  onSubmit: (text) => ref
      .read(conversationProvider(widget.sessionId).notifier)
      .sendMessage(text),
  onCancel: isIdle
      ? null
      : () => ref
            .read(conversationProvider(widget.sessionId).notifier)
            .cancelTurn(),
),
```

**Step 2: Update sendMessage to include agentId**

In `ConversationNotifier.sendMessage`, use `selectedAgentId` for the `agentId` field:

```dart
void sendMessage(String content) {
  final current = state.value;
  if (current is! ConversationActive || _requestController == null) return;

  final userMsg = ChatMessage.user(
    content: content,
    timestamp: DateTime.now(),
  );
  state = AsyncData(
    current.copyWith(messages: [...current.messages, userMsg]),
  );

  _requestController!.add(
    pb.AgentRequest(
      message: pb.UserMessage(
        content: content,
        agentId: current.selectedAgentId ?? '',
      ),
    ),
  );
}
```

**Step 3: Run all tests**

Run: `flutter test`
Expected: PASS

**Step 4: Commit**

```bash
git add lib/features/conversation/screens/conversation_screen.dart \
        lib/features/conversation/notifiers/conversation_notifier.dart
git commit -m "feat: wire enhanced InputBar with agent routing into ConversationScreen"
```

---

### Task 11: Update barrel exports and run final verification

**Files:**
- Modify: `lib/features/conversation/widgets/widgets.dart`
- Modify: `lib/features/conversation/models/models.dart`

**Step 1: Add exports**

In `lib/features/conversation/widgets/widgets.dart`, add:
```dart
export 'command_palette.dart';
export 'agent_mention_overlay.dart';
```

In `lib/features/conversation/models/models.dart`, add:
```dart
export 'input_command.dart';
```

**Step 2: Run full test suite**

Run: `flutter test`
Expected: All tests pass

**Step 3: Final commit**

```bash
git add lib/features/conversation/widgets/widgets.dart \
        lib/features/conversation/models/models.dart
git commit -m "chore: add barrel exports for rich input widgets and models"
```

---

## Dependency Graph

```
Task 1 (renameSession notifier) ─┐
Task 2 (RenameSessionDialog)  ───┼─→ Task 3 (SessionCard context menu) → Task 4 (wire in screen) → Task 5 (AppBar title)
                                  │
Task 6 (InputCommand model) ──────┤
Task 7 (CommandPalette widget) ───┼─→ Task 9 (enhance InputBar) → Task 10 (wire in screen) → Task 11 (exports)
Task 8 (AgentMentionOverlay) ─────┘
```

Tasks 1-5 (session rename) and Tasks 6-11 (rich input) are independent and can be parallelized.

Within each feature:
- Tasks 1, 2 can run in parallel (both are leaf nodes)
- Tasks 6, 7, 8 can run in parallel (all leaf nodes)
