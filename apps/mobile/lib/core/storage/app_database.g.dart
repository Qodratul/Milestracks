// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PendingRunPointsTable extends PendingRunPoints
    with TableInfo<$PendingRunPointsTable, PendingRunPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingRunPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMetersPerSecondMeta =
      const VerificationMeta('speedMetersPerSecond');
  @override
  late final GeneratedColumn<double> speedMetersPerSecond =
      GeneratedColumn<double>(
        'speed_meters_per_second',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _mockedMeta = const VerificationMeta('mocked');
  @override
  late final GeneratedColumn<bool> mocked = GeneratedColumn<bool>(
    'mocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadBatchKeyMeta = const VerificationMeta(
    'uploadBatchKey',
  );
  @override
  late final GeneratedColumn<String> uploadBatchKey = GeneratedColumn<String>(
    'upload_batch_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    runId,
    sequence,
    latitude,
    longitude,
    accuracyMeters,
    speedMetersPerSecond,
    mocked,
    recordedAt,
    uploadBatchKey,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_run_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingRunPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('speed_meters_per_second')) {
      context.handle(
        _speedMetersPerSecondMeta,
        speedMetersPerSecond.isAcceptableOrUnknown(
          data['speed_meters_per_second']!,
          _speedMetersPerSecondMeta,
        ),
      );
    }
    if (data.containsKey('mocked')) {
      context.handle(
        _mockedMeta,
        mocked.isAcceptableOrUnknown(data['mocked']!, _mockedMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('upload_batch_key')) {
      context.handle(
        _uploadBatchKeyMeta,
        uploadBatchKey.isAcceptableOrUnknown(
          data['upload_batch_key']!,
          _uploadBatchKeyMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {runId, sequence},
  ];
  @override
  PendingRunPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingRunPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      ),
      speedMetersPerSecond: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_meters_per_second'],
      ),
      mocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mocked'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      uploadBatchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_batch_key'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $PendingRunPointsTable createAlias(String alias) {
    return $PendingRunPointsTable(attachedDatabase, alias);
  }
}

class PendingRunPoint extends DataClass implements Insertable<PendingRunPoint> {
  final int id;
  final String runId;
  final int sequence;
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final double? speedMetersPerSecond;
  final bool mocked;
  final DateTime recordedAt;
  final String? uploadBatchKey;
  final bool synced;
  const PendingRunPoint({
    required this.id,
    required this.runId,
    required this.sequence,
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    this.speedMetersPerSecond,
    required this.mocked,
    required this.recordedAt,
    this.uploadBatchKey,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['run_id'] = Variable<String>(runId);
    map['sequence'] = Variable<int>(sequence);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    if (!nullToAbsent || speedMetersPerSecond != null) {
      map['speed_meters_per_second'] = Variable<double>(speedMetersPerSecond);
    }
    map['mocked'] = Variable<bool>(mocked);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || uploadBatchKey != null) {
      map['upload_batch_key'] = Variable<String>(uploadBatchKey);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PendingRunPointsCompanion toCompanion(bool nullToAbsent) {
    return PendingRunPointsCompanion(
      id: Value(id),
      runId: Value(runId),
      sequence: Value(sequence),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracyMeters: accuracyMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMeters),
      speedMetersPerSecond: speedMetersPerSecond == null && nullToAbsent
          ? const Value.absent()
          : Value(speedMetersPerSecond),
      mocked: Value(mocked),
      recordedAt: Value(recordedAt),
      uploadBatchKey: uploadBatchKey == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadBatchKey),
      synced: Value(synced),
    );
  }

  factory PendingRunPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingRunPoint(
      id: serializer.fromJson<int>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracyMeters: serializer.fromJson<double?>(json['accuracyMeters']),
      speedMetersPerSecond: serializer.fromJson<double?>(
        json['speedMetersPerSecond'],
      ),
      mocked: serializer.fromJson<bool>(json['mocked']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      uploadBatchKey: serializer.fromJson<String?>(json['uploadBatchKey']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'runId': serializer.toJson<String>(runId),
      'sequence': serializer.toJson<int>(sequence),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracyMeters': serializer.toJson<double?>(accuracyMeters),
      'speedMetersPerSecond': serializer.toJson<double?>(speedMetersPerSecond),
      'mocked': serializer.toJson<bool>(mocked),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'uploadBatchKey': serializer.toJson<String?>(uploadBatchKey),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  PendingRunPoint copyWith({
    int? id,
    String? runId,
    int? sequence,
    double? latitude,
    double? longitude,
    Value<double?> accuracyMeters = const Value.absent(),
    Value<double?> speedMetersPerSecond = const Value.absent(),
    bool? mocked,
    DateTime? recordedAt,
    Value<String?> uploadBatchKey = const Value.absent(),
    bool? synced,
  }) => PendingRunPoint(
    id: id ?? this.id,
    runId: runId ?? this.runId,
    sequence: sequence ?? this.sequence,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracyMeters: accuracyMeters.present
        ? accuracyMeters.value
        : this.accuracyMeters,
    speedMetersPerSecond: speedMetersPerSecond.present
        ? speedMetersPerSecond.value
        : this.speedMetersPerSecond,
    mocked: mocked ?? this.mocked,
    recordedAt: recordedAt ?? this.recordedAt,
    uploadBatchKey: uploadBatchKey.present
        ? uploadBatchKey.value
        : this.uploadBatchKey,
    synced: synced ?? this.synced,
  );
  PendingRunPoint copyWithCompanion(PendingRunPointsCompanion data) {
    return PendingRunPoint(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      speedMetersPerSecond: data.speedMetersPerSecond.present
          ? data.speedMetersPerSecond.value
          : this.speedMetersPerSecond,
      mocked: data.mocked.present ? data.mocked.value : this.mocked,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      uploadBatchKey: data.uploadBatchKey.present
          ? data.uploadBatchKey.value
          : this.uploadBatchKey,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingRunPoint(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('sequence: $sequence, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMetersPerSecond: $speedMetersPerSecond, ')
          ..write('mocked: $mocked, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('uploadBatchKey: $uploadBatchKey, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    runId,
    sequence,
    latitude,
    longitude,
    accuracyMeters,
    speedMetersPerSecond,
    mocked,
    recordedAt,
    uploadBatchKey,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingRunPoint &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.sequence == this.sequence &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.speedMetersPerSecond == this.speedMetersPerSecond &&
          other.mocked == this.mocked &&
          other.recordedAt == this.recordedAt &&
          other.uploadBatchKey == this.uploadBatchKey &&
          other.synced == this.synced);
}

class PendingRunPointsCompanion extends UpdateCompanion<PendingRunPoint> {
  final Value<int> id;
  final Value<String> runId;
  final Value<int> sequence;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> accuracyMeters;
  final Value<double?> speedMetersPerSecond;
  final Value<bool> mocked;
  final Value<DateTime> recordedAt;
  final Value<String?> uploadBatchKey;
  final Value<bool> synced;
  const PendingRunPointsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.speedMetersPerSecond = const Value.absent(),
    this.mocked = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.uploadBatchKey = const Value.absent(),
    this.synced = const Value.absent(),
  });
  PendingRunPointsCompanion.insert({
    this.id = const Value.absent(),
    required String runId,
    required int sequence,
    required double latitude,
    required double longitude,
    this.accuracyMeters = const Value.absent(),
    this.speedMetersPerSecond = const Value.absent(),
    this.mocked = const Value.absent(),
    required DateTime recordedAt,
    this.uploadBatchKey = const Value.absent(),
    this.synced = const Value.absent(),
  }) : runId = Value(runId),
       sequence = Value(sequence),
       latitude = Value(latitude),
       longitude = Value(longitude),
       recordedAt = Value(recordedAt);
  static Insertable<PendingRunPoint> custom({
    Expression<int>? id,
    Expression<String>? runId,
    Expression<int>? sequence,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<double>? speedMetersPerSecond,
    Expression<bool>? mocked,
    Expression<DateTime>? recordedAt,
    Expression<String>? uploadBatchKey,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (sequence != null) 'sequence': sequence,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (speedMetersPerSecond != null)
        'speed_meters_per_second': speedMetersPerSecond,
      if (mocked != null) 'mocked': mocked,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (uploadBatchKey != null) 'upload_batch_key': uploadBatchKey,
      if (synced != null) 'synced': synced,
    });
  }

  PendingRunPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? runId,
    Value<int>? sequence,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? accuracyMeters,
    Value<double?>? speedMetersPerSecond,
    Value<bool>? mocked,
    Value<DateTime>? recordedAt,
    Value<String?>? uploadBatchKey,
    Value<bool>? synced,
  }) {
    return PendingRunPointsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      sequence: sequence ?? this.sequence,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      speedMetersPerSecond: speedMetersPerSecond ?? this.speedMetersPerSecond,
      mocked: mocked ?? this.mocked,
      recordedAt: recordedAt ?? this.recordedAt,
      uploadBatchKey: uploadBatchKey ?? this.uploadBatchKey,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (speedMetersPerSecond.present) {
      map['speed_meters_per_second'] = Variable<double>(
        speedMetersPerSecond.value,
      );
    }
    if (mocked.present) {
      map['mocked'] = Variable<bool>(mocked.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (uploadBatchKey.present) {
      map['upload_batch_key'] = Variable<String>(uploadBatchKey.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingRunPointsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('sequence: $sequence, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMetersPerSecond: $speedMetersPerSecond, ')
          ..write('mocked: $mocked, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('uploadBatchKey: $uploadBatchKey, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
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
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
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
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final String key;
  final String value;
  const LocalSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
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

  LocalSetting copyWith({String? key, String? value}) =>
      LocalSetting(key: key ?? this.key, value: value ?? this.value);
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
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
      (other is LocalSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const LocalSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<LocalSetting> custom({
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

  LocalSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return LocalSettingsCompanion(
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
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingRunActionsTable extends PendingRunActions
    with TableInfo<$PendingRunActionsTable, PendingRunAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingRunActionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    runId,
    action,
    payloadJson,
    idempotencyKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_run_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingRunAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingRunAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingRunAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingRunActionsTable createAlias(String alias) {
    return $PendingRunActionsTable(attachedDatabase, alias);
  }
}

class PendingRunAction extends DataClass
    implements Insertable<PendingRunAction> {
  final int id;
  final String runId;
  final String action;
  final String payloadJson;
  final String idempotencyKey;
  final DateTime createdAt;
  const PendingRunAction({
    required this.id,
    required this.runId,
    required this.action,
    required this.payloadJson,
    required this.idempotencyKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['run_id'] = Variable<String>(runId);
    map['action'] = Variable<String>(action);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingRunActionsCompanion toCompanion(bool nullToAbsent) {
    return PendingRunActionsCompanion(
      id: Value(id),
      runId: Value(runId),
      action: Value(action),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
    );
  }

  factory PendingRunAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingRunAction(
      id: serializer.fromJson<int>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      action: serializer.fromJson<String>(json['action']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'runId': serializer.toJson<String>(runId),
      'action': serializer.toJson<String>(action),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingRunAction copyWith({
    int? id,
    String? runId,
    String? action,
    String? payloadJson,
    String? idempotencyKey,
    DateTime? createdAt,
  }) => PendingRunAction(
    id: id ?? this.id,
    runId: runId ?? this.runId,
    action: action ?? this.action,
    payloadJson: payloadJson ?? this.payloadJson,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingRunAction copyWithCompanion(PendingRunActionsCompanion data) {
    return PendingRunAction(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      action: data.action.present ? data.action.value : this.action,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingRunAction(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, runId, action, payloadJson, idempotencyKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingRunAction &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.action == this.action &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt);
}

class PendingRunActionsCompanion extends UpdateCompanion<PendingRunAction> {
  final Value<int> id;
  final Value<String> runId;
  final Value<String> action;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  const PendingRunActionsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.action = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingRunActionsCompanion.insert({
    this.id = const Value.absent(),
    required String runId,
    required String action,
    required String payloadJson,
    required String idempotencyKey,
    required DateTime createdAt,
  }) : runId = Value(runId),
       action = Value(action),
       payloadJson = Value(payloadJson),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<PendingRunAction> custom({
    Expression<int>? id,
    Expression<String>? runId,
    Expression<String>? action,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (action != null) 'action': action,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingRunActionsCompanion copyWith({
    Value<int>? id,
    Value<String>? runId,
    Value<String>? action,
    Value<String>? payloadJson,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
  }) {
    return PendingRunActionsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingRunActionsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PendingRunPointsTable pendingRunPoints = $PendingRunPointsTable(
    this,
  );
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $PendingRunActionsTable pendingRunActions =
      $PendingRunActionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pendingRunPoints,
    localSettings,
    pendingRunActions,
  ];
}

typedef $$PendingRunPointsTableCreateCompanionBuilder =
    PendingRunPointsCompanion Function({
      Value<int> id,
      required String runId,
      required int sequence,
      required double latitude,
      required double longitude,
      Value<double?> accuracyMeters,
      Value<double?> speedMetersPerSecond,
      Value<bool> mocked,
      required DateTime recordedAt,
      Value<String?> uploadBatchKey,
      Value<bool> synced,
    });
typedef $$PendingRunPointsTableUpdateCompanionBuilder =
    PendingRunPointsCompanion Function({
      Value<int> id,
      Value<String> runId,
      Value<int> sequence,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> accuracyMeters,
      Value<double?> speedMetersPerSecond,
      Value<bool> mocked,
      Value<DateTime> recordedAt,
      Value<String?> uploadBatchKey,
      Value<bool> synced,
    });

class $$PendingRunPointsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingRunPointsTable> {
  $$PendingRunPointsTableFilterComposer({
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

  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mocked => $composableBuilder(
    column: $table.mocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadBatchKey => $composableBuilder(
    column: $table.uploadBatchKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingRunPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingRunPointsTable> {
  $$PendingRunPointsTableOrderingComposer({
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

  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mocked => $composableBuilder(
    column: $table.mocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadBatchKey => $composableBuilder(
    column: $table.uploadBatchKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingRunPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingRunPointsTable> {
  $$PendingRunPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mocked =>
      $composableBuilder(column: $table.mocked, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadBatchKey => $composableBuilder(
    column: $table.uploadBatchKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$PendingRunPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingRunPointsTable,
          PendingRunPoint,
          $$PendingRunPointsTableFilterComposer,
          $$PendingRunPointsTableOrderingComposer,
          $$PendingRunPointsTableAnnotationComposer,
          $$PendingRunPointsTableCreateCompanionBuilder,
          $$PendingRunPointsTableUpdateCompanionBuilder,
          (
            PendingRunPoint,
            BaseReferences<
              _$AppDatabase,
              $PendingRunPointsTable,
              PendingRunPoint
            >,
          ),
          PendingRunPoint,
          PrefetchHooks Function()
        > {
  $$PendingRunPointsTableTableManager(
    _$AppDatabase db,
    $PendingRunPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingRunPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingRunPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingRunPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> runId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<double?> speedMetersPerSecond = const Value.absent(),
                Value<bool> mocked = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String?> uploadBatchKey = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => PendingRunPointsCompanion(
                id: id,
                runId: runId,
                sequence: sequence,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                speedMetersPerSecond: speedMetersPerSecond,
                mocked: mocked,
                recordedAt: recordedAt,
                uploadBatchKey: uploadBatchKey,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String runId,
                required int sequence,
                required double latitude,
                required double longitude,
                Value<double?> accuracyMeters = const Value.absent(),
                Value<double?> speedMetersPerSecond = const Value.absent(),
                Value<bool> mocked = const Value.absent(),
                required DateTime recordedAt,
                Value<String?> uploadBatchKey = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => PendingRunPointsCompanion.insert(
                id: id,
                runId: runId,
                sequence: sequence,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                speedMetersPerSecond: speedMetersPerSecond,
                mocked: mocked,
                recordedAt: recordedAt,
                uploadBatchKey: uploadBatchKey,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingRunPointsTable, PendingRunPoint>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingRunPointsTable,
                    PendingRunPoint
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingRunPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingRunPointsTable,
      PendingRunPoint,
      $$PendingRunPointsTableFilterComposer,
      $$PendingRunPointsTableOrderingComposer,
      $$PendingRunPointsTableAnnotationComposer,
      $$PendingRunPointsTableCreateCompanionBuilder,
      $$PendingRunPointsTableUpdateCompanionBuilder,
      (
        PendingRunPoint,
        BaseReferences<_$AppDatabase, $PendingRunPointsTable, PendingRunPoint>,
      ),
      PendingRunPoint,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
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

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
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

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
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

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LocalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettingsTable,
                    LocalSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;
typedef $$PendingRunActionsTableCreateCompanionBuilder =
    PendingRunActionsCompanion Function({
      Value<int> id,
      required String runId,
      required String action,
      required String payloadJson,
      required String idempotencyKey,
      required DateTime createdAt,
    });
typedef $$PendingRunActionsTableUpdateCompanionBuilder =
    PendingRunActionsCompanion Function({
      Value<int> id,
      Value<String> runId,
      Value<String> action,
      Value<String> payloadJson,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
    });

class $$PendingRunActionsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingRunActionsTable> {
  $$PendingRunActionsTableFilterComposer({
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

  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingRunActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingRunActionsTable> {
  $$PendingRunActionsTableOrderingComposer({
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

  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingRunActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingRunActionsTable> {
  $$PendingRunActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingRunActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingRunActionsTable,
          PendingRunAction,
          $$PendingRunActionsTableFilterComposer,
          $$PendingRunActionsTableOrderingComposer,
          $$PendingRunActionsTableAnnotationComposer,
          $$PendingRunActionsTableCreateCompanionBuilder,
          $$PendingRunActionsTableUpdateCompanionBuilder,
          (
            PendingRunAction,
            BaseReferences<
              _$AppDatabase,
              $PendingRunActionsTable,
              PendingRunAction
            >,
          ),
          PendingRunAction,
          PrefetchHooks Function()
        > {
  $$PendingRunActionsTableTableManager(
    _$AppDatabase db,
    $PendingRunActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingRunActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingRunActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingRunActionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> runId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingRunActionsCompanion(
                id: id,
                runId: runId,
                action: action,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String runId,
                required String action,
                required String payloadJson,
                required String idempotencyKey,
                required DateTime createdAt,
              }) => PendingRunActionsCompanion.insert(
                id: id,
                runId: runId,
                action: action,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingRunActionsTable, PendingRunAction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingRunActionsTable,
                    PendingRunAction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingRunActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingRunActionsTable,
      PendingRunAction,
      $$PendingRunActionsTableFilterComposer,
      $$PendingRunActionsTableOrderingComposer,
      $$PendingRunActionsTableAnnotationComposer,
      $$PendingRunActionsTableCreateCompanionBuilder,
      $$PendingRunActionsTableUpdateCompanionBuilder,
      (
        PendingRunAction,
        BaseReferences<
          _$AppDatabase,
          $PendingRunActionsTable,
          PendingRunAction
        >,
      ),
      PendingRunAction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PendingRunPointsTableTableManager get pendingRunPoints =>
      $$PendingRunPointsTableTableManager(_db, _db.pendingRunPoints);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$PendingRunActionsTableTableManager get pendingRunActions =>
      $$PendingRunActionsTableTableManager(_db, _db.pendingRunActions);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppDatabase>,
          AppDatabase,
          FutureOr<AppDatabase>
        >
    with $FutureModifier<AppDatabase>, $FutureProvider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $FutureProviderElement<AppDatabase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppDatabase> create(Ref ref) {
    return appDatabase(ref);
  }
}

String _$appDatabaseHash() => r'514d7eeb2fc624db78157563d34d4c846198535f';
