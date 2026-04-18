import 'package:depi_project/core/routing/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/routing/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

     initialRoute:FirebaseAuth.instance.currentUser != null &&
         FirebaseAuth.instance.currentUser!.emailVerified
        ? Routes.homePage
         : Routes.signIn,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
