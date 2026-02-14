// This is a generated file - do not edit.
//
// Generated from betcode/v1/agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $3;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $4;

import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum AgentRequest_Request {
  start,
  message,
  permission,
  questionResponse,
  cancel,
  encrypted,
  notSet
}

/// AgentRequest wraps all client-to-agent message types.
class AgentRequest extends $pb.GeneratedMessage {
  factory AgentRequest({
    StartConversation? start,
    UserMessage? message,
    PermissionResponse? permission,
    UserQuestionResponse? questionResponse,
    CancelRequest? cancel,
    EncryptedEnvelope? encrypted,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (message != null) result.message = message;
    if (permission != null) result.permission = permission;
    if (questionResponse != null) result.questionResponse = questionResponse;
    if (cancel != null) result.cancel = cancel;
    if (encrypted != null) result.encrypted = encrypted;
    return result;
  }

  AgentRequest._();

  factory AgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AgentRequest_Request>
      _AgentRequest_RequestByTag = {
    1: AgentRequest_Request.start,
    2: AgentRequest_Request.message,
    3: AgentRequest_Request.permission,
    4: AgentRequest_Request.questionResponse,
    5: AgentRequest_Request.cancel,
    6: AgentRequest_Request.encrypted,
    0: AgentRequest_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<StartConversation>(1, _omitFieldNames ? '' : 'start',
        subBuilder: StartConversation.create)
    ..aOM<UserMessage>(2, _omitFieldNames ? '' : 'message',
        subBuilder: UserMessage.create)
    ..aOM<PermissionResponse>(3, _omitFieldNames ? '' : 'permission',
        subBuilder: PermissionResponse.create)
    ..aOM<UserQuestionResponse>(4, _omitFieldNames ? '' : 'questionResponse',
        subBuilder: UserQuestionResponse.create)
    ..aOM<CancelRequest>(5, _omitFieldNames ? '' : 'cancel',
        subBuilder: CancelRequest.create)
    ..aOM<EncryptedEnvelope>(6, _omitFieldNames ? '' : 'encrypted',
        subBuilder: EncryptedEnvelope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRequest copyWith(void Function(AgentRequest) updates) =>
      super.copyWith((message) => updates(message as AgentRequest))
          as AgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentRequest create() => AgentRequest._();
  @$core.override
  AgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentRequest>(create);
  static AgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  AgentRequest_Request whichRequest() =>
      _AgentRequest_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StartConversation get start => $_getN(0);
  @$pb.TagNumber(1)
  set start(StartConversation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);
  @$pb.TagNumber(1)
  StartConversation ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  UserMessage get message => $_getN(1);
  @$pb.TagNumber(2)
  set message(UserMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
  @$pb.TagNumber(2)
  UserMessage ensureMessage() => $_ensure(1);

  @$pb.TagNumber(3)
  PermissionResponse get permission => $_getN(2);
  @$pb.TagNumber(3)
  set permission(PermissionResponse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPermission() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermission() => $_clearField(3);
  @$pb.TagNumber(3)
  PermissionResponse ensurePermission() => $_ensure(2);

  @$pb.TagNumber(4)
  UserQuestionResponse get questionResponse => $_getN(3);
  @$pb.TagNumber(4)
  set questionResponse(UserQuestionResponse value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuestionResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuestionResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  UserQuestionResponse ensureQuestionResponse() => $_ensure(3);

  @$pb.TagNumber(5)
  CancelRequest get cancel => $_getN(4);
  @$pb.TagNumber(5)
  set cancel(CancelRequest value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCancel() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancel() => $_clearField(5);
  @$pb.TagNumber(5)
  CancelRequest ensureCancel() => $_ensure(4);

  @$pb.TagNumber(6)
  EncryptedEnvelope get encrypted => $_getN(5);
  @$pb.TagNumber(6)
  set encrypted(EncryptedEnvelope value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEncrypted() => $_has(5);
  @$pb.TagNumber(6)
  void clearEncrypted() => $_clearField(6);
  @$pb.TagNumber(6)
  EncryptedEnvelope ensureEncrypted() => $_ensure(5);
}

/// StartConversation initiates or resumes a conversation session.
class StartConversation extends $pb.GeneratedMessage {
  factory StartConversation({
    $core.String? sessionId,
    $core.String? workingDirectory,
    $core.String? model,
    $core.Iterable<$core.String>? allowedTools,
    $core.bool? planMode,
    $core.String? worktreeId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (model != null) result.model = model;
    if (allowedTools != null) result.allowedTools.addAll(allowedTools);
    if (planMode != null) result.planMode = planMode;
    if (worktreeId != null) result.worktreeId = worktreeId;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  StartConversation._();

  factory StartConversation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartConversation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartConversation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workingDirectory')
    ..aOS(3, _omitFieldNames ? '' : 'model')
    ..pPS(4, _omitFieldNames ? '' : 'allowedTools')
    ..aOB(5, _omitFieldNames ? '' : 'planMode')
    ..aOS(6, _omitFieldNames ? '' : 'worktreeId')
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'StartConversation.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartConversation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartConversation copyWith(void Function(StartConversation) updates) =>
      super.copyWith((message) => updates(message as StartConversation))
          as StartConversation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartConversation create() => StartConversation._();
  @$core.override
  StartConversation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartConversation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartConversation>(create);
  static StartConversation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workingDirectory => $_getSZ(1);
  @$pb.TagNumber(2)
  set workingDirectory($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkingDirectory() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkingDirectory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get model => $_getSZ(2);
  @$pb.TagNumber(3)
  set model($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get allowedTools => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get planMode => $_getBF(4);
  @$pb.TagNumber(5)
  set planMode($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlanMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlanMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get worktreeId => $_getSZ(5);
  @$pb.TagNumber(6)
  set worktreeId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWorktreeId() => $_has(5);
  @$pb.TagNumber(6)
  void clearWorktreeId() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(6);
}

/// UserMessage contains the user's input.
class UserMessage extends $pb.GeneratedMessage {
  factory UserMessage({
    $core.String? content,
    $core.Iterable<$2.Attachment>? attachments,
    $core.String? agentId,
  }) {
    final result = create();
    if (content != null) result.content = content;
    if (attachments != null) result.attachments.addAll(attachments);
    if (agentId != null) result.agentId = agentId;
    return result;
  }

  UserMessage._();

  factory UserMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..pPM<$2.Attachment>(2, _omitFieldNames ? '' : 'attachments',
        subBuilder: $2.Attachment.create)
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMessage copyWith(void Function(UserMessage) updates) =>
      super.copyWith((message) => updates(message as UserMessage))
          as UserMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserMessage create() => UserMessage._();
  @$core.override
  UserMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserMessage>(create);
  static UserMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$2.Attachment> get attachments => $_getList(1);

  /// Optional target agent ID. When set, the message is routed to a
  /// specific agent instance instead of the default session agent.
  @$pb.TagNumber(3)
  $core.String get agentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentId() => $_clearField(3);
}

/// PermissionResponse is the user's decision on a permission request.
class PermissionResponse extends $pb.GeneratedMessage {
  factory PermissionResponse({
    $core.String? requestId,
    $2.PermissionDecision? decision,
    $3.Struct? updatedInput,
    $core.String? message,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (decision != null) result.decision = decision;
    if (updatedInput != null) result.updatedInput = updatedInput;
    if (message != null) result.message = message;
    return result;
  }

  PermissionResponse._();

  factory PermissionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aE<$2.PermissionDecision>(2, _omitFieldNames ? '' : 'decision',
        enumValues: $2.PermissionDecision.values)
    ..aOM<$3.Struct>(3, _omitFieldNames ? '' : 'updatedInput',
        subBuilder: $3.Struct.create)
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionResponse copyWith(void Function(PermissionResponse) updates) =>
      super.copyWith((message) => updates(message as PermissionResponse))
          as PermissionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionResponse create() => PermissionResponse._();
  @$core.override
  PermissionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionResponse>(create);
  static PermissionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.PermissionDecision get decision => $_getN(1);
  @$pb.TagNumber(2)
  set decision($2.PermissionDecision value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecision() => $_clearField(2);

  /// Modified tool input (for ALLOW_WITH_EDIT).
  @$pb.TagNumber(3)
  $3.Struct get updatedInput => $_getN(2);
  @$pb.TagNumber(3)
  set updatedInput($3.Struct value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdatedInput() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedInput() => $_clearField(3);
  @$pb.TagNumber(3)
  $3.Struct ensureUpdatedInput() => $_ensure(2);

  /// Deny message or follow-up comment.
  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

/// UserQuestionResponse is the user's answer to a question.
class UserQuestionResponse extends $pb.GeneratedMessage {
  factory UserQuestionResponse({
    $core.String? questionId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? answers,
  }) {
    final result = create();
    if (questionId != null) result.questionId = questionId;
    if (answers != null) result.answers.addEntries(answers);
    return result;
  }

  UserQuestionResponse._();

  factory UserQuestionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserQuestionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserQuestionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'questionId')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'answers',
        entryClassName: 'UserQuestionResponse.AnswersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserQuestionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserQuestionResponse copyWith(void Function(UserQuestionResponse) updates) =>
      super.copyWith((message) => updates(message as UserQuestionResponse))
          as UserQuestionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserQuestionResponse create() => UserQuestionResponse._();
  @$core.override
  UserQuestionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserQuestionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserQuestionResponse>(create);
  static UserQuestionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get questionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set questionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuestionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get answers => $_getMap(1);
}

/// CancelRequest asks to cancel the current agent turn.
class CancelRequest extends $pb.GeneratedMessage {
  factory CancelRequest({
    $core.String? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelRequest._();

  factory CancelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequest copyWith(void Function(CancelRequest) updates) =>
      super.copyWith((message) => updates(message as CancelRequest))
          as CancelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRequest create() => CancelRequest._();
  @$core.override
  CancelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRequest>(create);
  static CancelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

enum AgentEvent_Event {
  textDelta,
  toolCallStart,
  toolCallResult,
  permissionRequest,
  userQuestion,
  todoUpdate,
  statusChange,
  sessionInfo,
  error,
  usage,
  planMode,
  turnComplete,
  userInput,
  encrypted,
  notSet
}

/// AgentEvent wraps all agent-to-client event types.
class AgentEvent extends $pb.GeneratedMessage {
  factory AgentEvent({
    $fixnum.Int64? sequence,
    $4.Timestamp? timestamp,
    $core.String? parentToolUseId,
    TextDelta? textDelta,
    ToolCallStart? toolCallStart,
    ToolCallResult? toolCallResult,
    PermissionRequest? permissionRequest,
    UserQuestion? userQuestion,
    TodoUpdate? todoUpdate,
    StatusChange? statusChange,
    SessionInfo? sessionInfo,
    ErrorEvent? error,
    UsageReport? usage,
    PlanModeChange? planMode,
    TurnComplete? turnComplete,
    UserInput? userInput,
    EncryptedEnvelope? encrypted,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (timestamp != null) result.timestamp = timestamp;
    if (parentToolUseId != null) result.parentToolUseId = parentToolUseId;
    if (textDelta != null) result.textDelta = textDelta;
    if (toolCallStart != null) result.toolCallStart = toolCallStart;
    if (toolCallResult != null) result.toolCallResult = toolCallResult;
    if (permissionRequest != null) result.permissionRequest = permissionRequest;
    if (userQuestion != null) result.userQuestion = userQuestion;
    if (todoUpdate != null) result.todoUpdate = todoUpdate;
    if (statusChange != null) result.statusChange = statusChange;
    if (sessionInfo != null) result.sessionInfo = sessionInfo;
    if (error != null) result.error = error;
    if (usage != null) result.usage = usage;
    if (planMode != null) result.planMode = planMode;
    if (turnComplete != null) result.turnComplete = turnComplete;
    if (userInput != null) result.userInput = userInput;
    if (encrypted != null) result.encrypted = encrypted;
    return result;
  }

  AgentEvent._();

  factory AgentEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgentEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AgentEvent_Event> _AgentEvent_EventByTag = {
    10: AgentEvent_Event.textDelta,
    11: AgentEvent_Event.toolCallStart,
    12: AgentEvent_Event.toolCallResult,
    13: AgentEvent_Event.permissionRequest,
    14: AgentEvent_Event.userQuestion,
    15: AgentEvent_Event.todoUpdate,
    16: AgentEvent_Event.statusChange,
    17: AgentEvent_Event.sessionInfo,
    18: AgentEvent_Event.error,
    19: AgentEvent_Event.usage,
    20: AgentEvent_Event.planMode,
    21: AgentEvent_Event.turnComplete,
    22: AgentEvent_Event.userInput,
    23: AgentEvent_Event.encrypted,
    0: AgentEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23])
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$4.Timestamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $4.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'parentToolUseId')
    ..aOM<TextDelta>(10, _omitFieldNames ? '' : 'textDelta',
        subBuilder: TextDelta.create)
    ..aOM<ToolCallStart>(11, _omitFieldNames ? '' : 'toolCallStart',
        subBuilder: ToolCallStart.create)
    ..aOM<ToolCallResult>(12, _omitFieldNames ? '' : 'toolCallResult',
        subBuilder: ToolCallResult.create)
    ..aOM<PermissionRequest>(13, _omitFieldNames ? '' : 'permissionRequest',
        subBuilder: PermissionRequest.create)
    ..aOM<UserQuestion>(14, _omitFieldNames ? '' : 'userQuestion',
        subBuilder: UserQuestion.create)
    ..aOM<TodoUpdate>(15, _omitFieldNames ? '' : 'todoUpdate',
        subBuilder: TodoUpdate.create)
    ..aOM<StatusChange>(16, _omitFieldNames ? '' : 'statusChange',
        subBuilder: StatusChange.create)
    ..aOM<SessionInfo>(17, _omitFieldNames ? '' : 'sessionInfo',
        subBuilder: SessionInfo.create)
    ..aOM<ErrorEvent>(18, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorEvent.create)
    ..aOM<UsageReport>(19, _omitFieldNames ? '' : 'usage',
        subBuilder: UsageReport.create)
    ..aOM<PlanModeChange>(20, _omitFieldNames ? '' : 'planMode',
        subBuilder: PlanModeChange.create)
    ..aOM<TurnComplete>(21, _omitFieldNames ? '' : 'turnComplete',
        subBuilder: TurnComplete.create)
    ..aOM<UserInput>(22, _omitFieldNames ? '' : 'userInput',
        subBuilder: UserInput.create)
    ..aOM<EncryptedEnvelope>(23, _omitFieldNames ? '' : 'encrypted',
        subBuilder: EncryptedEnvelope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentEvent copyWith(void Function(AgentEvent) updates) =>
      super.copyWith((message) => updates(message as AgentEvent)) as AgentEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentEvent create() => AgentEvent._();
  @$core.override
  AgentEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgentEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentEvent>(create);
  static AgentEvent? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  AgentEvent_Event whichEvent() => _AgentEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($4.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get parentToolUseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentToolUseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentToolUseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentToolUseId() => $_clearField(3);

  @$pb.TagNumber(10)
  TextDelta get textDelta => $_getN(3);
  @$pb.TagNumber(10)
  set textDelta(TextDelta value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTextDelta() => $_has(3);
  @$pb.TagNumber(10)
  void clearTextDelta() => $_clearField(10);
  @$pb.TagNumber(10)
  TextDelta ensureTextDelta() => $_ensure(3);

  @$pb.TagNumber(11)
  ToolCallStart get toolCallStart => $_getN(4);
  @$pb.TagNumber(11)
  set toolCallStart(ToolCallStart value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasToolCallStart() => $_has(4);
  @$pb.TagNumber(11)
  void clearToolCallStart() => $_clearField(11);
  @$pb.TagNumber(11)
  ToolCallStart ensureToolCallStart() => $_ensure(4);

  @$pb.TagNumber(12)
  ToolCallResult get toolCallResult => $_getN(5);
  @$pb.TagNumber(12)
  set toolCallResult(ToolCallResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasToolCallResult() => $_has(5);
  @$pb.TagNumber(12)
  void clearToolCallResult() => $_clearField(12);
  @$pb.TagNumber(12)
  ToolCallResult ensureToolCallResult() => $_ensure(5);

  @$pb.TagNumber(13)
  PermissionRequest get permissionRequest => $_getN(6);
  @$pb.TagNumber(13)
  set permissionRequest(PermissionRequest value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPermissionRequest() => $_has(6);
  @$pb.TagNumber(13)
  void clearPermissionRequest() => $_clearField(13);
  @$pb.TagNumber(13)
  PermissionRequest ensurePermissionRequest() => $_ensure(6);

  @$pb.TagNumber(14)
  UserQuestion get userQuestion => $_getN(7);
  @$pb.TagNumber(14)
  set userQuestion(UserQuestion value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasUserQuestion() => $_has(7);
  @$pb.TagNumber(14)
  void clearUserQuestion() => $_clearField(14);
  @$pb.TagNumber(14)
  UserQuestion ensureUserQuestion() => $_ensure(7);

  @$pb.TagNumber(15)
  TodoUpdate get todoUpdate => $_getN(8);
  @$pb.TagNumber(15)
  set todoUpdate(TodoUpdate value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasTodoUpdate() => $_has(8);
  @$pb.TagNumber(15)
  void clearTodoUpdate() => $_clearField(15);
  @$pb.TagNumber(15)
  TodoUpdate ensureTodoUpdate() => $_ensure(8);

  @$pb.TagNumber(16)
  StatusChange get statusChange => $_getN(9);
  @$pb.TagNumber(16)
  set statusChange(StatusChange value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStatusChange() => $_has(9);
  @$pb.TagNumber(16)
  void clearStatusChange() => $_clearField(16);
  @$pb.TagNumber(16)
  StatusChange ensureStatusChange() => $_ensure(9);

  @$pb.TagNumber(17)
  SessionInfo get sessionInfo => $_getN(10);
  @$pb.TagNumber(17)
  set sessionInfo(SessionInfo value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasSessionInfo() => $_has(10);
  @$pb.TagNumber(17)
  void clearSessionInfo() => $_clearField(17);
  @$pb.TagNumber(17)
  SessionInfo ensureSessionInfo() => $_ensure(10);

  @$pb.TagNumber(18)
  ErrorEvent get error => $_getN(11);
  @$pb.TagNumber(18)
  set error(ErrorEvent value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasError() => $_has(11);
  @$pb.TagNumber(18)
  void clearError() => $_clearField(18);
  @$pb.TagNumber(18)
  ErrorEvent ensureError() => $_ensure(11);

  @$pb.TagNumber(19)
  UsageReport get usage => $_getN(12);
  @$pb.TagNumber(19)
  set usage(UsageReport value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUsage() => $_has(12);
  @$pb.TagNumber(19)
  void clearUsage() => $_clearField(19);
  @$pb.TagNumber(19)
  UsageReport ensureUsage() => $_ensure(12);

  @$pb.TagNumber(20)
  PlanModeChange get planMode => $_getN(13);
  @$pb.TagNumber(20)
  set planMode(PlanModeChange value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasPlanMode() => $_has(13);
  @$pb.TagNumber(20)
  void clearPlanMode() => $_clearField(20);
  @$pb.TagNumber(20)
  PlanModeChange ensurePlanMode() => $_ensure(13);

  @$pb.TagNumber(21)
  TurnComplete get turnComplete => $_getN(14);
  @$pb.TagNumber(21)
  set turnComplete(TurnComplete value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasTurnComplete() => $_has(14);
  @$pb.TagNumber(21)
  void clearTurnComplete() => $_clearField(21);
  @$pb.TagNumber(21)
  TurnComplete ensureTurnComplete() => $_ensure(14);

  @$pb.TagNumber(22)
  UserInput get userInput => $_getN(15);
  @$pb.TagNumber(22)
  set userInput(UserInput value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasUserInput() => $_has(15);
  @$pb.TagNumber(22)
  void clearUserInput() => $_clearField(22);
  @$pb.TagNumber(22)
  UserInput ensureUserInput() => $_ensure(15);

  @$pb.TagNumber(23)
  EncryptedEnvelope get encrypted => $_getN(16);
  @$pb.TagNumber(23)
  set encrypted(EncryptedEnvelope value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasEncrypted() => $_has(16);
  @$pb.TagNumber(23)
  void clearEncrypted() => $_clearField(23);
  @$pb.TagNumber(23)
  EncryptedEnvelope ensureEncrypted() => $_ensure(16);
}

/// TextDelta streams incremental text output.
class TextDelta extends $pb.GeneratedMessage {
  factory TextDelta({
    $core.String? text,
    $core.bool? isComplete,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (isComplete != null) result.isComplete = isComplete;
    return result;
  }

  TextDelta._();

  factory TextDelta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextDelta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextDelta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOB(2, _omitFieldNames ? '' : 'isComplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextDelta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextDelta copyWith(void Function(TextDelta) updates) =>
      super.copyWith((message) => updates(message as TextDelta)) as TextDelta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextDelta create() => TextDelta._();
  @$core.override
  TextDelta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextDelta getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextDelta>(create);
  static TextDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isComplete => $_getBF(1);
  @$pb.TagNumber(2)
  set isComplete($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsComplete() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsComplete() => $_clearField(2);
}

/// ToolCallStart indicates Claude is invoking a tool.
class ToolCallStart extends $pb.GeneratedMessage {
  factory ToolCallStart({
    $core.String? toolId,
    $core.String? toolName,
    $3.Struct? input,
    $core.String? description,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (toolName != null) result.toolName = toolName;
    if (input != null) result.input = input;
    if (description != null) result.description = description;
    return result;
  }

  ToolCallStart._();

  factory ToolCallStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOM<$3.Struct>(3, _omitFieldNames ? '' : 'input',
        subBuilder: $3.Struct.create)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallStart copyWith(void Function(ToolCallStart) updates) =>
      super.copyWith((message) => updates(message as ToolCallStart))
          as ToolCallStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallStart create() => ToolCallStart._();
  @$core.override
  ToolCallStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallStart>(create);
  static ToolCallStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $3.Struct get input => $_getN(2);
  @$pb.TagNumber(3)
  set input($3.Struct value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInput() => $_has(2);
  @$pb.TagNumber(3)
  void clearInput() => $_clearField(3);
  @$pb.TagNumber(3)
  $3.Struct ensureInput() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);
}

/// ToolCallResult contains tool output.
class ToolCallResult extends $pb.GeneratedMessage {
  factory ToolCallResult({
    $core.String? toolId,
    $core.String? output,
    $core.bool? isError,
    $core.int? durationMs,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (output != null) result.output = output;
    if (isError != null) result.isError = isError;
    if (durationMs != null) result.durationMs = durationMs;
    return result;
  }

  ToolCallResult._();

  factory ToolCallResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..aOS(2, _omitFieldNames ? '' : 'output')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
    ..aI(4, _omitFieldNames ? '' : 'durationMs', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallResult copyWith(void Function(ToolCallResult) updates) =>
      super.copyWith((message) => updates(message as ToolCallResult))
          as ToolCallResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallResult create() => ToolCallResult._();
  @$core.override
  ToolCallResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallResult>(create);
  static ToolCallResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get output => $_getSZ(1);
  @$pb.TagNumber(2)
  set output($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutput() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutput() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get durationMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set durationMs($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationMs() => $_clearField(4);
}

/// PermissionRequest asks the user to approve a tool call.
class PermissionRequest extends $pb.GeneratedMessage {
  factory PermissionRequest({
    $core.String? requestId,
    $core.String? toolName,
    $core.String? description,
    $3.Struct? input,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (toolName != null) result.toolName = toolName;
    if (description != null) result.description = description;
    if (input != null) result.input = input;
    return result;
  }

  PermissionRequest._();

  factory PermissionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOM<$3.Struct>(4, _omitFieldNames ? '' : 'input',
        subBuilder: $3.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionRequest copyWith(void Function(PermissionRequest) updates) =>
      super.copyWith((message) => updates(message as PermissionRequest))
          as PermissionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionRequest create() => PermissionRequest._();
  @$core.override
  PermissionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionRequest>(create);
  static PermissionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $3.Struct get input => $_getN(3);
  @$pb.TagNumber(4)
  set input($3.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasInput() => $_has(3);
  @$pb.TagNumber(4)
  void clearInput() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.Struct ensureInput() => $_ensure(3);
}

/// UserQuestion presents a question from Claude.
class UserQuestion extends $pb.GeneratedMessage {
  factory UserQuestion({
    $core.String? questionId,
    $core.String? question,
    $core.Iterable<$2.QuestionOption>? options,
    $core.bool? multiSelect,
  }) {
    final result = create();
    if (questionId != null) result.questionId = questionId;
    if (question != null) result.question = question;
    if (options != null) result.options.addAll(options);
    if (multiSelect != null) result.multiSelect = multiSelect;
    return result;
  }

  UserQuestion._();

  factory UserQuestion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserQuestion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserQuestion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'questionId')
    ..aOS(2, _omitFieldNames ? '' : 'question')
    ..pPM<$2.QuestionOption>(3, _omitFieldNames ? '' : 'options',
        subBuilder: $2.QuestionOption.create)
    ..aOB(4, _omitFieldNames ? '' : 'multiSelect')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserQuestion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserQuestion copyWith(void Function(UserQuestion) updates) =>
      super.copyWith((message) => updates(message as UserQuestion))
          as UserQuestion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserQuestion create() => UserQuestion._();
  @$core.override
  UserQuestion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserQuestion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserQuestion>(create);
  static UserQuestion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get questionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set questionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuestionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get question => $_getSZ(1);
  @$pb.TagNumber(2)
  set question($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuestion() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuestion() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$2.QuestionOption> get options => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get multiSelect => $_getBF(3);
  @$pb.TagNumber(4)
  set multiSelect($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMultiSelect() => $_has(3);
  @$pb.TagNumber(4)
  void clearMultiSelect() => $_clearField(4);
}

/// TodoUpdate provides the current task list state.
class TodoUpdate extends $pb.GeneratedMessage {
  factory TodoUpdate({
    $core.Iterable<$2.TodoItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  TodoUpdate._();

  factory TodoUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TodoUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TodoUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<$2.TodoItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: $2.TodoItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TodoUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TodoUpdate copyWith(void Function(TodoUpdate) updates) =>
      super.copyWith((message) => updates(message as TodoUpdate)) as TodoUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TodoUpdate create() => TodoUpdate._();
  @$core.override
  TodoUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TodoUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TodoUpdate>(create);
  static TodoUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$2.TodoItem> get items => $_getList(0);
}

/// StatusChange indicates a change in agent state.
class StatusChange extends $pb.GeneratedMessage {
  factory StatusChange({
    $2.AgentStatus? status,
    $core.String? message,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (message != null) result.message = message;
    return result;
  }

  StatusChange._();

  factory StatusChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatusChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatusChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aE<$2.AgentStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: $2.AgentStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChange copyWith(void Function(StatusChange) updates) =>
      super.copyWith((message) => updates(message as StatusChange))
          as StatusChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusChange create() => StatusChange._();
  @$core.override
  StatusChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatusChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatusChange>(create);
  static StatusChange? _defaultInstance;

  @$pb.TagNumber(1)
  $2.AgentStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.AgentStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

/// SessionInfo provides metadata about the session.
class SessionInfo extends $pb.GeneratedMessage {
  factory SessionInfo({
    $core.String? sessionId,
    $core.String? model,
    $core.String? workingDirectory,
    $core.String? worktreeId,
    $fixnum.Int64? messageCount,
    $core.bool? isResumed,
    $core.bool? isCompacted,
    $core.double? contextUsagePercent,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (model != null) result.model = model;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (worktreeId != null) result.worktreeId = worktreeId;
    if (messageCount != null) result.messageCount = messageCount;
    if (isResumed != null) result.isResumed = isResumed;
    if (isCompacted != null) result.isCompacted = isCompacted;
    if (contextUsagePercent != null)
      result.contextUsagePercent = contextUsagePercent;
    return result;
  }

  SessionInfo._();

  factory SessionInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..aOS(3, _omitFieldNames ? '' : 'workingDirectory')
    ..aOS(4, _omitFieldNames ? '' : 'worktreeId')
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'messageCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(6, _omitFieldNames ? '' : 'isResumed')
    ..aOB(7, _omitFieldNames ? '' : 'isCompacted')
    ..aD(8, _omitFieldNames ? '' : 'contextUsagePercent',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionInfo copyWith(void Function(SessionInfo) updates) =>
      super.copyWith((message) => updates(message as SessionInfo))
          as SessionInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionInfo create() => SessionInfo._();
  @$core.override
  SessionInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionInfo>(create);
  static SessionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get model => $_getSZ(1);
  @$pb.TagNumber(2)
  set model($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workingDirectory => $_getSZ(2);
  @$pb.TagNumber(3)
  set workingDirectory($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkingDirectory() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkingDirectory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get worktreeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set worktreeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorktreeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorktreeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get messageCount => $_getI64(4);
  @$pb.TagNumber(5)
  set messageCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessageCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessageCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isResumed => $_getBF(5);
  @$pb.TagNumber(6)
  set isResumed($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsResumed() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsResumed() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isCompacted => $_getBF(6);
  @$pb.TagNumber(7)
  set isCompacted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsCompacted() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsCompacted() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get contextUsagePercent => $_getN(7);
  @$pb.TagNumber(8)
  set contextUsagePercent($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContextUsagePercent() => $_has(7);
  @$pb.TagNumber(8)
  void clearContextUsagePercent() => $_clearField(8);
}

/// ErrorEvent indicates an error occurred.
class ErrorEvent extends $pb.GeneratedMessage {
  factory ErrorEvent({
    $core.String? code,
    $core.String? message,
    $core.bool? isFatal,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? details,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (isFatal != null) result.isFatal = isFatal;
    if (details != null) result.details.addEntries(details);
    return result;
  }

  ErrorEvent._();

  factory ErrorEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'isFatal')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'details',
        entryClassName: 'ErrorEvent.DetailsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('betcode.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorEvent copyWith(void Function(ErrorEvent) updates) =>
      super.copyWith((message) => updates(message as ErrorEvent)) as ErrorEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorEvent create() => ErrorEvent._();
  @$core.override
  ErrorEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorEvent>(create);
  static ErrorEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFatal => $_getBF(2);
  @$pb.TagNumber(3)
  set isFatal($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFatal() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFatal() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get details => $_getMap(3);
}

/// UsageReport provides token usage and cost.
class UsageReport extends $pb.GeneratedMessage {
  factory UsageReport({
    $core.int? inputTokens,
    $core.int? outputTokens,
    $core.int? cacheReadTokens,
    $core.int? cacheCreationTokens,
    $core.String? model,
    $core.double? costUsd,
    $core.int? durationMs,
  }) {
    final result = create();
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    if (cacheReadTokens != null) result.cacheReadTokens = cacheReadTokens;
    if (cacheCreationTokens != null)
      result.cacheCreationTokens = cacheCreationTokens;
    if (model != null) result.model = model;
    if (costUsd != null) result.costUsd = costUsd;
    if (durationMs != null) result.durationMs = durationMs;
    return result;
  }

  UsageReport._();

  factory UsageReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UsageReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UsageReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'inputTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'outputTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'cacheReadTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'cacheCreationTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'model')
    ..aD(6, _omitFieldNames ? '' : 'costUsd')
    ..aI(7, _omitFieldNames ? '' : 'durationMs', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UsageReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UsageReport copyWith(void Function(UsageReport) updates) =>
      super.copyWith((message) => updates(message as UsageReport))
          as UsageReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UsageReport create() => UsageReport._();
  @$core.override
  UsageReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UsageReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UsageReport>(create);
  static UsageReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get inputTokens => $_getIZ(0);
  @$pb.TagNumber(1)
  set inputTokens($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInputTokens() => $_has(0);
  @$pb.TagNumber(1)
  void clearInputTokens() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get outputTokens => $_getIZ(1);
  @$pb.TagNumber(2)
  set outputTokens($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutputTokens() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutputTokens() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get cacheReadTokens => $_getIZ(2);
  @$pb.TagNumber(3)
  set cacheReadTokens($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCacheReadTokens() => $_has(2);
  @$pb.TagNumber(3)
  void clearCacheReadTokens() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get cacheCreationTokens => $_getIZ(3);
  @$pb.TagNumber(4)
  set cacheCreationTokens($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCacheCreationTokens() => $_has(3);
  @$pb.TagNumber(4)
  void clearCacheCreationTokens() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get model => $_getSZ(4);
  @$pb.TagNumber(5)
  set model($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearModel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costUsd => $_getN(5);
  @$pb.TagNumber(6)
  set costUsd($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostUsd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get durationMs => $_getIZ(6);
  @$pb.TagNumber(7)
  set durationMs($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDurationMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationMs() => $_clearField(7);
}

/// PlanModeChange indicates plan mode toggled.
class PlanModeChange extends $pb.GeneratedMessage {
  factory PlanModeChange({
    $core.bool? active,
    $core.String? plan,
  }) {
    final result = create();
    if (active != null) result.active = active;
    if (plan != null) result.plan = plan;
    return result;
  }

  PlanModeChange._();

  factory PlanModeChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanModeChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanModeChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..aOS(2, _omitFieldNames ? '' : 'plan')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanModeChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanModeChange copyWith(void Function(PlanModeChange) updates) =>
      super.copyWith((message) => updates(message as PlanModeChange))
          as PlanModeChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanModeChange create() => PlanModeChange._();
  @$core.override
  PlanModeChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanModeChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanModeChange>(create);
  static PlanModeChange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get plan => $_getSZ(1);
  @$pb.TagNumber(2)
  set plan($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlan() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlan() => $_clearField(2);
}

/// TurnComplete indicates the agent finished a turn.
class TurnComplete extends $pb.GeneratedMessage {
  factory TurnComplete({
    $core.String? stopReason,
  }) {
    final result = create();
    if (stopReason != null) result.stopReason = stopReason;
    return result;
  }

  TurnComplete._();

  factory TurnComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnComplete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stopReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnComplete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnComplete copyWith(void Function(TurnComplete) updates) =>
      super.copyWith((message) => updates(message as TurnComplete))
          as TurnComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnComplete create() => TurnComplete._();
  @$core.override
  TurnComplete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnComplete>(create);
  static TurnComplete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stopReason => $_getSZ(0);
  @$pb.TagNumber(1)
  set stopReason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStopReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearStopReason() => $_clearField(1);
}

/// UserInput records a user's prompt for session replay.
class UserInput extends $pb.GeneratedMessage {
  factory UserInput({
    $core.String? content,
  }) {
    final result = create();
    if (content != null) result.content = content;
    return result;
  }

  UserInput._();

  factory UserInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInput copyWith(void Function(UserInput) updates) =>
      super.copyWith((message) => updates(message as UserInput)) as UserInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInput create() => UserInput._();
  @$core.override
  UserInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInput>(create);
  static UserInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
}

/// EncryptedEnvelope wraps an application-layer encrypted payload.
/// The relay sees valid protobuf but cannot read the inner content.
class EncryptedEnvelope extends $pb.GeneratedMessage {
  factory EncryptedEnvelope({
    $core.List<$core.int>? ciphertext,
    $core.List<$core.int>? nonce,
  }) {
    final result = create();
    if (ciphertext != null) result.ciphertext = ciphertext;
    if (nonce != null) result.nonce = nonce;
    return result;
  }

  EncryptedEnvelope._();

  factory EncryptedEnvelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EncryptedEnvelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EncryptedEnvelope',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'ciphertext', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncryptedEnvelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncryptedEnvelope copyWith(void Function(EncryptedEnvelope) updates) =>
      super.copyWith((message) => updates(message as EncryptedEnvelope))
          as EncryptedEnvelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncryptedEnvelope create() => EncryptedEnvelope._();
  @$core.override
  EncryptedEnvelope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EncryptedEnvelope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptedEnvelope>(create);
  static EncryptedEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ciphertext => $_getN(0);
  @$pb.TagNumber(1)
  set ciphertext($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCiphertext() => $_has(0);
  @$pb.TagNumber(1)
  void clearCiphertext() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);
}

class ListSessionsRequest extends $pb.GeneratedMessage {
  factory ListSessionsRequest({
    $core.String? workingDirectory,
    $core.String? worktreeId,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (worktreeId != null) result.worktreeId = worktreeId;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListSessionsRequest._();

  factory ListSessionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workingDirectory')
    ..aOS(2, _omitFieldNames ? '' : 'worktreeId')
    ..aI(3, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'offset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsRequest copyWith(void Function(ListSessionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSessionsRequest))
          as ListSessionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest create() => ListSessionsRequest._();
  @$core.override
  ListSessionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionsRequest>(create);
  static ListSessionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workingDirectory => $_getSZ(0);
  @$pb.TagNumber(1)
  set workingDirectory($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkingDirectory() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkingDirectory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get worktreeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set worktreeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorktreeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorktreeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListSessionsResponse extends $pb.GeneratedMessage {
  factory ListSessionsResponse({
    $core.Iterable<SessionSummary>? sessions,
    $core.int? total,
  }) {
    final result = create();
    if (sessions != null) result.sessions.addAll(sessions);
    if (total != null) result.total = total;
    return result;
  }

  ListSessionsResponse._();

  factory ListSessionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<SessionSummary>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: SessionSummary.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsResponse copyWith(void Function(ListSessionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSessionsResponse))
          as ListSessionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse create() => ListSessionsResponse._();
  @$core.override
  ListSessionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionsResponse>(create);
  static ListSessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SessionSummary> get sessions => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class SessionSummary extends $pb.GeneratedMessage {
  factory SessionSummary({
    $core.String? id,
    $core.String? model,
    $core.String? workingDirectory,
    $core.String? worktreeId,
    $core.String? status,
    $core.int? messageCount,
    $core.int? totalInputTokens,
    $core.int? totalOutputTokens,
    $core.double? totalCostUsd,
    $4.Timestamp? createdAt,
    $4.Timestamp? updatedAt,
    $core.String? lastMessagePreview,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (model != null) result.model = model;
    if (workingDirectory != null) result.workingDirectory = workingDirectory;
    if (worktreeId != null) result.worktreeId = worktreeId;
    if (status != null) result.status = status;
    if (messageCount != null) result.messageCount = messageCount;
    if (totalInputTokens != null) result.totalInputTokens = totalInputTokens;
    if (totalOutputTokens != null) result.totalOutputTokens = totalOutputTokens;
    if (totalCostUsd != null) result.totalCostUsd = totalCostUsd;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (lastMessagePreview != null)
      result.lastMessagePreview = lastMessagePreview;
    if (name != null) result.name = name;
    return result;
  }

  SessionSummary._();

  factory SessionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..aOS(3, _omitFieldNames ? '' : 'workingDirectory')
    ..aOS(4, _omitFieldNames ? '' : 'worktreeId')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aI(6, _omitFieldNames ? '' : 'messageCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'totalInputTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'totalOutputTokens',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(9, _omitFieldNames ? '' : 'totalCostUsd')
    ..aOM<$4.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $4.Timestamp.create)
    ..aOM<$4.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $4.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'lastMessagePreview')
    ..aOS(13, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSummary copyWith(void Function(SessionSummary) updates) =>
      super.copyWith((message) => updates(message as SessionSummary))
          as SessionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionSummary create() => SessionSummary._();
  @$core.override
  SessionSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionSummary>(create);
  static SessionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get model => $_getSZ(1);
  @$pb.TagNumber(2)
  set model($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workingDirectory => $_getSZ(2);
  @$pb.TagNumber(3)
  set workingDirectory($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkingDirectory() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkingDirectory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get worktreeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set worktreeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorktreeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorktreeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get messageCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set messageCount($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMessageCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearMessageCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalInputTokens => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalInputTokens($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalInputTokens() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalInputTokens() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get totalOutputTokens => $_getIZ(7);
  @$pb.TagNumber(8)
  set totalOutputTokens($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalOutputTokens() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalOutputTokens() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalCostUsd => $_getN(8);
  @$pb.TagNumber(9)
  set totalCostUsd($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalCostUsd() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalCostUsd() => $_clearField(9);

  @$pb.TagNumber(10)
  $4.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($4.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $4.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $4.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($4.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $4.Timestamp ensureUpdatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get lastMessagePreview => $_getSZ(11);
  @$pb.TagNumber(12)
  set lastMessagePreview($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLastMessagePreview() => $_has(11);
  @$pb.TagNumber(12)
  void clearLastMessagePreview() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get name => $_getSZ(12);
  @$pb.TagNumber(13)
  set name($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasName() => $_has(12);
  @$pb.TagNumber(13)
  void clearName() => $_clearField(13);
}

class ResumeSessionRequest extends $pb.GeneratedMessage {
  factory ResumeSessionRequest({
    $core.String? sessionId,
    $fixnum.Int64? fromSequence,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (fromSequence != null) result.fromSequence = fromSequence;
    return result;
  }

  ResumeSessionRequest._();

  factory ResumeSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'fromSequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeSessionRequest copyWith(void Function(ResumeSessionRequest) updates) =>
      super.copyWith((message) => updates(message as ResumeSessionRequest))
          as ResumeSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeSessionRequest create() => ResumeSessionRequest._();
  @$core.override
  ResumeSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeSessionRequest>(create);
  static ResumeSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set fromSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromSequence() => $_clearField(2);
}

class CompactSessionRequest extends $pb.GeneratedMessage {
  factory CompactSessionRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CompactSessionRequest._();

  factory CompactSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompactSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompactSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionRequest copyWith(
          void Function(CompactSessionRequest) updates) =>
      super.copyWith((message) => updates(message as CompactSessionRequest))
          as CompactSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompactSessionRequest create() => CompactSessionRequest._();
  @$core.override
  CompactSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompactSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompactSessionRequest>(create);
  static CompactSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class CompactSessionResponse extends $pb.GeneratedMessage {
  factory CompactSessionResponse({
    $core.int? messagesBefore,
    $core.int? messagesAfter,
    $core.int? tokensSaved,
  }) {
    final result = create();
    if (messagesBefore != null) result.messagesBefore = messagesBefore;
    if (messagesAfter != null) result.messagesAfter = messagesAfter;
    if (tokensSaved != null) result.tokensSaved = tokensSaved;
    return result;
  }

  CompactSessionResponse._();

  factory CompactSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompactSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompactSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'messagesBefore',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'messagesAfter',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'tokensSaved',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionResponse copyWith(
          void Function(CompactSessionResponse) updates) =>
      super.copyWith((message) => updates(message as CompactSessionResponse))
          as CompactSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompactSessionResponse create() => CompactSessionResponse._();
  @$core.override
  CompactSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompactSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompactSessionResponse>(create);
  static CompactSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get messagesBefore => $_getIZ(0);
  @$pb.TagNumber(1)
  set messagesBefore($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessagesBefore() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessagesBefore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get messagesAfter => $_getIZ(1);
  @$pb.TagNumber(2)
  set messagesAfter($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessagesAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessagesAfter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get tokensSaved => $_getIZ(2);
  @$pb.TagNumber(3)
  set tokensSaved($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTokensSaved() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokensSaved() => $_clearField(3);
}

class CancelTurnRequest extends $pb.GeneratedMessage {
  factory CancelTurnRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CancelTurnRequest._();

  factory CancelTurnRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelTurnRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelTurnRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTurnRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTurnRequest copyWith(void Function(CancelTurnRequest) updates) =>
      super.copyWith((message) => updates(message as CancelTurnRequest))
          as CancelTurnRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTurnRequest create() => CancelTurnRequest._();
  @$core.override
  CancelTurnRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelTurnRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelTurnRequest>(create);
  static CancelTurnRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class CancelTurnResponse extends $pb.GeneratedMessage {
  factory CancelTurnResponse({
    $core.bool? wasActive,
  }) {
    final result = create();
    if (wasActive != null) result.wasActive = wasActive;
    return result;
  }

  CancelTurnResponse._();

  factory CancelTurnResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelTurnResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelTurnResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'wasActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTurnResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTurnResponse copyWith(void Function(CancelTurnResponse) updates) =>
      super.copyWith((message) => updates(message as CancelTurnResponse))
          as CancelTurnResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTurnResponse create() => CancelTurnResponse._();
  @$core.override
  CancelTurnResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelTurnResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelTurnResponse>(create);
  static CancelTurnResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get wasActive => $_getBF(0);
  @$pb.TagNumber(1)
  set wasActive($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearWasActive() => $_clearField(1);
}

class InputLockRequest extends $pb.GeneratedMessage {
  factory InputLockRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  InputLockRequest._();

  factory InputLockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputLockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputLockRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputLockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputLockRequest copyWith(void Function(InputLockRequest) updates) =>
      super.copyWith((message) => updates(message as InputLockRequest))
          as InputLockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputLockRequest create() => InputLockRequest._();
  @$core.override
  InputLockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputLockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputLockRequest>(create);
  static InputLockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class InputLockResponse extends $pb.GeneratedMessage {
  factory InputLockResponse({
    $core.bool? granted,
    $core.String? previousHolder,
  }) {
    final result = create();
    if (granted != null) result.granted = granted;
    if (previousHolder != null) result.previousHolder = previousHolder;
    return result;
  }

  InputLockResponse._();

  factory InputLockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputLockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputLockResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'granted')
    ..aOS(2, _omitFieldNames ? '' : 'previousHolder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputLockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputLockResponse copyWith(void Function(InputLockResponse) updates) =>
      super.copyWith((message) => updates(message as InputLockResponse))
          as InputLockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputLockResponse create() => InputLockResponse._();
  @$core.override
  InputLockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputLockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputLockResponse>(create);
  static InputLockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get granted => $_getBF(0);
  @$pb.TagNumber(1)
  set granted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGranted() => $_has(0);
  @$pb.TagNumber(1)
  void clearGranted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get previousHolder => $_getSZ(1);
  @$pb.TagNumber(2)
  set previousHolder($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreviousHolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousHolder() => $_clearField(2);
}

class SessionGrantEntry extends $pb.GeneratedMessage {
  factory SessionGrantEntry({
    $core.String? toolName,
    $core.bool? granted,
  }) {
    final result = create();
    if (toolName != null) result.toolName = toolName;
    if (granted != null) result.granted = granted;
    return result;
  }

  SessionGrantEntry._();

  factory SessionGrantEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionGrantEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionGrantEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolName')
    ..aOB(2, _omitFieldNames ? '' : 'granted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionGrantEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionGrantEntry copyWith(void Function(SessionGrantEntry) updates) =>
      super.copyWith((message) => updates(message as SessionGrantEntry))
          as SessionGrantEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionGrantEntry create() => SessionGrantEntry._();
  @$core.override
  SessionGrantEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionGrantEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionGrantEntry>(create);
  static SessionGrantEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolName => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolName() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get granted => $_getBF(1);
  @$pb.TagNumber(2)
  set granted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGranted() => $_has(1);
  @$pb.TagNumber(2)
  void clearGranted() => $_clearField(2);
}

class ListSessionGrantsRequest extends $pb.GeneratedMessage {
  factory ListSessionGrantsRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ListSessionGrantsRequest._();

  factory ListSessionGrantsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionGrantsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionGrantsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionGrantsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionGrantsRequest copyWith(
          void Function(ListSessionGrantsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSessionGrantsRequest))
          as ListSessionGrantsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionGrantsRequest create() => ListSessionGrantsRequest._();
  @$core.override
  ListSessionGrantsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionGrantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionGrantsRequest>(create);
  static ListSessionGrantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class ListSessionGrantsResponse extends $pb.GeneratedMessage {
  factory ListSessionGrantsResponse({
    $core.Iterable<SessionGrantEntry>? grants,
  }) {
    final result = create();
    if (grants != null) result.grants.addAll(grants);
    return result;
  }

  ListSessionGrantsResponse._();

  factory ListSessionGrantsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionGrantsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionGrantsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..pPM<SessionGrantEntry>(1, _omitFieldNames ? '' : 'grants',
        subBuilder: SessionGrantEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionGrantsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionGrantsResponse copyWith(
          void Function(ListSessionGrantsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSessionGrantsResponse))
          as ListSessionGrantsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionGrantsResponse create() => ListSessionGrantsResponse._();
  @$core.override
  ListSessionGrantsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionGrantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionGrantsResponse>(create);
  static ListSessionGrantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SessionGrantEntry> get grants => $_getList(0);
}

class ClearSessionGrantsRequest extends $pb.GeneratedMessage {
  factory ClearSessionGrantsRequest({
    $core.String? sessionId,
    $core.String? toolName,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (toolName != null) result.toolName = toolName;
    return result;
  }

  ClearSessionGrantsRequest._();

  factory ClearSessionGrantsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearSessionGrantsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearSessionGrantsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionGrantsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionGrantsRequest copyWith(
          void Function(ClearSessionGrantsRequest) updates) =>
      super.copyWith((message) => updates(message as ClearSessionGrantsRequest))
          as ClearSessionGrantsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearSessionGrantsRequest create() => ClearSessionGrantsRequest._();
  @$core.override
  ClearSessionGrantsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearSessionGrantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearSessionGrantsRequest>(create);
  static ClearSessionGrantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Optional: clear only this tool's grant. Empty = clear all.
  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);
}

class ClearSessionGrantsResponse extends $pb.GeneratedMessage {
  factory ClearSessionGrantsResponse() => create();

  ClearSessionGrantsResponse._();

  factory ClearSessionGrantsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearSessionGrantsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearSessionGrantsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionGrantsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionGrantsResponse copyWith(
          void Function(ClearSessionGrantsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ClearSessionGrantsResponse))
          as ClearSessionGrantsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearSessionGrantsResponse create() => ClearSessionGrantsResponse._();
  @$core.override
  ClearSessionGrantsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearSessionGrantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearSessionGrantsResponse>(create);
  static ClearSessionGrantsResponse? _defaultInstance;
}

class SetSessionGrantRequest extends $pb.GeneratedMessage {
  factory SetSessionGrantRequest({
    $core.String? sessionId,
    $core.String? toolName,
    $core.bool? granted,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (toolName != null) result.toolName = toolName;
    if (granted != null) result.granted = granted;
    return result;
  }

  SetSessionGrantRequest._();

  factory SetSessionGrantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSessionGrantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSessionGrantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOB(3, _omitFieldNames ? '' : 'granted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSessionGrantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSessionGrantRequest copyWith(
          void Function(SetSessionGrantRequest) updates) =>
      super.copyWith((message) => updates(message as SetSessionGrantRequest))
          as SetSessionGrantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSessionGrantRequest create() => SetSessionGrantRequest._();
  @$core.override
  SetSessionGrantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSessionGrantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSessionGrantRequest>(create);
  static SetSessionGrantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get granted => $_getBF(2);
  @$pb.TagNumber(3)
  set granted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGranted() => $_has(2);
  @$pb.TagNumber(3)
  void clearGranted() => $_clearField(3);
}

class SetSessionGrantResponse extends $pb.GeneratedMessage {
  factory SetSessionGrantResponse() => create();

  SetSessionGrantResponse._();

  factory SetSessionGrantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSessionGrantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSessionGrantResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSessionGrantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSessionGrantResponse copyWith(
          void Function(SetSessionGrantResponse) updates) =>
      super.copyWith((message) => updates(message as SetSessionGrantResponse))
          as SetSessionGrantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSessionGrantResponse create() => SetSessionGrantResponse._();
  @$core.override
  SetSessionGrantResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSessionGrantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSessionGrantResponse>(create);
  static SetSessionGrantResponse? _defaultInstance;
}

class RenameSessionRequest extends $pb.GeneratedMessage {
  factory RenameSessionRequest({
    $core.String? sessionId,
    $core.String? name,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (name != null) result.name = name;
    return result;
  }

  RenameSessionRequest._();

  factory RenameSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSessionRequest copyWith(void Function(RenameSessionRequest) updates) =>
      super.copyWith((message) => updates(message as RenameSessionRequest))
          as RenameSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameSessionRequest create() => RenameSessionRequest._();
  @$core.override
  RenameSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameSessionRequest>(create);
  static RenameSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class RenameSessionResponse extends $pb.GeneratedMessage {
  factory RenameSessionResponse() => create();

  RenameSessionResponse._();

  factory RenameSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'betcode.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSessionResponse copyWith(
          void Function(RenameSessionResponse) updates) =>
      super.copyWith((message) => updates(message as RenameSessionResponse))
          as RenameSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameSessionResponse create() => RenameSessionResponse._();
  @$core.override
  RenameSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameSessionResponse>(create);
  static RenameSessionResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
