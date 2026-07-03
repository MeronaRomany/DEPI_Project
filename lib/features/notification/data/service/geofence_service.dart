import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geofencing_api/geofencing_api.dart';
// import 'package:geofencing_api/geofencing_api.dart' as geo;

import '../../presentation/cubit/get_it.dart';
import '../../presentation/cubit/notification_cubit.dart';
import 'notifcation_service.dart';

class GeofenceService {
  static final GeofenceService _instance = GeofenceService._internal();
  factory GeofenceService() => _instance;

  GeofenceService._internal();
  bool _listenersInitialized = false;

  final Set<GeofenceRegion> _regions = {};

  /// Permissions
  Future<bool> requestPermission({bool background = true}) async {
    if (!await Geofencing.instance.isLocationServicesEnabled) {
      return false;
    }

    LocationPermission permission = await Geofencing.instance
        .getLocationPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geofencing.instance.requestLocationPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    if (kIsWeb) {
      return true;
    }

    /// Android background permission
    if (Platform.isAndroid &&
        background &&
        permission == LocationPermission.whileInUse) {
      permission = await Geofencing.instance.requestLocationPermission();

      if (permission != LocationPermission.always) {
        return false;
      }
    }

    return true;
  }

  /// Setup
  void setup() {
    Geofencing.instance.setup(
      interval: 5000,
      accuracy: 100,
      statusChangeDelay: 10000,
      allowsMockLocation: false,
      printsDebugLog: true,
    );
  }

  /// Add Regions
  void addRegion({
    required String id,
    required String name,
    required double lat,
    required double lon,
    double radius = 150,
  }) {
    _regions.removeWhere((e) => e.id == id);

    _regions.add(
      GeofenceRegion.circular(
        id: id,
        data: {'name': name,
          'lat': lat,
          'lon': lon,
        },
        center: LatLng(lat, lon),
        radius: radius,
        loiteringDelay: 60000,
      ),
    );
  }


  Future<void> start() async {
    if (!_listenersInitialized) {
      Geofencing.instance.addGeofenceStatusChangedListener(
        _onGeofenceStatusChanged,
      );

      Geofencing.instance.addGeofenceErrorCallbackListener(_onGeofenceError);

      _listenersInitialized = true;
    }
    print("Regions count = ${_regions.length}");

    for (final region in _regions) {
      final data = region.data as Map<String, dynamic>?;
      print("Region: ${region.id} - ${data?['name']}");
    }

    await Geofencing.instance.start(regions: _regions);
  }


  Future<void> stop() async {
    await Geofencing.instance.stop();
  }


  /// Callbacks
  Future<void> _onGeofenceStatusChanged(
    GeofenceRegion region,
    GeofenceStatus status,
    Location location,

  ) async {
    debugPrint('Region: ${region.id} Status: ${status.name}');

    if (status == GeofenceStatus.enter) {
      debugPrint("Entered ${region.id}");

      final data = region.data as Map<String, dynamic>?;
      final name = data?['name'] ?? '';
      debugPrint('Entered: $name');
      final placeLat = data?['lat'] as double;
      final placeLon = data?['lon'] as double;

      final cubit = getIt<NotificationCubit>();



      cubit.showPlaceNotification(
        name,
        placeLat,
        placeLon,
      );
      NotificationService.showNotifications(
        id: region.id.hashCode,
        body:
            ((region.data as Map<String, dynamic>?)?['name'] as String?) ?? '',
      );
    }
  }

  void _onGeofenceError(Object error, StackTrace stackTrace) {
    print(error);
  }


  Future<void> clearRegions() async {
    await Geofencing.instance.stop();

    _regions.clear();
  }

  Future<void> restart() async {
    await stop();
    await start();
  }
}
