import 'package:floor/floor.dart';

@Entity(tableName: 'places')
class PlaceEntity {
  @primaryKey
  final int id;

  final String name;
  final double lat;
  final double lon;
  final String type;

  PlaceEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.type,
  });
}