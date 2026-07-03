import 'package:geolocator/geolocator.dart';

import '../api/overpass_api.dart';
import '../controller/LocationTracker.dart';
import '../db/app_database.dart';
import '../db/place_entity.dart';
import '../service/geofence_service.dart';
import '../service/location_service.dart';

class PlaceRepository {
  final OverpassApi api;
  final AppDatabase db;
  final LocationService locationService;
  final LocationTracker tracker;
  final GeofenceService geofenceService;

  List<PlaceEntity> cachedPlaces = [];

  PlaceRepository(
      this.api,
      this.db,
      this.locationService,
      this.tracker,
      this.geofenceService,
      );

  List<PlaceEntity> getNearestPlacesFromUser({
    required List<PlaceEntity> places,
    required double userLat,
    required double userLon,
    int limit = 50,
  }) {
    final sorted = [...places];

    sorted.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userLat,
        userLon,
        a.lat,
        a.lon,
      );

      final distanceB = Geolocator.distanceBetween(
        userLat,
        userLon,
        b.lat,
        b.lon,
      );

      return distanceA.compareTo(distanceB);
    });

    return sorted.take(limit).toList();
  }

  Future<void> updateNearbyPlaces(Position pos) async {
    if (!tracker.shouldFetch(pos)) {
      return;
    }

    final userLat = pos.latitude;
    final userLon = pos.longitude;

    const double offset = 0.2;

    try {
      final elements = await api.fetchPlaces(
        userLat - offset,
        userLon - offset,
        userLat + offset,
        userLon + offset,
      );

      List<PlaceEntity> places = elements
          .where((e) {
        final lat = e['lat'] ?? e['center']?['lat'];
        final lon = e['lon'] ?? e['center']?['lon'];

        return lat != null &&
            lon != null &&
            e['tags']?['name'] != null;
      })
          .map((e) {
        final lat = e['lat'] ?? e['center']['lat'];
        final lon = e['lon'] ?? e['center']['lon'];
        final rawId = e['id'];
        final int id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? rawId.hashCode;

        return PlaceEntity(
          id: id,
          name: e['tags']['name'],
          lat: (lat as num).toDouble(),
          lon: (lon as num).toDouble(),
          type: e['tags']?['tourism'] ??
              e['tags']?['historic'] ??
              'unknown',
        );
      })
          .toList();

      final unique = <int, PlaceEntity>{};

      for (final place in places) {
        unique[place.id] = place;
      }

      places = unique.values.toList();

      cachedPlaces = places;

      await db.placeDao.clearAll();
      await db.placeDao.insertPlaces(places);

      final nearestPlaces = getNearestPlacesFromUser(
        places: places,
        userLat: userLat,
        userLon: userLon,
      );

      await geofenceService.clearRegions();

      for (final place in nearestPlaces) {
        geofenceService.addRegion(
          id: place.id.toString(),
          name: place.name,
          lat: place.lat,
          lon: place.lon,
        );
      }

      geofenceService.addRegion(
        id: "999999",
        name: "Home Test",
        lat: userLat + 0.0001,
        radius: 30,
        lon: userLon,
      );

      await geofenceService.start();
    } catch (e) {
      cachedPlaces = await db.placeDao.getAllPlaces();
    }
  }
}