import 'package:depi_project/core/networking/dio_helper.dart';
import 'package:depi_project/features/travel/data/db/travel_dao.dart';
import 'package:depi_project/features/travel/data/db/travel_database.dart';
import 'package:depi_project/features/travel/data/models/travel_item_entity.dart';
import 'package:depi_project/features/travel/data/remote/travel_api_service.dart';
import 'package:depi_project/features/travel/data/repo/travel_repository.dart';
import 'package:depi_project/features/travel/presentation/controller/travel_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'App/my_app.dart';
import 'features/notification/data/controller/LocationTracker.dart';
import 'features/notification/data/api/overpass_api.dart';
import 'features/notification/data/controller/location_controller.dart';
import 'features/notification/data/db/app_database.dart';
import 'features/notification/data/service/geofence_service.dart';
import 'features/notification/data/service/location_service.dart';
import 'features/notification/data/repo/place_repository.dart';
import 'features/notification/data/service/notifcation_service.dart';
import 'features/notification/presentation/cubit/get_it.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  try {
    await dotenv.load(fileName: "env");
  } catch (e) {
    debugPrint("dotenv load error: $e");
  }

  DioHelper.init();

  
  await _initTravelController();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidDebugProvider(),
    );
    await FirebaseAppCheck.instance.getToken(true);

    final db = await $FloorAppDatabase.databaseBuilder('app.db').build();

    await NotificationService.initNotifications();

    final geofenceService = GeofenceService();
    final bool granted = await geofenceService.requestPermission();

    if (granted) {
      geofenceService.setup();
      final locationService = LocationService();
      final repository = PlaceRepository(
        OverpassApi(),
        db,
        locationService,
        LocationTracker(),
        geofenceService,
      );
      final locationController = LocationController(
        locationService,
        repository.updateNearbyPlaces,
      );
      locationController.start();
    }
  } catch (e) {
    debugPrint("Firebase/Notification init error: $e");
  }

  setup();
  runApp(const MyApp());
}


Future<void> _initTravelController() async {
  TravelDao dao;

  try {
    final db =
        await $FloorTravelDatabase.databaseBuilder('travel.db').build();
    dao = db.travelDao;
    debugPrint("TravelDatabase opened successfully.");
  } catch (e) {
    debugPrint("TravelDatabase failed, using in-memory fallback: $e");
    dao = _InMemoryTravelDao();
  }

  Get.put(
    TravelController(TravelRepository(dao, TravelApiService())),
    permanent: true,
  );
}

class _InMemoryTravelDao implements TravelDao {
  @override
  Future<List<TravelItemEntity>> getByCategory(
          String category, String locationId) async =>
      [];

  @override
  Future<void> insertItems(List<TravelItemEntity> items) async {}

  @override
  Future<void> deleteByCategory(String category, String locationId) async {}

  @override
  Future<void> clearAll() async {}
}
