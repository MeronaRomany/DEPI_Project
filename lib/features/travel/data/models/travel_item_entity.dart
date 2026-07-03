import 'package:floor/floor.dart';

@Entity(tableName: 'travel_items')
class TravelItemEntity {
  @PrimaryKey()
  final String id;

  final String name;
  final String imageUrl;
  final String rating;
  final String numReviews;

  final String category;

  final String locationId;

  TravelItemEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.numReviews,
    required this.category,
    required this.locationId,
  });
}
