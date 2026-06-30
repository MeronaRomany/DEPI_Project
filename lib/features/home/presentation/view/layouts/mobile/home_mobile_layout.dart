import 'package:depi_project/features/home/presentation/view/layouts/mobile/widgets/grid_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:depi_project/features/home/data/states_city_repo.dart';
import 'package:depi_project/features/home/data/tripadvisor_service.dart';
import 'package:depi_project/features/home/data/model.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';

import '../../../../../notification/presentation/view/notification_screen.dart';
import 'app_colors.dart';
import 'widgets/grid_card_item.dart';
import 'profile.dart';
import 'saved_screen.dart'; // استيراد صفحة المفضلة الجديدة هنا

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

  String _userName = 'Traveler';

  final List<Map<String, dynamic>> savedPlaces = [];
  final List<String> categories = ["All", "Places", "Restaurants", "Cafes", "Museums"];

  List<Map<String, dynamic>> apiSearchResults = [];
  bool isLoading = false;

  bool _isLoadingMore = false;
  int _currentOffset = 0;
  static const String cairoLocationId = "294019";

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void _getUserName() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        _userName = user.displayName!;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredLocalItems() {
    List<Map<String, dynamic>> allItems = [];
    final states = StateCityRepo.data['states'] as List? ?? [];
    final cities = StateCityRepo.data['cities'] as List? ?? [];

    if (selectedCategory == "All" || selectedCategory == "Places") {
      for (var s in states) {
        String stateName = s['name'] ?? 'Egypt';
        allItems.add({
          "id": s['id'],
          "name": stateName,
          "image": s['image'],
          "location": s['details']?['location'] ?? stateName,
          "rating": s['details']?['reviews']?[0]?['rating'] ?? 4.5,
          "description": "Discover the wonders of $stateName. A captivating destination offering rich history, unique culture, and unforgettable experiences for every traveler.",
          "latitude": 26.8206,
          "longitude": 30.8025,
          "webUrl": "https://en.wikipedia.org/wiki/${stateName.replaceAll(' ', '_')}",
          "category": "state",
        });
      }
      for (var c in cities) {
        String cityName = c['name'] ?? 'City';
        allItems.add({
          "id": c['id'],
          "name": cityName,
          "image": c['image'],
          "location": c['details']?['location'] ?? c['stateId'] ?? "Egypt",
          "rating": 4.7,
          "description": "$cityName is a vibrant city in ${c['stateId']}. Experience the local culture, delicious cuisine, and historical landmarks.",
          "latitude": 30.0444,
          "longitude": 31.2357,
          "webUrl": "https://en.wikipedia.org/wiki/${cityName.replaceAll(' ', '_')}",
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
        "description": "Delicious authentic Egyptian food and Koshary. Enjoy traditional flavors.",
        "latitude": 30.0450,
        "longitude": 31.2360,
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
        "description": "Relax in a cozy atmosphere with a cup of premium coffee and snacks.",
        "latitude": 31.2001,
        "longitude": 29.9187,
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
        "description": "Home to an extensive collection of ancient Egyptian antiquities and treasures.",
        "latitude": 30.0478,
        "longitude": 31.2336,
        "category": "museum",
      });
    }

    if (searchQuery.isNotEmpty) {
      allItems = allItems
          .where((item) => item['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return allItems;
  }

  Future<void> _loadCategoryData(String category) async {
    if (category == "All") {
      setState(() {
        apiSearchResults = [];
        _currentOffset = 0;
      });
      return;
    }

    setState(() {
      isLoading = true;
      apiSearchResults = [];
      _currentOffset = 0;
    });

    List<Map<String, dynamic>> results = [];
    try {
      if (category == "Restaurants") {
        results = await TripAdvisorService.fetchRestaurants(cairoLocationId, offset: 0);
      } else if (category == "Cafes") {
        final allRestaurants = await TripAdvisorService.fetchRestaurants(cairoLocationId, offset: 0);
        results = allRestaurants.where((item) => item['name'].toString().toLowerCase().contains('cafe')).toList();
        if (results.isEmpty) results = allRestaurants;
      } else if (category == "Places" || category == "Museums") {
        results = await TripAdvisorService.fetchAttractions(cairoLocationId, offset: 0);
        if (category == "Museums") {
          results = results.where((item) => item['name'].toString().toLowerCase().contains('museum')).toList();
        }
      }

      setState(() {
        apiSearchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading category: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;
    if (selectedCategory == "All") return;

    setState(() {
      _isLoadingMore = true;
      _currentOffset += 30;
    });

    List<Map<String, dynamic>> newItems = [];
    try {
      if (selectedCategory == "Restaurants") {
        newItems = await TripAdvisorService.fetchRestaurants(cairoLocationId, offset: _currentOffset);
      } else if (selectedCategory == "Cafes") {
        final allRestaurants = await TripAdvisorService.fetchRestaurants(cairoLocationId, offset: _currentOffset);
        newItems = allRestaurants.where((item) => item['name'].toString().toLowerCase().contains('cafe')).toList();
        if (newItems.isEmpty) newItems = allRestaurants;
      } else if (selectedCategory == "Places" || selectedCategory == "Museums") {
        newItems = await TripAdvisorService.fetchAttractions(cairoLocationId, offset: _currentOffset);
        if (selectedCategory == "Museums") {
          newItems = newItems.where((item) => item['name'].toString().toLowerCase().contains('museum')).toList();
        }
      }

      setState(() {
        apiSearchResults.addAll(newItems);
        _isLoadingMore = false;
      });
    } catch (e) {
      print("Error loading more: $e");
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _executeSearch(String value) async {
    final cleanValue = value.trim();
    if (cleanValue.isNotEmpty) {
      setState(() {
        isLoading = true;
        searchQuery = cleanValue;
        selectedCategory = "All";
        apiSearchResults = [];
      });

      try {
        final results = await TripAdvisorService.searchPlaces(cleanValue);
        setState(() {
          apiSearchResults = results;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        searchQuery = '';
        apiSearchResults = [];
      });
    }
  }

  void _toggleFavorite(Map<String, dynamic> place) {
    setState(() {
      final isExist = savedPlaces.any((element) => element['id'] == place['id']);
      if (isExist) {
        savedPlaces.removeWhere((element) => element['id'] == place['id']);
      } else {
        savedPlaces.add(place);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: IndexedStack(
          index: selectedNavIndex,
          children: [
            _buildHomeExploreContent(),
            SavedScreen( // تم استبدال الكود القديم بالشاشة الجديدة هنا
              savedPlaces: savedPlaces,
              onToggleFavorite: _toggleFavorite,
            ),
            const Profile(),
            NotificationScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeExploreContent() {
    final width = MediaQuery.of(context).size.width;
    final itemsToDisplay = (searchQuery.isNotEmpty && apiSearchResults.isNotEmpty)
        ? apiSearchResults
        : (apiSearchResults.isNotEmpty ? apiSearchResults : _getFilteredLocalItems());

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoadingMore) {
          if (apiSearchResults.isNotEmpty) {
            _loadMoreData();
          }
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/top-view-travel-kit-wooden-table.jpg"),
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
                  height: 200,
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
                            "Welcome, $_userName 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
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
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
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
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            setState(() {
                              searchQuery = '';
                              apiSearchResults = [];
                            });
                          }
                        },
                        onSubmitted: _executeSearch,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: LocalAppColor.kgrey),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, color: LocalAppColor.kgrey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                searchQuery = '';
                                apiSearchResults = [];
                              });
                            },
                          )
                              : null,
                          hintText: "Search destinations, restaurants...",
                          hintStyle: const TextStyle(fontSize: 14, color: LocalAppColor.kgrey),
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
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
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
                      setState(() {
                        selectedCategory = cat;
                        if (searchQuery.isNotEmpty) {
                          _searchController.clear();
                          searchQuery = '';
                          apiSearchResults = [];
                        }
                      });
                      if (cat != "All") {
                        _loadCategoryData(cat);
                      } else {
                        setState(() {
                          apiSearchResults = [];
                        });
                      }
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
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    selectedCategory == "All" ? "Popular Discovery" : "Popular $selectedCategory",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: LocalAppColor.kblack),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(${itemsToDisplay.length})",
                    style: const TextStyle(fontSize: 16, color: LocalAppColor.kgrey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Builder(
              builder: (context) {
                if (isLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(60.0),
                        child: CircularProgressIndicator(color: LocalAppColor.kred),
                      ),
                    ),
                  );
                }

                if (itemsToDisplay.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          "No results found",
                          style: TextStyle(color: LocalAppColor.kgrey, fontSize: 15),
                        ),
                      ),
                    ),
                  );
                }

                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = itemsToDisplay[index];
                      final isSaved = savedPlaces.any((element) => element['id'] == item['id']);

                      return GridCardItem(
                        item: item,
                        isSaved: isSaved,
                        onTap: () {
                          final placeModel = PlaceModel.fromJson(item, item['category'] ?? 'general');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsScreen(place: placeModel)),
                          );
                        },
                        onFavoriteTap: () => _toggleFavorite(item),
                      );
                    },
                    childCount: itemsToDisplay.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                );
              },
            ),
          ),

          if (_isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 25)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedNavIndex,
      onTap: (index) => setState(() => selectedNavIndex = index),
      selectedItemColor: LocalAppColor.kred,
      unselectedItemColor: LocalAppColor.kgrey,
      backgroundColor: LocalAppColor.kWhite,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notification"),
      ],
    );
  }
}