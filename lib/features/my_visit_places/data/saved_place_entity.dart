import 'package:floor/floor.dart';

@Entity(tableName: 'saved_places')
class SavedPlaceEntity {
  @PrimaryKey()
  final String id;
  final String name;
  final String image;
  final String location;
  final double rating;
  final String description;
  final String category;
  final double? latitude;
  final double? longitude;

  SavedPlaceEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.rating,
    required this.description,
    required this.category,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'location': location,
      'rating': rating,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SavedPlaceEntity.fromMap(Map<String, dynamic> map) {
    return SavedPlaceEntity(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      location: map['location'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }
}
