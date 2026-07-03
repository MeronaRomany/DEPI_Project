// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $TravelDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $TravelDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $TravelDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<TravelDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorTravelDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TravelDatabaseBuilderContract databaseBuilder(String name) =>
      _$TravelDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TravelDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$TravelDatabaseBuilder(null);
}

class _$TravelDatabaseBuilder implements $TravelDatabaseBuilderContract {
  _$TravelDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $TravelDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $TravelDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<TravelDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TravelDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TravelDatabase extends TravelDatabase {
  _$TravelDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TravelDao? _travelDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `travel_items` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `rating` TEXT NOT NULL, `numReviews` TEXT NOT NULL, `category` TEXT NOT NULL, `locationId` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TravelDao get travelDao {
    return _travelDaoInstance ??= _$TravelDao(database, changeListener);
  }
}

class _$TravelDao extends TravelDao {
  _$TravelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _travelItemEntityInsertionAdapter = InsertionAdapter(
            database,
            'travel_items',
            (TravelItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'imageUrl': item.imageUrl,
                  'rating': item.rating,
                  'numReviews': item.numReviews,
                  'category': item.category,
                  'locationId': item.locationId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TravelItemEntity> _travelItemEntityInsertionAdapter;

  @override
  Future<List<TravelItemEntity>> getByCategory(
    String category,
    String locationId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM travel_items WHERE category = ?1 AND locationId = ?2',
        mapper: (Map<String, Object?> row) => TravelItemEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            imageUrl: row['imageUrl'] as String,
            rating: row['rating'] as String,
            numReviews: row['numReviews'] as String,
            category: row['category'] as String,
            locationId: row['locationId'] as String),
        arguments: [category, locationId]);
  }

  @override
  Future<void> deleteByCategory(
    String category,
    String locationId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM travel_items WHERE category = ?1 AND locationId = ?2',
        arguments: [category, locationId]);
  }

  @override
  Future<void> clearAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM travel_items');
  }

  @override
  Future<void> insertItems(List<TravelItemEntity> items) async {
    await _travelItemEntityInsertionAdapter.insertList(
        items, OnConflictStrategy.abort);
  }
}
