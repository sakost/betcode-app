// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestTypeMeta = const VerificationMeta(
    'requestType',
  );
  @override
  late final GeneratedColumn<String> requestType = GeneratedColumn<String>(
    'request_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<Uint8List> payload = GeneratedColumn<Uint8List>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    machineId,
    sessionId,
    requestType,
    payload,
    idempotencyKey,
    priority,
    sequence,
    status,
    retryCount,
    lastError,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_machineIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('request_type')) {
      context.handle(
        _requestTypeMeta,
        requestType.isAcceptableOrUnknown(
          data['request_type']!,
          _requestTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      requestType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}payload'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String machineId;
  final String? sessionId;
  final String requestType;
  final Uint8List payload;
  final String idempotencyKey;
  final int priority;
  final int sequence;
  final String status;
  final int retryCount;
  final String? lastError;
  final int createdAt;
  final int expiresAt;
  const SyncQueueData({
    required this.id,
    required this.machineId,
    this.sessionId,
    required this.requestType,
    required this.payload,
    required this.idempotencyKey,
    required this.priority,
    required this.sequence,
    required this.status,
    required this.retryCount,
    this.lastError,
    required this.createdAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['machine_id'] = Variable<String>(machineId);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['request_type'] = Variable<String>(requestType);
    map['payload'] = Variable<Uint8List>(payload);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['priority'] = Variable<int>(priority);
    map['sequence'] = Variable<int>(sequence);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['expires_at'] = Variable<int>(expiresAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      machineId: Value(machineId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      requestType: Value(requestType),
      payload: Value(payload),
      idempotencyKey: Value(idempotencyKey),
      priority: Value(priority),
      sequence: Value(sequence),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      machineId: serializer.fromJson<String>(json['machineId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      requestType: serializer.fromJson<String>(json['requestType']),
      payload: serializer.fromJson<Uint8List>(json['payload']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      priority: serializer.fromJson<int>(json['priority']),
      sequence: serializer.fromJson<int>(json['sequence']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      expiresAt: serializer.fromJson<int>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'machineId': serializer.toJson<String>(machineId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'requestType': serializer.toJson<String>(requestType),
      'payload': serializer.toJson<Uint8List>(payload),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'priority': serializer.toJson<int>(priority),
      'sequence': serializer.toJson<int>(sequence),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<int>(createdAt),
      'expiresAt': serializer.toJson<int>(expiresAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? machineId,
    Value<String?> sessionId = const Value.absent(),
    String? requestType,
    Uint8List? payload,
    String? idempotencyKey,
    int? priority,
    int? sequence,
    String? status,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    int? createdAt,
    int? expiresAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    machineId: machineId ?? this.machineId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    requestType: requestType ?? this.requestType,
    payload: payload ?? this.payload,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    priority: priority ?? this.priority,
    sequence: sequence ?? this.sequence,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      requestType: data.requestType.present
          ? data.requestType.value
          : this.requestType,
      payload: data.payload.present ? data.payload.value : this.payload,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      priority: data.priority.present ? data.priority.value : this.priority,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('machineId: $machineId, ')
          ..write('sessionId: $sessionId, ')
          ..write('requestType: $requestType, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('priority: $priority, ')
          ..write('sequence: $sequence, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    machineId,
    sessionId,
    requestType,
    $driftBlobEquality.hash(payload),
    idempotencyKey,
    priority,
    sequence,
    status,
    retryCount,
    lastError,
    createdAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.machineId == this.machineId &&
          other.sessionId == this.sessionId &&
          other.requestType == this.requestType &&
          $driftBlobEquality.equals(other.payload, this.payload) &&
          other.idempotencyKey == this.idempotencyKey &&
          other.priority == this.priority &&
          other.sequence == this.sequence &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> machineId;
  final Value<String?> sessionId;
  final Value<String> requestType;
  final Value<Uint8List> payload;
  final Value<String> idempotencyKey;
  final Value<int> priority;
  final Value<int> sequence;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<int> createdAt;
  final Value<int> expiresAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.machineId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.requestType = const Value.absent(),
    this.payload = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.priority = const Value.absent(),
    this.sequence = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String machineId,
    this.sessionId = const Value.absent(),
    required String requestType,
    required Uint8List payload,
    required String idempotencyKey,
    this.priority = const Value.absent(),
    required int sequence,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required int createdAt,
    required int expiresAt,
  }) : machineId = Value(machineId),
       requestType = Value(requestType),
       payload = Value(payload),
       idempotencyKey = Value(idempotencyKey),
       sequence = Value(sequence),
       createdAt = Value(createdAt),
       expiresAt = Value(expiresAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? machineId,
    Expression<String>? sessionId,
    Expression<String>? requestType,
    Expression<Uint8List>? payload,
    Expression<String>? idempotencyKey,
    Expression<int>? priority,
    Expression<int>? sequence,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<int>? createdAt,
    Expression<int>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (machineId != null) 'machine_id': machineId,
      if (sessionId != null) 'session_id': sessionId,
      if (requestType != null) 'request_type': requestType,
      if (payload != null) 'payload': payload,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (priority != null) 'priority': priority,
      if (sequence != null) 'sequence': sequence,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? machineId,
    Value<String?>? sessionId,
    Value<String>? requestType,
    Value<Uint8List>? payload,
    Value<String>? idempotencyKey,
    Value<int>? priority,
    Value<int>? sequence,
    Value<String>? status,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<int>? createdAt,
    Value<int>? expiresAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      sessionId: sessionId ?? this.sessionId,
      requestType: requestType ?? this.requestType,
      payload: payload ?? this.payload,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      priority: priority ?? this.priority,
      sequence: sequence ?? this.sequence,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (requestType.present) {
      map['request_type'] = Variable<String>(requestType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<Uint8List>(payload.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('machineId: $machineId, ')
          ..write('sessionId: $sessionId, ')
          ..write('requestType: $requestType, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('priority: $priority, ')
          ..write('sequence: $sequence, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $CachedSessionsTable extends CachedSessions
    with TableInfo<$CachedSessionsTable, CachedSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workingDirectoryMeta = const VerificationMeta(
    'workingDirectory',
  );
  @override
  late final GeneratedColumn<String> workingDirectory = GeneratedColumn<String>(
    'working_directory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _worktreeIdMeta = const VerificationMeta(
    'worktreeId',
  );
  @override
  late final GeneratedColumn<String> worktreeId = GeneratedColumn<String>(
    'worktree_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageCountMeta = const VerificationMeta(
    'messageCount',
  );
  @override
  late final GeneratedColumn<int> messageCount = GeneratedColumn<int>(
    'message_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalInputTokensMeta = const VerificationMeta(
    'totalInputTokens',
  );
  @override
  late final GeneratedColumn<int> totalInputTokens = GeneratedColumn<int>(
    'total_input_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalOutputTokensMeta = const VerificationMeta(
    'totalOutputTokens',
  );
  @override
  late final GeneratedColumn<int> totalOutputTokens = GeneratedColumn<int>(
    'total_output_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCostUsdMeta = const VerificationMeta(
    'totalCostUsd',
  );
  @override
  late final GeneratedColumn<double> totalCostUsd = GeneratedColumn<double>(
    'total_cost_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lastMessagePreviewMeta =
      const VerificationMeta('lastMessagePreview');
  @override
  late final GeneratedColumn<String> lastMessagePreview =
      GeneratedColumn<String>(
        'last_message_preview',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _messagesJsonMeta = const VerificationMeta(
    'messagesJson',
  );
  @override
  late final GeneratedColumn<String> messagesJson = GeneratedColumn<String>(
    'messages_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    machineId,
    model,
    workingDirectory,
    worktreeId,
    status,
    messageCount,
    totalInputTokens,
    totalOutputTokens,
    totalCostUsd,
    lastMessagePreview,
    lastSequence,
    messagesJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_machineIdMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('working_directory')) {
      context.handle(
        _workingDirectoryMeta,
        workingDirectory.isAcceptableOrUnknown(
          data['working_directory']!,
          _workingDirectoryMeta,
        ),
      );
    }
    if (data.containsKey('worktree_id')) {
      context.handle(
        _worktreeIdMeta,
        worktreeId.isAcceptableOrUnknown(data['worktree_id']!, _worktreeIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('message_count')) {
      context.handle(
        _messageCountMeta,
        messageCount.isAcceptableOrUnknown(
          data['message_count']!,
          _messageCountMeta,
        ),
      );
    }
    if (data.containsKey('total_input_tokens')) {
      context.handle(
        _totalInputTokensMeta,
        totalInputTokens.isAcceptableOrUnknown(
          data['total_input_tokens']!,
          _totalInputTokensMeta,
        ),
      );
    }
    if (data.containsKey('total_output_tokens')) {
      context.handle(
        _totalOutputTokensMeta,
        totalOutputTokens.isAcceptableOrUnknown(
          data['total_output_tokens']!,
          _totalOutputTokensMeta,
        ),
      );
    }
    if (data.containsKey('total_cost_usd')) {
      context.handle(
        _totalCostUsdMeta,
        totalCostUsd.isAcceptableOrUnknown(
          data['total_cost_usd']!,
          _totalCostUsdMeta,
        ),
      );
    }
    if (data.containsKey('last_message_preview')) {
      context.handle(
        _lastMessagePreviewMeta,
        lastMessagePreview.isAcceptableOrUnknown(
          data['last_message_preview']!,
          _lastMessagePreviewMeta,
        ),
      );
    }
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    }
    if (data.containsKey('messages_json')) {
      context.handle(
        _messagesJsonMeta,
        messagesJson.isAcceptableOrUnknown(
          data['messages_json']!,
          _messagesJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      workingDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}working_directory'],
      ),
      worktreeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worktree_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      messageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_count'],
      )!,
      totalInputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_input_tokens'],
      )!,
      totalOutputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_output_tokens'],
      )!,
      totalCostUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost_usd'],
      )!,
      lastMessagePreview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message_preview'],
      ),
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
      messagesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}messages_json'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedSessionsTable createAlias(String alias) {
    return $CachedSessionsTable(attachedDatabase, alias);
  }
}

class CachedSession extends DataClass implements Insertable<CachedSession> {
  final String id;
  final String machineId;
  final String? model;
  final String? workingDirectory;
  final String? worktreeId;
  final String? status;
  final int messageCount;
  final int totalInputTokens;
  final int totalOutputTokens;
  final double totalCostUsd;
  final String? lastMessagePreview;
  final int lastSequence;
  final String? messagesJson;
  final int updatedAt;
  const CachedSession({
    required this.id,
    required this.machineId,
    this.model,
    this.workingDirectory,
    this.worktreeId,
    this.status,
    required this.messageCount,
    required this.totalInputTokens,
    required this.totalOutputTokens,
    required this.totalCostUsd,
    this.lastMessagePreview,
    required this.lastSequence,
    this.messagesJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['machine_id'] = Variable<String>(machineId);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || workingDirectory != null) {
      map['working_directory'] = Variable<String>(workingDirectory);
    }
    if (!nullToAbsent || worktreeId != null) {
      map['worktree_id'] = Variable<String>(worktreeId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['message_count'] = Variable<int>(messageCount);
    map['total_input_tokens'] = Variable<int>(totalInputTokens);
    map['total_output_tokens'] = Variable<int>(totalOutputTokens);
    map['total_cost_usd'] = Variable<double>(totalCostUsd);
    if (!nullToAbsent || lastMessagePreview != null) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview);
    }
    map['last_sequence'] = Variable<int>(lastSequence);
    if (!nullToAbsent || messagesJson != null) {
      map['messages_json'] = Variable<String>(messagesJson);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CachedSessionsCompanion toCompanion(bool nullToAbsent) {
    return CachedSessionsCompanion(
      id: Value(id),
      machineId: Value(machineId),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      workingDirectory: workingDirectory == null && nullToAbsent
          ? const Value.absent()
          : Value(workingDirectory),
      worktreeId: worktreeId == null && nullToAbsent
          ? const Value.absent()
          : Value(worktreeId),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      messageCount: Value(messageCount),
      totalInputTokens: Value(totalInputTokens),
      totalOutputTokens: Value(totalOutputTokens),
      totalCostUsd: Value(totalCostUsd),
      lastMessagePreview: lastMessagePreview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessagePreview),
      lastSequence: Value(lastSequence),
      messagesJson: messagesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(messagesJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSession(
      id: serializer.fromJson<String>(json['id']),
      machineId: serializer.fromJson<String>(json['machineId']),
      model: serializer.fromJson<String?>(json['model']),
      workingDirectory: serializer.fromJson<String?>(json['workingDirectory']),
      worktreeId: serializer.fromJson<String?>(json['worktreeId']),
      status: serializer.fromJson<String?>(json['status']),
      messageCount: serializer.fromJson<int>(json['messageCount']),
      totalInputTokens: serializer.fromJson<int>(json['totalInputTokens']),
      totalOutputTokens: serializer.fromJson<int>(json['totalOutputTokens']),
      totalCostUsd: serializer.fromJson<double>(json['totalCostUsd']),
      lastMessagePreview: serializer.fromJson<String?>(
        json['lastMessagePreview'],
      ),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
      messagesJson: serializer.fromJson<String?>(json['messagesJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'machineId': serializer.toJson<String>(machineId),
      'model': serializer.toJson<String?>(model),
      'workingDirectory': serializer.toJson<String?>(workingDirectory),
      'worktreeId': serializer.toJson<String?>(worktreeId),
      'status': serializer.toJson<String?>(status),
      'messageCount': serializer.toJson<int>(messageCount),
      'totalInputTokens': serializer.toJson<int>(totalInputTokens),
      'totalOutputTokens': serializer.toJson<int>(totalOutputTokens),
      'totalCostUsd': serializer.toJson<double>(totalCostUsd),
      'lastMessagePreview': serializer.toJson<String?>(lastMessagePreview),
      'lastSequence': serializer.toJson<int>(lastSequence),
      'messagesJson': serializer.toJson<String?>(messagesJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CachedSession copyWith({
    String? id,
    String? machineId,
    Value<String?> model = const Value.absent(),
    Value<String?> workingDirectory = const Value.absent(),
    Value<String?> worktreeId = const Value.absent(),
    Value<String?> status = const Value.absent(),
    int? messageCount,
    int? totalInputTokens,
    int? totalOutputTokens,
    double? totalCostUsd,
    Value<String?> lastMessagePreview = const Value.absent(),
    int? lastSequence,
    Value<String?> messagesJson = const Value.absent(),
    int? updatedAt,
  }) => CachedSession(
    id: id ?? this.id,
    machineId: machineId ?? this.machineId,
    model: model.present ? model.value : this.model,
    workingDirectory: workingDirectory.present
        ? workingDirectory.value
        : this.workingDirectory,
    worktreeId: worktreeId.present ? worktreeId.value : this.worktreeId,
    status: status.present ? status.value : this.status,
    messageCount: messageCount ?? this.messageCount,
    totalInputTokens: totalInputTokens ?? this.totalInputTokens,
    totalOutputTokens: totalOutputTokens ?? this.totalOutputTokens,
    totalCostUsd: totalCostUsd ?? this.totalCostUsd,
    lastMessagePreview: lastMessagePreview.present
        ? lastMessagePreview.value
        : this.lastMessagePreview,
    lastSequence: lastSequence ?? this.lastSequence,
    messagesJson: messagesJson.present ? messagesJson.value : this.messagesJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedSession copyWithCompanion(CachedSessionsCompanion data) {
    return CachedSession(
      id: data.id.present ? data.id.value : this.id,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      model: data.model.present ? data.model.value : this.model,
      workingDirectory: data.workingDirectory.present
          ? data.workingDirectory.value
          : this.workingDirectory,
      worktreeId: data.worktreeId.present
          ? data.worktreeId.value
          : this.worktreeId,
      status: data.status.present ? data.status.value : this.status,
      messageCount: data.messageCount.present
          ? data.messageCount.value
          : this.messageCount,
      totalInputTokens: data.totalInputTokens.present
          ? data.totalInputTokens.value
          : this.totalInputTokens,
      totalOutputTokens: data.totalOutputTokens.present
          ? data.totalOutputTokens.value
          : this.totalOutputTokens,
      totalCostUsd: data.totalCostUsd.present
          ? data.totalCostUsd.value
          : this.totalCostUsd,
      lastMessagePreview: data.lastMessagePreview.present
          ? data.lastMessagePreview.value
          : this.lastMessagePreview,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
      messagesJson: data.messagesJson.present
          ? data.messagesJson.value
          : this.messagesJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSession(')
          ..write('id: $id, ')
          ..write('machineId: $machineId, ')
          ..write('model: $model, ')
          ..write('workingDirectory: $workingDirectory, ')
          ..write('worktreeId: $worktreeId, ')
          ..write('status: $status, ')
          ..write('messageCount: $messageCount, ')
          ..write('totalInputTokens: $totalInputTokens, ')
          ..write('totalOutputTokens: $totalOutputTokens, ')
          ..write('totalCostUsd: $totalCostUsd, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('messagesJson: $messagesJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    machineId,
    model,
    workingDirectory,
    worktreeId,
    status,
    messageCount,
    totalInputTokens,
    totalOutputTokens,
    totalCostUsd,
    lastMessagePreview,
    lastSequence,
    messagesJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSession &&
          other.id == this.id &&
          other.machineId == this.machineId &&
          other.model == this.model &&
          other.workingDirectory == this.workingDirectory &&
          other.worktreeId == this.worktreeId &&
          other.status == this.status &&
          other.messageCount == this.messageCount &&
          other.totalInputTokens == this.totalInputTokens &&
          other.totalOutputTokens == this.totalOutputTokens &&
          other.totalCostUsd == this.totalCostUsd &&
          other.lastMessagePreview == this.lastMessagePreview &&
          other.lastSequence == this.lastSequence &&
          other.messagesJson == this.messagesJson &&
          other.updatedAt == this.updatedAt);
}

class CachedSessionsCompanion extends UpdateCompanion<CachedSession> {
  final Value<String> id;
  final Value<String> machineId;
  final Value<String?> model;
  final Value<String?> workingDirectory;
  final Value<String?> worktreeId;
  final Value<String?> status;
  final Value<int> messageCount;
  final Value<int> totalInputTokens;
  final Value<int> totalOutputTokens;
  final Value<double> totalCostUsd;
  final Value<String?> lastMessagePreview;
  final Value<int> lastSequence;
  final Value<String?> messagesJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CachedSessionsCompanion({
    this.id = const Value.absent(),
    this.machineId = const Value.absent(),
    this.model = const Value.absent(),
    this.workingDirectory = const Value.absent(),
    this.worktreeId = const Value.absent(),
    this.status = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.totalInputTokens = const Value.absent(),
    this.totalOutputTokens = const Value.absent(),
    this.totalCostUsd = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastSequence = const Value.absent(),
    this.messagesJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSessionsCompanion.insert({
    required String id,
    required String machineId,
    this.model = const Value.absent(),
    this.workingDirectory = const Value.absent(),
    this.worktreeId = const Value.absent(),
    this.status = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.totalInputTokens = const Value.absent(),
    this.totalOutputTokens = const Value.absent(),
    this.totalCostUsd = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastSequence = const Value.absent(),
    this.messagesJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       machineId = Value(machineId),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSession> custom({
    Expression<String>? id,
    Expression<String>? machineId,
    Expression<String>? model,
    Expression<String>? workingDirectory,
    Expression<String>? worktreeId,
    Expression<String>? status,
    Expression<int>? messageCount,
    Expression<int>? totalInputTokens,
    Expression<int>? totalOutputTokens,
    Expression<double>? totalCostUsd,
    Expression<String>? lastMessagePreview,
    Expression<int>? lastSequence,
    Expression<String>? messagesJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (machineId != null) 'machine_id': machineId,
      if (model != null) 'model': model,
      if (workingDirectory != null) 'working_directory': workingDirectory,
      if (worktreeId != null) 'worktree_id': worktreeId,
      if (status != null) 'status': status,
      if (messageCount != null) 'message_count': messageCount,
      if (totalInputTokens != null) 'total_input_tokens': totalInputTokens,
      if (totalOutputTokens != null) 'total_output_tokens': totalOutputTokens,
      if (totalCostUsd != null) 'total_cost_usd': totalCostUsd,
      if (lastMessagePreview != null)
        'last_message_preview': lastMessagePreview,
      if (lastSequence != null) 'last_sequence': lastSequence,
      if (messagesJson != null) 'messages_json': messagesJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? machineId,
    Value<String?>? model,
    Value<String?>? workingDirectory,
    Value<String?>? worktreeId,
    Value<String?>? status,
    Value<int>? messageCount,
    Value<int>? totalInputTokens,
    Value<int>? totalOutputTokens,
    Value<double>? totalCostUsd,
    Value<String?>? lastMessagePreview,
    Value<int>? lastSequence,
    Value<String?>? messagesJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedSessionsCompanion(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      model: model ?? this.model,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      worktreeId: worktreeId ?? this.worktreeId,
      status: status ?? this.status,
      messageCount: messageCount ?? this.messageCount,
      totalInputTokens: totalInputTokens ?? this.totalInputTokens,
      totalOutputTokens: totalOutputTokens ?? this.totalOutputTokens,
      totalCostUsd: totalCostUsd ?? this.totalCostUsd,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastSequence: lastSequence ?? this.lastSequence,
      messagesJson: messagesJson ?? this.messagesJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (workingDirectory.present) {
      map['working_directory'] = Variable<String>(workingDirectory.value);
    }
    if (worktreeId.present) {
      map['worktree_id'] = Variable<String>(worktreeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (messageCount.present) {
      map['message_count'] = Variable<int>(messageCount.value);
    }
    if (totalInputTokens.present) {
      map['total_input_tokens'] = Variable<int>(totalInputTokens.value);
    }
    if (totalOutputTokens.present) {
      map['total_output_tokens'] = Variable<int>(totalOutputTokens.value);
    }
    if (totalCostUsd.present) {
      map['total_cost_usd'] = Variable<double>(totalCostUsd.value);
    }
    if (lastMessagePreview.present) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    if (messagesJson.present) {
      map['messages_json'] = Variable<String>(messagesJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSessionsCompanion(')
          ..write('id: $id, ')
          ..write('machineId: $machineId, ')
          ..write('model: $model, ')
          ..write('workingDirectory: $workingDirectory, ')
          ..write('worktreeId: $worktreeId, ')
          ..write('status: $status, ')
          ..write('messageCount: $messageCount, ')
          ..write('totalInputTokens: $totalInputTokens, ')
          ..write('totalOutputTokens: $totalOutputTokens, ')
          ..write('totalCostUsd: $totalCostUsd, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('messagesJson: $messagesJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MachinesTable extends Machines with TableInfo<$MachinesTable, Machine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MachinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relayUrlMeta = const VerificationMeta(
    'relayUrl',
  );
  @override
  late final GeneratedColumn<String> relayUrl = GeneratedColumn<String>(
    'relay_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('offline'),
  );
  static const VerificationMeta _lastConnectedMeta = const VerificationMeta(
    'lastConnected',
  );
  @override
  late final GeneratedColumn<int> lastConnected = GeneratedColumn<int>(
    'last_connected',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    relayUrl,
    hostname,
    status,
    lastConnected,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'machines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Machine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relay_url')) {
      context.handle(
        _relayUrlMeta,
        relayUrl.isAcceptableOrUnknown(data['relay_url']!, _relayUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_relayUrlMeta);
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_connected')) {
      context.handle(
        _lastConnectedMeta,
        lastConnected.isAcceptableOrUnknown(
          data['last_connected']!,
          _lastConnectedMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Machine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Machine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relayUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relay_url'],
      )!,
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_connected'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $MachinesTable createAlias(String alias) {
    return $MachinesTable(attachedDatabase, alias);
  }
}

class Machine extends DataClass implements Insertable<Machine> {
  final String id;
  final String name;
  final String relayUrl;
  final String? hostname;
  final String status;
  final int? lastConnected;
  final bool isFavorite;
  const Machine({
    required this.id,
    required this.name,
    required this.relayUrl,
    this.hostname,
    required this.status,
    this.lastConnected,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['relay_url'] = Variable<String>(relayUrl);
    if (!nullToAbsent || hostname != null) {
      map['hostname'] = Variable<String>(hostname);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastConnected != null) {
      map['last_connected'] = Variable<int>(lastConnected);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  MachinesCompanion toCompanion(bool nullToAbsent) {
    return MachinesCompanion(
      id: Value(id),
      name: Value(name),
      relayUrl: Value(relayUrl),
      hostname: hostname == null && nullToAbsent
          ? const Value.absent()
          : Value(hostname),
      status: Value(status),
      lastConnected: lastConnected == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnected),
      isFavorite: Value(isFavorite),
    );
  }

  factory Machine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Machine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      relayUrl: serializer.fromJson<String>(json['relayUrl']),
      hostname: serializer.fromJson<String?>(json['hostname']),
      status: serializer.fromJson<String>(json['status']),
      lastConnected: serializer.fromJson<int?>(json['lastConnected']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'relayUrl': serializer.toJson<String>(relayUrl),
      'hostname': serializer.toJson<String?>(hostname),
      'status': serializer.toJson<String>(status),
      'lastConnected': serializer.toJson<int?>(lastConnected),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Machine copyWith({
    String? id,
    String? name,
    String? relayUrl,
    Value<String?> hostname = const Value.absent(),
    String? status,
    Value<int?> lastConnected = const Value.absent(),
    bool? isFavorite,
  }) => Machine(
    id: id ?? this.id,
    name: name ?? this.name,
    relayUrl: relayUrl ?? this.relayUrl,
    hostname: hostname.present ? hostname.value : this.hostname,
    status: status ?? this.status,
    lastConnected: lastConnected.present
        ? lastConnected.value
        : this.lastConnected,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Machine copyWithCompanion(MachinesCompanion data) {
    return Machine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      relayUrl: data.relayUrl.present ? data.relayUrl.value : this.relayUrl,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      status: data.status.present ? data.status.value : this.status,
      lastConnected: data.lastConnected.present
          ? data.lastConnected.value
          : this.lastConnected,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Machine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relayUrl: $relayUrl, ')
          ..write('hostname: $hostname, ')
          ..write('status: $status, ')
          ..write('lastConnected: $lastConnected, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    relayUrl,
    hostname,
    status,
    lastConnected,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Machine &&
          other.id == this.id &&
          other.name == this.name &&
          other.relayUrl == this.relayUrl &&
          other.hostname == this.hostname &&
          other.status == this.status &&
          other.lastConnected == this.lastConnected &&
          other.isFavorite == this.isFavorite);
}

class MachinesCompanion extends UpdateCompanion<Machine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> relayUrl;
  final Value<String?> hostname;
  final Value<String> status;
  final Value<int?> lastConnected;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const MachinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.relayUrl = const Value.absent(),
    this.hostname = const Value.absent(),
    this.status = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MachinesCompanion.insert({
    required String id,
    required String name,
    required String relayUrl,
    this.hostname = const Value.absent(),
    this.status = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       relayUrl = Value(relayUrl);
  static Insertable<Machine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? relayUrl,
    Expression<String>? hostname,
    Expression<String>? status,
    Expression<int>? lastConnected,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (relayUrl != null) 'relay_url': relayUrl,
      if (hostname != null) 'hostname': hostname,
      if (status != null) 'status': status,
      if (lastConnected != null) 'last_connected': lastConnected,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MachinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? relayUrl,
    Value<String?>? hostname,
    Value<String>? status,
    Value<int?>? lastConnected,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return MachinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      relayUrl: relayUrl ?? this.relayUrl,
      hostname: hostname ?? this.hostname,
      status: status ?? this.status,
      lastConnected: lastConnected ?? this.lastConnected,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relayUrl.present) {
      map['relay_url'] = Variable<String>(relayUrl.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastConnected.present) {
      map['last_connected'] = Variable<int>(lastConnected.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MachinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relayUrl: $relayUrl, ')
          ..write('hostname: $hostname, ')
          ..write('status: $status, ')
          ..write('lastConnected: $lastConnected, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationCacheTable extends NotificationCache
    with TableInfo<$NotificationCacheTable, NotificationCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<int> receivedAt = GeneratedColumn<int>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [notificationId, receivedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  NotificationCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationCacheData(
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_id'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $NotificationCacheTable createAlias(String alias) {
    return $NotificationCacheTable(attachedDatabase, alias);
  }
}

class NotificationCacheData extends DataClass
    implements Insertable<NotificationCacheData> {
  final String notificationId;
  final int receivedAt;
  const NotificationCacheData({
    required this.notificationId,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<String>(notificationId);
    map['received_at'] = Variable<int>(receivedAt);
    return map;
  }

  NotificationCacheCompanion toCompanion(bool nullToAbsent) {
    return NotificationCacheCompanion(
      notificationId: Value(notificationId),
      receivedAt: Value(receivedAt),
    );
  }

  factory NotificationCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationCacheData(
      notificationId: serializer.fromJson<String>(json['notificationId']),
      receivedAt: serializer.fromJson<int>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<String>(notificationId),
      'receivedAt': serializer.toJson<int>(receivedAt),
    };
  }

  NotificationCacheData copyWith({String? notificationId, int? receivedAt}) =>
      NotificationCacheData(
        notificationId: notificationId ?? this.notificationId,
        receivedAt: receivedAt ?? this.receivedAt,
      );
  NotificationCacheData copyWithCompanion(NotificationCacheCompanion data) {
    return NotificationCacheData(
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationCacheData(')
          ..write('notificationId: $notificationId, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(notificationId, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationCacheData &&
          other.notificationId == this.notificationId &&
          other.receivedAt == this.receivedAt);
}

class NotificationCacheCompanion
    extends UpdateCompanion<NotificationCacheData> {
  final Value<String> notificationId;
  final Value<int> receivedAt;
  final Value<int> rowid;
  const NotificationCacheCompanion({
    this.notificationId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationCacheCompanion.insert({
    required String notificationId,
    required int receivedAt,
    this.rowid = const Value.absent(),
  }) : notificationId = Value(notificationId),
       receivedAt = Value(receivedAt);
  static Insertable<NotificationCacheData> custom({
    Expression<String>? notificationId,
    Expression<int>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationCacheCompanion copyWith({
    Value<String>? notificationId,
    Value<int>? receivedAt,
    Value<int>? rowid,
  }) {
    return NotificationCacheCompanion(
      notificationId: notificationId ?? this.notificationId,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<int>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationCacheCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $CachedSessionsTable cachedSessions = $CachedSessionsTable(this);
  late final $MachinesTable machines = $MachinesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $NotificationCacheTable notificationCache =
      $NotificationCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncQueue,
    cachedSessions,
    machines,
    settings,
    notificationCache,
  ];
}

typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String machineId,
      Value<String?> sessionId,
      required String requestType,
      required Uint8List payload,
      required String idempotencyKey,
      Value<int> priority,
      required int sequence,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      required int createdAt,
      required int expiresAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> machineId,
      Value<String?> sessionId,
      Value<String> requestType,
      Value<Uint8List> payload,
      Value<String> idempotencyKey,
      Value<int> priority,
      Value<int> sequence,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<int> createdAt,
      Value<int> expiresAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get machineId =>
      $composableBuilder(column: $table.machineId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> machineId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> requestType = const Value.absent(),
                Value<Uint8List> payload = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> expiresAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                machineId: machineId,
                sessionId: sessionId,
                requestType: requestType,
                payload: payload,
                idempotencyKey: idempotencyKey,
                priority: priority,
                sequence: sequence,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String machineId,
                Value<String?> sessionId = const Value.absent(),
                required String requestType,
                required Uint8List payload,
                required String idempotencyKey,
                Value<int> priority = const Value.absent(),
                required int sequence,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required int createdAt,
                required int expiresAt,
              }) => SyncQueueCompanion.insert(
                id: id,
                machineId: machineId,
                sessionId: sessionId,
                requestType: requestType,
                payload: payload,
                idempotencyKey: idempotencyKey,
                priority: priority,
                sequence: sequence,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$CachedSessionsTableCreateCompanionBuilder =
    CachedSessionsCompanion Function({
      required String id,
      required String machineId,
      Value<String?> model,
      Value<String?> workingDirectory,
      Value<String?> worktreeId,
      Value<String?> status,
      Value<int> messageCount,
      Value<int> totalInputTokens,
      Value<int> totalOutputTokens,
      Value<double> totalCostUsd,
      Value<String?> lastMessagePreview,
      Value<int> lastSequence,
      Value<String?> messagesJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CachedSessionsTableUpdateCompanionBuilder =
    CachedSessionsCompanion Function({
      Value<String> id,
      Value<String> machineId,
      Value<String?> model,
      Value<String?> workingDirectory,
      Value<String?> worktreeId,
      Value<String?> status,
      Value<int> messageCount,
      Value<int> totalInputTokens,
      Value<int> totalOutputTokens,
      Value<double> totalCostUsd,
      Value<String?> lastMessagePreview,
      Value<int> lastSequence,
      Value<String?> messagesJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$CachedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worktreeId => $composableBuilder(
    column: $table.worktreeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalInputTokens => $composableBuilder(
    column: $table.totalInputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalOutputTokens => $composableBuilder(
    column: $table.totalOutputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCostUsd => $composableBuilder(
    column: $table.totalCostUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessagePreview => $composableBuilder(
    column: $table.lastMessagePreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messagesJson => $composableBuilder(
    column: $table.messagesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worktreeId => $composableBuilder(
    column: $table.worktreeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalInputTokens => $composableBuilder(
    column: $table.totalInputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalOutputTokens => $composableBuilder(
    column: $table.totalOutputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCostUsd => $composableBuilder(
    column: $table.totalCostUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessagePreview => $composableBuilder(
    column: $table.lastMessagePreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messagesJson => $composableBuilder(
    column: $table.messagesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get machineId =>
      $composableBuilder(column: $table.machineId, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get worktreeId => $composableBuilder(
    column: $table.worktreeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalInputTokens => $composableBuilder(
    column: $table.totalInputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalOutputTokens => $composableBuilder(
    column: $table.totalOutputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCostUsd => $composableBuilder(
    column: $table.totalCostUsd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessagePreview => $composableBuilder(
    column: $table.lastMessagePreview,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messagesJson => $composableBuilder(
    column: $table.messagesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSessionsTable,
          CachedSession,
          $$CachedSessionsTableFilterComposer,
          $$CachedSessionsTableOrderingComposer,
          $$CachedSessionsTableAnnotationComposer,
          $$CachedSessionsTableCreateCompanionBuilder,
          $$CachedSessionsTableUpdateCompanionBuilder,
          (
            CachedSession,
            BaseReferences<_$AppDatabase, $CachedSessionsTable, CachedSession>,
          ),
          CachedSession,
          PrefetchHooks Function()
        > {
  $$CachedSessionsTableTableManager(
    _$AppDatabase db,
    $CachedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> machineId = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> workingDirectory = const Value.absent(),
                Value<String?> worktreeId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> messageCount = const Value.absent(),
                Value<int> totalInputTokens = const Value.absent(),
                Value<int> totalOutputTokens = const Value.absent(),
                Value<double> totalCostUsd = const Value.absent(),
                Value<String?> lastMessagePreview = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
                Value<String?> messagesJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSessionsCompanion(
                id: id,
                machineId: machineId,
                model: model,
                workingDirectory: workingDirectory,
                worktreeId: worktreeId,
                status: status,
                messageCount: messageCount,
                totalInputTokens: totalInputTokens,
                totalOutputTokens: totalOutputTokens,
                totalCostUsd: totalCostUsd,
                lastMessagePreview: lastMessagePreview,
                lastSequence: lastSequence,
                messagesJson: messagesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String machineId,
                Value<String?> model = const Value.absent(),
                Value<String?> workingDirectory = const Value.absent(),
                Value<String?> worktreeId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> messageCount = const Value.absent(),
                Value<int> totalInputTokens = const Value.absent(),
                Value<int> totalOutputTokens = const Value.absent(),
                Value<double> totalCostUsd = const Value.absent(),
                Value<String?> lastMessagePreview = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
                Value<String?> messagesJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSessionsCompanion.insert(
                id: id,
                machineId: machineId,
                model: model,
                workingDirectory: workingDirectory,
                worktreeId: worktreeId,
                status: status,
                messageCount: messageCount,
                totalInputTokens: totalInputTokens,
                totalOutputTokens: totalOutputTokens,
                totalCostUsd: totalCostUsd,
                lastMessagePreview: lastMessagePreview,
                lastSequence: lastSequence,
                messagesJson: messagesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSessionsTable,
      CachedSession,
      $$CachedSessionsTableFilterComposer,
      $$CachedSessionsTableOrderingComposer,
      $$CachedSessionsTableAnnotationComposer,
      $$CachedSessionsTableCreateCompanionBuilder,
      $$CachedSessionsTableUpdateCompanionBuilder,
      (
        CachedSession,
        BaseReferences<_$AppDatabase, $CachedSessionsTable, CachedSession>,
      ),
      CachedSession,
      PrefetchHooks Function()
    >;
typedef $$MachinesTableCreateCompanionBuilder =
    MachinesCompanion Function({
      required String id,
      required String name,
      required String relayUrl,
      Value<String?> hostname,
      Value<String> status,
      Value<int?> lastConnected,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$MachinesTableUpdateCompanionBuilder =
    MachinesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> relayUrl,
      Value<String?> hostname,
      Value<String> status,
      Value<int?> lastConnected,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

class $$MachinesTableFilterComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relayUrl => $composableBuilder(
    column: $table.relayUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastConnected => $composableBuilder(
    column: $table.lastConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MachinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relayUrl => $composableBuilder(
    column: $table.relayUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastConnected => $composableBuilder(
    column: $table.lastConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MachinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relayUrl =>
      $composableBuilder(column: $table.relayUrl, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get lastConnected => $composableBuilder(
    column: $table.lastConnected,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$MachinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MachinesTable,
          Machine,
          $$MachinesTableFilterComposer,
          $$MachinesTableOrderingComposer,
          $$MachinesTableAnnotationComposer,
          $$MachinesTableCreateCompanionBuilder,
          $$MachinesTableUpdateCompanionBuilder,
          (Machine, BaseReferences<_$AppDatabase, $MachinesTable, Machine>),
          Machine,
          PrefetchHooks Function()
        > {
  $$MachinesTableTableManager(_$AppDatabase db, $MachinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MachinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MachinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MachinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> relayUrl = const Value.absent(),
                Value<String?> hostname = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> lastConnected = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MachinesCompanion(
                id: id,
                name: name,
                relayUrl: relayUrl,
                hostname: hostname,
                status: status,
                lastConnected: lastConnected,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String relayUrl,
                Value<String?> hostname = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> lastConnected = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MachinesCompanion.insert(
                id: id,
                name: name,
                relayUrl: relayUrl,
                hostname: hostname,
                status: status,
                lastConnected: lastConnected,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MachinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MachinesTable,
      Machine,
      $$MachinesTableFilterComposer,
      $$MachinesTableOrderingComposer,
      $$MachinesTableAnnotationComposer,
      $$MachinesTableCreateCompanionBuilder,
      $$MachinesTableUpdateCompanionBuilder,
      (Machine, BaseReferences<_$AppDatabase, $MachinesTable, Machine>),
      Machine,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$NotificationCacheTableCreateCompanionBuilder =
    NotificationCacheCompanion Function({
      required String notificationId,
      required int receivedAt,
      Value<int> rowid,
    });
typedef $$NotificationCacheTableUpdateCompanionBuilder =
    NotificationCacheCompanion Function({
      Value<String> notificationId,
      Value<int> receivedAt,
      Value<int> rowid,
    });

class $$NotificationCacheTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationCacheTable> {
  $$NotificationCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationCacheTable> {
  $$NotificationCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationCacheTable> {
  $$NotificationCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$NotificationCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationCacheTable,
          NotificationCacheData,
          $$NotificationCacheTableFilterComposer,
          $$NotificationCacheTableOrderingComposer,
          $$NotificationCacheTableAnnotationComposer,
          $$NotificationCacheTableCreateCompanionBuilder,
          $$NotificationCacheTableUpdateCompanionBuilder,
          (
            NotificationCacheData,
            BaseReferences<
              _$AppDatabase,
              $NotificationCacheTable,
              NotificationCacheData
            >,
          ),
          NotificationCacheData,
          PrefetchHooks Function()
        > {
  $$NotificationCacheTableTableManager(
    _$AppDatabase db,
    $NotificationCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> notificationId = const Value.absent(),
                Value<int> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationCacheCompanion(
                notificationId: notificationId,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String notificationId,
                required int receivedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotificationCacheCompanion.insert(
                notificationId: notificationId,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationCacheTable,
      NotificationCacheData,
      $$NotificationCacheTableFilterComposer,
      $$NotificationCacheTableOrderingComposer,
      $$NotificationCacheTableAnnotationComposer,
      $$NotificationCacheTableCreateCompanionBuilder,
      $$NotificationCacheTableUpdateCompanionBuilder,
      (
        NotificationCacheData,
        BaseReferences<
          _$AppDatabase,
          $NotificationCacheTable,
          NotificationCacheData
        >,
      ),
      NotificationCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$CachedSessionsTableTableManager get cachedSessions =>
      $$CachedSessionsTableTableManager(_db, _db.cachedSessions);
  $$MachinesTableTableManager get machines =>
      $$MachinesTableTableManager(_db, _db.machines);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$NotificationCacheTableTableManager get notificationCache =>
      $$NotificationCacheTableTableManager(_db, _db.notificationCache);
}
