import 'package:depi_project/core/response_layout.dart';
import 'package:depi_project/features/Auth/presentation/view/layouts/forgetPassword_tablet_layout.dart';
import 'package:depi_project/features/Auth/presentation/view/layouts/forgetPassword_web_layout.dart';
import 'package:flutter/material.dart';

import 'layouts/forgetPassword_mobile_layout.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileWidget: ForgetPasswordMobileLayout(),
      tabletWidget: ForgetpasswordTabletLayout(),
      websiteWidget: ForgetpasswordWebLayout(),
    );
  }
}
