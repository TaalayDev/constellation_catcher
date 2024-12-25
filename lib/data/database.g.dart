// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlayerAchievementsTable extends PlayerAchievements
    with TableInfo<$PlayerAchievementsTable, PlayerAchievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
      'total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unlockedMeta =
      const VerificationMeta('unlocked');
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
      'unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, iconName, rarity, progress, total, unlocked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_achievements';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerAchievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(_unlockedMeta,
          unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerAchievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerAchievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total'])!,
      unlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}unlocked'])!,
    );
  }

  @override
  $PlayerAchievementsTable createAlias(String alias) {
    return $PlayerAchievementsTable(attachedDatabase, alias);
  }
}

class PlayerAchievement extends DataClass
    implements Insertable<PlayerAchievement> {
  final int id;
  final String name;
  final String description;
  final String iconName;
  final String rarity;
  final int progress;
  final int total;
  final bool unlocked;
  const PlayerAchievement(
      {required this.id,
      required this.name,
      required this.description,
      required this.iconName,
      required this.rarity,
      required this.progress,
      required this.total,
      required this.unlocked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon_name'] = Variable<String>(iconName);
    map['rarity'] = Variable<String>(rarity);
    map['progress'] = Variable<int>(progress);
    map['total'] = Variable<int>(total);
    map['unlocked'] = Variable<bool>(unlocked);
    return map;
  }

  PlayerAchievementsCompanion toCompanion(bool nullToAbsent) {
    return PlayerAchievementsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      iconName: Value(iconName),
      rarity: Value(rarity),
      progress: Value(progress),
      total: Value(total),
      unlocked: Value(unlocked),
    );
  }

  factory PlayerAchievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerAchievement(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      iconName: serializer.fromJson<String>(json['iconName']),
      rarity: serializer.fromJson<String>(json['rarity']),
      progress: serializer.fromJson<int>(json['progress']),
      total: serializer.fromJson<int>(json['total']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'iconName': serializer.toJson<String>(iconName),
      'rarity': serializer.toJson<String>(rarity),
      'progress': serializer.toJson<int>(progress),
      'total': serializer.toJson<int>(total),
      'unlocked': serializer.toJson<bool>(unlocked),
    };
  }

  PlayerAchievement copyWith(
          {int? id,
          String? name,
          String? description,
          String? iconName,
          String? rarity,
          int? progress,
          int? total,
          bool? unlocked}) =>
      PlayerAchievement(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        iconName: iconName ?? this.iconName,
        rarity: rarity ?? this.rarity,
        progress: progress ?? this.progress,
        total: total ?? this.total,
        unlocked: unlocked ?? this.unlocked,
      );
  PlayerAchievement copyWithCompanion(PlayerAchievementsCompanion data) {
    return PlayerAchievement(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      progress: data.progress.present ? data.progress.value : this.progress,
      total: data.total.present ? data.total.value : this.total,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerAchievement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('rarity: $rarity, ')
          ..write('progress: $progress, ')
          ..write('total: $total, ')
          ..write('unlocked: $unlocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, iconName, rarity, progress, total, unlocked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerAchievement &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconName == this.iconName &&
          other.rarity == this.rarity &&
          other.progress == this.progress &&
          other.total == this.total &&
          other.unlocked == this.unlocked);
}

class PlayerAchievementsCompanion extends UpdateCompanion<PlayerAchievement> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> iconName;
  final Value<String> rarity;
  final Value<int> progress;
  final Value<int> total;
  final Value<bool> unlocked;
  const PlayerAchievementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconName = const Value.absent(),
    this.rarity = const Value.absent(),
    this.progress = const Value.absent(),
    this.total = const Value.absent(),
    this.unlocked = const Value.absent(),
  });
  PlayerAchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String iconName,
    required String rarity,
    this.progress = const Value.absent(),
    required int total,
    this.unlocked = const Value.absent(),
  })  : name = Value(name),
        description = Value(description),
        iconName = Value(iconName),
        rarity = Value(rarity),
        total = Value(total);
  static Insertable<PlayerAchievement> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconName,
    Expression<String>? rarity,
    Expression<int>? progress,
    Expression<int>? total,
    Expression<bool>? unlocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconName != null) 'icon_name': iconName,
      if (rarity != null) 'rarity': rarity,
      if (progress != null) 'progress': progress,
      if (total != null) 'total': total,
      if (unlocked != null) 'unlocked': unlocked,
    });
  }

  PlayerAchievementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? iconName,
      Value<String>? rarity,
      Value<int>? progress,
      Value<int>? total,
      Value<bool>? unlocked}) {
    return PlayerAchievementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      rarity: rarity ?? this.rarity,
      progress: progress ?? this.progress,
      total: total ?? this.total,
      unlocked: unlocked ?? this.unlocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('rarity: $rarity, ')
          ..write('progress: $progress, ')
          ..write('total: $total, ')
          ..write('unlocked: $unlocked')
          ..write(')'))
        .toString();
  }
}

class $PlayerStatsTable extends PlayerStats
    with TableInfo<$PlayerStatsTable, PlayerStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_stats';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $PlayerStatsTable createAlias(String alias) {
    return $PlayerStatsTable(attachedDatabase, alias);
  }
}

class PlayerStat extends DataClass implements Insertable<PlayerStat> {
  final int id;
  final String key;
  final int value;
  const PlayerStat({required this.id, required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<int>(value);
    return map;
  }

  PlayerStatsCompanion toCompanion(bool nullToAbsent) {
    return PlayerStatsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
    );
  }

  factory PlayerStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerStat(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<int>(value),
    };
  }

  PlayerStat copyWith({int? id, String? key, int? value}) => PlayerStat(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
      );
  PlayerStat copyWithCompanion(PlayerStatsCompanion data) {
    return PlayerStat(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStat(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerStat &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class PlayerStatsCompanion extends UpdateCompanion<PlayerStat> {
  final Value<int> id;
  final Value<String> key;
  final Value<int> value;
  const PlayerStatsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  PlayerStatsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required int value,
  })  : key = Value(key),
        value = Value(value);
  static Insertable<PlayerStat> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  PlayerStatsCompanion copyWith(
      {Value<int>? id, Value<String>? key, Value<int>? value}) {
    return PlayerStatsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStatsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayerAchievementsTable playerAchievements =
      $PlayerAchievementsTable(this);
  late final $PlayerStatsTable playerStats = $PlayerStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [playerAchievements, playerStats];
}

typedef $$PlayerAchievementsTableCreateCompanionBuilder
    = PlayerAchievementsCompanion Function({
  Value<int> id,
  required String name,
  required String description,
  required String iconName,
  required String rarity,
  Value<int> progress,
  required int total,
  Value<bool> unlocked,
});
typedef $$PlayerAchievementsTableUpdateCompanionBuilder
    = PlayerAchievementsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> iconName,
  Value<String> rarity,
  Value<int> progress,
  Value<int> total,
  Value<bool> unlocked,
});

class $$PlayerAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerAchievementsTable> {
  $$PlayerAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnFilters(column));
}

class $$PlayerAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerAchievementsTable> {
  $$PlayerAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnOrderings(column));
}

class $$PlayerAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerAchievementsTable> {
  $$PlayerAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);
}

class $$PlayerAchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerAchievementsTable,
    PlayerAchievement,
    $$PlayerAchievementsTableFilterComposer,
    $$PlayerAchievementsTableOrderingComposer,
    $$PlayerAchievementsTableAnnotationComposer,
    $$PlayerAchievementsTableCreateCompanionBuilder,
    $$PlayerAchievementsTableUpdateCompanionBuilder,
    (
      PlayerAchievement,
      BaseReferences<_$AppDatabase, $PlayerAchievementsTable, PlayerAchievement>
    ),
    PlayerAchievement,
    PrefetchHooks Function()> {
  $$PlayerAchievementsTableTableManager(
      _$AppDatabase db, $PlayerAchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerAchievementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> rarity = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<bool> unlocked = const Value.absent(),
          }) =>
              PlayerAchievementsCompanion(
            id: id,
            name: name,
            description: description,
            iconName: iconName,
            rarity: rarity,
            progress: progress,
            total: total,
            unlocked: unlocked,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String description,
            required String iconName,
            required String rarity,
            Value<int> progress = const Value.absent(),
            required int total,
            Value<bool> unlocked = const Value.absent(),
          }) =>
              PlayerAchievementsCompanion.insert(
            id: id,
            name: name,
            description: description,
            iconName: iconName,
            rarity: rarity,
            progress: progress,
            total: total,
            unlocked: unlocked,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlayerAchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerAchievementsTable,
    PlayerAchievement,
    $$PlayerAchievementsTableFilterComposer,
    $$PlayerAchievementsTableOrderingComposer,
    $$PlayerAchievementsTableAnnotationComposer,
    $$PlayerAchievementsTableCreateCompanionBuilder,
    $$PlayerAchievementsTableUpdateCompanionBuilder,
    (
      PlayerAchievement,
      BaseReferences<_$AppDatabase, $PlayerAchievementsTable, PlayerAchievement>
    ),
    PlayerAchievement,
    PrefetchHooks Function()>;
typedef $$PlayerStatsTableCreateCompanionBuilder = PlayerStatsCompanion
    Function({
  Value<int> id,
  required String key,
  required int value,
});
typedef $$PlayerStatsTableUpdateCompanionBuilder = PlayerStatsCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<int> value,
});

class $$PlayerStatsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$PlayerStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$PlayerStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PlayerStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerStatsTable,
    PlayerStat,
    $$PlayerStatsTableFilterComposer,
    $$PlayerStatsTableOrderingComposer,
    $$PlayerStatsTableAnnotationComposer,
    $$PlayerStatsTableCreateCompanionBuilder,
    $$PlayerStatsTableUpdateCompanionBuilder,
    (PlayerStat, BaseReferences<_$AppDatabase, $PlayerStatsTable, PlayerStat>),
    PlayerStat,
    PrefetchHooks Function()> {
  $$PlayerStatsTableTableManager(_$AppDatabase db, $PlayerStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<int> value = const Value.absent(),
          }) =>
              PlayerStatsCompanion(
            id: id,
            key: key,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required int value,
          }) =>
              PlayerStatsCompanion.insert(
            id: id,
            key: key,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlayerStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerStatsTable,
    PlayerStat,
    $$PlayerStatsTableFilterComposer,
    $$PlayerStatsTableOrderingComposer,
    $$PlayerStatsTableAnnotationComposer,
    $$PlayerStatsTableCreateCompanionBuilder,
    $$PlayerStatsTableUpdateCompanionBuilder,
    (PlayerStat, BaseReferences<_$AppDatabase, $PlayerStatsTable, PlayerStat>),
    PlayerStat,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayerAchievementsTableTableManager get playerAchievements =>
      $$PlayerAchievementsTableTableManager(_db, _db.playerAchievements);
  $$PlayerStatsTableTableManager get playerStats =>
      $$PlayerStatsTableTableManager(_db, _db.playerStats);
}
