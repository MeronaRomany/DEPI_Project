import 'package:floor/floor.dart';
import '../models/travel_item_entity.dart';

@dao
abstract class TravelDao {
  @Query('SELECT * FROM travel_items WHERE category = :category AND locationId = :locationId')
  Future<List<TravelItemEntity>> getByCategory(String category, String locationId);

  @insert
  Future<void> insertItems(List<TravelItemEntity> items);

  @Query('DELETE FROM travel_items WHERE category = :category AND locationId = :locationId')
  Future<void> deleteByCategory(String category, String locationId);

  @Query('DELETE FROM travel_items')
  Future<void> clearAll();
}
