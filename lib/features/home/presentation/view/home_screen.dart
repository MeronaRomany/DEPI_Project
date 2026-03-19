import 'package:depi_project/core/response_layout.dart';
import 'package:depi_project/features/home/presentation/view/layouts/home_mobile_layout.dart';
import 'package:depi_project/features/home/presentation/view/layouts/home_tablet_layout.dart';
import 'package:depi_project/features/home/presentation/view/layouts/home_web_layout.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileWidget: HomeMobileLayout(),
      tabletWidget: HomeTabletLayout(),
      websiteWidget: HomeWebLayout(),
    );
  }
}
