import 'package:geolocator/geolocator.dart';

class LocationTracker {
  Position? _lastPosition;

  final double thresholdMeters;

  LocationTracker({this.thresholdMeters = 20});

  bool shouldFetch(Position newPosition) {
    if (_lastPosition == null) {
      _lastPosition = newPosition;
      return true;
    }

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    if (distance >= thresholdMeters) {
      _lastPosition = newPosition;
      return true;
    }

    return false;
  }
}