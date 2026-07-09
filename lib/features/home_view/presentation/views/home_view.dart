import 'package:depi_project/features/display_map/view/page_map.dart';
import 'package:depi_project/features/home_view/presentation/widgets/categories_list.dart';
import 'package:depi_project/features/home_view/presentation/widgets/search_bar_widget.dart';
import 'package:depi_project/features/home_view/presentation/widgets/section_list_widget.dart';
import 'package:depi_project/features/my_visit_places/presentation/view/saved_screen.dart';
import 'package:depi_project/features/notification/presentation/view/notification_screen.dart';
import 'package:depi_project/features/profile/view/profile.dart';
import 'package:depi_project/features/travel/presentation/cubit/travel_cubit.dart';
import 'package:depi_project/features/travel/presentation/cubit/travel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/app_color.dart';
import '../widgets/home_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.kWhite,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeContent(),
          SizedBox(),
          SavedScreen(),
          NotificationScreen(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Appcolor.kWhite,
        selectedItemColor: Appcolor.kPrimary,
        unselectedItemColor: Appcolor.kgrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
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

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: Appcolor.kPrimary,
        onRefresh: () => context.read<TravelCubit>().forceRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SearchBarWidget(),
              const CategoriesList(),
              BlocBuilder<TravelCubit, TravelState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1E824C),
                        ),
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
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
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Appcolor.kgrey.withAlpha(160),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.read<TravelCubit>().fetchAll(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final showAll = state.selectedCategory == TravelCategory.all;

                  return Column(
                    children: [
                      if ((showAll || state.selectedCategory == TravelCategory.attractions) &&
                          state.attractions.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Attractions',
                          items: state.attractions,
                        ),
                      if ((showAll || state.selectedCategory == TravelCategory.hotels) &&
                          state.hotels.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Hotels',
                          items: state.hotels,
                        ),
                      if ((showAll || state.selectedCategory == TravelCategory.restaurants) &&
                          state.restaurants.isNotEmpty)
                        SectionListWidget(
                          title: 'Popular Restaurants',
                          items: state.restaurants,
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
