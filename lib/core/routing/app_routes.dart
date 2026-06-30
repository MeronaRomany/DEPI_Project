import 'package:depi_project/core/routing/routes.dart';
import 'package:depi_project/features/home_view/presentation/views/home_view.dart';
import 'package:flutter/material.dart';

import '../../features/Auth/presentation/view/forget password/forget_password.dart';
import '../../features/Auth/presentation/view/email verifiy/VerifyEmailPage_mobile_layout.dart';
import '../../features/Auth/presentation/view/Sign in/sign_in.dart';
import '../../features/Auth/presentation/view/sign up/sign_up.dart';
import '../../features/notification/presentation/view/notification_screen.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => SignIn());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUp());
      case Routes.forgetPass:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case "verfiy email":
        return MaterialPageRoute(builder: (_) => VerifyEmailPage());
      case Routes.notif:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
    }
    return MaterialPageRoute(
      builder: (_) => Center(
        child: Text("Not found page", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
