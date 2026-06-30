import 'package:depi_project/features/home_view/presentation/widgets/categories_list.dart';
import 'package:depi_project/features/home_view/presentation/widgets/search_bar_widget.dart';
import 'package:depi_project/features/home_view/presentation/widgets/section_list_widget.dart';
import 'package:depi_project/features/travel/presentation/controller/travel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_color.dart';
import '../widgets/home_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TravelController controller = Get.find<TravelController>();

    return Scaffold(
      backgroundColor: Appcolor.kWhite,
      body: SafeArea(
        child: RefreshIndicator(
          color: Appcolor.kPrimary,
          onRefresh: controller.forceRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SearchBarWidget(),
                const CategoriesList(),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Appcolor.kPrimary,
                        ),
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 48,
                            color: Appcolor.kgrey.withAlpha(120),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load places',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Appcolor.kblack,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pull down to retry',
                            style: TextStyle(
                              fontSize: 13,
                              color: Appcolor.kgrey.withAlpha(160),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (controller.attractions.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Attractions',
                          items: controller.attractions,
                        ),
                      if (controller.hotels.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Hotels',
                          items: controller.hotels,
                        ),
                      if (controller.restaurants.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Restaurants',
                          items: controller.restaurants,
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Appcolor.kWhite,
        selectedItemColor: Appcolor.kPrimary,
        unselectedItemColor: Appcolor.kgrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
