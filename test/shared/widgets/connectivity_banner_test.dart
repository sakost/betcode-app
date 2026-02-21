import 'package:betcode_app/core/grpc/connection_state.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/sync/connectivity.dart';
import 'package:betcode_app/shared/widgets/connectivity_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityBanner', () {
    Widget buildApp({
      AsyncValue<GrpcConnectionStatus> connectionStatus = const AsyncData(
        GrpcConnectionStatus.connected,
      ),
      AsyncValue<NetworkStatus> networkStatus = const AsyncData(
        NetworkStatus.online,
      ),
    }) {
      return ProviderScope(
        overrides: [
          connectionStatusProvider.overrideWith(
            (_) => connectionStatus.when(
              data: Stream.value,
              loading: () => const Stream<GrpcConnectionStatus>.empty(),
              error: Stream<GrpcConnectionStatus>.error,
            ),
          ),
          networkStatusProvider.overrideWith(
            (_) => networkStatus.when(
              data: Stream.value,
              loading: () => const Stream<NetworkStatus>.empty(),
              error: Stream<NetworkStatus>.error,
            ),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ConnectivityBanner(),
                Expanded(child: Placeholder()),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('hidden when online and connected', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('No internet connection'), findsNothing);
      expect(find.text('Relay unreachable'), findsNothing);
    });

    testWidgets('shows offline banner when network is offline', (tester) async {
      await tester.pumpWidget(
        buildApp(
          networkStatus: const AsyncData(NetworkStatus.offline),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet'), findsOneWidget);
    });

    testWidgets('shows relay banner when disconnected but online', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          connectionStatus: const AsyncData(GrpcConnectionStatus.reconnecting),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('reconnecting'), findsOneWidget);
    });
  });
}
