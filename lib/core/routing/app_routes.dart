import 'package:depi_project/core/routing/routes.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import 'package:depi_project/features/home/data/model.dart'; // استيراد الموديل
import 'package:flutter/material.dart';

import '../../features/Auth/presentation/view/forget password/forget_password.dart';
import '../../features/Auth/presentation/view/email verifiy/VerifyEmailPage_mobile_layout.dart';
import '../../features/Auth/presentation/view/Sign in/sign_in.dart';
import '../../features/Auth/presentation/view/sign up/sign_up.dart';
import '../../features/home/presentation/view/home_screen.dart';
import '../../features/home/presentation/view/layouts/mobile/profile.dart';
import '../../features/notification/presentation/view/notification_screen.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => const SignIn());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case Routes.forgetPass:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case "verfiy email":

        return MaterialPageRoute(builder: (_)=>VerifyEmailPage());
      case Routes.notif:
        return MaterialPageRoute(builder: (_)=>NotificationScreen());

      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const Profile());
      case Routes.details:
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(
            // بناء الـ Object مانيوال هنا مباشرة للهروب من مشكلة الـ fromJson تماماً وضمان عمل الكود
            place: PlaceModel(
              id: args['id']?.toString() ?? '',
              name: args['name'] ?? '',
              image: args['image'] ?? '',
              location: args['location'] ?? 'Egypt',
              rating: (args['rating'] ?? 4.5).toDouble(),
              category: args['category'] ?? 'state',
              description: args['description'] ?? '',
            ),
          ),
        );
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Not found page", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}