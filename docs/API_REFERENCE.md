# BetCode App - gRPC API Reference

**Version**: 0.1.0
**Last Updated**: 2026-02-06

The Flutter app communicates exclusively via gRPC to the betcode-daemon (directly or through the relay). This document describes every RPC and message type the app uses.

Proto definitions: `proto/betcode/v1/*.proto`
Generated Dart code: `lib/generated/`

---

## Services

| Service | Proto File | Purpose |
|---------|-----------|---------|
| AgentService | agent.proto | Conversation streaming, session management |
| AuthService | auth.proto | JWT login, registration, token refresh |
| MachineService | machine.proto | Machine list, switching |
| WorktreeService | worktree.proto | Worktree CRUD per machine |
| ConfigService | config.proto | Settings, permissions, MCP servers |
| GitLabService | gitlab.proto | MRs, pipelines, issues |
| HealthService | health.proto | Daemon/relay health checks |
| VersionService | version.proto | Version negotiation, capabilities |

---

## AgentService

The primary service. Handles all conversation interaction.

### Converse (bidirectional stream)

```
rpc Converse(stream AgentRequest) returns (stream AgentEvent)
```

The main interaction RPC. Opens a bidirectional stream for real-time conversation.

**Client sends** (`AgentRequest` oneof):

| Message | When | Fields |
|---------|------|--------|
| `StartConversation` | First message in stream | `session_id` (empty=new), `working_directory`, `model`, `allowed_tools`, `plan_mode`, `worktree_id`, `metadata` |
| `UserMessage` | User types a message | `content`, `attachments[]` |
| `PermissionResponse` | User approves/denies tool | `request_id`, `decision` (ALLOW_ONCE, ALLOW_SESSION, DENY) |
| `UserQuestionResponse` | User answers a question | `question_id`, `answers` (map) |
| `CancelRequest` | User cancels current turn | `reason` |

**Server sends** (`AgentEvent` oneof, each with `sequence` + `timestamp`):

| Event | When | Key Fields |
|-------|------|------------|
| `SessionInfo` | After StartConversation | `session_id`, `model`, `working_directory`, `is_resumed`, `is_compacted`, `context_usage_percent` |
| `TextDelta` | Agent streaming text | `text`, `is_complete` |
| `ToolCallStart` | Agent invokes a tool | `tool_id`, `tool_name`, `input` (Struct), `description` |
| `ToolCallResult` | Tool execution done | `tool_id`, `output`, `is_error`, `duration_ms` |
| `PermissionRequest` | Tool needs user approval | `request_id`, `tool_name`, `description`, `input` |
| `UserQuestion` | Agent asks user a question | `question_id`, `question`, `options[]`, `multi_select` |
| `TodoUpdate` | Task list changed | `items[]` (id, subject, description, active_form, status) |
| `StatusChange` | Agent state changed | `status` (THINKING, EXECUTING_TOOL, WAITING_FOR_USER, IDLE, COMPACTING, ERROR), `message` |
| `ErrorEvent` | Error occurred | `code`, `message`, `is_fatal`, `details` (map) |
| `UsageReport` | Turn token usage | `input_tokens`, `output_tokens`, `cache_read_tokens`, `cache_creation_tokens`, `model`, `cost_usd`, `duration_ms` |
| `PlanModeChange` | Plan mode toggled | `active`, `plan` |
| `TurnComplete` | Agent finished turn | `stop_reason` |

**Stream lifecycle**:
1. Client sends `StartConversation` (empty `session_id` = new session)
2. Server sends `SessionInfo`
3. Client sends `UserMessage`, server streams events until `TurnComplete`
4. Multiple turns within one stream
5. Either side can close; Claude subprocess continues if turn active

**Reconnection**: Client tracks `last_received_sequence`. On disconnect, reopen stream with same `session_id`. Daemon replays from `last_sequence + 1`. Client ignores `sequence <= last_received`.

### ListSessions

```
rpc ListSessions(ListSessionsRequest) returns (ListSessionsResponse)
```

| Request Field | Type | Description |
|---------------|------|-------------|
| `working_directory` | string | Filter by directory (optional) |
| `worktree_id` | string | Filter by worktree (optional) |
| `limit` | uint32 | Pagination limit |
| `offset` | uint32 | Pagination offset |

Returns `ListSessionsResponse` with `sessions[]` (`SessionSummary`) and `total` count.

`SessionSummary` fields: `id`, `model`, `working_directory`, `worktree_id`, `status`, `message_count`, `total_input_tokens`, `total_output_tokens`, `total_cost_usd`, `created_at`, `updated_at`, `last_message_preview`.

### ResumeSession

```
rpc ResumeSession(ResumeSessionRequest) returns (stream AgentEvent)
```

Server-side stream that replays historical events from `from_sequence`. Use this to restore conversation history after app restart or reconnection.

To send new messages on a resumed session, open a `Converse` stream with the same `session_id`. Both streams can be active simultaneously.

### CompactSession

```
rpc CompactSession(CompactSessionRequest) returns (CompactSessionResponse)
```

Triggers context compaction. Only works when session is IDLE (no active turn). Returns `messages_before`, `messages_after`, `tokens_saved`.

### CancelTurn

```
rpc CancelTurn(CancelTurnRequest) returns (CancelTurnResponse)
```

Cancels the current agent turn. Returns `was_active` (true if a turn was running).

### RequestInputLock

```
rpc RequestInputLock(InputLockRequest) returns (InputLockResponse)
```

Requests exclusive input lock for a session. Returns `granted` and `previous_holder`.

---

## AuthService

JWT authentication for relay access.

### Login

```
rpc Login(LoginRequest) returns (LoginResponse)
```

| Field | Direction | Description |
|-------|-----------|-------------|
| `username` | Request | User identifier |
| `password` | Request | Plaintext password (over TLS) |
| `access_token` | Response | Short-lived JWT (15 min) |
| `refresh_token` | Response | Long-lived token (7 days) |
| `expires_in_secs` | Response | Access token lifetime |
| `user_id` | Response | User identifier |

### Register

```
rpc Register(RegisterRequest) returns (RegisterResponse)
```

Fields: `username`, `password`, `email` -> returns `user_id`, `access_token`, `refresh_token`, `expires_in_secs`.

### RefreshToken

```
rpc RefreshToken(RefreshTokenRequest) returns (RefreshTokenResponse)
```

Exchange expired access token for a new pair. Send `refresh_token`, receive new `access_token` + `refresh_token`.

### RevokeToken

```
rpc RevokeToken(RevokeTokenRequest) returns (RevokeTokenResponse)
```

Revoke a refresh token on logout.

---

## MachineService

Machine management (available through relay).

### ListMachines

```
rpc ListMachines(ListMachinesRequest) returns (ListMachinesResponse)
```

Returns all machines owned by the authenticated user.

`Machine` fields: `id`, `name`, `hostname`, `status` (ONLINE/OFFLINE/CONNECTING), `capabilities[]`, `last_seen`, `worktrees[]`, `resources` (os, cpu_cores, memory_bytes, disk_free_bytes).

### GetMachine / SwitchMachine

Standard CRUD. `SwitchMachine` returns the new active machine and `previous_machine_id`.

---

## WorktreeService

Git worktree management per machine.

| RPC | Description |
|-----|-------------|
| `ListWorktrees` | List worktrees for a repo path |
| `CreateWorktree` | Create new worktree (branch, name, path, create_branch flag) |
| `SwitchWorktree` | Switch active worktree |
| `RemoveWorktree` | Remove worktree (with force option, returns `sessions_closed` count) |

`WorktreeInfo` fields: `id`, `name`, `path`, `branch`, `created_at`, `active_session_id`.

---

## ConfigService

```
rpc GetSettings(GetSettingsRequest) returns (Settings)
rpc UpdateSettings(UpdateSettingsRequest) returns (Settings)
rpc ListMcpServers(ListMcpServersRequest) returns (ListMcpServersResponse)
rpc GetPermissions(GetPermissionsRequest) returns (PermissionRules)
```

Read and update daemon settings, list MCP servers, view permission rules.

---

## GitLabService

```
rpc ListMergeRequests(ListMrsRequest) returns (ListMrsResponse)
rpc GetMergeRequest(GetMrRequest) returns (MergeRequestInfo)
rpc ListPipelines(ListPipelinesRequest) returns (ListPipelinesResponse)
rpc GetPipelineJobs(GetJobsRequest) returns (GetJobsResponse)
rpc GetJobLog(GetJobLogRequest) returns (GetJobLogResponse)
rpc ListIssues(ListIssuesRequest) returns (ListIssuesResponse)
```

Read-only GitLab integration. Data fetched by the daemon's GitLab API client.

---

## VersionService

```
rpc GetVersion(GetVersionRequest) returns (GetVersionResponse)
rpc NegotiateCapabilities(NegotiateRequest) returns (NegotiateResponse)
```

**GetVersionResponse**: `api_version`, `server_version`, `features[]`, `claude_code` (version, api_version, compatibility), `constraints` (min_client_version, recommended_client, deprecated_features).

**NegotiateRequest**: `client_version`, `client_type` ("flutter"), `requested_features[]`, `client_capabilities`.

**NegotiateResponse**: `accepted`, `rejection_reason`, `upgrade_url`, `granted_features[]`, `warnings[]`, `capabilities` (streaming, compression, max_message_size, available_tools, available_models, feature_flags).

Client MUST call `GetVersion` + `NegotiateCapabilities` before establishing sessions. If `accepted = false`, show upgrade prompt.

---

## Error Codes

### gRPC Status Codes Used

| Status | When | Client Action |
|--------|------|---------------|
| OK (0) | Success | Process response |
| CANCELLED (1) | Client cancelled | No action |
| INVALID_ARGUMENT (3) | Bad request | Fix request, don't retry |
| NOT_FOUND (5) | Session/worktree/machine gone | Refresh list |
| PERMISSION_DENIED (7) | Auth failed or no input lock | Re-auth or request lock |
| RESOURCE_EXHAUSTED (8) | Rate limit or capacity | Backoff per `retry-after-ms` |
| FAILED_PRECONDITION (9) | Invalid state | Check state, retry if appropriate |
| UNAVAILABLE (14) | Server temporarily down | Retry with backoff |
| UNAUTHENTICATED (16) | Missing/invalid credentials | Re-authenticate |

### Application Error Codes (in `ErrorEvent.code`)

| Code | Meaning | Client Action |
|------|---------|---------------|
| `SESSION_NOT_FOUND` | Session doesn't exist | Refresh session list |
| `SESSION_CLOSED` | Session ended | Start new session |
| `SESSION_ACTIVE` | Turn in progress | Wait for TurnComplete |
| `WORKTREE_NOT_FOUND` | Worktree deleted | Refresh worktree list |
| `MACHINE_OFFLINE` | Target machine disconnected | Wait or buffer |
| `NO_INPUT_LOCK` | Another client holds lock | Request lock or observe |
| `PERMISSION_TIMEOUT` | Permission request expired | Auto-denied, retry operation |
| `POOL_EXHAUSTED` | No subprocess slots | Retry with backoff |
| `RATE_LIMITED` | Rate limit exceeded | Backoff per `retry-after-ms` in details |
| `SUBPROCESS_CRASHED` | Claude process died | Auto-restart in progress |

### Rate Limit Response Metadata

On `RESOURCE_EXHAUSTED`, check gRPC trailing metadata:

| Key | Type | Description |
|-----|------|-------------|
| `retry-after-ms` | int | Minimum wait before retry |
| `rate-limit-limit` | int | Total allowed in window |
| `rate-limit-remaining` | int | Remaining in window |
| `rate-limit-reset` | int | Unix timestamp when window resets |

### Rate Limit Backoff Algorithm

```
base_delay = retry_after_ms (or 1000ms default)
max_delay = 300000ms (5 minutes)
jitter_factor = 0.2

for attempt in 1..max_attempts:
    delay = min(base_delay * 2^(attempt-1), max_delay)
    jitter = delay * jitter_factor * random(-1, 1)
    sleep(delay + jitter)
    retry...
```

`max_attempts`: 5 for interactive, 10 for background sync.
