# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability in BetCode App, **please report it privately** by emailing the maintainer directly. **Do not open a public issue.**

Contact: [Konstantin Sazhenov](https://github.com/sakost) (reach out via GitHub profile for email)

We will acknowledge receipt within 48 hours and aim to provide a fix or mitigation plan within 7 days for confirmed vulnerabilities.

## Scope

BetCode App is a Flutter mobile client. Security concerns specific to this repository include:

- **Secure storage** — JWT tokens and credentials stored via `flutter_secure_storage` (Keystore on Android, Keychain on iOS)
- **Network transport** — gRPC communication to the daemon/relay (TLS, certificate validation)
- **JWT handling** — Token lifecycle, refresh, and expiry
- **Local data** — SQLite database contents (drift), offline sync queue
- **Input handling** — Markdown rendering, user input sanitization

For security concerns related to the backend (daemon, relay, mTLS, subprocess sandboxing), please refer to the [main BetCode repository's security documentation](https://github.com/sakost/betcode).

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.x   | Yes (current pre-release) |

## Disclosure Policy

- Vulnerabilities will be disclosed publicly after a fix is available
- Credit will be given to reporters unless they prefer to remain anonymous
- We follow coordinated disclosure — please allow reasonable time for a fix before public disclosure
