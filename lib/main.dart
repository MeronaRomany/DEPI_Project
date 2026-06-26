import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';
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
import 'features/notification/presentation/cubit/notification_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
void main()async {
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

    final token = await FirebaseAppCheck.instance.getToken(true);


    final db = await $FloorAppDatabase
        .databaseBuilder('app.db')
        .build();

    //Notification
    await NotificationService.initNotifications();


    /// 📍 geofence
    final geofenceService = GeofenceService();

    /// permissions
    bool granted =
    await geofenceService.requestPermission();

    if (granted) {
      geofenceService.setup();

      /// services
      final locationService = LocationService();

      /// repository
      final repository = PlaceRepository(
        OverpassApi(),
        db,
        locationService,
        LocationTracker(),
        geofenceService,
      );

      /// controller
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
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<NotificationCubit>(),
        ),
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}



