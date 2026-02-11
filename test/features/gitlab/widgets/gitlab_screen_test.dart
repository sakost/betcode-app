import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/gitlab/notifiers/gitlab_providers.dart';
import 'package:betcode_app/features/gitlab/notifiers/issues_notifier.dart';
import 'package:betcode_app/features/gitlab/notifiers/merge_requests_notifier.dart';
import 'package:betcode_app/features/gitlab/notifiers/pipelines_notifier.dart';
import 'package:betcode_app/features/gitlab/screens/gitlab_screen.dart';
import 'package:betcode_app/features/gitlab/widgets/issue_card.dart';
import 'package:betcode_app/features/gitlab/widgets/merge_request_card.dart';
import 'package:betcode_app/features/gitlab/widgets/pipeline_card.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pb.dart';
import 'package:betcode_app/generated/betcode/v1/gitlab.pbenum.dart';
import 'package:betcode_app/shared/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _app(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: child);

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

/// A notifier that returns a canned async value without gRPC calls.
///
/// For [AsyncLoading], [build] never completes so the widget stays in loading.
/// For [AsyncData], it returns the data immediately.
/// For [AsyncError], it throws the error.
class _FakePipelinesNotifier extends PipelinesNotifier {
  _FakePipelinesNotifier(this._value);

  final AsyncValue<List<PipelineInfo>> _value;

  @override
  Future<List<PipelineInfo>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<PipelineInfo>>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

class _FakeMergeRequestsNotifier extends MergeRequestsNotifier {
  _FakeMergeRequestsNotifier(this._value);

  final AsyncValue<List<MergeRequestInfo>> _value;

  @override
  Future<List<MergeRequestInfo>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<MergeRequestInfo>>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

class _FakeIssuesNotifier extends IssuesNotifier {
  _FakeIssuesNotifier(this._value);

  final AsyncValue<List<IssueInfo>> _value;

  @override
  Future<List<IssueInfo>> build() {
    return _value.when(
      data: (d) => Future.value(d),
      loading: () => Completer<List<IssueInfo>>().future,
      error: (e, st) => Future.error(e, st),
    );
  }
}

// ---------------------------------------------------------------------------
// Default overrides helper
// ---------------------------------------------------------------------------

/// Creates a [ProviderScope] with the given notifier overrides wrapping
/// [child]. Defaults to loading state for all three providers.
Widget _scopedScreen({
  AsyncValue<List<PipelineInfo>> pipelinesState = const AsyncLoading(),
  AsyncValue<List<MergeRequestInfo>> mergeRequestsState = const AsyncLoading(),
  AsyncValue<List<IssueInfo>> issuesState = const AsyncLoading(),
}) {
  return ProviderScope(
    overrides: [
      pipelinesProvider.overrideWith(
        () => _FakePipelinesNotifier(pipelinesState),
      ),
      mergeRequestsProvider.overrideWith(
        () => _FakeMergeRequestsNotifier(mergeRequestsState),
      ),
      issuesProvider.overrideWith(
        () => _FakeIssuesNotifier(issuesState),
      ),
    ],
    child: _app(const GitLabScreen()),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -----------------------------------------------------------------------
  // GitLabScreen - tabs & structure
  // -----------------------------------------------------------------------

  group('GitLabScreen - structure', () {
    testWidgets('has three tabs: Pipelines, Merge Requests, Issues',
        (t) async {
      await t.pumpWidget(_scopedScreen());
      await t.pump();

      expect(find.text('Pipelines'), findsOneWidget);
      expect(find.text('Merge Requests'), findsOneWidget);
      expect(find.text('Issues'), findsOneWidget);
      expect(find.text('GitLab'), findsOneWidget);
    });

    testWidgets('shows AppBar with title GitLab', (t) async {
      await t.pumpWidget(_scopedScreen());
      await t.pump();

      expect(find.text('GitLab'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // Pipelines tab
  // -----------------------------------------------------------------------

  group('GitLabScreen - Pipelines tab', () {
    testWidgets('shows loading indicator while fetching', (t) async {
      await t.pumpWidget(_scopedScreen());
      await t.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays list of PipelineCard widgets when data arrives',
        (t) async {
      final pipelines = [
        PipelineInfo(id: Int64(1), refName: 'main', sha: 'abc12345'),
        PipelineInfo(id: Int64(2), refName: 'develop', sha: 'def67890'),
      ];

      await t.pumpWidget(_scopedScreen(
        pipelinesState: AsyncData(pipelines),
        mergeRequestsState: const AsyncData([]),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      expect(find.byType(PipelineCard), findsNWidgets(2));
      expect(find.text('main'), findsOneWidget);
      expect(find.text('develop'), findsOneWidget);
    });

    testWidgets('shows empty state when no pipelines exist', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: const AsyncData([]),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      expect(find.text('No pipelines'), findsOneWidget);
      expect(find.byIcon(Icons.rocket_launch_outlined), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: AsyncError(
          Exception('connection refused'),
          StackTrace.empty,
        ),
        mergeRequestsState: const AsyncData([]),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      expect(find.textContaining('connection refused'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // Merge Requests tab
  // -----------------------------------------------------------------------

  group('GitLabScreen - Merge Requests tab', () {
    testWidgets('displays list of MergeRequestCard widgets when data arrives',
        (t) async {
      final mrs = [
        MergeRequestInfo(
          id: Int64(1),
          iid: Int64(10),
          title: 'Fix auth',
          state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
          sourceBranch: 'fix/auth',
          targetBranch: 'main',
        ),
        MergeRequestInfo(
          id: Int64(2),
          iid: Int64(11),
          title: 'Add tests',
          state: MergeRequestState.MERGE_REQUEST_STATE_MERGED,
          sourceBranch: 'test/unit',
          targetBranch: 'main',
        ),
      ];

      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: AsyncData(mrs),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      // Switch to Merge Requests tab
      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();

      expect(find.byType(MergeRequestCard), findsNWidgets(2));
      expect(find.text('Fix auth'), findsOneWidget);
      expect(find.text('Add tests'), findsOneWidget);
    });

    testWidgets('shows empty state when no merge requests exist', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: const AsyncData([]),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      // Switch to Merge Requests tab
      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();

      expect(find.text('No merge requests'), findsOneWidget);
      expect(find.byIcon(Icons.call_merge_outlined), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: AsyncError(
          Exception('network error'),
          StackTrace.empty,
        ),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      // Switch to Merge Requests tab
      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();

      expect(find.textContaining('network error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // Issues tab
  // -----------------------------------------------------------------------

  group('GitLabScreen - Issues tab', () {
    testWidgets('displays list of IssueCard widgets when data arrives',
        (t) async {
      final issues = [
        IssueInfo(
          id: Int64(1),
          iid: Int64(5),
          title: 'Fix login bug',
          state: IssueState.ISSUE_STATE_OPENED,
        ),
        IssueInfo(
          id: Int64(2),
          iid: Int64(6),
          title: 'Add dark mode',
          state: IssueState.ISSUE_STATE_CLOSED,
        ),
      ];

      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: const AsyncData([]),
        issuesState: AsyncData(issues),
      ));
      await t.pumpAndSettle();

      // Switch to Issues tab
      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();

      expect(find.byType(IssueCard), findsNWidgets(2));
      expect(find.text('Fix login bug'), findsOneWidget);
      expect(find.text('Add dark mode'), findsOneWidget);
    });

    testWidgets('shows empty state when no issues exist', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: const AsyncData([]),
        issuesState: const AsyncData([]),
      ));
      await t.pumpAndSettle();

      // Switch to Issues tab
      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();

      expect(find.text('No issues'), findsOneWidget);
      expect(find.byIcon(Icons.bug_report_outlined), findsOneWidget);
    });

    testWidgets('shows error state on failure', (t) async {
      await t.pumpWidget(_scopedScreen(
        pipelinesState: const AsyncData([]),
        mergeRequestsState: const AsyncData([]),
        issuesState: AsyncError(
          Exception('server error'),
          StackTrace.empty,
        ),
      ));
      await t.pumpAndSettle();

      // Switch to Issues tab
      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();

      expect(find.textContaining('server error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // Tab switching
  // -----------------------------------------------------------------------

  group('GitLabScreen - tab switching', () {
    testWidgets('switching tabs shows correct content', (t) async {
      final pipelines = [
        PipelineInfo(id: Int64(1), refName: 'main', sha: 'abc12345'),
      ];
      final mrs = [
        MergeRequestInfo(
          id: Int64(1),
          iid: Int64(10),
          title: 'Fix auth',
          state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
        ),
      ];
      final issues = [
        IssueInfo(
          id: Int64(1),
          iid: Int64(5),
          title: 'Fix login bug',
          state: IssueState.ISSUE_STATE_OPENED,
        ),
      ];

      await t.pumpWidget(_scopedScreen(
        pipelinesState: AsyncData(pipelines),
        mergeRequestsState: AsyncData(mrs),
        issuesState: AsyncData(issues),
      ));
      await t.pumpAndSettle();

      // Pipelines tab (default)
      expect(find.byType(PipelineCard), findsOneWidget);
      expect(find.text('main'), findsOneWidget);

      // Switch to Merge Requests tab
      await t.tap(find.text('Merge Requests'));
      await t.pumpAndSettle();
      expect(find.byType(MergeRequestCard), findsOneWidget);
      expect(find.text('Fix auth'), findsOneWidget);

      // Switch to Issues tab
      await t.tap(find.text('Issues'));
      await t.pumpAndSettle();
      expect(find.byType(IssueCard), findsOneWidget);
      expect(find.text('Fix login bug'), findsOneWidget);

      // Switch back to Pipelines tab
      await t.tap(find.text('Pipelines'));
      await t.pumpAndSettle();
      expect(find.byType(PipelineCard), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // PipelineCard
  // -----------------------------------------------------------------------

  group('PipelineCard', () {
    testWidgets('displays ref name', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            refName: 'feature/auth',
            sha: 'deadbeef12345678',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('feature/auth'), findsOneWidget);
    });

    testWidgets('displays truncated SHA in monospace', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            sha: 'deadbeef12345678',
            refName: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('deadbeef'), findsOneWidget);
    });

    testWidgets('displays full SHA when shorter than 8 chars', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            sha: 'abc',
            refName: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('abc'), findsOneWidget);
    });

    testWidgets('displays Success status badge', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            status: PipelineStatus.PIPELINE_STATUS_SUCCESS,
            refName: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('displays Failed status badge', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            status: PipelineStatus.PIPELINE_STATUS_FAILED,
            refName: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('displays Running status badge', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            status: PipelineStatus.PIPELINE_STATUS_RUNNING,
            refName: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Running'), findsOneWidget);
    });

    testWidgets('displays source when present', (t) async {
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(
            id: Int64(1),
            refName: 'main',
            source: 'push',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('push'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(PipelineCard(
          pipeline: PipelineInfo(id: Int64(1), refName: 'main'),
          onTap: () => tapped = true,
        )),
      );
      await t.pumpAndSettle();

      await t.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // MergeRequestCard
  // -----------------------------------------------------------------------

  group('MergeRequestCard', () {
    testWidgets('displays title', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Fix authentication',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Fix authentication'), findsOneWidget);
    });

    testWidgets('displays IID in !123 format', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(123),
            title: 'Test MR',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('!123'), findsOneWidget);
    });

    testWidgets('displays Opened state badge', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Opened'), findsOneWidget);
    });

    testWidgets('displays Closed state badge', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_CLOSED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets('displays Merged state badge', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_MERGED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Merged'), findsOneWidget);
    });

    testWidgets('displays source and target branches', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
            sourceBranch: 'feature/auth',
            targetBranch: 'main',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.textContaining('feature/auth'), findsOneWidget);
      expect(find.textContaining('main'), findsOneWidget);
    });

    testWidgets('displays author', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
            author: 'alice',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('alice'), findsOneWidget);
    });

    testWidgets('displays Draft chip when draft is true', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
            draft: true,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Draft'), findsOneWidget);
    });

    testWidgets('displays labels as chips', (t) async {
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
            labels: ['backend', 'urgent'],
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('backend'), findsOneWidget);
      expect(find.text('urgent'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(MergeRequestCard(
          mergeRequest: MergeRequestInfo(
            id: Int64(1),
            iid: Int64(10),
            title: 'Test',
            state: MergeRequestState.MERGE_REQUEST_STATE_OPENED,
          ),
          onTap: () => tapped = true,
        )),
      );
      await t.pumpAndSettle();

      await t.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // IssueCard
  // -----------------------------------------------------------------------

  group('IssueCard', () {
    testWidgets('displays title', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Fix login bug',
            state: IssueState.ISSUE_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Fix login bug'), findsOneWidget);
    });

    testWidgets('displays IID in #123 format', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(99),
            title: 'Test',
            state: IssueState.ISSUE_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('#99'), findsOneWidget);
    });

    testWidgets('displays Opened state badge', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Test',
            state: IssueState.ISSUE_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Opened'), findsOneWidget);
    });

    testWidgets('displays Closed state badge', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Test',
            state: IssueState.ISSUE_STATE_CLOSED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets('displays author', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Test',
            state: IssueState.ISSUE_STATE_OPENED,
            author: 'bob',
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('bob'), findsOneWidget);
    });

    testWidgets('displays labels as chips', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Test',
            state: IssueState.ISSUE_STATE_OPENED,
            labels: ['security', 'critical'],
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.text('security'), findsOneWidget);
      expect(find.text('critical'), findsOneWidget);
    });

    testWidgets('displays lock icon when confidential', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Secret issue',
            state: IssueState.ISSUE_STATE_OPENED,
            confidential: true,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('does not display lock icon when not confidential', (t) async {
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Public issue',
            state: IssueState.ISSUE_STATE_OPENED,
          ),
        )),
      );
      await t.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsNothing);
    });

    testWidgets('calls onTap when tapped', (t) async {
      var tapped = false;
      await t.pumpWidget(
        _app(IssueCard(
          issue: IssueInfo(
            id: Int64(1),
            iid: Int64(5),
            title: 'Test',
            state: IssueState.ISSUE_STATE_OPENED,
          ),
          onTap: () => tapped = true,
        )),
      );
      await t.pumpAndSettle();

      await t.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });
}
