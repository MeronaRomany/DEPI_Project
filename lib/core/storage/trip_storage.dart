import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TripStorage {
  static const String tripsKey = "user_trips";

  /// تحميل كل الرحلات
  static Future<List<Map<String, dynamic>>> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(tripsKey);

    if (data == null) return [];

    final List decoded = jsonDecode(data);

    return decoded
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// حفظ القائمة كاملة
  static Future<void> saveTrips(
      List<Map<String, dynamic>> trips,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      tripsKey,
      jsonEncode(trips),
    );
  }

  /// إضافة رحلة
  static Future<void> addTrip(
      Map<String, dynamic> trip,
      ) async {
    List<Map<String, dynamic>> trips = await loadTrips();

    trips.add(trip);

    await saveTrips(trips);
  }

  /// حذف رحلة
  static Future<void> deleteTrip(
      int index,
      ) async {
    List<Map<String, dynamic>> trips = await loadTrips();

    if (index >= 0 && index < trips.length) {
      trips.removeAt(index);

      await saveTrips(trips);
    }
  }

  /// تعديل رحلة
  static Future<void> updateTrip(
      int index,
      Map<String, dynamic> newTrip,
      ) async {
    List<Map<String, dynamic>> trips = await loadTrips();

    if (index >= 0 && index < trips.length) {
      trips[index] = newTrip;

      await saveTrips(trips);
    }
  }

  /// حذف الكل
  static Future<void> clearTrips() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(tripsKey);
  }

  /// عدد الرحلات
  static Future<int> countTrips() async {
    List<Map<String, dynamic>> trips = await loadTrips();

    return trips.length;
  }

  /// هل يوجد رحلات؟
  static Future<bool> hasTrips() async {
    return (await countTrips()) > 0;
  }
}