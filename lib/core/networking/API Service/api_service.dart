import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> getPlacesByQuery(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=15&accept-language=en');

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'TravelApp_DEPI_Project',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) {
          String randomImage = 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600';

          if (query.toLowerCase().contains('egypt') || query.toLowerCase().contains('cairo')) {
            randomImage = 'https://images.unsplash.com/photo-1503177119275-0aa32b31d468?q=80&w=600'; // صورة لمصر
          } else if (query.toLowerCase().contains('india') || query.toLowerCase().contains('taj')) {
            randomImage = 'https://images.unsplash.com/photo-1564507592333-c60657eea523?q=80&w=600'; // صورة للهند
          } else if (query.toLowerCase().contains('paris') || query.toLowerCase().contains('france')) {
            randomImage = 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=600';
          }

          return {
            "id": item['place_id'].toString(),
            "name": item['display_name'].toString().split(',')[0], // بناخد أول جزء من الاسم عشان ميبقاش طويل جداً
            "location": item['display_name'].toString(), // الاسم الكامل فيه المحافظة والدولة
            "image": randomImage,
            "rating": 4.5, // تقييم افتراضي شيك
            "category": "Places",
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}