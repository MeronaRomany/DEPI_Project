import 'package:depi_project/core/routing/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routing/routes.dart';
import '../features/notification/data/service/notifcation_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      initialRoute: Firebase.apps.isNotEmpty &&
              FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? Routes.homePage
          : Routes.signIn,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
