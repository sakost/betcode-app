// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationState()';
}


}

/// @nodoc
class $ConversationStateCopyWith<$Res>  {
$ConversationStateCopyWith(ConversationState _, $Res Function(ConversationState) __);
}


/// Adds pattern-matching-related methods to [ConversationState].
extension ConversationStatePatterns on ConversationState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConversationInitial value)?  initial,TResult Function( ConversationConnecting value)?  connecting,TResult Function( ConversationActive value)?  active,TResult Function( ConversationError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConversationInitial() when initial != null:
return initial(_that);case ConversationConnecting() when connecting != null:
return connecting(_that);case ConversationActive() when active != null:
return active(_that);case ConversationError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConversationInitial value)  initial,required TResult Function( ConversationConnecting value)  connecting,required TResult Function( ConversationActive value)  active,required TResult Function( ConversationError value)  error,}){
final _that = this;
switch (_that) {
case ConversationInitial():
return initial(_that);case ConversationConnecting():
return connecting(_that);case ConversationActive():
return active(_that);case ConversationError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConversationInitial value)?  initial,TResult? Function( ConversationConnecting value)?  connecting,TResult? Function( ConversationActive value)?  active,TResult? Function( ConversationError value)?  error,}){
final _that = this;
switch (_that) {
case ConversationInitial() when initial != null:
return initial(_that);case ConversationConnecting() when connecting != null:
return connecting(_that);case ConversationActive() when active != null:
return active(_that);case ConversationError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  connecting,TResult Function( String sessionId,  List<ChatMessage> messages,  AgentStatus agentStatus,  int lastSequence,  List<TodoItem> todos,  bool planModeActive,  String? planContent,  UsageInfo? usage,  String? errorMessage,  Map<String, AgentInfo> agents,  String? selectedAgentId)?  active,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConversationInitial() when initial != null:
return initial();case ConversationConnecting() when connecting != null:
return connecting();case ConversationActive() when active != null:
return active(_that.sessionId,_that.messages,_that.agentStatus,_that.lastSequence,_that.todos,_that.planModeActive,_that.planContent,_that.usage,_that.errorMessage,_that.agents,_that.selectedAgentId);case ConversationError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  connecting,required TResult Function( String sessionId,  List<ChatMessage> messages,  AgentStatus agentStatus,  int lastSequence,  List<TodoItem> todos,  bool planModeActive,  String? planContent,  UsageInfo? usage,  String? errorMessage,  Map<String, AgentInfo> agents,  String? selectedAgentId)  active,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ConversationInitial():
return initial();case ConversationConnecting():
return connecting();case ConversationActive():
return active(_that.sessionId,_that.messages,_that.agentStatus,_that.lastSequence,_that.todos,_that.planModeActive,_that.planContent,_that.usage,_that.errorMessage,_that.agents,_that.selectedAgentId);case ConversationError():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  connecting,TResult? Function( String sessionId,  List<ChatMessage> messages,  AgentStatus agentStatus,  int lastSequence,  List<TodoItem> todos,  bool planModeActive,  String? planContent,  UsageInfo? usage,  String? errorMessage,  Map<String, AgentInfo> agents,  String? selectedAgentId)?  active,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ConversationInitial() when initial != null:
return initial();case ConversationConnecting() when connecting != null:
return connecting();case ConversationActive() when active != null:
return active(_that.sessionId,_that.messages,_that.agentStatus,_that.lastSequence,_that.todos,_that.planModeActive,_that.planContent,_that.usage,_that.errorMessage,_that.agents,_that.selectedAgentId);case ConversationError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ConversationInitial implements ConversationState {
  const ConversationInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationState.initial()';
}


}




/// @nodoc


class ConversationConnecting implements ConversationState {
  const ConversationConnecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationState.connecting()';
}


}




/// @nodoc


class ConversationActive implements ConversationState {
  const ConversationActive({required this.sessionId, required final  List<ChatMessage> messages, required this.agentStatus, required this.lastSequence, final  List<TodoItem> todos = const [], this.planModeActive = false, this.planContent, this.usage, this.errorMessage, final  Map<String, AgentInfo> agents = const {}, this.selectedAgentId}): _messages = messages,_todos = todos,_agents = agents;
  

 final  String sessionId;
 final  List<ChatMessage> _messages;
 List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  AgentStatus agentStatus;
 final  int lastSequence;
 final  List<TodoItem> _todos;
@JsonKey() List<TodoItem> get todos {
  if (_todos is EqualUnmodifiableListView) return _todos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todos);
}

@JsonKey() final  bool planModeActive;
 final  String? planContent;
 final  UsageInfo? usage;
 final  String? errorMessage;
 final  Map<String, AgentInfo> _agents;
@JsonKey() Map<String, AgentInfo> get agents {
  if (_agents is EqualUnmodifiableMapView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_agents);
}

 final  String? selectedAgentId;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationActiveCopyWith<ConversationActive> get copyWith => _$ConversationActiveCopyWithImpl<ConversationActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationActive&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.agentStatus, agentStatus) || other.agentStatus == agentStatus)&&(identical(other.lastSequence, lastSequence) || other.lastSequence == lastSequence)&&const DeepCollectionEquality().equals(other._todos, _todos)&&(identical(other.planModeActive, planModeActive) || other.planModeActive == planModeActive)&&(identical(other.planContent, planContent) || other.planContent == planContent)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._agents, _agents)&&(identical(other.selectedAgentId, selectedAgentId) || other.selectedAgentId == selectedAgentId));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,const DeepCollectionEquality().hash(_messages),agentStatus,lastSequence,const DeepCollectionEquality().hash(_todos),planModeActive,planContent,usage,errorMessage,const DeepCollectionEquality().hash(_agents),selectedAgentId);

@override
String toString() {
  return 'ConversationState.active(sessionId: $sessionId, messages: $messages, agentStatus: $agentStatus, lastSequence: $lastSequence, todos: $todos, planModeActive: $planModeActive, planContent: $planContent, usage: $usage, errorMessage: $errorMessage, agents: $agents, selectedAgentId: $selectedAgentId)';
}


}

/// @nodoc
abstract mixin class $ConversationActiveCopyWith<$Res> implements $ConversationStateCopyWith<$Res> {
  factory $ConversationActiveCopyWith(ConversationActive value, $Res Function(ConversationActive) _then) = _$ConversationActiveCopyWithImpl;
@useResult
$Res call({
 String sessionId, List<ChatMessage> messages, AgentStatus agentStatus, int lastSequence, List<TodoItem> todos, bool planModeActive, String? planContent, UsageInfo? usage, String? errorMessage, Map<String, AgentInfo> agents, String? selectedAgentId
});


$UsageInfoCopyWith<$Res>? get usage;

}
/// @nodoc
class _$ConversationActiveCopyWithImpl<$Res>
    implements $ConversationActiveCopyWith<$Res> {
  _$ConversationActiveCopyWithImpl(this._self, this._then);

  final ConversationActive _self;
  final $Res Function(ConversationActive) _then;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? messages = null,Object? agentStatus = null,Object? lastSequence = null,Object? todos = null,Object? planModeActive = null,Object? planContent = freezed,Object? usage = freezed,Object? errorMessage = freezed,Object? agents = null,Object? selectedAgentId = freezed,}) {
  return _then(ConversationActive(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,agentStatus: null == agentStatus ? _self.agentStatus : agentStatus // ignore: cast_nullable_to_non_nullable
as AgentStatus,lastSequence: null == lastSequence ? _self.lastSequence : lastSequence // ignore: cast_nullable_to_non_nullable
as int,todos: null == todos ? _self._todos : todos // ignore: cast_nullable_to_non_nullable
as List<TodoItem>,planModeActive: null == planModeActive ? _self.planModeActive : planModeActive // ignore: cast_nullable_to_non_nullable
as bool,planContent: freezed == planContent ? _self.planContent : planContent // ignore: cast_nullable_to_non_nullable
as String?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as UsageInfo?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,agents: null == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as Map<String, AgentInfo>,selectedAgentId: freezed == selectedAgentId ? _self.selectedAgentId : selectedAgentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsageInfoCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $UsageInfoCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

/// @nodoc


class ConversationError implements ConversationState {
  const ConversationError(this.message);
  

 final  String message;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationErrorCopyWith<ConversationError> get copyWith => _$ConversationErrorCopyWithImpl<ConversationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ConversationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConversationErrorCopyWith<$Res> implements $ConversationStateCopyWith<$Res> {
  factory $ConversationErrorCopyWith(ConversationError value, $Res Function(ConversationError) _then) = _$ConversationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConversationErrorCopyWithImpl<$Res>
    implements $ConversationErrorCopyWith<$Res> {
  _$ConversationErrorCopyWithImpl(this._self, this._then);

  final ConversationError _self;
  final $Res Function(ConversationError) _then;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConversationError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatMessage {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatMessage()';
}


}

/// @nodoc
class $ChatMessageCopyWith<$Res>  {
$ChatMessageCopyWith(ChatMessage _, $Res Function(ChatMessage) __);
}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserChatMessage value)?  user,TResult Function( AgentChatMessage value)?  agent,TResult Function( ToolCallMessage value)?  toolCall,TResult Function( PermissionRequestMessage value)?  permissionRequest,TResult Function( UserQuestionMessage value)?  userQuestion,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserChatMessage() when user != null:
return user(_that);case AgentChatMessage() when agent != null:
return agent(_that);case ToolCallMessage() when toolCall != null:
return toolCall(_that);case PermissionRequestMessage() when permissionRequest != null:
return permissionRequest(_that);case UserQuestionMessage() when userQuestion != null:
return userQuestion(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserChatMessage value)  user,required TResult Function( AgentChatMessage value)  agent,required TResult Function( ToolCallMessage value)  toolCall,required TResult Function( PermissionRequestMessage value)  permissionRequest,required TResult Function( UserQuestionMessage value)  userQuestion,}){
final _that = this;
switch (_that) {
case UserChatMessage():
return user(_that);case AgentChatMessage():
return agent(_that);case ToolCallMessage():
return toolCall(_that);case PermissionRequestMessage():
return permissionRequest(_that);case UserQuestionMessage():
return userQuestion(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserChatMessage value)?  user,TResult? Function( AgentChatMessage value)?  agent,TResult? Function( ToolCallMessage value)?  toolCall,TResult? Function( PermissionRequestMessage value)?  permissionRequest,TResult? Function( UserQuestionMessage value)?  userQuestion,}){
final _that = this;
switch (_that) {
case UserChatMessage() when user != null:
return user(_that);case AgentChatMessage() when agent != null:
return agent(_that);case ToolCallMessage() when toolCall != null:
return toolCall(_that);case PermissionRequestMessage() when permissionRequest != null:
return permissionRequest(_that);case UserQuestionMessage() when userQuestion != null:
return userQuestion(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String content,  DateTime timestamp)?  user,TResult Function( String content,  DateTime timestamp,  bool isComplete,  String? parentToolUseId)?  agent,TResult Function( String toolId,  String toolName,  String description,  String? input,  String? output,  bool isError,  int? durationMs,  bool isComplete,  String? parentToolUseId)?  toolCall,TResult Function( String requestId,  String toolName,  String description,  String? input,  PermissionDecision? decision,  String? parentToolUseId)?  permissionRequest,TResult Function( String questionId,  String question,  List<QuestionOption> options,  bool multiSelect,  Map<String, String>? answers,  String? parentToolUseId)?  userQuestion,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserChatMessage() when user != null:
return user(_that.content,_that.timestamp);case AgentChatMessage() when agent != null:
return agent(_that.content,_that.timestamp,_that.isComplete,_that.parentToolUseId);case ToolCallMessage() when toolCall != null:
return toolCall(_that.toolId,_that.toolName,_that.description,_that.input,_that.output,_that.isError,_that.durationMs,_that.isComplete,_that.parentToolUseId);case PermissionRequestMessage() when permissionRequest != null:
return permissionRequest(_that.requestId,_that.toolName,_that.description,_that.input,_that.decision,_that.parentToolUseId);case UserQuestionMessage() when userQuestion != null:
return userQuestion(_that.questionId,_that.question,_that.options,_that.multiSelect,_that.answers,_that.parentToolUseId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String content,  DateTime timestamp)  user,required TResult Function( String content,  DateTime timestamp,  bool isComplete,  String? parentToolUseId)  agent,required TResult Function( String toolId,  String toolName,  String description,  String? input,  String? output,  bool isError,  int? durationMs,  bool isComplete,  String? parentToolUseId)  toolCall,required TResult Function( String requestId,  String toolName,  String description,  String? input,  PermissionDecision? decision,  String? parentToolUseId)  permissionRequest,required TResult Function( String questionId,  String question,  List<QuestionOption> options,  bool multiSelect,  Map<String, String>? answers,  String? parentToolUseId)  userQuestion,}) {final _that = this;
switch (_that) {
case UserChatMessage():
return user(_that.content,_that.timestamp);case AgentChatMessage():
return agent(_that.content,_that.timestamp,_that.isComplete,_that.parentToolUseId);case ToolCallMessage():
return toolCall(_that.toolId,_that.toolName,_that.description,_that.input,_that.output,_that.isError,_that.durationMs,_that.isComplete,_that.parentToolUseId);case PermissionRequestMessage():
return permissionRequest(_that.requestId,_that.toolName,_that.description,_that.input,_that.decision,_that.parentToolUseId);case UserQuestionMessage():
return userQuestion(_that.questionId,_that.question,_that.options,_that.multiSelect,_that.answers,_that.parentToolUseId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String content,  DateTime timestamp)?  user,TResult? Function( String content,  DateTime timestamp,  bool isComplete,  String? parentToolUseId)?  agent,TResult? Function( String toolId,  String toolName,  String description,  String? input,  String? output,  bool isError,  int? durationMs,  bool isComplete,  String? parentToolUseId)?  toolCall,TResult? Function( String requestId,  String toolName,  String description,  String? input,  PermissionDecision? decision,  String? parentToolUseId)?  permissionRequest,TResult? Function( String questionId,  String question,  List<QuestionOption> options,  bool multiSelect,  Map<String, String>? answers,  String? parentToolUseId)?  userQuestion,}) {final _that = this;
switch (_that) {
case UserChatMessage() when user != null:
return user(_that.content,_that.timestamp);case AgentChatMessage() when agent != null:
return agent(_that.content,_that.timestamp,_that.isComplete,_that.parentToolUseId);case ToolCallMessage() when toolCall != null:
return toolCall(_that.toolId,_that.toolName,_that.description,_that.input,_that.output,_that.isError,_that.durationMs,_that.isComplete,_that.parentToolUseId);case PermissionRequestMessage() when permissionRequest != null:
return permissionRequest(_that.requestId,_that.toolName,_that.description,_that.input,_that.decision,_that.parentToolUseId);case UserQuestionMessage() when userQuestion != null:
return userQuestion(_that.questionId,_that.question,_that.options,_that.multiSelect,_that.answers,_that.parentToolUseId);case _:
  return null;

}
}

}

/// @nodoc


class UserChatMessage implements ChatMessage {
  const UserChatMessage({required this.content, required this.timestamp});
  

 final  String content;
 final  DateTime timestamp;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserChatMessageCopyWith<UserChatMessage> get copyWith => _$UserChatMessageCopyWithImpl<UserChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserChatMessage&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,content,timestamp);

@override
String toString() {
  return 'ChatMessage.user(content: $content, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $UserChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory $UserChatMessageCopyWith(UserChatMessage value, $Res Function(UserChatMessage) _then) = _$UserChatMessageCopyWithImpl;
@useResult
$Res call({
 String content, DateTime timestamp
});




}
/// @nodoc
class _$UserChatMessageCopyWithImpl<$Res>
    implements $UserChatMessageCopyWith<$Res> {
  _$UserChatMessageCopyWithImpl(this._self, this._then);

  final UserChatMessage _self;
  final $Res Function(UserChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,Object? timestamp = null,}) {
  return _then(UserChatMessage(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class AgentChatMessage implements ChatMessage {
  const AgentChatMessage({required this.content, required this.timestamp, this.isComplete = false, this.parentToolUseId});
  

 final  String content;
 final  DateTime timestamp;
@JsonKey() final  bool isComplete;
 final  String? parentToolUseId;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentChatMessageCopyWith<AgentChatMessage> get copyWith => _$AgentChatMessageCopyWithImpl<AgentChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentChatMessage&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.parentToolUseId, parentToolUseId) || other.parentToolUseId == parentToolUseId));
}


@override
int get hashCode => Object.hash(runtimeType,content,timestamp,isComplete,parentToolUseId);

@override
String toString() {
  return 'ChatMessage.agent(content: $content, timestamp: $timestamp, isComplete: $isComplete, parentToolUseId: $parentToolUseId)';
}


}

/// @nodoc
abstract mixin class $AgentChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory $AgentChatMessageCopyWith(AgentChatMessage value, $Res Function(AgentChatMessage) _then) = _$AgentChatMessageCopyWithImpl;
@useResult
$Res call({
 String content, DateTime timestamp, bool isComplete, String? parentToolUseId
});




}
/// @nodoc
class _$AgentChatMessageCopyWithImpl<$Res>
    implements $AgentChatMessageCopyWith<$Res> {
  _$AgentChatMessageCopyWithImpl(this._self, this._then);

  final AgentChatMessage _self;
  final $Res Function(AgentChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,Object? timestamp = null,Object? isComplete = null,Object? parentToolUseId = freezed,}) {
  return _then(AgentChatMessage(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,parentToolUseId: freezed == parentToolUseId ? _self.parentToolUseId : parentToolUseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ToolCallMessage implements ChatMessage {
  const ToolCallMessage({required this.toolId, required this.toolName, required this.description, this.input, this.output, this.isError = false, this.durationMs, this.isComplete = false, this.parentToolUseId});
  

 final  String toolId;
 final  String toolName;
 final  String description;
 final  String? input;
 final  String? output;
@JsonKey() final  bool isError;
 final  int? durationMs;
@JsonKey() final  bool isComplete;
 final  String? parentToolUseId;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolCallMessageCopyWith<ToolCallMessage> get copyWith => _$ToolCallMessageCopyWithImpl<ToolCallMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolCallMessage&&(identical(other.toolId, toolId) || other.toolId == toolId)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&(identical(other.description, description) || other.description == description)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.parentToolUseId, parentToolUseId) || other.parentToolUseId == parentToolUseId));
}


@override
int get hashCode => Object.hash(runtimeType,toolId,toolName,description,input,output,isError,durationMs,isComplete,parentToolUseId);

@override
String toString() {
  return 'ChatMessage.toolCall(toolId: $toolId, toolName: $toolName, description: $description, input: $input, output: $output, isError: $isError, durationMs: $durationMs, isComplete: $isComplete, parentToolUseId: $parentToolUseId)';
}


}

/// @nodoc
abstract mixin class $ToolCallMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory $ToolCallMessageCopyWith(ToolCallMessage value, $Res Function(ToolCallMessage) _then) = _$ToolCallMessageCopyWithImpl;
@useResult
$Res call({
 String toolId, String toolName, String description, String? input, String? output, bool isError, int? durationMs, bool isComplete, String? parentToolUseId
});




}
/// @nodoc
class _$ToolCallMessageCopyWithImpl<$Res>
    implements $ToolCallMessageCopyWith<$Res> {
  _$ToolCallMessageCopyWithImpl(this._self, this._then);

  final ToolCallMessage _self;
  final $Res Function(ToolCallMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? toolId = null,Object? toolName = null,Object? description = null,Object? input = freezed,Object? output = freezed,Object? isError = null,Object? durationMs = freezed,Object? isComplete = null,Object? parentToolUseId = freezed,}) {
  return _then(ToolCallMessage(
toolId: null == toolId ? _self.toolId : toolId // ignore: cast_nullable_to_non_nullable
as String,toolName: null == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String?,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,parentToolUseId: freezed == parentToolUseId ? _self.parentToolUseId : parentToolUseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PermissionRequestMessage implements ChatMessage {
  const PermissionRequestMessage({required this.requestId, required this.toolName, required this.description, this.input, this.decision, this.parentToolUseId});
  

 final  String requestId;
 final  String toolName;
 final  String description;
 final  String? input;
 final  PermissionDecision? decision;
 final  String? parentToolUseId;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionRequestMessageCopyWith<PermissionRequestMessage> get copyWith => _$PermissionRequestMessageCopyWithImpl<PermissionRequestMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionRequestMessage&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&(identical(other.description, description) || other.description == description)&&(identical(other.input, input) || other.input == input)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.parentToolUseId, parentToolUseId) || other.parentToolUseId == parentToolUseId));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,toolName,description,input,decision,parentToolUseId);

@override
String toString() {
  return 'ChatMessage.permissionRequest(requestId: $requestId, toolName: $toolName, description: $description, input: $input, decision: $decision, parentToolUseId: $parentToolUseId)';
}


}

/// @nodoc
abstract mixin class $PermissionRequestMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory $PermissionRequestMessageCopyWith(PermissionRequestMessage value, $Res Function(PermissionRequestMessage) _then) = _$PermissionRequestMessageCopyWithImpl;
@useResult
$Res call({
 String requestId, String toolName, String description, String? input, PermissionDecision? decision, String? parentToolUseId
});




}
/// @nodoc
class _$PermissionRequestMessageCopyWithImpl<$Res>
    implements $PermissionRequestMessageCopyWith<$Res> {
  _$PermissionRequestMessageCopyWithImpl(this._self, this._then);

  final PermissionRequestMessage _self;
  final $Res Function(PermissionRequestMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? toolName = null,Object? description = null,Object? input = freezed,Object? decision = freezed,Object? parentToolUseId = freezed,}) {
  return _then(PermissionRequestMessage(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,toolName: null == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String?,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as PermissionDecision?,parentToolUseId: freezed == parentToolUseId ? _self.parentToolUseId : parentToolUseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UserQuestionMessage implements ChatMessage {
  const UserQuestionMessage({required this.questionId, required this.question, required final  List<QuestionOption> options, required this.multiSelect, final  Map<String, String>? answers, this.parentToolUseId}): _options = options,_answers = answers;
  

 final  String questionId;
 final  String question;
 final  List<QuestionOption> _options;
 List<QuestionOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  bool multiSelect;
 final  Map<String, String>? _answers;
 Map<String, String>? get answers {
  final value = _answers;
  if (value == null) return null;
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  String? parentToolUseId;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserQuestionMessageCopyWith<UserQuestionMessage> get copyWith => _$UserQuestionMessageCopyWithImpl<UserQuestionMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserQuestionMessage&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.multiSelect, multiSelect) || other.multiSelect == multiSelect)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.parentToolUseId, parentToolUseId) || other.parentToolUseId == parentToolUseId));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,question,const DeepCollectionEquality().hash(_options),multiSelect,const DeepCollectionEquality().hash(_answers),parentToolUseId);

@override
String toString() {
  return 'ChatMessage.userQuestion(questionId: $questionId, question: $question, options: $options, multiSelect: $multiSelect, answers: $answers, parentToolUseId: $parentToolUseId)';
}


}

/// @nodoc
abstract mixin class $UserQuestionMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory $UserQuestionMessageCopyWith(UserQuestionMessage value, $Res Function(UserQuestionMessage) _then) = _$UserQuestionMessageCopyWithImpl;
@useResult
$Res call({
 String questionId, String question, List<QuestionOption> options, bool multiSelect, Map<String, String>? answers, String? parentToolUseId
});




}
/// @nodoc
class _$UserQuestionMessageCopyWithImpl<$Res>
    implements $UserQuestionMessageCopyWith<$Res> {
  _$UserQuestionMessageCopyWithImpl(this._self, this._then);

  final UserQuestionMessage _self;
  final $Res Function(UserQuestionMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? question = null,Object? options = null,Object? multiSelect = null,Object? answers = freezed,Object? parentToolUseId = freezed,}) {
  return _then(UserQuestionMessage(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>,multiSelect: null == multiSelect ? _self.multiSelect : multiSelect // ignore: cast_nullable_to_non_nullable
as bool,answers: freezed == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,parentToolUseId: freezed == parentToolUseId ? _self.parentToolUseId : parentToolUseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UsageInfo {

 int get inputTokens; int get outputTokens; int get cacheReadTokens; int get cacheCreationTokens; String get model; double get costUsd; int get durationMs;
/// Create a copy of UsageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsageInfoCopyWith<UsageInfo> get copyWith => _$UsageInfoCopyWithImpl<UsageInfo>(this as UsageInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsageInfo&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.cacheReadTokens, cacheReadTokens) || other.cacheReadTokens == cacheReadTokens)&&(identical(other.cacheCreationTokens, cacheCreationTokens) || other.cacheCreationTokens == cacheCreationTokens)&&(identical(other.model, model) || other.model == model)&&(identical(other.costUsd, costUsd) || other.costUsd == costUsd)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}


@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,cacheReadTokens,cacheCreationTokens,model,costUsd,durationMs);

@override
String toString() {
  return 'UsageInfo(inputTokens: $inputTokens, outputTokens: $outputTokens, cacheReadTokens: $cacheReadTokens, cacheCreationTokens: $cacheCreationTokens, model: $model, costUsd: $costUsd, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $UsageInfoCopyWith<$Res>  {
  factory $UsageInfoCopyWith(UsageInfo value, $Res Function(UsageInfo) _then) = _$UsageInfoCopyWithImpl;
@useResult
$Res call({
 int inputTokens, int outputTokens, int cacheReadTokens, int cacheCreationTokens, String model, double costUsd, int durationMs
});




}
/// @nodoc
class _$UsageInfoCopyWithImpl<$Res>
    implements $UsageInfoCopyWith<$Res> {
  _$UsageInfoCopyWithImpl(this._self, this._then);

  final UsageInfo _self;
  final $Res Function(UsageInfo) _then;

/// Create a copy of UsageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputTokens = null,Object? outputTokens = null,Object? cacheReadTokens = null,Object? cacheCreationTokens = null,Object? model = null,Object? costUsd = null,Object? durationMs = null,}) {
  return _then(_self.copyWith(
inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,cacheReadTokens: null == cacheReadTokens ? _self.cacheReadTokens : cacheReadTokens // ignore: cast_nullable_to_non_nullable
as int,cacheCreationTokens: null == cacheCreationTokens ? _self.cacheCreationTokens : cacheCreationTokens // ignore: cast_nullable_to_non_nullable
as int,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,costUsd: null == costUsd ? _self.costUsd : costUsd // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UsageInfo].
extension UsageInfoPatterns on UsageInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsageInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsageInfo value)  $default,){
final _that = this;
switch (_that) {
case _UsageInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _UsageInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens,  int cacheReadTokens,  int cacheCreationTokens,  String model,  double costUsd,  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsageInfo() when $default != null:
return $default(_that.inputTokens,_that.outputTokens,_that.cacheReadTokens,_that.cacheCreationTokens,_that.model,_that.costUsd,_that.durationMs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens,  int cacheReadTokens,  int cacheCreationTokens,  String model,  double costUsd,  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _UsageInfo():
return $default(_that.inputTokens,_that.outputTokens,_that.cacheReadTokens,_that.cacheCreationTokens,_that.model,_that.costUsd,_that.durationMs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inputTokens,  int outputTokens,  int cacheReadTokens,  int cacheCreationTokens,  String model,  double costUsd,  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _UsageInfo() when $default != null:
return $default(_that.inputTokens,_that.outputTokens,_that.cacheReadTokens,_that.cacheCreationTokens,_that.model,_that.costUsd,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc


class _UsageInfo implements UsageInfo {
  const _UsageInfo({this.inputTokens = 0, this.outputTokens = 0, this.cacheReadTokens = 0, this.cacheCreationTokens = 0, this.model = '', this.costUsd = 0.0, this.durationMs = 0});
  

@override@JsonKey() final  int inputTokens;
@override@JsonKey() final  int outputTokens;
@override@JsonKey() final  int cacheReadTokens;
@override@JsonKey() final  int cacheCreationTokens;
@override@JsonKey() final  String model;
@override@JsonKey() final  double costUsd;
@override@JsonKey() final  int durationMs;

/// Create a copy of UsageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsageInfoCopyWith<_UsageInfo> get copyWith => __$UsageInfoCopyWithImpl<_UsageInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsageInfo&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.cacheReadTokens, cacheReadTokens) || other.cacheReadTokens == cacheReadTokens)&&(identical(other.cacheCreationTokens, cacheCreationTokens) || other.cacheCreationTokens == cacheCreationTokens)&&(identical(other.model, model) || other.model == model)&&(identical(other.costUsd, costUsd) || other.costUsd == costUsd)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}


@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,cacheReadTokens,cacheCreationTokens,model,costUsd,durationMs);

@override
String toString() {
  return 'UsageInfo(inputTokens: $inputTokens, outputTokens: $outputTokens, cacheReadTokens: $cacheReadTokens, cacheCreationTokens: $cacheCreationTokens, model: $model, costUsd: $costUsd, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$UsageInfoCopyWith<$Res> implements $UsageInfoCopyWith<$Res> {
  factory _$UsageInfoCopyWith(_UsageInfo value, $Res Function(_UsageInfo) _then) = __$UsageInfoCopyWithImpl;
@override @useResult
$Res call({
 int inputTokens, int outputTokens, int cacheReadTokens, int cacheCreationTokens, String model, double costUsd, int durationMs
});




}
/// @nodoc
class __$UsageInfoCopyWithImpl<$Res>
    implements _$UsageInfoCopyWith<$Res> {
  __$UsageInfoCopyWithImpl(this._self, this._then);

  final _UsageInfo _self;
  final $Res Function(_UsageInfo) _then;

/// Create a copy of UsageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputTokens = null,Object? outputTokens = null,Object? cacheReadTokens = null,Object? cacheCreationTokens = null,Object? model = null,Object? costUsd = null,Object? durationMs = null,}) {
  return _then(_UsageInfo(
inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,cacheReadTokens: null == cacheReadTokens ? _self.cacheReadTokens : cacheReadTokens // ignore: cast_nullable_to_non_nullable
as int,cacheCreationTokens: null == cacheCreationTokens ? _self.cacheCreationTokens : cacheCreationTokens // ignore: cast_nullable_to_non_nullable
as int,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,costUsd: null == costUsd ? _self.costUsd : costUsd // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AgentInfo {

 String get id; String get name; AgentStatus get status; bool get isComplete; int get messageCount; DateTime? get lastActivity;
/// Create a copy of AgentInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentInfoCopyWith<AgentInfo> get copyWith => _$AgentInfoCopyWithImpl<AgentInfo>(this as AgentInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,isComplete,messageCount,lastActivity);

@override
String toString() {
  return 'AgentInfo(id: $id, name: $name, status: $status, isComplete: $isComplete, messageCount: $messageCount, lastActivity: $lastActivity)';
}


}

/// @nodoc
abstract mixin class $AgentInfoCopyWith<$Res>  {
  factory $AgentInfoCopyWith(AgentInfo value, $Res Function(AgentInfo) _then) = _$AgentInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, AgentStatus status, bool isComplete, int messageCount, DateTime? lastActivity
});




}
/// @nodoc
class _$AgentInfoCopyWithImpl<$Res>
    implements $AgentInfoCopyWith<$Res> {
  _$AgentInfoCopyWithImpl(this._self, this._then);

  final AgentInfo _self;
  final $Res Function(AgentInfo) _then;

/// Create a copy of AgentInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? isComplete = null,Object? messageCount = null,Object? lastActivity = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgentStatus,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentInfo].
extension AgentInfoPatterns on AgentInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentInfo value)  $default,){
final _that = this;
switch (_that) {
case _AgentInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AgentInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AgentStatus status,  bool isComplete,  int messageCount,  DateTime? lastActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentInfo() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.isComplete,_that.messageCount,_that.lastActivity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AgentStatus status,  bool isComplete,  int messageCount,  DateTime? lastActivity)  $default,) {final _that = this;
switch (_that) {
case _AgentInfo():
return $default(_that.id,_that.name,_that.status,_that.isComplete,_that.messageCount,_that.lastActivity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AgentStatus status,  bool isComplete,  int messageCount,  DateTime? lastActivity)?  $default,) {final _that = this;
switch (_that) {
case _AgentInfo() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.isComplete,_that.messageCount,_that.lastActivity);case _:
  return null;

}
}

}

/// @nodoc


class _AgentInfo implements AgentInfo {
  const _AgentInfo({required this.id, required this.name, required this.status, this.isComplete = false, this.messageCount = 0, this.lastActivity});
  

@override final  String id;
@override final  String name;
@override final  AgentStatus status;
@override@JsonKey() final  bool isComplete;
@override@JsonKey() final  int messageCount;
@override final  DateTime? lastActivity;

/// Create a copy of AgentInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentInfoCopyWith<_AgentInfo> get copyWith => __$AgentInfoCopyWithImpl<_AgentInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,isComplete,messageCount,lastActivity);

@override
String toString() {
  return 'AgentInfo(id: $id, name: $name, status: $status, isComplete: $isComplete, messageCount: $messageCount, lastActivity: $lastActivity)';
}


}

/// @nodoc
abstract mixin class _$AgentInfoCopyWith<$Res> implements $AgentInfoCopyWith<$Res> {
  factory _$AgentInfoCopyWith(_AgentInfo value, $Res Function(_AgentInfo) _then) = __$AgentInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AgentStatus status, bool isComplete, int messageCount, DateTime? lastActivity
});




}
/// @nodoc
class __$AgentInfoCopyWithImpl<$Res>
    implements _$AgentInfoCopyWith<$Res> {
  __$AgentInfoCopyWithImpl(this._self, this._then);

  final _AgentInfo _self;
  final $Res Function(_AgentInfo) _then;

/// Create a copy of AgentInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? isComplete = null,Object? messageCount = null,Object? lastActivity = freezed,}) {
  return _then(_AgentInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgentStatus,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
