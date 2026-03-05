import 'package:flutter/material.dart';

import '../../../../core/response_layout.dart';
import 'layouts/sign_in_mobile_layout.dart';
import 'layouts/sign_in_tablet_layout.dart';
import 'layouts/sign_in_web_layout.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileWidget:SignInMobileLayout(),
        tabletWidget:SignInTabletLayout(),
        websiteWidget: SignInWebLayout()
    );
  }
}
