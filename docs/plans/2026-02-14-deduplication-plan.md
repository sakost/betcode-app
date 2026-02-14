# Deduplication Plan — Target 1% lib/ and 10% test/

**Date:** 2026-02-14
**Current state:** lib/ 7.64% (34 clones, 715 lines), test/ 14.68% (194 clones, 2496 lines)
**Target:** lib/ ≤ 1%, test/ ≤ 10%

## jscpd Configuration

Split into two separate thresholds by updating `.jscpd.json` and adding a
script or two jscpd invocations:
- `npx jscpd lib/ --threshold 1`
- `npx jscpd test/ --threshold 10`

---

## lib/ Tasks (7.64% → 1%)

### Task 1: AuthFormScaffold

**Files:** `lib/features/auth/widgets/auth_form_scaffold.dart` (new)
**Modifies:** `login_screen.dart`, `register_screen.dart`
**Lines saved:** ~200

`login_screen.dart` and `register_screen.dart` are ~90% identical: same relay
config init, same relay connection logic, same form scaffold, same header,
same password field, same username field, same submit button pattern. Only
differences: email field (register only), the RPC call (login vs register),
button/link text.

Create `AuthFormScaffold` as a `ConsumerStatefulWidget` that takes an
`AuthMode` enum (login/register). Both screens become thin wrappers:

```dart
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const AuthFormScaffold(mode: AuthMode.login);
}
```

The scaffold owns all shared state: form key, controllers, relay init,
relay connection, isLoading, obscurePassword, useTls. The mode enum
controls:
- Whether to show the email field
- Which RPC to call (authClient.login vs authClient.register)
- Button text ('Login' vs 'Register')
- Navigation link text and target

### Task 2: StatusBadge

**File:** `lib/shared/widgets/status_badge.dart` (new)
**Modifies:** `machine_card.dart`, `session_card.dart`, `pipeline_card.dart`,
`issue_card.dart`, `merge_request_card.dart`
**Lines saved:** ~80

All five cards have a private `_StatusBadge` widget with identical build:
`Container(padding, BoxDecoration(color.withAlpha, borderRadius), Text)`.
Only the resolve map differs.

Create one shared `StatusBadge` widget:

```dart
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.color, required this.label});
  final Color color;
  final String label;
}
```

Callers resolve color/label at the call site (or via a static helper on
their data type) and pass the resolved values.

### Task 3: EmptyState

**File:** `lib/shared/widgets/empty_state.dart` (new)
**Modifies:** `git_repos_screen.dart`, `worktrees_screen.dart`,
`machines_screen.dart`, `sessions_screen.dart`, `repo_detail_screen.dart`
**Lines saved:** ~60

All four list screens (plus repo_detail_screen's _EmptyWorktreesState) have
identical `_EmptyState` private widgets:
Center > Padding > Column > [Icon(64, 0.5 alpha), SizedBox(16), Text(title),
SizedBox(8), Text(subtitle, 0.7 alpha)].

Create one shared `EmptyState`:

```dart
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
}
```

### Task 4: AsyncListScaffold

**File:** `lib/shared/widgets/async_list_scaffold.dart` (new)
**Modifies:** `git_repos_screen.dart`, `worktrees_screen.dart`,
`machines_screen.dart`, `sessions_screen.dart`
**Lines saved:** ~120

All four list screens follow the same pattern:
1. Watch an `AsyncValue<List<T>>`
2. `.when(loading: CircularProgressIndicator, error: ErrorDisplay, data: ...)`
3. If data is empty, show `EmptyState`
4. Otherwise, `RefreshIndicator` + `ListView.builder`

Create a generic widget:

```dart
class AsyncListScaffold<T> extends StatelessWidget {
  const AsyncListScaffold({
    super.key,
    required this.asyncValue,
    required this.itemBuilder,
    required this.onRefresh,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final AsyncValue<List<T>> asyncValue;
  final Widget Function(BuildContext, T) itemBuilder;
  final Future<void> Function() onRefresh;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
}
```

### Task 5: TappableCard

**File:** `lib/shared/widgets/tappable_card.dart` (new)
**Modifies:** `machine_card.dart`, `session_card.dart`, `pipeline_card.dart`,
`issue_card.dart`, `merge_request_card.dart`, `git_repo_card.dart`,
`repo_detail_screen.dart` (worktree cards)
**Lines saved:** ~80

Every card widget builds:
```dart
Card(
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  child: InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...],
      ),
    ),
  ),
)
```

Create `TappableCard`:

```dart
class TappableCard extends StatelessWidget {
  const TappableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
}
```

The child receives a Column (or any widget). `isSelected` adds a primary
border like MachineCard currently does manually.

### Task 6: Worktree Notifier Consolidation

**Modifies:** `repo_worktrees_provider.dart`, `worktrees_notifier.dart`
**Lines saved:** ~40

Both notifiers have near-identical `createWorktree` methods. Extract the
shared gRPC call into a top-level helper function:

```dart
Future<WorktreeDetail> _createWorktreeRpc(
  WorktreeServiceClient client, {
  required String name,
  required String repoId,
  required String branch,
  String? setupScript,
}) async {
  return client.createWorktree(
    CreateWorktreeRequest(
      name: name,
      repoId: repoId,
      branch: branch,
      setupScript: setupScript ?? '',
    ),
  );
}
```

Both notifiers call this helper then refresh their own state.

### Task 7: HeaderInterceptor Base Class

**Modifies:** `lib/core/grpc/interceptors.dart`
**Lines saved:** ~30

`AuthInterceptor` and `MachineIdInterceptor` have identical structure. Only
the header name and value provider differ. Extract:

```dart
abstract class HeaderInterceptor extends ClientInterceptor {
  CallOptions _addHeader(CallOptions options);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(...) =>
      invoker(method, request, _addHeader(options));

  @override
  ResponseStream<R> interceptStreaming<Q, R>(...) =>
      invoker(method, requests, _addHeader(options));
}
```

Both subclasses just implement `_addHeader`.

---

## test/ Tasks (14.68% → 10%)

### Task 8: FakeResponseFuture

**File:** `test/helpers/fake_response_future.dart` (new)
**Modifies:** All test files that define their own `FakeResponseFuture`
(at least 3: `repo_worktrees_provider_test.dart`,
`worktrees_notifier_test.dart`, `sessions_notifier_test.dart`,
`settings_notifier_test.dart`, `machines_notifier_test.dart`)
**Lines saved:** ~100

The same `FakeResponseFuture<T>` class is copy-pasted across multiple test
files. Move to a shared location and import.

### Task 9: createTestContainer

**File:** `test/helpers/test_container.dart` (new)
**Modifies:** Most notifier test files (8+)
**Lines saved:** ~300

Factory function:

```dart
ProviderContainer createTestContainer({
  GrpcConnectionStatus status = GrpcConnectionStatus.connected,
  List<Override> overrides = const [],
}) {
  return ProviderContainer(
    overrides: [
      connectionStatusProvider.overrideWithValue(
        AsyncData(status),
      ),
      ...overrides,
    ],
  );
}
```

Most tests currently build identical containers with only the service mock
varying. This helper handles the common `connectionStatusProvider` override
and merges any additional overrides.

### Task 10: Widget Pump Helpers

**File:** `test/helpers/pump_helpers.dart` (new)
**Modifies:** Widget test files (`router_test.dart`,
`worktrees_screen_test.dart`, `sessions_screen_test.dart`,
`machines_screen_test.dart`, `settings_screen_test.dart`)
**Lines saved:** ~200

Common patterns:
- `buildAuthApp({String? initialLocation, List<Override>? overrides})` —
  authenticated ProviderScope + MaterialApp.router
- `buildUnauthApp({String? initialLocation})` — unauthenticated variant
- `pumpAuthScreen(WidgetTester tester, Widget child, {List<Override>?})` —
  pump a screen inside an authenticated ProviderScope

These are currently defined as local functions in each test file with
identical implementations.

---

## Task Order

Tasks are mostly independent but should be done in this order:

1. **Task 3** (EmptyState) — no deps, simplest
2. **Task 2** (StatusBadge) — no deps, simple
3. **Task 5** (TappableCard) — no deps
4. **Task 4** (AsyncListScaffold) — depends on Task 3
5. **Task 1** (AuthFormScaffold) — largest, most complex
6. **Task 7** (HeaderInterceptor) — isolated, small
7. **Task 6** (Worktree notifier) — isolated, small
8. **Task 8** (FakeResponseFuture) — test, no deps
9. **Task 9** (createTestContainer) — test, no deps
10. **Task 10** (Widget pump helpers) — test, no deps

Tasks 8-10 (test helpers) can be done in parallel with any lib task.

---

## Verification

After all tasks, run:
```bash
npx jscpd lib/ --threshold 1
npx jscpd test/ --threshold 10
flutter test
```

All three must pass.
