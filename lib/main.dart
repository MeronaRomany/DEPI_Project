import 'package:depi_project/core/networking/dio_helper.dart';
import 'package:depi_project/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:depi_project/features/travel/data/db/travel_dao.dart';
import 'package:depi_project/features/travel/data/db/travel_database.dart';
import 'package:depi_project/features/travel/data/models/travel_item_entity.dart';
import 'package:depi_project/features/travel/data/remote/travel_api_service.dart';
import 'package:depi_project/features/travel/data/repo/travel_repository.dart';
import 'package:depi_project/features/travel/presentation/controller/travel_controller.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

import 'features/my_visit_places/data/saved_place_dao.dart';
import 'features/my_visit_places/presentation/cubit/saved_places_cubit.dart';
import 'features/my_visit_places/presentation/cubit/trip_cubit.dart';

import 'features/notification/data/api/overpass_api.dart';
import 'features/notification/data/controller/location_controller.dart';
import 'features/notification/data/controller/LocationTracker.dart';
import 'features/notification/data/db/app_database.dart';
import 'features/notification/data/repo/place_repository.dart';
import 'features/notification/data/service/geofence_service.dart';
import 'features/notification/data/service/location_service.dart';
import 'features/notification/data/service/notifcation_service.dart';
import 'features/notification/presentation/cubit/get_it.dart';
import 'features/notification/presentation/cubit/notification_cubit.dart';

import 'features/splash/splash_screen.dart';

import 'core/routing/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("dotenv error: $e");
  }

  await _initTravelController();

  AppDatabase? db;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidDebugProvider(),
    );

    db = await $FloorAppDatabase.databaseBuilder('app.db').build();

    await NotificationService.initNotifications();

    final geofenceService = GeofenceService();

    final granted = await geofenceService.requestPermission();

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

      final controller = LocationController(
        locationService,
        repository.updateNearbyPlaces,
      );

      controller.start();
    }
  } catch (e) {
    debugPrint("Initialization Error: $e");
  }

  if (db != null) {
    setup(db);
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<TripCubit>()..loadTrips(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) =>
          SavedPlacesCubit(getIt<SavedPlaceDao>())
            ..loadSavedPlaces(),
        ),
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'),
          navigatorKey: NotificationService.navigatorKey,
          home: const SplashScreen(),
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    ),
  );
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
    TravelController(
      TravelRepository(
        dao,
        TravelApiService(),
      ),
    ),
    permanent: true,
  );
}

class _InMemoryTravelDao implements TravelDao {
  @override
  Future<List<TravelItemEntity>> getByCategory(
      String category,
      String locationId,
      ) async {
    return [];
  }

  @override
  Future<void> insertItems(List<TravelItemEntity> items) async {}

  @override
  Future<void> deleteByCategory(
      String category,
      String locationId,
      ) async {}

  @override
  Future<void> clearAll() async {}
}