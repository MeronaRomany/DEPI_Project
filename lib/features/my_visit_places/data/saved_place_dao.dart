import 'package:floor/floor.dart';
import 'saved_place_entity.dart';

@dao
abstract class SavedPlaceDao {
  @Query('SELECT * FROM saved_places')
  Future<List<SavedPlaceEntity>> getAllSavedPlaces();

  @insert
  Future<void> insertSavedPlace(SavedPlaceEntity place);

  @delete
  Future<void> deleteSavedPlace(SavedPlaceEntity place);

  @Query('DELETE FROM saved_places WHERE id = :id')
  Future<void> deleteSavedPlaceById(String id);

  @Query('SELECT * FROM saved_places WHERE id = :id')
  Future<SavedPlaceEntity?> getSavedPlaceById(String id);
}
