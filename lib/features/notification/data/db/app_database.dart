import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


import '../../../my_visit_places/data/saved_place_dao.dart';
import '../../../my_visit_places/data/saved_place_entity.dart';
import '../../../my_visit_places/data/trip_dao.dart';
import '../../../my_visit_places/data/trip_entity.dart';
import 'place_entity.dart';
import 'place_dao.dart';

part 'app_database.g.dart';

@Database(version: 3, entities: [PlaceEntity, TripEntity, SavedPlaceEntity])
abstract class AppDatabase extends FloorDatabase {
  PlaceDao get placeDao;
  TripDao get tripDao;
  SavedPlaceDao get savedPlaceDao;
}
