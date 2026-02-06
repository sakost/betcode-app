# BetCode App - Roadmap

**Version**: 0.1.0
**Last Updated**: 2026-02-06
**Status**: Scaffolding

## Overview

The BetCode Flutter app is a mobile/web client for the BetCode system. It connects to the betcode-daemon via gRPC (directly on LAN or through a relay server) and provides a full conversation UI for Claude Code agent sessions.

The app is a **thin presentation layer** over gRPC. All agent intelligence, tool execution, and permission enforcement live in the daemon. The app renders events, captures user input, and manages offline queueing.

---

## Phase 1: Core Scaffold and Local Conversation

**Goal**: Basic app structure with gRPC connection to a local daemon and streaming conversation UI.

### 1.1 Project Setup
- Flutter project scaffold (Riverpod, go_router, drift, grpc)
- Protobuf Dart code generation from `proto/betcode/v1/*.proto`
- App shell with bottom navigation and routing
- Theme system (light/dark)

### 1.2 gRPC Client Layer
- `ClientManager` for channel lifecycle and connection state
- gRPC interceptors (logging, error handling)
- Connection to local daemon (direct IP/port for initial dev)
- `StreamProvider` for connection status

### 1.3 Conversation Screen
- Bidirectional streaming via `AgentService.Converse`
- Streaming text rendering (TextDelta accumulation into markdown)
- Tool call cards (ToolCallStart -> ToolCallResult, collapsible)
- Permission request bottom sheet (Allow Once / Allow Session / Deny)
- User question dialogs (single-select and multi-select)
- Todo list display (TodoUpdate events)
- Status indicators (Thinking, Executing Tool, Idle, Error)
- Usage report display (tokens, cost, model)
- Input bar with send button
- Turn cancellation

### 1.4 Session Management
- `AgentService.ListSessions` -> session list screen
- Session resume via `AgentService.ResumeSession`
- Session compaction via `AgentService.CompactSession`
- Sequence tracking for reconnection (`last_received_sequence`)

**Deliverable**: Working conversation app that connects to a running daemon on the local network.

---

## Phase 2: Offline Support and Local Storage

**Goal**: Drift database, offline queueing, cached session viewing.

### 2.1 Drift Database
- Table definitions: `sync_queue`, `cached_sessions`, `machines`, `settings`
- Migration strategy with schema versioning
- Database initialization on app start

### 2.2 Sync Engine
- Offline queue processor (`sync_queue` table)
- Priority-based drain (permission responses first, then messages)
- Exponential backoff on failures (1s -> 5s -> 30s -> 5min)
- Idempotency keys (UUIDv7) on all queued actions
- Queue TTL enforcement (7 days default)
- Sync status provider (pending count, errors, last sync time)

### 2.3 Connectivity Monitoring
- `connectivity_plus` integration for network state
- 3-second stability delay before processing queue on reconnect
- Connection state machine: DISCONNECTED -> CONNECTING -> CONNECTED -> RECONNECTING

### 2.4 Session Caching
- Snapshot session state to `cached_sessions` on each sync
- Offline viewing of conversation history
- Clear visual indicator when viewing cached (stale) data

**Deliverable**: App works offline (queues actions, shows cached sessions) and syncs on reconnect.

---

## Phase 3: Relay Authentication and Remote Access

**Goal**: Connect to daemons through the relay server with JWT authentication.

### 3.1 Auth Flow
- Registration screen (username, email, password)
- Login screen with JWT token handling
- `flutter_secure_storage` for JWT persistence (Keychain/Keystore)
- Token refresh via `AuthService.RefreshToken`
- Auto-refresh before expiry
- Logout with token revocation

### 3.2 Relay Connection
- `RelayClient` with JWT auth interceptor
- gRPC metadata injection (`authorization: Bearer <token>`)
- Version negotiation (`VersionService.GetVersion`, `NegotiateCapabilities`)
- Feature flag handling (enable/disable UI based on server capabilities)

### 3.3 Machine Management
- Machine list screen (`MachineService.ListMachines`)
- Machine status badges (online/offline/connecting)
- Machine switching (`MachineService.SwitchMachine`)
- Machine bookmarks in local `machines` table

### 3.4 Reconnection Logic
- gRPC stream reconnection with exponential backoff (100ms -> 1s -> 5s -> 30s)
- Resume from `last_received_sequence` on reconnect
- Event deduplication (ignore `sequence <= last_received`)
- Transparent reconnection (no user action required)

**Deliverable**: Full remote access to any registered machine through the relay.

---

## Phase 4: Multi-Machine, Worktrees, and Polish

**Goal**: Full feature set including worktrees, GitLab, notifications, and production readiness.

### 4.1 Worktree Management
- Worktree list per machine (`WorktreeService.ListWorktrees`)
- Create worktree (branch, name, path)
- Switch/remove worktrees
- Per-worktree session filtering

### 4.2 GitLab Integration
- MR list and detail views (`GitLabService.ListMergeRequests`)
- Pipeline status and job logs
- Issue list
- Deep links from conversation tool results to GitLab screens

### 4.3 Push Notifications
- FCM (Android) / APNs (iOS) registration
- Device token management with relay
- Permission request notifications (with reminder schedule: initial, +1h, +24h)
- Task completion notifications
- Notification preferences screen
- Collapse behavior (group rapid-fire requests)
- Rate limiting (5/hour per session, 20/day per user)

### 4.4 Input Lock
- Input lock request/transfer between clients
- Read-only mode when another client holds lock
- Visual indicator showing lock holder
- Lock timeout handling (10s for transfer request)

### 4.5 Settings Screen
- Permission rule management
- MCP server list (read-only view from daemon)
- Model selection
- Relay configuration (URL, account)
- Notification preferences
- Theme selection

### 4.6 Rate Limit Handling
- Parse `retry-after-ms` from RESOURCE_EXHAUSTED responses
- Exponential backoff with jitter (20% factor)
- User-facing toast/banner for rate limit events
- Proactive warning when `rate-limit-remaining < 3`

### 4.7 Production Polish
- Error handling across all screens (AsyncValue pattern)
- Loading states and skeleton screens
- Pull-to-refresh on list screens
- Search in session list
- Markdown rendering with syntax-highlighted code blocks
- Accessibility (semantic labels, contrast ratios)
- Localization infrastructure (notification keys from relay)

**Deliverable**: Production-ready mobile app with full BetCode feature set.

---

## Phase 5: Web and Advanced Features

**Goal**: Flutter web support and advanced orchestration visibility.

### 5.1 Flutter Web (PWA)
- gRPC-Web transport (requires proxy configuration)
- No offline sync (tab lifecycle is unpredictable)
- No push notifications
- Responsive layout for desktop browsers

### 5.2 Subagent Visibility
- Subagent list per session
- DAG visualization for orchestration plans
- Per-subagent event streams (via `parent_tool_use_id`)
- Subagent status badges

### 5.3 Direct LAN Mode
- mDNS daemon discovery on local network
- Direct mTLS connection (skip relay)
- Auto-prefer LAN over relay when available

---

## Platform Support Matrix

| Platform | Min Version | Transport | Secure Storage | Background Sync | Push |
|----------|-------------|-----------|---------------|-----------------|------|
| Android | SDK 24 (7.0) | OkHttp | Keystore | WorkManager | FCM |
| iOS | 15.0 | URLSession | Keychain | BGTaskScheduler | APNs |
| Web | Modern browsers | gRPC-Web | Encrypted localStorage | None | None |

---

## What the App Does NOT Do

The following are handled by the daemon or Claude Code, not the app:

- Agent intelligence (ReAct loop, tool selection, context management)
- Tool execution (Read, Write, Edit, Bash, Glob, Grep, etc.)
- MCP server lifecycle
- Permission evaluation logic (app only presents UI, daemon decides)
- CLAUDE.md resolution
- Git operations (worktree commands executed by daemon)
- Anthropic API calls (handled by Claude Code subprocess)
