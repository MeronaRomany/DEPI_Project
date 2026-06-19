class PlaceModel {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final String description;
  final String category;
  final List<String>? howToReach;
  final List<Map<String, dynamic>>? subCategories;

  final double? latitude;
  final double? longitude;
  final String? webUrl;

  PlaceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.description,
    required this.category,
    this.howToReach,
    this.subCategories,
    this.latitude,
    this.longitude,
    this.webUrl,
  });

  // تحويل من JSON (اللي جاي من السيرفيس) لـ Model
  factory PlaceModel.fromJson(Map<String, dynamic> json, String cat) {
    // منطق ذكي لاستخراج الصورة (يدعم هيكل API المحتوي على images/medium/url)
    String extractedImage = json['image'] ?? '';
    if (extractedImage.isEmpty && json['photo'] != null && json['photo']['images'] != null) {
      extractedImage = json['photo']['images']['medium']?['url'] ?? extractedImage;
    } else if (json['photo'] != null && json['photo']['images'] != null) {
      extractedImage = json['photo']['images']['original']?['url'] ?? extractedImage;
    }

    // منطق ذكي لاستخراج العنوان (يدعم address_obj)
    String extractedLocation = json['location'] ?? '';
    if (extractedLocation.isEmpty && json['address_obj'] != null) {
      extractedLocation = json['address_obj']['address_string'] ?? '';
    }

    // استخراج التقييم
    double extractedRating = 4.5;
    if (json['rating'] is num) {
      extractedRating = (json['rating'] as num).toDouble();
    } else if (json['rating'] is String) {
      extractedRating = double.tryParse(json['rating']) ?? 4.5;
    }

    return PlaceModel(
      id: json['id']?.toString() ?? json['name']?.toString() ?? DateTime.now().toString(),
      name: json['name'] ?? '',
      location: extractedLocation,
      image: extractedImage,
      rating: extractedRating,
      description: json['description'] ?? '',
      category: cat,
      howToReach: json['howToReach'] != null ? List<String>.from(json['howToReach']) : null,
      subCategories: json['subCategories'] != null ? List<Map<String, dynamic>>.from(json['subCategories']) : null,

      // تعبئة البيانات الجديدة
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      webUrl: json['web_url'] ?? json['website'],
    );
  }

  // دالة تحويل الموديل إلى Map (مفيدة في حال أردت إرساله كأرجيمنتز للشاشات)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image': image,
      'rating': rating,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'webUrl': webUrl,
      'howToReach': howToReach,
      'subCategories': subCategories,
    };
  }
}