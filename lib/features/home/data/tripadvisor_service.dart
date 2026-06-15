import 'dart:convert';
import 'package:http/http.dart' as http;

class TripAdvisorService {
  static const String _apiKey = "https://travel-advisor.p.rapidapi.com/";
  static const String _baseUrl = 'https://api.content.tripadvisor.com/api/v1/location';

  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final encodedQuery = Uri.encodeComponent(query.trim());
    final String url = '$_baseUrl/search?key=$_apiKey&searchQuery=$encodedQuery&language=en';

    try {
      print('--- Sending request to: $url ---');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List jsonList = data['data'] ?? [];

        List<Map<String, dynamic>> results = [];

        for (var item in jsonList) {
          final locationId = item['location_id'];
          if (locationId == null) continue;

          // تحديد الـ Category تلقائياً بناءً على الكلمة أو رد السيرفر
          String currentCategory = 'state';
          String fallbackImage = 'https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8'; // Default Egypt

          String lowerQuery = query.toLowerCase();
          if (lowerQuery.contains('rest') || lowerQuery.contains('food') || lowerQuery.contains('eat')) {
            currentCategory = 'food';
            fallbackImage = 'https://images.unsplash.com/photo-1544025162-d76694265947';
          } else if (lowerQuery.contains('caf')) {
            currentCategory = 'cafe';
            fallbackImage = 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb';
          } else if (lowerQuery.contains('hotel')) {
            currentCategory = 'hotel';
            fallbackImage = 'https://images.unsplash.com/photo-1566073771259-6a8506099945';
          }

          String placeName = item['name'] ?? 'Beautiful Destination';
          String cityName = item['address_obj']?['city'] ?? 'Egypt';

          results.add({
            "id": locationId.toString(),
            "name": placeName,
            "location": item['address_obj']?['address_string'] ?? cityName,
            "image": fallbackImage,
            "rating": 4.5,
            "description": item['description'] ?? 'Welcome to $placeName. Located in $cityName, it stands as a wonderful place to visit, explore, and experience the local culture and authentic vibe.',
            "category": currentCategory,

            // حقن داتا الـ Dynamic Details بناءً على التصميم اللي في الصورة
            "howToReach": currentCategory == 'state' || currentCategory == 'city'
                ? [
              "Flights: There are domestic airports and connecting flights available to reach $cityName easily.",
              "Railways: Major cities are connected by rail networks with regular trains serving this destination daily.",
              "Roads: Well-maintained highways and local transport (buses/taxis) connect it seamlessly."
            ]
                : null, // الأكل والكافيهات مش هتحتاج How to reach في التصميم

            // الأزرار الأربعة اللي بتظهر تحت الكفر في شاشة الديتيلز (تظهر للمدن والمحافظات فقط)
            "subCategories": currentCategory == 'state' || currentCategory == 'city'
                ? [
              {"type": "Places", "icon": "location_on"},
              {"type": "Hotels", "icon": "hotel"},
              {"type": "Food", "icon": "restaurant"},
              {"type": "Activities", "icon": "local_activity"},
            ]
                : null,
          });
        }
        return results;
      } else {
        print('❌ TripAdvisor Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Catch Error: $e');
      return [];
    }
  }
}