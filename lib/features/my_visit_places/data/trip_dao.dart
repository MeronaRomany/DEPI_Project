import 'package:floor/floor.dart';
import 'trip_entity.dart';

@dao
abstract class TripDao {
  @Query('SELECT * FROM trips')
  Future<List<TripEntity>> getAllTrips();

  @Query('SELECT * FROM trips WHERE id = :id')
  Future<TripEntity?> getTripById(int id);

  @insert
  Future<void> insertTrip(TripEntity trip);

  @update
  Future<void> updateTrip(TripEntity trip);

  @Query('DELETE FROM trips WHERE id = :id')
  Future<void> deleteTripById(int id);

  @Query('DELETE FROM trips')
  Future<void> deleteAllTrips();
}
