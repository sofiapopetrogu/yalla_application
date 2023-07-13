// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PatientDao? _patientDaoInstance;

  StepDao? _stepDaoInstance;

  HeartDao? _heartDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Patient` (`id` TEXT, `birthday` INTEGER NOT NULL, `sex` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `StepsDaily` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `steps` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, `patient` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HeartDaily` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `heart` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, `patient` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PatientDao get patientDao {
    return _patientDaoInstance ??= _$PatientDao(database, changeListener);
  }

  @override
  StepDao get stepDao {
    return _stepDaoInstance ??= _$StepDao(database, changeListener);
  }

  @override
  HeartDao get heartDao {
    return _heartDaoInstance ??= _$HeartDao(database, changeListener);
  }
}

class _$PatientDao extends PatientDao {
  _$PatientDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _patientInsertionAdapter = InsertionAdapter(
            database,
            'Patient',
            (Patient item) => <String, Object?>{
                  'id': item.id,
                  'birthday': _dateTimeConverter.encode(item.birthday),
                  'sex': item.sex
                }),
        _patientDeletionAdapter = DeletionAdapter(
            database,
            'Patient',
            ['id'],
            (Patient item) => <String, Object?>{
                  'id': item.id,
                  'birthday': _dateTimeConverter.encode(item.birthday),
                  'sex': item.sex
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Patient> _patientInsertionAdapter;

  final DeletionAdapter<Patient> _patientDeletionAdapter;

  @override
  Future<Patient?> findPatient(int patient) async {
    return _queryAdapter.query('SELECT * FROM Patient WHERE patient == ?1',
        mapper: (Map<String, Object?> row) => Patient(
            id: row['id'] as String?,
            birthday: _dateTimeConverter.decode(row['birthday'] as int),
            sex: row['sex'] as String),
        arguments: [patient]);
  }

  @override
  Future<void> insertPatient(Patient patients) async {
    await _patientInsertionAdapter.insert(patients, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePatient(Patient patients) async {
    await _patientDeletionAdapter.delete(patients);
  }
}

class _$StepDao extends StepDao {
  _$StepDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _steps_DailyInsertionAdapter = InsertionAdapter(
            database,
            'StepsDaily',
            (StepsDaily item) => <String, Object?>{
                  'id': item.id,
                  'steps': item.steps,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'patient': item.patient
                }),
        _steps_DailyDeletionAdapter = DeletionAdapter(
            database,
            'StepsDaily',
            ['id'],
            (StepsDaily item) => <String, Object?>{
                  'id': item.id,
                  'steps': item.steps,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'patient': item.patient
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StepsDaily> _steps_DailyInsertionAdapter;

  final DeletionAdapter<StepsDaily> _steps_DailyDeletionAdapter;

  @override
  Future<List<StepsDaily>> findAllSteps() async {
    return _queryAdapter.queryList('SELECT * FROM StepsDaily',
        mapper: (Map<String, Object?> row) => StepsDaily(
            id: row['id'] as int?,
            steps: row['steps'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            patient: row['patient'] as String));
  }

  @override
  Future<void> deleteAllSteps() async {
    await _queryAdapter.queryNoReturn('DELETE FROM StepsDaily WHERE 1');
  }

  @override
  Future<void> insertSteps(StepsDaily stepsdaily) async {
    await _steps_DailyInsertionAdapter.insert(
        stepsdaily, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMultSteps(List<StepsDaily> stepsdaily) async {
    await _steps_DailyInsertionAdapter.insertList(
        stepsdaily, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSteps(StepsDaily stepsdaily) async {
    await _steps_DailyDeletionAdapter.delete(stepsdaily);
  }
}

class _$HeartDao extends HeartDao {
  _$HeartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _heart_DailyInsertionAdapter = InsertionAdapter(
            database,
            'HeartDaily',
            (HeartDaily item) => <String, Object?>{
                  'id': item.id,
                  'heart': item.heart,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'patient': item.patient
                }),
        _heart_DailyDeletionAdapter = DeletionAdapter(
            database,
            'HeartDaily',
            ['id'],
            (HeartDaily item) => <String, Object?>{
                  'id': item.id,
                  'heart': item.heart,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'patient': item.patient
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HeartDaily> _heart_DailyInsertionAdapter;

  final DeletionAdapter<HeartDaily> _heart_DailyDeletionAdapter;

  @override
  Future<List<HeartDaily>> findHeartbyDate(
    DateTime startTime,
    DateTime endTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM HeartDaily WHERE dateTime between ?1 and ?2 ORDER BY dateTime ASC',
        mapper: (Map<String, Object?> row) => HeartDaily(id: row['id'] as int?, heart: row['heart'] as int, dateTime: _dateTimeConverter.decode(row['dateTime'] as int), patient: row['patient'] as String),
        arguments: [
          _dateTimeConverter.encode(startTime),
          _dateTimeConverter.encode(endTime)
        ]);
  }

  @override
  Future<List<HeartDaily>> findAllHeart() async {
    return _queryAdapter.queryList('SELECT * FROM HeartDaily',
        mapper: (Map<String, Object?> row) => HeartDaily(
            id: row['id'] as int?,
            heart: row['heart'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            patient: row['patient'] as String));
  }

  @override
  Future<void> deleteAllHeart() async {
    await _queryAdapter.queryNoReturn('DELETE FROM HeartDaily WHERE 1');
  }

  @override
  Future<void> insertHeart(HeartDaily heartdaily) async {
    await _heart_DailyInsertionAdapter.insert(
        heartdaily, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMultHeart(List<HeartDaily> heartdaily) async {
    await _heart_DailyInsertionAdapter.insertList(
        heartdaily, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHeart(HeartDaily heartdaily) async {
    await _heart_DailyDeletionAdapter.delete(heartdaily);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
