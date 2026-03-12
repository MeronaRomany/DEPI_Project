import 'package:depi_project/core/routing/routes.dart';
import 'package:flutter/material.dart';

import '../../features/Auth/presentation/view/forget_password.dart';
import '../../features/Auth/presentation/view/sign_in.dart';
import '../../features/Auth/presentation/view/sign_up.dart';
import '../../features/home/presentation/view/home_screen.dart';

class AppRouter{

  static Route? generateRoute(RouteSettings setting){
    switch(setting.name){
      case Routes.signIn:
        return MaterialPageRoute(builder: (_)=>SignIn());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_)=>SignUp());
      case Routes.forgetPass:
        return MaterialPageRoute(builder: (_)=>ForgetPassword());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_)=>HomeScreen());
    }
    return MaterialPageRoute(builder: (_)=>Center(child: Text("Not found page")));
  }
}
