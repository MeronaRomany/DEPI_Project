import 'package:geolocator/geolocator.dart';
import 'LocationTracker.dart';
import '../api/overpass_api.dart';

class PlacesController {
  final OverpassApi api;
  final LocationTracker tracker;

  List<dynamic> cachedPlaces = [];

  PlacesController({
    required this.api,
    required this.tracker,
  });

  Future<void> onLocationUpdate(Position position) async {

    if (!tracker.shouldFetch(position)) {
      print("Using cached data");
      return;
    }

    print("Fetching new places...");

    const offset = 0.05; // ~5km

    try {
      final result = await api.fetchPlaces(
        position.latitude - offset,
        position.longitude - offset,
        position.latitude + offset,
        position.longitude + offset,
      );

      cachedPlaces = result;

      print("✅ Places updated: ${cachedPlaces.length}");


    } catch (e) {
      print("❌ API error: $e");
    }
  }
}