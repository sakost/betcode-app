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
import 'package:integration_test/integration_test.dart';
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
        StreamController<pb.AgentEvent>? resumeController;
        var resumeCallCount = 0;

        when(() => mockClient.resumeSession(any())).thenAnswer((_) {
          resumeCallCount++;
          resumeController = StreamController<pb.AgentEvent>();
          return _FakeResponseStream<pb.AgentEvent>(resumeController!);
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

        // Verify reconnection state.
        final reconnecting = container.read(conversationProvider(null)).value;
        expect(reconnecting, isA<ConversationActive>());
        expect(
          (reconnecting! as ConversationActive).errorMessage,
          contains('Reconnecting'),
        );

        // Simulate app going to background.
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        // Advance time — reconnection should NOT fire while paused.
        await tester.pump(const Duration(seconds: 5));
        expect(resumeCallCount, 0, reason: 'No reconnect while paused');

        // Simulate app returning to foreground.
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();

        // Counter should be reset and first attempt fires at 500ms.
        await tester.pump(const Duration(milliseconds: 600));
        expect(resumeCallCount, 1, reason: 'Reconnect after resume');

        // Send a successful event to confirm reconnection works.
        resumeController!.add(
          pb.AgentEvent(
            sequence: Int64(2),
            textDelta: pb.TextDelta(text: 'Back online'),
          ),
        );
        await tester.pump();

        final restored = container
            .read(
              conversationProvider(null),
            )
            .value;
        expect(restored, isA<ConversationActive>());
        final restoredActive = restored! as ConversationActive;
        expect(restoredActive.errorMessage, isNull);
        expect(restoredActive.messages, hasLength(1));

        await resumeController?.close();
      },
    );

    testWidgets(
      'reconnection exhausts max attempts without '
      'infinite loop on immediate errors',
      (tester) async {
        var resumeCallCount = 0;

        when(() => mockClient.resumeSession(any())).thenAnswer((_) {
          resumeCallCount++;
          // Stream that immediately errors.
          final controller = StreamController<pb.AgentEvent>()
            ..addError(
              const GrpcError.unavailable('dns fail'),
            );
          return _FakeResponseStream<pb.AgentEvent>(
            controller,
          );
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

        // Trigger first error.
        eventController.addError(const GrpcError.unavailable('initial'));
        await tester.pump();

        // Advance past all backoff durations (500ms + 1s + 3s + 10s + 30s).
        await tester.pump(const Duration(minutes: 2));

        // Should have made exactly 5 attempts.
        expect(resumeCallCount, 5);

        final s = container.read(conversationProvider(null)).value;
        expect(s, isA<ConversationError>());
      },
    );
  });
}
