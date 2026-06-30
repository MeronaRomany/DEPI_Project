import 'package:depi_project/core/networking/dio_helper.dart';
import '../models/travel_item_entity.dart';

class TravelApiService {
  /// Fallback used until the user searches for a destination.
  static const String defaultLocationId = '294201'; // Cairo, Egypt

  /// Looks up a location_id for a free-text place name (e.g. "Cairo",
  /// "Paris", "New York"). Returns null if nothing matched.
  Future<String?> searchLocationId(String query) async {
    final response = await DioHelper.getData(
      endPoint: 'locations/search',
      queryParameters: {
        'query': query,
        'lang': 'en_US',
      },
    );

    final List<dynamic> data = response.data['data'] ?? [];
    if (data.isEmpty) return null;

    // Prefer an actual city/region ("geos") match over a single hotel /
    // restaurant / attraction hit, since we want a destination-level id
    // to feed into hotels/restaurants/attractions lists.
    final geoMatch = data.firstWhere(
      (item) =>
          item != null &&
          item['result_type'] == 'geos' &&
          item['result_object']?['location_id'] != null,
      orElse: () => null,
    );

    final anyMatch = geoMatch ??
        data.firstWhere(
          (item) =>
              item != null && item['result_object']?['location_id'] != null,
          orElse: () => null,
        );

    return anyMatch?['result_object']?['location_id']?.toString();
  }

  Future<List<TravelItemEntity>> fetchHotels(String locationId) {
    return _fetchItems(
      'hotels/list',
      'hotel',
      locationId,
      extraParams: {
        'adults': '1',
        'rooms': '1',
        'nights': '2',
        'offset': '0',
        'order': 'asc',
        'sort': 'recommended',
      },
    );
  }

  Future<List<TravelItemEntity>> fetchRestaurants(String locationId) =>
      _fetchItems('restaurants/list', 'restaurant', locationId);

  Future<List<TravelItemEntity>> fetchAttractions(String locationId) =>
      _fetchItems('attractions/list', 'attraction', locationId);

  Future<List<TravelItemEntity>> _fetchItems(
    String endpoint,
    String category,
    String locationId, {
    Map<String, String> extraParams = const {},
  }) async {
    final response = await DioHelper.getData(
      endPoint: endpoint,
      queryParameters: {
        'location_id': locationId,
        'limit': '10',
        'lang': 'en_US',
        'currency': 'USD',
        'lunit': 'km',
        ...extraParams,
      },
    );

    // TEMP DEBUG — remove once hotels are confirmed working.
    // ignore: avoid_print
    print('[$category] status=${response.statusCode} data=${response.data}');

    final List<dynamic> data = response.data['data'] ?? [];

    return data
        .where((item) => item != null && item['name'] != null)
        .map<TravelItemEntity>((item) {
          // Extract the best available image URL from nested photo object
          String imageUrl = '';
          try {
            final photo = item['photo'];
            if (photo != null) {
              final images = photo['images'];
              imageUrl = images?['large']?['url'] ??
                  images?['medium']?['url'] ??
                  images?['small']?['url'] ??
                  '';
            }
          } catch (_) {}

          final itemLocationId =
              item['location_id']?.toString() ?? locationId;

          return TravelItemEntity(
            id: '${category}_$itemLocationId',
            name: item['name'] as String? ?? '',
            imageUrl: imageUrl,
            rating: item['rating']?.toString() ?? '0',
            numReviews: item['num_reviews']?.toString() ?? '0',
            category: category,
            locationId: locationId,
          );
        })
        .toList();
  }
}