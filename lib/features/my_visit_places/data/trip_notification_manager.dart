import 'package:depi_project/features/notification/data/service/notifcation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripNotificationManager {
  static const String _scheduledIdsKey = 'trip_scheduled_notification_ids';

  static Future<void> scheduleTripNotifications(Map<String, dynamic> trip, {String? oldTitle}) async {
    if (oldTitle != null) {
      await cancelTripNotifications(oldTitle);
    }

    final String tripTitle = trip['title'] ?? 'New Trip';
    final List<dynamic> schedule = trip['schedule'] ?? [];
    List<int> newScheduledIds = [];

    for (var day in schedule) {
      final String dateStr = day['date'] ?? '';
      final String timeStr = day['startTime'] ?? '';
      final List<dynamic> places = day['places'] ?? [];

      if (dateStr.isNotEmpty && timeStr.isNotEmpty && places.isNotEmpty) {
        try {
          final parts = dateStr.split('/');
          final timeParts = timeStr.split(':');
          if (parts.length == 3 && timeParts.length == 2) {
            final int dayPart = int.parse(parts[0]);
            final int monthPart = int.parse(parts[1]);
            final int yearPart = int.parse(parts[2]);
            final int hourPart = int.parse(timeParts[0]);
            final int minutePart = int.parse(timeParts[1]);

            final DateTime visitDate = DateTime(
              yearPart,
              monthPart,
              dayPart,
              hourPart,
              minutePart,
            );

            DateTime notificationDate = visitDate.subtract(const Duration(days: 1));

            for (var placeName in places) {
              final String uniqueKey = '$tripTitle|${placeName.toString()}|$dateStr';
              final int notificationId = uniqueKey.hashCode;
              newScheduledIds.add(notificationId);

              await NotificationService.scheduleNotifications(
                id: notificationId,
                body: "Upcoming visit to $placeName in your trip '$tripTitle' tomorrow!",
                scheduledDate: notificationDate,
              );
            }
          }
        } catch (e) {
          // skip invalid date/day entries
        }
      }
    }

    await _saveScheduledIds(tripTitle, newScheduledIds);
  }

  static Future<void> cancelTripNotifications(String tripTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataStr = prefs.getString(_scheduledIdsKey);
    if (dataStr != null) {
      final Map<String, dynamic> allData = jsonDecode(dataStr);
      if (allData.containsKey(tripTitle)) {
        final List<dynamic> ids = allData[tripTitle];
        for (var id in ids) {
          if (id is int) {
            await NotificationService.cancelNotification(id);
          }
        }
        allData.remove(tripTitle);
        await prefs.setString(_scheduledIdsKey, jsonEncode(allData));
      }
    }
  }

  static Future<void> _saveScheduledIds(String tripTitle, List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataStr = prefs.getString(_scheduledIdsKey);
    Map<String, dynamic> allData = {};
    if (dataStr != null) {
      allData = jsonDecode(dataStr);
    }
    allData[tripTitle] = ids;
    await prefs.setString(_scheduledIdsKey, jsonEncode(allData));
  }
}
