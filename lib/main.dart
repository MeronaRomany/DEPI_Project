import 'package:depi_project/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';
import 'features/my_visit_places/data/saved_place_dao.dart';
import 'features/my_visit_places/presentation/cubit/saved_places_cubit.dart';
import 'features/my_visit_places/presentation/cubit/trip_cubit.dart';
import 'features/notification/data/db/app_database.dart';
import 'features/notification/data/repo/place_repository.dart';

import 'core/routing/app_routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/notification/data/controller/LocationTracker.dart';
import 'features/notification/data/api/overpass_api.dart';
import 'features/notification/data/controller/location_controller.dart';
import 'features/notification/data/service/geofence_service.dart';
import 'features/notification/data/service/location_service.dart';
import 'features/notification/data/service/notifcation_service.dart';
import 'features/notification/presentation/cubit/get_it.dart';
import 'features/notification/presentation/cubit/notification_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase? db;
  try {
    await Future.wait([
      dotenv.load(fileName: ".env"),
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    ]);

    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidDebugProvider(),
    );

    db = await $FloorAppDatabase.databaseBuilder('app.db')
        .build();

    await NotificationService.initNotifications();

    final geofenceService = GeofenceService();

    bool granted = await geofenceService.requestPermission();

    if (granted && db != null) {
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
    debugPrint("Error during initialization: $e");
  }

  if (db != null) {
    setup(db);
  }
  debugPrint("GetIt setup completed");
  debugPrint(getIt.isRegistered<SavedPlacesCubit>().toString());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<NotificationCubit>()),
        BlocProvider(create: (_) => getIt<TripCubit>()..loadTrips()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(
          create: (_) => SavedPlacesCubit(getIt<SavedPlaceDao>())
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
