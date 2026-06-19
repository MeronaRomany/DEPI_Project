import 'dart:convert';
import 'package:http/http.dart' as http;

class TripAdvisorService {
  // تأكد من وضع مفتاحك هنا
  static const String _apiKey = "https://travel-advisor.p.rapidapi.com/";
  static const String _baseUrl = 'https://api.content.tripadvisor.com/api/v1/location';
  static const String _host = 'travel-advisor.p.rapidapi.com';


  // --- بيانات وهمية للطوارئ (تظهر إذا فشل الاتصال) ---
  static List<Map<String, dynamic>> _getMockRestaurants() {
    return [
      {"id": "r1", "name": "Abou Tarek", "image": "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38", "location": "Cairo, Egypt", "rating": 4.8, "description": "Famous for Koshary.", "category": "restaurant", "latitude": 30.0444, "longitude": 31.2357},
      {"id": "r2", "name": "Zooba", "image": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5", "location": "Cairo, Egypt", "rating": 4.6, "description": "Modern Egyptian street food.", "category": "restaurant", "latitude": 30.0450, "longitude": 31.2360},
      {"id": "r3", "name": "Felfela", "image": "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4", "location": "Downtown, Cairo", "rating": 4.5, "description": "Traditional Egyptian cuisine.", "category": "restaurant", "latitude": 30.0470, "longitude": 31.2380},
      {"id": "r4", "name": "Kazaz", "image": "https://images.unsplash.com/photo-1551218808-94e220e084d2", "location": "Zamalek, Cairo", "rating": 4.4, "description": "Great liver sandwiches.", "category": "restaurant", "latitude": 30.0600, "longitude": 31.2200},
      {"id": "r5", "name": "Sabaya", "image": "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b", "location": "Maadi, Cairo", "rating": 4.3, "description": "Authentic home-style food.", "category": "restaurant", "latitude": 30.0100, "longitude": 31.2500},
      {"id": "r6", "name": "El Malky", "image": "https://images.unsplash.com/photo-1544025162-d76694265947", "location": "Multiple Locations", "rating": 4.7, "description": "Famous fast food sandwiches.", "category": "restaurant", "latitude": 30.0500, "longitude": 31.2400},
      {"id": "r7", "name": "Pizza Hut", "image": "https://images.unsplash.com/photo-1513104890138-7c749659a591", "location": "Cairo Festival City", "rating": 4.2, "description": "International chain pizza.", "category": "restaurant", "latitude": 30.0300, "longitude": 31.4500},
      {"id": "r8", "name": "Sushi Station", "image": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c", "location": "New Cairo", "rating": 4.5, "description": "Fresh Japanese cuisine.", "category": "restaurant", "latitude": 30.0000, "longitude": 31.5000},
      {"id": "r9", "name": "Burger King", "image": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd", "location": "Mall of Egypt", "rating": 4.1, "description": "Flame grilled burgers.", "category": "restaurant", "latitude": 30.0400, "longitude": 31.0200},
      {"id": "r10", "name": "El Prince", "image": "https://images.unsplash.com/photo-1504674900247-0877df9cc836", "location": "Haram, Giza", "rating": 4.6, "description": "Classic Egyptian dining.", "category": "restaurant", "latitude": 29.9900, "longitude": 31.1300},
      // Cafes (treated as restaurants in API usually)
      {"id": "c1", "name": "Cilantro", "image": "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085", "location": "Cairo, Egypt", "rating": 4.5, "description": "Popular cafe chain.", "category": "cafe", "latitude": 30.0444, "longitude": 31.2357},
      {"id": "c2", "name": "Beano's", "image": "https://images.unsplash.com/photo-1559925393-8be0ec4767c8", "location": "Maadi, Cairo", "rating": 4.6, "description": "Cozy atmosphere and great coffee.", "category": "cafe", "latitude": 30.0100, "longitude": 31.2500},
      {"id": "c3", "name": "Starbucks", "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93", "location": "City Stars", "rating": 4.4, "description": "World famous coffee.", "category": "cafe", "latitude": 30.0600, "longitude": 31.3200},
      {"id": "c4", "name": "Espresso Lab", "image": "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb", "location": "Zamalek", "rating": 4.8, "description": "Specialty coffee.", "category": "cafe", "latitude": 30.0600, "longitude": 31.2200},
    ];
  }

  static List<Map<String, dynamic>> _getMockAttractions() {
    return [
      {"id": "a1", "name": "The Great Pyramids", "image": "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368", "location": "Giza, Egypt", "rating": 5.0, "description": "One of the Seven Wonders of the World.", "category": "attraction", "latitude": 29.9792, "longitude": 31.1342},
      {"id": "a2", "name": "The Egyptian Museum", "image": "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8", "location": "Tahrir, Cairo", "rating": 4.8, "description": "Home to ancient Egyptian antiquities.", "category": "attraction", "latitude": 30.0478, "longitude": 31.2336},
      {"id": "a3", "name": "Khan El-Khalili", "image": "https://images.unsplash.com/photo-1572276596237-5db2c3e16c5d", "location": "Old Cairo", "rating": 4.7, "description": "Famous bazaar and souk.", "category": "attraction", "latitude": 30.0478, "longitude": 31.2632},
      {"id": "a4", "name": "Cairo Tower", "image": "https://images.unsplash.com/photo-1572252009286-268acec5ca0a", "location": "Zamalek, Cairo", "rating": 4.6, "description": "Iconic landmark with panoramic views.", "category": "attraction", "latitude": 30.0444, "longitude": 31.2235},
      {"id": "a5", "name": "Al-Azhar Park", "image": "https://images.unsplash.com/photo-1564399580075-5dfe19c205f3", "location": "Cairo, Egypt", "rating": 4.5, "description": "Beautiful green space in the city.", "category": "attraction", "latitude": 30.0370, "longitude": 31.2630},
      {"id": "a6", "name": "Saladin Citadel", "image": "https://images.unsplash.com/photo-1566577134770-3d85bb3a9cc4", "location": "Cairo, Egypt", "rating": 4.6, "description": "Medieval Islamic fortification.", "category": "attraction", "latitude": 30.0280, "longitude": 31.2620},
      {"id": "a7", "name": "Muhammad Ali Mosque", "image": "https://images.unsplash.com/photo-1564564244660-5d73c057f2d2", "location": "Cairo Citadel", "rating": 4.8, "description": "Ottoman style mosque.", "category": "attraction", "latitude": 30.0280, "longitude": 31.2610},
      {"id": "a8", "name": "Nile River", "image": "https://images.unsplash.com/photo-1564564244660-5d73c057f2d2", "location": "Cairo, Egypt", "rating": 4.9, "description": "The longest river in the world.", "category": "attraction", "latitude": 30.1000, "longitude": 31.3000},
      {"id": "a9", "name": "Sphinx", "image": "https://images.unsplash.com/photo-1539650116455-251d9a0d8446", "location": "Giza, Egypt", "rating": 4.9, "description": "Limestone statue of a reclining sphinx.", "category": "attraction", "latitude": 29.9753, "longitude": 31.1376},
      {"id": "a10", "name": "Bibliotheca Alexandrina", "image": "https://images.unsplash.com/photo-1569660503326-3cf33c9ab30c", "location": "Alexandria", "rating": 4.7, "description": "Major library and cultural center.", "category": "attraction", "latitude": 31.2080, "longitude": 29.9190},
    ];
  }

  // 1. دالة البحث العامة
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final encodedQuery = Uri.encodeComponent(query.trim());
    final String url = '$_baseUrl/locations/v2/search?query=$encodedQuery&language=en_US&currency=USD';

    try {
      print('--- Search API: $url ---');
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-RapidAPI-Key': _apiKey, 'X-RapidAPI-Host': _host},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['data']?['App_Search_v2']?['items'] ?? [];
        List<Map<String, dynamic>> results = [];

        for (var item in items) {
          final details = item['details'] ?? {};
          final locationId = details['location_id'];
          if (locationId == null) continue;

          String imageUrl = details['photo']?['images']?['medium']?['url'] ?? 'https://via.placeholder.com/150';
          results.add({
            "id": locationId.toString(),
            "name": details['name'],
            "location": details['address_obj']?['address_string'] ?? 'Egypt',
            "image": imageUrl,
            "rating": (details['rating'] ?? 4.5).toDouble(),
            "description": details['description'] ?? 'No description',
            "category": 'search_result',
            "latitude": details['latitude'],
            "longitude": details['longitude'],
          });
        }
        return results;
      }
    } catch (e) {
      print('Search Error: $e');
    }

    // Fallback: Search in mock data if API fails
    final allMock = [..._getMockAttractions(), ..._getMockRestaurants()];
    return allMock.where((item) =>
        item['name'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // 2. دالة جلب المطاعم (مع Pagination)
  static Future<List<Map<String, dynamic>>> fetchRestaurants(String locationId, {int offset = 0}) async {
    if (_apiKey == 'YOUR_RAPIDAPI_KEY_HERE' || _apiKey == "---------------------------") {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockRestaurants().skip(offset).take(30).toList();
    }

    final String url = '$_baseUrl/restaurants/list?location_id=$locationId&limit=30&offset=$offset&lang=en_US&currency=USD';

    try {
      print('--- Restaurants API Offset $offset ---');
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-RapidAPI-Key': _apiKey, 'X-RapidAPI-Host': _host},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['data'] ?? [];
        return _parseItems(items, 'restaurant');
      }
    } catch (e) {
      print('Restaurants Error: $e');
    }
    return _getMockRestaurants().skip(offset).take(30).toList(); // Fallback
  }

  // 3. دالة جلب المعالم (مع Pagination)
  static Future<List<Map<String, dynamic>>> fetchAttractions(String locationId, {int offset = 0}) async {
    if (_apiKey == 'YOUR_RAPIDAPI_KEY_HERE' || _apiKey == "---------------------------") {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockAttractions().skip(offset).take(30).toList();
    }

    final String url = '$_baseUrl/attractions/list?location_id=$locationId&limit=30&offset=$offset&lang=en_US&currency=USD';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-RapidAPI-Key': _apiKey, 'X-RapidAPI-Host': _host},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['data'] ?? [];
        return _parseItems(items, 'attraction');
      }
    } catch (e) {
      print('Attractions Error: $e');
    }
    return _getMockAttractions().skip(offset).take(30).toList(); // Fallback
  }

  // دالة مساعدة لتحويل البيانات القادمة من List Endpoints
  static List<Map<String, dynamic>> _parseItems(List items, String defaultCat) {
    List<Map<String, dynamic>> results = [];
    for (var item in items) {
      final String name = item['name'] ?? 'Unknown Place';

      String photoUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947';
      if (item['photo'] != null && item['photo']['images'] != null) {
        photoUrl = item['photo']['images']['medium']?['url'] ?? photoUrl;
      } else if (item['photo'] != null) {
        photoUrl = item['photo']['images']['original']?['url'] ?? photoUrl;
      }

      results.add({
        "id": item['location_id']?.toString() ?? name.hashCode.toString(),
        "name": name,
        "location": item['address'] ?? item['address_obj']?['address_string'] ?? 'Egypt',
        "image": photoUrl,
        "rating": (item['rating'] is String ? double.tryParse(item['rating']) : (item['rating'] ?? 4.0).toDouble()) ?? 4.0,
        "description": item['description'] ?? 'Great place to visit.',
        "category": defaultCat,
        "latitude": item['latitude'] != null ? double.tryParse(item['latitude'].toString()) : null,
        "longitude": item['longitude'] != null ? double.tryParse(item['longitude'].toString()) : null,
        "webUrl": item['web_url'] ?? item['website'] ?? '',
      });
    }
    return results;
  }
}