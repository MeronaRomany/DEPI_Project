import 'package:floor/floor.dart';

@Entity(tableName: 'trips')
class TripEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;
  final String destination;
  final String destinationImage;
  final String startDate;
  final String endDate;
  final String places; // Comma-separated or JSON
  final int placesCount;
  final String schedule; // JSON string
  final String image;

  TripEntity({
    this.id,
    required this.title,
    required this.destination,
    required this.destinationImage,
    required this.startDate,
    required this.endDate,
    required this.places,
    required this.placesCount,
    required this.schedule,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'destinationImage': destinationImage,
      'startDate': startDate,
      'endDate': endDate,
      'places': places,
      'placesCount': placesCount,
      'schedule': schedule,
      'image': image,
    };
  }
}
