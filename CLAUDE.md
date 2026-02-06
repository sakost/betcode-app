# BetCode App

Flutter mobile/web client for the BetCode system. Connects to betcode-daemon via gRPC to provide a mobile interface for Claude Code agent sessions.

## What This App Does

This is a **thin presentation layer** over gRPC. It does NOT talk to the Anthropic API or Claude Code directly. The daemon owns the agent loop, tool execution, and permission enforcement. This app multiplexes its I/O.

Key capabilities:
- Streaming conversation UI with tool cards and permission dialogs
- Machine list and switching (multi-machine support via relay)
- Session management (list, resume, search)
- Worktree CRUD per machine
- GitLab integration (pipelines, MRs, issues)
- Offline queue with sync engine (queue requests while disconnected, replay on reconnect)
- Push notifications for permissions and task completions

## Architecture

```
betcode_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── generated/                    # Protobuf generated code (DO NOT EDIT)
│   ├── core/
│   │   ├── grpc/
│   │   │   ├── client_manager.dart   # Channel lifecycle, reconnection
│   │   │   ├── relay_client.dart     # Relay connection with JWT
│   │   │   └── interceptors.dart     # JWT auth, logging, retry
│   │   ├── sync/
│   │   │   ├── sync_engine.dart      # Offline queue processor
│   │   │   └── connectivity.dart     # Network state monitor
│   │   ├── storage/
│   │   │   ├── database.dart         # drift (SQLite) ORM
│   │   │   └── secure_storage.dart   # Token/credential storage
│   │   └── auth/
│   │       └── auth_provider.dart    # JWT lifecycle
│   ├── features/
│   │   ├── conversation/             # Agent chat: streaming, tools, perms
│   │   ├── machines/                 # Machine list, status, switch
│   │   ├── worktrees/                # Worktree CRUD per machine
│   │   ├── gitlab/                   # Pipelines, MRs, issues
│   │   ├── settings/                 # Permissions, MCP, models, relay
│   │   └── sessions/                 # Session list, search, resume
│   └── shared/
│       ├── theme/
│       └── widgets/
├── test/
├── android/
├── ios/
├── web/
└── pubspec.yaml
```

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| State management | flutter_riverpod | Reactive providers, dependency injection |
| Routing | go_router | Declarative navigation |
| Local storage | drift (SQLite) | Offline cache, sync queue |
| Secure storage | flutter_secure_storage | JWT tokens, credentials |
| Network protocol | grpc + protobuf | Bidirectional streaming to daemon |
| Markdown rendering | flutter_markdown | Agent response display |
| Syntax highlighting | flutter_highlight | Code blocks in agent output |
| Connectivity | connectivity_plus | Network state monitoring |

## Key Dependencies

```yaml
dependencies:
  grpc: ^3.1.0
  protobuf: ^3.1.0
  flutter_riverpod: ^2.0.0
  drift: ^2.0.0
  flutter_secure_storage: ^9.0.0
  connectivity_plus: ^6.0.0
  flutter_markdown: ^0.7.0
  flutter_highlight: ^0.8.0
  go_router: ^14.0.0
```

## State Management Patterns

All state flows through Riverpod providers. Follow these patterns:

```dart
// Stream providers for real-time data (gRPC streams)
final conversationProvider = StreamProvider.family<AgentEvent, String>(
  (ref, sessionId) => ref.read(agentServiceClient).converse(sessionId),
);

// Future providers for fetched data (cached locally)
final machinesProvider = FutureProvider<List<Machine>>((ref) { ... });

// Stream providers for connection/sync status
final connectionProvider = StreamProvider<ConnectionState>((ref) =>
  ref.read(grpcClientManager).connectionState,
);
```

Rules:
- Use `StreamProvider` for gRPC streams and real-time state
- Use `FutureProvider` for one-shot fetches (machines, sessions, worktrees)
- Use `.family` modifier when provider depends on a parameter (session ID, machine ID)
- Never hold gRPC state outside of providers

## gRPC Communication

The app communicates exclusively through gRPC to the betcode-daemon. The primary RPC is the `Converse` bidirectional stream:

```
Client                              Daemon
  |-- StartConversation ----------->|
  |<-- SessionInfo -----------------|
  |-- UserMessage ----------------->|
  |<-- StatusChange(THINKING) ------|
  |<-- TextDelta (streaming) -------|
  |<-- ToolCallStart ----------------|
  |<-- ToolCallResult ---------------|
  |<-- PermissionRequest ------------|
  |-- PermissionResponse ---------->|
  |<-- TextDelta --------------------|
  |<-- UsageReport ------------------|
  |<-- StatusChange(IDLE) ----------|
```

Every `AgentEvent` carries a monotonic `sequence` number for reconnection.

### Reconnection Strategy

gRPC streams do not survive network interruptions:
1. Record `last_received_sequence`
2. Exponential backoff: 100ms -> 1s -> 5s -> 30s max
3. Re-establish stream with `ResumeSession { session_id, last_sequence }`
4. Daemon replays events from `last_sequence + 1`
5. Client deduplicates by ignoring `sequence <= last_received`

## Offline Sync Engine

Mobile-first design: user actions are instant (written to local drift DB), then synced via gRPC when online.

```
User action --> drift DB (instant) --> sync_queue --> gRPC (when online)
```

Priority queue order (highest first):
1. Permission responses (unblocks agent)
2. User question responses (unblocks agent)
3. Cancel requests (time-sensitive)
4. User messages (primary intent)
5. Session management (can wait)
6. Status/heartbeat (background)

Queue limit: 500 pending events. Queue TTL: 7 days.

Sync queue states: `PENDING -> SENDING -> SENT` (or `BLOCKED` / `FAILED`).

All user-initiated actions include idempotency keys (UUIDv7) to handle duplicate replays safely.

## Platform Targets

| Platform | Transport | Secure Storage | Background Sync | Push |
|----------|-----------|---------------|-----------------|------|
| Android (SDK 24+) | OkHttp | Keystore | WorkManager | FCM |
| iOS (15+) | URLSession | Keychain | BGTaskScheduler | APNs |
| Web | gRPC-Web | Encrypted localStorage | None | None |

Web has no offline sync and no push notifications.

## Coding Conventions

- **Dart style**: Follow official Dart style guide, `dart format` for formatting
- **File naming**: `snake_case.dart` for all files
- **Feature-first organization**: Group by feature (`features/conversation/`), not by type
- **Barrel exports**: Each feature directory has a barrel file (`conversation.dart`)
- **Immutable state**: Use `@freezed` or `@immutable` for all state classes
- **No business logic in widgets**: Widgets read from providers, logic lives in notifiers/services
- **Error handling**: Use `AsyncValue` from Riverpod, never catch-and-ignore
- **Generated code**: Never manually edit files in `generated/`. Regenerate from proto definitions.

## Build & Run

```bash
# Get dependencies
flutter pub get

# Generate drift and protobuf code
dart run build_runner build --delete-conflicting-outputs

# Run on connected device
flutter run

# Run on web (requires gRPC-Web proxy for daemon connection)
flutter run -d chrome

# Run tests
flutter test
```

## Protobuf Code Generation

Proto definitions live in the betcode repo at `proto/betcode/v1/`. Generated Dart code goes into `lib/generated/`.

```bash
# Generate from proto (requires protoc + dart protoc plugin)
protoc --dart_out=grpc:lib/generated/ \
  -Iproto/ \
  proto/betcode/v1/*.proto
```

## Screens

| Screen | Purpose |
|--------|---------|
| Conversation | Agent chat with streaming text, tool cards, permission dialogs |
| Sessions | List, resume, delete sessions, search by content |
| Machines | View connected machines, switch active, status badges |
| Worktrees | Create, switch, remove worktrees per machine |
| GitLab | Pipeline jobs, MR diffs, issues |
| Settings | Permission rules, MCP servers, model selection, relay config |
