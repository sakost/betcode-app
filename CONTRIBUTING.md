# Contributing to BetCode App

Thank you for your interest in contributing to BetCode App! This guide covers
everything you need to get started with the Flutter mobile client.

## Getting Started

### Prerequisites

- **Flutter SDK** 3.10+ (install via [flutter.dev](https://flutter.dev/docs/get-started/install))
- **Dart SDK** 3.10+ (included with Flutter)
- **protoc** (protobuf compiler) + Dart protoc plugin — for regenerating gRPC code
- **Android Studio** or **Xcode** — for running on device/emulator

### Setup

```bash
git clone https://github.com/sakost/betcode_app.git
cd betcode_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Making Changes

### Workflow

1. Fork the repository and clone your fork
2. Create a feature branch from `master` (`git checkout -b feat/my-feature`)
3. Make your changes, adding tests for new features
4. Run quality checks (see below)
5. Commit using [conventional commit](#commit-messages) messages
6. Push your branch and open a pull request

### Quality Gates

Run all of these before submitting a PR:

```bash
flutter analyze        # Static analysis
flutter test           # Run test suite
dart format --set-exit-if-changed .  # Check formatting
```

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/), consistent
with the [main BetCode repository](https://github.com/sakost/betcode). Every
commit message must follow this format:

```
type(scope): short description

Optional longer body explaining context and reasoning.

BREAKING CHANGE: description of what breaks (if applicable)
```

### Types

| Type | When to use |
|------|-------------|
| `feat` | New feature or functionality |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `ci` | CI/CD pipeline changes |
| `chore` | Maintenance tasks (deps, config, tooling) |
| `style` | Formatting, linting fixes (no logic change) |

### Scopes

Scopes are optional but encouraged. Use feature names or cross-cutting concerns:

`conversation`, `machines`, `sessions`, `worktrees`, `gitlab`, `settings`,
`grpc`, `sync`, `storage`, `auth`, `theme`

### Breaking Changes

For breaking changes, add `!` after the type/scope and include a
`BREAKING CHANGE:` footer:

```
feat(grpc)!: update to v2 session protocol

Migrated all gRPC calls to the v2 session API.

BREAKING CHANGE: Requires betcode-daemon v0.3+ with v2 proto support.
```

## Pull Request Requirements

All of the following must be satisfied before a PR can be merged:

- **CI passes** — analyze, test, and format checks
- **Tests included** — new features must have tests; bug fixes should add a
  regression test where practical
- **Conventional commits** — all commits in the PR follow the convention
- **PR title** — follows conventional commit format

### What We Look For

- Clean, focused changes — one concern per PR
- Tests that cover the new behavior
- No unnecessary dependency additions
- No business logic in widgets — logic lives in notifiers/services
- `@freezed` / `@immutable` for all state classes
- `AsyncValue` from Riverpod for error handling, never catch-and-ignore

### What We Won't Merge

- Proto contract changes without prior coordination (open an issue first)
- Features without tests
- PRs that don't pass CI
- Cosmetic-only refactors unless they measurably improve code quality

## Code Standards

Follow these conventions (also documented in `CLAUDE.md`):

- **Dart style**: Follow the official [Dart style guide](https://dart.dev/effective-dart/style), use `dart format`
- **File naming**: `snake_case.dart` for all files
- **Feature-first organization**: Group by feature (`features/conversation/`), not by type
- **Immutable state**: Use `@freezed` or `@immutable` for all state classes
- **No business logic in widgets**: Widgets read from providers, logic lives in notifiers/services
- **Error handling**: Use `AsyncValue` from Riverpod, never catch-and-ignore
- **Generated code**: Never manually edit files in `lib/generated/`

## Adding Dependencies

1. Check that the dependency's license is compatible — permitted licenses:
   **MIT**, **Apache-2.0**, **BSD-2-Clause**, **BSD-3-Clause**, **ISC**
2. Add to `pubspec.yaml` under the appropriate section with a comment
3. Run `flutter pub get`
4. If the dependency introduces a license type not already listed in
   `THIRD-PARTY-LICENSES.md`, update that file

## Proto Changes

The protobuf definitions are shared between the backend and the mobile app.
Proto source files live in the [main BetCode repository](https://github.com/sakost/betcode)
at `proto/betcode/v1/`.

- **Non-breaking additions** (new fields, new RPCs, new messages): can ship
  in any release
- **Breaking changes** (field removals, type changes, removed RPCs):
  1. Open an issue to discuss the change
  2. Coordinate with the main repository
  3. Both repos must be updated before either is released

To regenerate Dart code from proto definitions:

```bash
protoc --dart_out=grpc:lib/generated/ \
  -Iproto/ \
  proto/betcode/v1/*.proto
```

See the main repo's [CONTRIBUTING.md](https://github.com/sakost/betcode/blob/master/CONTRIBUTING.md)
for the full proto change policy.

## Reporting Issues

- **Bug reports**: Open an issue with steps to reproduce, expected vs. actual
  behavior, and device/OS info
- **Feature requests**: Open an issue describing the use case and proposed solution
- **Security issues**: Email the maintainer directly — **do not open a public issue**.
  See [SECURITY.md](SECURITY.md) for details.

Look for issues labeled `good first issue` if you're new, or `help wanted`
for more substantial tasks.

## Review Process

All PRs are reviewed by a maintainer. Expect feedback within a few days.
Small fixes may be merged quickly; larger features may need iteration.

If your PR sits without review for more than a week, feel free to ping.

## License

By contributing to BetCode App, you agree that your contributions will be
licensed under the [MIT](LICENSE-MIT) or [Apache-2.0](LICENSE-APACHE) license,
at the user's option.

Note: The [main BetCode repository](https://github.com/sakost/betcode) uses
Apache-2.0 only. This repository is dual-licensed under MIT OR Apache-2.0.
