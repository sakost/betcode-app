import 'dart:async';

import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/features/conversation/models/conversation_state.dart';
import 'package:betcode_app/features/conversation/notifiers/conversation_providers.dart';
import 'package:betcode_app/generated/betcode/v1/agent.pb.dart' as pb;
import 'package:betcode_app/generated/betcode/v1/agent.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart' show Override;

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockAgentServiceClient extends Mock implements AgentServiceClient {}

class _FakeResponseStream<T> extends Fake implements ResponseStream<T> {
  _FakeResponseStream(this._controller);
  final StreamController<T> _controller;

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

/// A minimal app widget that hosts the conversation notifier and displays
/// state information for assertions.
class _TestApp extends ConsumerWidget {
  const _TestApp({required this.overrides});
  final List<Override> overrides;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(conversationProvider(null));
            final stateVal = state.value;
            String label;
            if (stateVal is ConversationActive) {
              label = stateVal.errorMessage ?? 'active';
            } else if (stateVal is ConversationError) {
              label = 'error:${stateVal.message}';
            } else if (stateVal is ConversationConnecting) {
              label = 'connecting';
            } else {
              label = 'initial';
            }
            return Scaffold(
              body: Center(child: Text(label, key: const Key('state'))),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lifecycle helpers
// ---------------------------------------------------------------------------

/// Transitions the app to background through the proper lifecycle sequence:
/// resumed → inactive → hidden → paused.
///
/// IMPORTANT: Do NOT call `tester.pump()` while the app is in `paused` state —
/// `SchedulerBinding` disables frames when paused, causing `pump()` to hang.
void simulateAppBackground(WidgetTester tester) {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
}

/// Transitions the app to foreground through the proper lifecycle sequence:
/// paused → hidden → inactive → resumed.
void simulateAppForeground(WidgetTester tester) {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
}

void main() {

  late MockAgentServiceClient mockClient;
  late StreamController<pb.AgentEvent> eventController;

  setUpAll(() {
    registerFallbackValue(const Stream<pb.AgentRequest>.empty());
    registerFallbackValue(pb.ResumeSessionRequest());
  });

  setUp(() {
    mockClient = MockAgentServiceClient();
    eventController = StreamController<pb.AgentEvent>();

    when(() => mockClient.converse(any())).thenAnswer((inv) {
      (inv.positionalArguments[0] as Stream<pb.AgentRequest>).listen((_) {});
      return _FakeResponseStream<pb.AgentEvent>(eventController);
    });
  });

  tearDown(() {
    if (!eventController.isClosed) {
      unawaited(eventController.close());
    }
  });

  group('Reconnection with app lifecycle', () {
    testWidgets(
      'pauses reconnection when app is backgrounded and resumes on foreground',
      (tester) async {
        StreamController<pb.AgentEvent>? reconnectController;
        var converseCallCount = 0;

        // Reconnection uses converse(), not resumeSession().
        // Return a fresh stream for each reconnection attempt.
        when(() => mockClient.converse(any())).thenAnswer((inv) {
          (inv.positionalArguments[0] as Stream<pb.AgentRequest>)
              .listen((_) {});
          converseCallCount++;
          if (converseCallCount == 1) {
            return _FakeResponseStream<pb.AgentEvent>(eventController);
          }
          // Reconnection attempt.
          reconnectController = StreamController<pb.AgentEvent>();
          return _FakeResponseStream<pb.AgentEvent>(reconnectController!);
        });

        await tester.pumpWidget(
          _TestApp(
            overrides: [agentServiceProvider.overrideWithValue(mockClient)],
          ),
        );

        // Access the notifier and start a conversation.
        final container = ProviderScope.containerOf(
          tester.element(find.byKey(const Key('state'))),
        );
        final notifier = container.read(conversationProvider(null).notifier);
        await notifier.startConversation(workingDirectory: '/tmp');
        await tester.pump();

        // Receive session info to go active.
        eventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(sessionId: 'sess-lifecycle'),
          ),
        );
        await tester.pump();

        final activeState = container.read(conversationProvider(null)).value;
        expect(activeState, isA<ConversationActive>());

        // Inject a transient error to trigger reconnection.
        eventController.addError(const GrpcError.unavailable('lost'));
        await tester.pump();

        // Verify reconnection state — timer scheduled for 500ms.
        final reconnecting = container.read(conversationProvider(null)).value;
        expect(reconnecting, isA<ConversationActive>());
        expect(
          (reconnecting! as ConversationActive).errorMessage,
          contains('Reconnecting'),
        );

        // Background the app — this cancels the pending reconnection timer.
        // Do NOT pump while paused (SchedulerBinding disables frames).
        simulateAppBackground(tester);

        // Verify timer was cancelled: only the initial converse call was made.
        expect(converseCallCount, 1, reason: 'No reconnect while paused');

        // Return to foreground — this resets the attempt counter and
        // re-schedules the reconnection timer (500ms).
        simulateAppForeground(tester);
        await tester.pump();

        // Wait for the 500ms reconnection timer to fire.
        await tester.pump(const Duration(milliseconds: 600));
        expect(converseCallCount, 2, reason: 'Reconnect after resume');

        // Send a successful event to confirm reconnection works.
        reconnectController!.add(
          pb.AgentEvent(
            sequence: Int64(2),
            textDelta: pb.TextDelta(text: 'Back online'),
          ),
        );
        await tester.pump();

        final restored =
            container.read(conversationProvider(null)).value;
        expect(restored, isA<ConversationActive>());
        final restoredActive = restored! as ConversationActive;
        expect(restoredActive.errorMessage, isNull);
        expect(restoredActive.messages, hasLength(1));

        await reconnectController?.close();
      },
    );

    testWidgets(
      'reconnection exhausts max attempts without '
      'infinite loop on immediate errors',
      (tester) async {
        var converseCallCount = 0;

        // Reconnection uses converse(), not resumeSession().
        // First call returns the real stream; subsequent calls error.
        when(() => mockClient.converse(any())).thenAnswer((inv) {
          (inv.positionalArguments[0] as Stream<pb.AgentRequest>)
              .listen((_) {});
          converseCallCount++;
          if (converseCallCount == 1) {
            return _FakeResponseStream<pb.AgentEvent>(eventController);
          }
          // Reconnection attempts — return a fresh stream that immediately
          // errors to simulate persistent network failure.
          final controller = StreamController<pb.AgentEvent>()
            ..addError(const GrpcError.unavailable('dns fail'));
          return _FakeResponseStream<pb.AgentEvent>(controller);
        });

        await tester.pumpWidget(
          _TestApp(
            overrides: [agentServiceProvider.overrideWithValue(mockClient)],
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byKey(const Key('state'))),
        );
        final notifier = container.read(conversationProvider(null).notifier);
        await notifier.startConversation(workingDirectory: '/tmp');
        await tester.pump();

        eventController.add(
          pb.AgentEvent(
            sequence: Int64(1),
            sessionInfo: pb.SessionInfo(sessionId: 'sess-exhaust'),
          ),
        );
        await tester.pump();

        // Trigger first error on the original stream.
        eventController.addError(const GrpcError.unavailable('initial'));
        await tester.pump();

        // Advance fake time through all 5 reconnection backoff durations:
        // 500ms, 1s, 3s, 10s, 30s. Each attempt immediately errors, so we
        // just need to advance past the backoff timer for each.
        const backoffs = [
          Duration(milliseconds: 600),
          Duration(seconds: 2),
          Duration(seconds: 4),
          Duration(seconds: 11),
          Duration(seconds: 31),
        ];
        for (final backoff in backoffs) {
          await tester.pump(backoff);
        }

        // Should have made exactly 5 reconnection attempts
        // (converseCallCount = 1 initial + 5 reconnects = 6).
        expect(converseCallCount, 6);

        final s = container.read(conversationProvider(null)).value;
        expect(s, isA<ConversationError>());
      },
    );
  });
}
