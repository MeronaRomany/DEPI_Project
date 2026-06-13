import 'package:floor/floor.dart';
import '../db/place_entity.dart';

@dao
abstract class PlaceDao {
  @Query('SELECT * FROM places')
  Future<List<PlaceEntity>> getAllPlaces();

  @insert
  Future<void> insertPlaces(List<PlaceEntity> places);

  @Query('DELETE FROM places')
  Future<void> clearAll();
}