# BetCode App - Data Flow

**Version**: 0.1.0
**Last Updated**: 2026-02-06

## System Context

```
                    +-------------------+
                    |   betcode-relay   |
                    |  (gRPC router)    |
                    +--------+----------+
                             |
                     TLS + JWT (remote)
                             |
+-------------------+        |        +-------------------+
|   betcode_app     |--------+--------|  betcode-daemon   |
|   (this app)      |                 |  (Rust server)    |
+-------------------+   gRPC bidi     +-------------------+
                        streaming           |
                                     Claude Code subprocess
                                            |
                                     Anthropic API
```

The app is a thin client. All intelligence lives in the daemon/Claude Code. The app's job:
1. Render agent events as they stream in
2. Capture user input and send it upstream
3. Handle offline scenarios gracefully
4. Manage authentication and machine selection

---

## Connection Flow

```
App Launch
  |
  v
Check secure storage for JWT
  |
  +-- No JWT --> Login/Register screen
  +-- Has JWT --> Check token expiry
        |
        +-- Expired --> RefreshToken RPC --> Success: continue / Failure: login
        +-- Valid --> Continue
              |
              v
        GetVersion + NegotiateCapabilities
              |
              +-- Incompatible --> Show upgrade prompt
              +-- Compatible --> Load machine list, resume last session
```

### Connection State Machine

```
DISCONNECTED -- connect() --> CONNECTING -- success --> AUTHENTICATING
                                  |                        |
                                  +-- failure              +-- JWT valid --> CONNECTED
                                  |                        +-- auth fail --> DISCONNECTED
                                  v
                            RECONNECTING (exp backoff: 100ms -> 1s -> 5s -> 30s max)
                                  ^
                                  |-- network loss
                              CONNECTED
```

---

## Conversation Data Flow

### Sending a Message

```
User taps Send
  |
  +-- Online + has input lock:
  |     Send UserMessage via Converse stream
  |     Wait for StatusChange(THINKING)
  |
  +-- Online + no input lock:
  |     Show "Another device controls this session"
  |     Offer "Request Input Lock"
  |
  +-- Offline:
        Write to sync_queue (drift DB), priority = 3
        idempotency_key = UUIDv7
        Show "Queued - will send when online"
```

### Receiving Events

```
gRPC stream delivers AgentEvent --> Record event.sequence
  |
  +-- TextDelta ---------> Append to message bubble, render markdown
  +-- ToolCallStart -----> Add tool card (collapsed), show spinner
  +-- ToolCallResult ----> Update tool card with result, stop spinner
  +-- PermissionRequest -> Show permission bottom sheet
  +-- UserQuestion ------> Show question dialog
  +-- TodoUpdate --------> Update task list widget
  +-- StatusChange ------> Update status indicator in app bar
  +-- SessionInfo -------> Store session metadata
  +-- ErrorEvent --------> Toast (non-fatal) or dialog (fatal)
  +-- UsageReport -------> Update token/cost display
  +-- PlanModeChange ----> Toggle plan mode indicator
  +-- TurnComplete ------> Enable input bar, status = IDLE
```

### Permission Flow

```
Server sends PermissionRequest --> Show bottom sheet:
  [Tool: Bash] [Command: cargo test]
  [Allow Once] [Allow Session] [Deny]
  |
  +-- Online: Send PermissionResponse via stream
  +-- Offline: Queue in sync_queue, priority = 0 (highest)
```

---

## Offline Sync Engine

### Queue Architecture

```
User Action --> drift DB (instant UI) --> sync_queue --> Sync Engine
  |
  +-- ONLINE: Drain by priority then FIFO
  |     +-- Success --> mark 'sent', remove
  |     +-- Transient failure --> backoff, keep queued
  |     +-- Permanent failure --> mark 'failed', notify user
  |
  +-- OFFLINE: Wait for connectivity change
        On reconnect: 3s stability delay, then drain
```

### Priority Queue

| Priority | Type | Rationale |
|----------|------|-----------|
| 0 | Permission responses | Unblocks agent work |
| 1 | User question responses | Unblocks agent work |
| 2 | Cancel requests | Time-sensitive |
| 3 | User messages | Primary user intent |
| 4 | Session management | Can wait |
| 5 | Status/heartbeat | Background |

### Sync Queue States

```
PENDING --> SENDING --> SENT (removed)
               |
               +-- transient error --> BLOCKED (retry with backoff)
               +-- permanent error --> FAILED (removed, user notified)
```

### Conflict Resolution

Daemon is source of truth. Client queue contains intents, not facts.

| Conflict | Detection | Resolution |
|----------|-----------|------------|
| Message to closed session | NOT_FOUND | Remove, offer new session |
| Permission for expired request | FAILED_PRECONDITION | Remove, notify "expired" |
| Message while another client has lock | PERMISSION_DENIED | BLOCKED, offer "Request Lock" |
| Duplicate replay (network glitch) | Idempotency key match | Server returns success |
| Worktree removed while offline | NOT_FOUND | Remove, refresh list |
| Session compacted past cache | `is_compacted = true` | Clear cache, rebuild |

All user actions include `idempotency_key` (UUIDv7). Daemon deduplicates within 24h.

---

## State Management (Riverpod)

### Provider Hierarchy

```
connectionProvider (StreamProvider<ConnectionState>)
  |
  +-- authProvider (StateNotifierProvider<AuthNotifier, AuthState>)
  |     +-- machinesProvider (FutureProvider<List<Machine>>)
  |     +-- sessionsProvider (FutureProvider<List<SessionSummary>>)
  |
  +-- conversationProvider.family(sessionId) (StreamProvider<AgentEvent>)
  |     +-- messagesProvider.family(sessionId) -- accumulated message list
  |     +-- statusProvider.family(sessionId) -- current agent status
  |     +-- usageProvider.family(sessionId) -- token/cost tracking
  |     +-- todosProvider.family(sessionId) -- task list
  |
  +-- syncStatusProvider (StreamProvider<SyncStatus>)
  +-- worktreesProvider.family(machineId) (FutureProvider<List<WorktreeInfo>>)
```

### Rules

- `StreamProvider` for real-time gRPC streams and connection state
- `FutureProvider` for one-shot fetches (machines, sessions, worktrees)
- `.family` modifier when provider needs a parameter
- `StateNotifierProvider` for complex state with mutations (auth, settings)
- No business logic in widgets; all logic in notifiers/services
- Use `AsyncValue` pattern for loading/error/data in UI

---

## Push Notification Flow

```
Relay detects: no client holds input lock
  --> Send push via FCM (Android) / APNs (iOS)
      |
      +-- App foreground: Suppressed (gRPC stream has the data)
      +-- App background: Show notification, tap opens screen
      +-- App terminated: Show notification, tap launches with deep link
```

| Event | Priority | Reminders |
|-------|----------|-----------|
| PermissionRequest | HIGH | Initial, +1h, +24h |
| UserQuestion | HIGH | Initial, +1h, +24h |
| StatusChange(ERROR) | HIGH | Initial only |
| Task completion | NORMAL | Initial only |

Rate limits: 5/hour per session, 20/day per user, 5-min collapse window.

---

## Reconnection Strategy

```
Stream drops --> Record last_received_sequence
  --> Exponential backoff: 100ms -> 1s -> 5s -> 30s max
  --> Re-establish Converse stream with same session_id
  --> ResumeSession from last_received_sequence
  --> Daemon replays from last_sequence + 1
  --> Client ignores sequence <= last_received
  --> Resume live streaming
```

If compacted past cached point: daemon returns `is_compacted = true`, client clears cache and rebuilds from SessionInfo.

---

## Security Data Flow

### Token Storage

| Platform | Mechanism |
|----------|-----------|
| Android | Android Keystore via flutter_secure_storage |
| iOS | iOS Keychain via flutter_secure_storage |
| Web | Encrypted localStorage via flutter_secure_storage |

### Auth Header Injection

Every gRPC call through relay: `metadata: { "authorization": "Bearer <token>" }`
Injected by `AuthInterceptor` in `core/grpc/interceptors.dart`.

### Token Refresh

```
AuthInterceptor detects expiry approaching
  --> RefreshToken RPC
      +-- Success: Store new tokens, retry request
      +-- Failure: Clear tokens, redirect to login
```
