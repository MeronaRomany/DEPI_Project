class PlaceModel {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final String description;
  final String category; // 'state', 'city', 'food', 'cafe', 'hotel'
  final List<String>? howToReach; // [Flights, Railways, Roads]
  final List<Map<String, dynamic>>? subCategories; // الأزرار الأربعة اللي جوه الشاشة

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
  });

  // تحويل من JSON (اللي جاي من السيرفيس) لـ Model
  factory PlaceModel.fromJson(Map<String, dynamic> json, String cat) {
    return PlaceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      description: json['description'] ?? '',
      category: cat,
      howToReach: json['howToReach'] != null ? List<String>.from(json['howToReach']) : null,
      subCategories: json['subCategories'] != null ? List<Map<String, dynamic>>.from(json['subCategories']) : null,
    );
  }
}