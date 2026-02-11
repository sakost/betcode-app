import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/core/grpc/relay_config.dart';

void main() {
  group('RelayConfig', () {
    test('isValid returns true for valid config', () {
      const config = RelayConfig(host: 'relay.example.com', port: 443);
      expect(config.isValid, isTrue);
    });

    test('isValid returns false for empty host', () {
      const config = RelayConfig(host: '', port: 443);
      expect(config.isValid, isFalse);
    });

    test('isValid returns false for port 0', () {
      const config = RelayConfig(host: 'relay.example.com', port: 0);
      expect(config.isValid, isFalse);
    });

    test('isValid returns false for port above 65535', () {
      const config = RelayConfig(host: 'relay.example.com', port: 65536);
      expect(config.isValid, isFalse);
    });

    test('isValid returns true for port 65535', () {
      const config = RelayConfig(host: 'relay.example.com', port: 65535);
      expect(config.isValid, isTrue);
    });

    test('isValid returns true for port 1', () {
      const config = RelayConfig(host: 'relay.example.com', port: 1);
      expect(config.isValid, isTrue);
    });

    test('fromEnvironment uses defaults', () {
      // Without --dart-define, host is empty, port 443, useTls true
      final config = RelayConfig.fromEnvironment();
      expect(config.host, '');
      expect(config.port, 443);
      expect(config.useTls, isTrue);
    });

    test('equality works for identical configs', () {
      const a = RelayConfig(host: 'h', port: 443, useTls: true);
      const b = RelayConfig(host: 'h', port: 443, useTls: true);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality fails for different configs', () {
      const a = RelayConfig(host: 'h1', port: 443);
      const b = RelayConfig(host: 'h2', port: 443);
      expect(a, isNot(equals(b)));
    });

    test('useTls defaults to true', () {
      const config = RelayConfig(host: 'h', port: 443);
      expect(config.useTls, isTrue);
    });

    test('isValid returns false for negative port', () {
      const config = RelayConfig(host: 'relay.example.com', port: -1);
      expect(config.isValid, isFalse);
    });
  });
}
