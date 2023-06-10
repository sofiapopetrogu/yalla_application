// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorStepDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StepDatabaseBuilder databaseBuilder(String name) =>
      _$StepDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StepDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$StepDatabaseBuilder(null);
}

class _$StepDatabaseBuilder {
  _$StepDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$StepDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$StepDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<StepDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$StepDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$StepDatabase extends StepDatabase {
  _$StepDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StepDao? _stepDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Steps_Daily` (`row_id` TEXT PRIMARY KEY AUTOINCREMENT NOT NULL, `patient_id` TEXT NOT NULL, `day` TEXT NOT NULL, `time` TEXT NOT NULL, `value` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StepDao get stepDao {
    return _stepDaoInstance ??= _$StepDao(database, changeListener);
  }
}

class _$StepDao extends StepDao {
  _$StepDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _steps_DailyInsertionAdapter = InsertionAdapter(
            database,
            'Steps_Daily',
            (Steps_Daily item) => <String, Object?>{
                  'row_id': item.row_id,
                  'patient_id': item.patient_id,
                  'day': item.day,
                  'time': item.time,
                  'value': item.value
                }),
        _steps_DailyDeletionAdapter = DeletionAdapter(
            database,
            'Steps_Daily',
            ['row_id'],
            (Steps_Daily item) => <String, Object?>{
                  'row_id': item.row_id,
                  'patient_id': item.patient_id,
                  'day': item.day,
                  'time': item.time,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Steps_Daily> _steps_DailyInsertionAdapter;

  final DeletionAdapter<Steps_Daily> _steps_DailyDeletionAdapter;

  @override
  Future<List<Steps_Daily>> findAllSteps() async {
    return _queryAdapter.queryList('SELECT * FROM Steps_Daily',
        mapper: (Map<String, Object?> row) => Steps_Daily(
            row['row_id'] as String,
            row['patient_id'] as String,
            row['day'] as String,
            row['time'] as String,
            row['value'] as int));
  }

  @override
  Future<void> insertSteps(Steps_Daily steps_daily) async {
    await _steps_DailyInsertionAdapter.insert(
        steps_daily, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSteps(Steps_Daily steps_daily) async {
    await _steps_DailyDeletionAdapter.delete(steps_daily);
  }
}
