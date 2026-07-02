import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';


import 'core/routing/app_routes.dart';
import 'features/Auth/presentation/view/sign up/layouts/sign_up_mobile_layout.dart';
import 'features/home/presentation/view/layouts/mobile/splash_screen.dart';
import 'features/Auth/presentation/view/Sign in/layouts/sign_in_mobile_layout.dart';
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
    await Future.wait([
      dotenv.load(fileName: ".env"),
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ]);

    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidDebugProvider(),
    );

    final db = await $FloorAppDatabase.databaseBuilder('app.db').build();

    await NotificationService.initNotifications();

    final geofenceService = GeofenceService();

    bool granted = await geofenceService.requestPermission();

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
    debugPrint("Error during initialization: $e");
  }

  setup();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('en', 'US'),

        home: const SplashScreen(),

        // ✅ أهم سطر
        onGenerateRoute: AppRouter.generateRoute,

        routes: {
          '/signIn': (context) => const SignInMobileLayout(),
          '/signUp': (context) => const SignUpMobileLayout(),
        },
      ),
    ),
  );
}