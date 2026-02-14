# BetCode App

**Flutter mobile client for Claude Code agent sessions via gRPC.**

> **Disclaimer**: BetCode is an independent, community-driven project. It is **not** affiliated with, endorsed by, or sponsored by Anthropic or the Claude team. Claude and Claude Code are products of Anthropic. BetCode simply wraps the publicly available Claude Code CLI.

---

## Status

**v0.1.0** — Pre-release. See [CLAUDE.md](CLAUDE.md) for architecture details.

---

## What It Does

BetCode App is a **thin presentation layer** over gRPC. It does not talk to the Anthropic API or Claude Code directly. The [betcode-daemon](https://github.com/sakost/betcode) owns the agent loop, tool execution, and permission enforcement. This app multiplexes its I/O.

### Key Features

- **Streaming conversation UI** — Real-time agent chat with tool cards and permission dialogs
- **Machine management** — View connected machines, switch active machine, status monitoring
- **Session management** — List, resume, delete, and search sessions
- **Worktree CRUD** — Create, switch, and remove Git worktrees per machine
- **GitLab integration** — Pipeline jobs, merge request diffs, issues
- **Offline queue** — Queue requests while disconnected, replay on reconnect

---

## Architecture

```
Flutter App  ──gRPC──>  betcode-daemon  ──subprocess──>  claude (CLI)
                              │
                         betcode-relay (optional, for multi-machine)
```

The app communicates exclusively through gRPC bidirectional streaming. All state flows through Riverpod providers. See [CLAUDE.md](CLAUDE.md) for the full architecture, tech stack, and coding conventions.

---

## Prerequisites

- **Flutter SDK** 3.10+
- A running **betcode-daemon** instance to connect to
- For development: **protoc** + Dart protoc plugin (for gRPC code generation)

---

## Quick Start

```bash
git clone https://github.com/sakost/betcode_app.git
cd betcode_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Related

- [betcode](https://github.com/sakost/betcode) — Main repository (daemon, relay, CLI, proto definitions)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for setup instructions, code quality standards, commit conventions, and PR requirements.

---

## License

Licensed under either of

- [Apache License, Version 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)

at your option.

```
Copyright 2026 Konstantin Sazhenov
```

---

## Disclaimer

This project is **not** affiliated with, endorsed by, or sponsored by [Anthropic](https://www.anthropic.com/). "Claude" and "Claude Code" are trademarks or products of Anthropic, PBC. BetCode is an independent open-source project that wraps the publicly available Claude Code CLI. Use of Claude Code is subject to Anthropic's own terms of service.
