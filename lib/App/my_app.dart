import 'package:depi_project/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

import '../core/routing/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

     initialRoute: Routes.signIn,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
