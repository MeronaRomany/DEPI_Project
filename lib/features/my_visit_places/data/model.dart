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
  final String? address;
  final String? city;
  final String? country;
  final String? ranking;
  final String? priceLevel;
  final String? phone;
  final String? website;
  final String? email;
  final String? openingHours;
  final String? attractionType;
  final String? cuisine;
  final String? hotelFacilities;
  final List<String>? amenities;
  final List<Map<String, dynamic>>? travelerReviews;

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
    this.address,
    this.city,
    this.country,
    this.ranking,
    this.priceLevel,
    this.phone,
    this.website,
    this.email,
    this.openingHours,
    this.attractionType,
    this.cuisine,
    this.hotelFacilities,
    this.amenities,
    this.travelerReviews,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json, String cat) {
    String extractedImage = (json['image'] ?? '').toString();
    if (extractedImage.isEmpty && json['photo'] is Map) {
      final photo = Map<String, dynamic>.from(json['photo'] as Map);
      if (photo['images'] is Map) {
        final images = Map<String, dynamic>.from(photo['images'] as Map);
        extractedImage = images['medium']?['url'] ?? extractedImage;
        if (extractedImage.isEmpty) {
          extractedImage = images['original']?['url'] ?? extractedImage;
        }
      }
    }

    String extractedLocation = (json['location'] ?? '').toString();
    if (extractedLocation.isEmpty && json['address_obj'] is Map) {
      final addressObj = Map<String, dynamic>.from(json['address_obj'] as Map);
      extractedLocation = addressObj['address_string']?.toString() ?? '';
    }

    final addressObj = json['address_obj'] is Map
        ? Map<String, dynamic>.from(json['address_obj'] as Map)
        : <String, dynamic>{};

    double extractedRating = 4.5;
    if (json['rating'] is num) {
      extractedRating = (json['rating'] as num).toDouble();
    } else if (json['rating'] is String) {
      extractedRating = double.tryParse(json['rating']) ?? 4.5;
    }

    final amenities = json['amenities'] is List
        ? (json['amenities'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final reviews = json['reviews'] is List
        ? (json['reviews'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <Map<String, dynamic>>[];

    return PlaceModel(
      id: json['id']?.toString() ?? json['name']?.toString() ?? DateTime.now().toString(),
      name: json['name'] ?? '',
      location: extractedLocation,
      image: extractedImage,
      rating: extractedRating,
      description: json['description']?.toString() ?? '',
      category: cat,
      howToReach: json['howToReach'] != null ? List<String>.from(json['howToReach']) : null,
      subCategories: json['subCategories'] != null ? List<Map<String, dynamic>>.from(json['subCategories']) : null,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      webUrl: json['web_url']?.toString() ?? json['website']?.toString(),
      address: (json['address'] ?? addressObj['address_string'] ?? '').toString(),
      city: (json['city'] ?? addressObj['city'] ?? '').toString(),
      country: (json['country'] ?? addressObj['country'] ?? '').toString(),
      ranking: json['ranking']?.toString(),
      priceLevel: json['price_level']?.toString(),
      phone: json['phone']?.toString(),
      website: json['website']?.toString(),
      email: json['email']?.toString(),
      openingHours: json['opening_hours']?.toString() ?? json['hours']?.toString(),
      attractionType: json['attraction_type']?.toString() ?? json['subtype']?.toString(),
      cuisine: json['cuisine']?.toString(),
      hotelFacilities: json['hotel_facilities']?.toString(),
      amenities: amenities.isEmpty ? null : amenities,
      travelerReviews: reviews.isEmpty ? null : reviews,
    );
  }

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
      'address': address,
      'city': city,
      'country': country,
      'ranking': ranking,
      'priceLevel': priceLevel,
      'phone': phone,
      'website': website,
      'email': email,
      'openingHours': openingHours,
      'attractionType': attractionType,
      'cuisine': cuisine,
      'hotelFacilities': hotelFacilities,
      'amenities': amenities,
      'travelerReviews': travelerReviews,
      'howToReach': howToReach,
      'subCategories': subCategories,
    };
  }
}