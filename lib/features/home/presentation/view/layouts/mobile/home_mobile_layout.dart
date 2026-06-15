import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد الفايربيز لقراءة بيانات اليوزر

// تعديل الـ Imports للمسارات المطلقة الصحيحة داخل مشروعك لإنهاء الـ 87 خطأ
import 'package:depi_project/features/home/data/states_city_repo.dart';
import 'package:depi_project/features/home/data/tripadvisor_service.dart';
import 'package:depi_project/features/home/data/model.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';

import 'app_colors.dart';
import 'widgets/grid_card_item.dart';

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

  // المتغير الآن ديناميكي وقابل للتحديث من الـ Firebase
  String _userName = 'Traveler';

  final List<Map<String, dynamic>> savedPlaces = [];
  final List<String> categories = ["All", "Places", "Restaurants", "Cafes", "Museums"];

  List<Map<String, dynamic>> apiSearchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserName(); // جلب اسم اليوزر الحقيقي فور فتح الشاشة
  }

  // دالة جلب الـ displayName للمستخدم الحالي المسجل في الفايربيز
  void _getUserName() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        _userName = user.displayName!; // تحديث الواجهة بالاسم الفعلي
      });
    }
  }

  // دالة جلب البيانات المحلية وتصفيتها
  List<Map<String, dynamic>> _getFilteredLocalItems() {
    List<Map<String, dynamic>> allItems = [];
    final states = StateCityRepo.data['states'] as List? ?? [];
    final cities = StateCityRepo.data['cities'] as List? ?? [];

    if (selectedCategory == "All" || selectedCategory == "Places") {
      for (var s in states) {
        allItems.add({
          "id": s['id'],
          "name": s['name'],
          "image": s['image'],
          "location": s['details']?['location'] ?? s['name'] ?? "Egypt",
          "rating": s['details']?['reviews']?[0]?['rating'] ?? 4.5,
        });
      }
      for (var c in cities) {
        allItems.add({
          "id": c['id'],
          "name": c['name'],
          "image": c['image'],
          "location": c['details']?['location'] ?? c['stateId'] ?? "Egypt",
          "rating": 4.7,
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
      });
    }
    if (selectedCategory == "All" || selectedCategory == "Cafes") {
      allItems.add({
        "id": "cafe_1",
        "name": "Grand Cafe",
        "image": "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb",
        "location": "Alexandria, Egypt",
        "rating": 4.6,
      });
    }
    if (selectedCategory == "All" || selectedCategory == "Museums") {
      allItems.add({
        "id": "mus_1",
        "name": "The Egyptian Museum",
        "image": "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8",
        "location": "Tahrir Square, Cairo",
        "rating": 4.9,
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

  void _executeSearch(String value) async {
    final cleanValue = value.trim();
    if (cleanValue.isNotEmpty) {
      setState(() {
        isLoading = true;
        searchQuery = cleanValue;
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
            _buildSavedContent(),
            const Center(child: Text("Profile", style: TextStyle(color: LocalAppColor.kgrey))),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeExploreContent() {
    final width = MediaQuery.of(context).size.width;

    final itemsToDisplay = (searchQuery.isNotEmpty && apiSearchResults.isNotEmpty)
        ? apiSearchResults
        : _getFilteredLocalItems();

    return CustomScrollView(
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
                          "Welcome, $_userName 👋", // طباعة الاسم الديناميكي
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
                        // استخدام بناء مانيوال للأوبجكت هنا متوافق تماماً مع الـ Router لتجنب أية أخطاء
                        Navigator.pushNamed(
                          context,
                          'details',
                          arguments: item,
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
        const SliverToBoxAdapter(child: SizedBox(height: 25)),
      ],
    );
  }

  Widget _buildSavedContent() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Saved Places",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: LocalAppColor.kblack),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: Builder(
            builder: (context) {
              if (savedPlaces.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(80.0),
                      child: Column(
                        children: [
                          Icon(Icons.favorite_border, size: 50, color: LocalAppColor.kgrey),
                          SizedBox(height: 12),
                          Text("No saved places yet", style: TextStyle(color: LocalAppColor.kgrey, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => GridCardItem(
                    item: savedPlaces[index],
                    isSaved: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'details',
                        arguments: savedPlaces[index],
                      );
                    },
                    onFavoriteTap: () => _toggleFavorite(savedPlaces[index]),
                  ),
                  childCount: savedPlaces.length,
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
        )
      ],
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
      ],
    );
  }
}