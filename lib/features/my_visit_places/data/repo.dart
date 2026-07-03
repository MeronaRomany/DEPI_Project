import 'dart:convert';

import 'package:depi_project/features/my_visit_places/data/trip_dao.dart';
import 'package:depi_project/features/my_visit_places/data/trip_entity.dart';
import 'package:depi_project/features/my_visit_places/data/trip_notification_manager.dart';

class TripRepository {
  final TripDao _tripDao;

  TripRepository(this._tripDao);

  Future<List<Map<String, dynamic>>> getAllTrips() async {
    final entities = await _tripDao.getAllTrips();
    return entities.map((e) {
      final map = e.toMap();
      map['schedule'] = jsonDecode(e.schedule);
      return map;
    }).toList();
  }

  Future<void> saveTrip(Map<String, dynamic> tripData) async {
    final entity = TripEntity(
      id: tripData['id'],
      title: tripData['title'] ?? '',
      destination: tripData['destination'] ?? '',
      destinationImage: tripData['destinationImage'] ?? '',
      startDate: tripData['startDate'] ?? '',
      endDate: tripData['endDate'] ?? '',
      places: tripData['places'] ?? '',
      placesCount: tripData['placesCount'] ?? 0,
      schedule: jsonEncode(tripData['schedule'] ?? []),
      image: tripData['image'] ?? '',
    );

    if (entity.id == null) {
      await _tripDao.insertTrip(entity);
    } else {
      await _tripDao.updateTrip(entity);
    }

    await TripNotificationManager.scheduleTripNotifications(tripData);
  }

  Future<void> deleteTrip(Map<String, dynamic> tripData) async {
    final id = tripData['id'];
    if (id != null) {
      await _tripDao.deleteTripById(id);
      await TripNotificationManager.cancelTripNotifications(tripData['title'] ?? '');
    }
  }
}
