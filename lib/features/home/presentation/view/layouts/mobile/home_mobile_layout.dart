import 'package:depi_project/features/home/presentation/view/layouts/mobile/widgets/grid_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import 'package:depi_project/features/Auth/presentation/cubit/auth_cubit.dart';

import '../../../../../my_visit_places/data/model.dart';
import '../../../../../my_visit_places/data/states_city_repo.dart';
import '../../../../../my_visit_places/data/tripadvisor_service.dart';
import '../../../../../my_visit_places/presentation/cubit/saved_places_cubit.dart';
import '../../../../../my_visit_places/presentation/view/saved_screen.dart';
import '../../../../../notification/presentation/view/notification_screen.dart';
import 'app_colors.dart';
import '../../../../../profile/view/profile.dart';

class HomeMobileLayout extends StatefulWidget {
  const HomeMobileLayout({super.key});

  @override
  State<HomeMobileLayout> createState() => _HomeMobileLayoutState();
}

class _HomeMobileLayoutState extends State<HomeMobileLayout> {
  String selectedCategory = "All";
  int selectedNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<String> categories = [
    "All",
    "Places",
    "Restaurants",
    "Cafes",
    "Museums",
  ];
  List<Map<String, dynamic>> apiSearchResults = [];
  bool isLoading = false;
  static const String cairoLocationId = "294019";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredLocalItems() {
    List<Map<String, dynamic>> allItems = [];
    final states = StateCityRepo.data['states'] as List? ?? [];
    final cities = StateCityRepo.data['cities'] as List? ?? [];

    if (selectedCategory == "All" || selectedCategory == "Places") {
      for (var s in states) {
        String stateName = s['name'] ?? 'Egypt';
        allItems.add({
          "id": s['id']?.toString() ?? stateName,
          "name": stateName,
          "image": s['image'],
          "location": s['details']?['location'] ?? stateName,
          "rating": s['details']?['reviews']?[0]?['rating'] ?? 4.5,
          "description": "Discover the wonders of $stateName.",
          "category": "state",
        });
      }
      for (var c in cities) {
        String cityName = c['name'] ?? 'City';
        allItems.add({
          "id": c['id']?.toString() ?? cityName,
          "name": cityName,
          "image": c['image'],
          "location": c['details']?['location'] ?? c['stateId'] ?? "Egypt",
          "rating": 4.7,
          "category": "city",
        });
      }
    }

    if (selectedCategory == "All" || selectedCategory == "Restaurants") {
      allItems.add({
        "id": "rest_1",
        "name": "Local Egyptian Food",
        "image": "https://images.unsplash.com/photo-1544025162-d76694265947",
        "location": "Cairo, Egypt",
        "rating": 4.8,
        "category": "restaurant",
      });
    }
    if (selectedCategory == "All" || selectedCategory == "Cafes") {
      allItems.add({
        "id": "cafe_1",
        "name": "Grand Cafe",
        "image": "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb",
        "location": "Alexandria, Egypt",
        "rating": 4.6,
        "category": "cafe",
      });
    }
    if (selectedCategory == "All" || selectedCategory == "Museums") {
      allItems.add({
        "id": "mus_1",
        "name": "The Egyptian Museum",
        "image": "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8",
        "location": "Tahrir Square, Cairo",
        "rating": 4.9,
        "category": "museum",
      });
    }

    if (searchQuery.isNotEmpty) {
      allItems = allItems
          .where(
            (item) => item['name'].toString().toLowerCase().contains(
              searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    return allItems;
  }

  Future<void> _loadCategoryData(String category) async {
    if (category == "All") {
      setState(() {
        apiSearchResults = [];
      });
      return;
    }
    setState(() {
      isLoading = true;
      apiSearchResults = [];
    });
    try {
      List<Map<String, dynamic>> results = [];
      if (category == "Restaurants") {
        results = await TripAdvisorService.fetchRestaurants(cairoLocationId);
      } else if (category == "Cafes") {
        results = (await TripAdvisorService.fetchRestaurants(cairoLocationId))
            .where(
              (item) => item['name'].toString().toLowerCase().contains('cafe'),
            )
            .toList();
      } else if (category == "Places" || category == "Museums") {
        results = await TripAdvisorService.fetchAttractions(cairoLocationId);
        if (category == "Museums") {
          results = results
              .where(
                (item) =>
                    item['name'].toString().toLowerCase().contains('museum'),
              )
              .toList();
        }
      }
      if (mounted)
        setState(() {
          apiSearchResults = results;
          isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _executeSearch(String value) async {
    final cleanValue = value.trim();
    if (cleanValue.isEmpty) {
      setState(() {
        searchQuery = '';
        apiSearchResults = [];
      });
      return;
    }
    setState(() {
      isLoading = true;
      searchQuery = cleanValue;
      selectedCategory = "All";
      apiSearchResults = [];
    });
    try {
      final results = await TripAdvisorService.searchPlaces(cleanValue);
      if (mounted)
        setState(() {
          apiSearchResults = results;
          isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
      builder: (context, savedState) {
        final savedList = (savedState is SavedPlacesLoaded)
            ? savedState.savedPlaces
            : <Map<String, dynamic>>[];

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          bottomNavigationBar: _buildBottomNav(),
          body: SafeArea(
            child: IndexedStack(
              index: selectedNavIndex,
              children: [
                _buildHomeExploreContent(savedList),
                SavedScreen(
                  savedPlaces: savedList,
                  onToggleFavorite: (place) =>
                      context.read<SavedPlacesCubit>().toggleFavorite(place),
                ),
                const Profile(),
                NotificationScreen(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeExploreContent(List<Map<String, dynamic>> savedList) {
    final itemsToDisplay =
        (searchQuery.isNotEmpty && apiSearchResults.isNotEmpty)
        ? apiSearchResults
        : (apiSearchResults.isNotEmpty
              ? apiSearchResults
              : _getFilteredLocalItems());

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildCategories()),
        SliverToBoxAdapter(child: _buildSectionTitle(itemsToDisplay.length)),
        _buildGrid(itemsToDisplay, savedList),
        const SliverToBoxAdapter(child: SizedBox(height: 25)),
      ],
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = "Traveler";
        if (state is AuthAuthenticated)
          name = state.user.displayName ?? "Traveler";
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/top-view-travel-kit-wooden-table.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, $name 👋",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Explore the world with us!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: LocalAppColor.kred,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) {
                  if (v.isEmpty)
                    setState(() {
                      searchQuery = '';
                      apiSearchResults = [];
                    });
                },
                onSubmitted: _executeSearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: LocalAppColor.kgrey,
                  ),
                  hintText: "Search destinations...",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _executeSearch(_searchController.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LocalAppColor.kred,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = cat);
              _loadCategoryData(cat);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: isSelected ? LocalAppColor.kred : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : LocalAppColor.kblack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(int count) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            selectedCategory == "All"
                ? "Popular Discovery"
                : "Popular $selectedCategory",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            "($count)",
            style: const TextStyle(fontSize: 16, color: LocalAppColor.kgrey),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
    List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> savedList,
  ) {
    if (isLoading)
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(60),
            child: CircularProgressIndicator(color: LocalAppColor.kred),
          ),
        ),
      );
    if (items.isEmpty)
      return const SliverToBoxAdapter(
        child: Center(child: Text("No results found")),
      );

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          final isSaved = savedList.any(
            (s) => s['id'].toString() == item['id'].toString(),
          );
          return GridCardItem(
            item: item,
            isSaved: isSaved,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(
                  place: PlaceModel.fromJson(
                    item,
                    item['category'] ?? 'general',
                  ),
                ),
              ),
            ),
            onFavoriteTap: () =>
                context.read<SavedPlacesCubit>().toggleFavorite(item),
          );
        }, childCount: items.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedNavIndex,
      onTap: (index) => setState(() => selectedNavIndex = index),
      selectedItemColor: LocalAppColor.kred,
      unselectedItemColor: LocalAppColor.kgrey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notification",
        ),
      ],
    );
  }
}
