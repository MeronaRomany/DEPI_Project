import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/travel_item_entity.dart';
import 'travel_dao.dart';

part 'travel_database.g.dart';

@Database(version: 1, entities: [TravelItemEntity])
abstract class TravelDatabase extends FloorDatabase {
  TravelDao get travelDao;
}
