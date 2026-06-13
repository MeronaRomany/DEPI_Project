import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../service/location_service.dart';

class LocationController {
  final LocationService locationService;
  final Function(Position) onLocationUpdate;

  StreamSubscription<Position>? _sub;

  LocationController(
      this.locationService,
      this.onLocationUpdate,
      );

  void start() {
    _sub = locationService
        .getLocationStream()
        .listen(onLocationUpdate);
  }

  void stop() {
    _sub?.cancel();
  }
}