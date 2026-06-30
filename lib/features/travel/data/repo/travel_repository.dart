import '../db/travel_dao.dart';
import '../models/travel_item_entity.dart';
import '../remote/travel_api_service.dart';

class TravelRepository {
  final TravelDao _dao;
  final TravelApiService _apiService;

  TravelRepository(this._dao, this._apiService);

  /// Resolves a free-text place name (e.g. "Paris") to a location_id.
  Future<String?> searchLocationId(String query) =>
      _apiService.searchLocationId(query);

  Future<List<TravelItemEntity>> getHotels(String locationId) => _getItems(
        'hotel',
        locationId,
        () => _apiService.fetchHotels(locationId),
      );

  Future<List<TravelItemEntity>> getRestaurants(String locationId) =>
      _getItems(
        'restaurant',
        locationId,
        () => _apiService.fetchRestaurants(locationId),
      );

  Future<List<TravelItemEntity>> getAttractions(String locationId) =>
      _getItems(
        'attraction',
        locationId,
        () => _apiService.fetchAttractions(locationId),
      );

  /// Cache-first strategy:
  /// 1. Return cached data if it exists in Floor DB for this location
  /// 2. Otherwise fetch from API → save to DB → return
  Future<List<TravelItemEntity>> _getItems(
    String category,
    String locationId,
    Future<List<TravelItemEntity>> Function() fetchFromApi,
  ) async {
    final cached = await _dao.getByCategory(category, locationId);
    if (cached.isNotEmpty) return cached;

    final fresh = await fetchFromApi();
    if (fresh.isNotEmpty) {
      await _dao.deleteByCategory(category, locationId);
      await _dao.insertItems(fresh);
    }
    return fresh;
  }

  /// Force refresh from API (ignores cache, clears everything)
  Future<void> refreshAll() async {
    await _dao.clearAll();
  }
}