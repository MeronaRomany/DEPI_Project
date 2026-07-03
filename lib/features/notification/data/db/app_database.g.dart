// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  PlaceDao? _placeDaoInstance;

  TripDao? _tripDaoInstance;

  SavedPlaceDao? _savedPlaceDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `places` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `lat` REAL NOT NULL, `lon` REAL NOT NULL, `type` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `trips` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `destination` TEXT NOT NULL, `destinationImage` TEXT NOT NULL, `startDate` TEXT NOT NULL, `endDate` TEXT NOT NULL, `places` TEXT NOT NULL, `placesCount` INTEGER NOT NULL, `schedule` TEXT NOT NULL, `image` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `saved_places` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `image` TEXT NOT NULL, `location` TEXT NOT NULL, `rating` REAL NOT NULL, `description` TEXT NOT NULL, `category` TEXT NOT NULL, `latitude` REAL, `longitude` REAL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PlaceDao get placeDao {
    return _placeDaoInstance ??= _$PlaceDao(database, changeListener);
  }

  @override
  TripDao get tripDao {
    return _tripDaoInstance ??= _$TripDao(database, changeListener);
  }

  @override
  SavedPlaceDao get savedPlaceDao {
    return _savedPlaceDaoInstance ??= _$SavedPlaceDao(database, changeListener);
  }
}

class _$PlaceDao extends PlaceDao {
  _$PlaceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _placeEntityInsertionAdapter = InsertionAdapter(
            database,
            'places',
            (PlaceEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lat': item.lat,
                  'lon': item.lon,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlaceEntity> _placeEntityInsertionAdapter;

  @override
  Future<List<PlaceEntity>> getAllPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM places',
        mapper: (Map<String, Object?> row) => PlaceEntity(
            id: row['id'] as int,
            name: row['name'] as String,
            lat: row['lat'] as double,
            lon: row['lon'] as double,
            type: row['type'] as String));
  }

  @override
  Future<void> clearAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM places');
  }

  @override
  Future<void> insertPlaces(List<PlaceEntity> places) async {
    await _placeEntityInsertionAdapter.insertList(
        places, OnConflictStrategy.abort);
  }
}

class _$TripDao extends TripDao {
  _$TripDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tripEntityInsertionAdapter = InsertionAdapter(
            database,
            'trips',
            (TripEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'destination': item.destination,
                  'destinationImage': item.destinationImage,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'places': item.places,
                  'placesCount': item.placesCount,
                  'schedule': item.schedule,
                  'image': item.image
                }),
        _tripEntityUpdateAdapter = UpdateAdapter(
            database,
            'trips',
            ['id'],
            (TripEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'destination': item.destination,
                  'destinationImage': item.destinationImage,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'places': item.places,
                  'placesCount': item.placesCount,
                  'schedule': item.schedule,
                  'image': item.image
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TripEntity> _tripEntityInsertionAdapter;

  final UpdateAdapter<TripEntity> _tripEntityUpdateAdapter;

  @override
  Future<List<TripEntity>> getAllTrips() async {
    return _queryAdapter.queryList('SELECT * FROM trips',
        mapper: (Map<String, Object?> row) => TripEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            destination: row['destination'] as String,
            destinationImage: row['destinationImage'] as String,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            places: row['places'] as String,
            placesCount: row['placesCount'] as int,
            schedule: row['schedule'] as String,
            image: row['image'] as String));
  }

  @override
  Future<TripEntity?> getTripById(int id) async {
    return _queryAdapter.query('SELECT * FROM trips WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TripEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            destination: row['destination'] as String,
            destinationImage: row['destinationImage'] as String,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            places: row['places'] as String,
            placesCount: row['placesCount'] as int,
            schedule: row['schedule'] as String,
            image: row['image'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteTripById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM trips WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllTrips() async {
    await _queryAdapter.queryNoReturn('DELETE FROM trips');
  }

  @override
  Future<void> insertTrip(TripEntity trip) async {
    await _tripEntityInsertionAdapter.insert(trip, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTrip(TripEntity trip) async {
    await _tripEntityUpdateAdapter.update(trip, OnConflictStrategy.abort);
  }
}

class _$SavedPlaceDao extends SavedPlaceDao {
  _$SavedPlaceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _savedPlaceEntityInsertionAdapter = InsertionAdapter(
            database,
            'saved_places',
            (SavedPlaceEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'image': item.image,
                  'location': item.location,
                  'rating': item.rating,
                  'description': item.description,
                  'category': item.category,
                  'latitude': item.latitude,
                  'longitude': item.longitude
                }),
        _savedPlaceEntityDeletionAdapter = DeletionAdapter(
            database,
            'saved_places',
            ['id'],
            (SavedPlaceEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'image': item.image,
                  'location': item.location,
                  'rating': item.rating,
                  'description': item.description,
                  'category': item.category,
                  'latitude': item.latitude,
                  'longitude': item.longitude
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SavedPlaceEntity> _savedPlaceEntityInsertionAdapter;

  final DeletionAdapter<SavedPlaceEntity> _savedPlaceEntityDeletionAdapter;

  @override
  Future<List<SavedPlaceEntity>> getAllSavedPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM saved_places',
        mapper: (Map<String, Object?> row) => SavedPlaceEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            image: row['image'] as String,
            location: row['location'] as String,
            rating: row['rating'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?));
  }

  @override
  Future<void> deleteSavedPlaceById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM saved_places WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<SavedPlaceEntity?> getSavedPlaceById(String id) async {
    return _queryAdapter.query('SELECT * FROM saved_places WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SavedPlaceEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            image: row['image'] as String,
            location: row['location'] as String,
            rating: row['rating'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?),
        arguments: [id]);
  }

  @override
  Future<void> insertSavedPlace(SavedPlaceEntity place) async {
    await _savedPlaceEntityInsertionAdapter.insert(
        place, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSavedPlace(SavedPlaceEntity place) async {
    await _savedPlaceEntityDeletionAdapter.delete(place);
  }
}
