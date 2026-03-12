import 'package:depi_project/core/response_layout.dart';
import 'package:depi_project/features/Auth/presentation/view/layouts/sign_up_mobile_layout.dart';
import 'package:depi_project/features/Auth/presentation/view/layouts/sign_up_tablet_layout.dart';
import 'package:flutter/material.dart';

import 'layouts/sign_up_web_layout.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileWidget: SignUpMobileLayout(),
        tabletWidget: SignUpTabletLayout(),
        websiteWidget: SignUpWebLayout());
  }
}
