import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:depi_project/features/home/data/model.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import 'app_colors.dart';
import 'trips_screen.dart';
import 'create_trip_screen.dart';

class SavedScreen extends StatefulWidget {
  final List<Map<String, dynamic>> savedPlaces;
  final Function(Map<String, dynamic>) onToggleFavorite;

  const SavedScreen({
    super.key,
    required this.savedPlaces,
    required this.onToggleFavorite,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> globalTrips = [];

  @override
  void initState() {
    super.initState();
    _loadTripsFromStorage();
  }

  // ✅ تحميل الرحلات من الذاكرة الدائمة
  Future<void> _loadTripsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tripsString = prefs.getString('user_trips');

    if (tripsString != null) {
      final List<dynamic> decoded = jsonDecode(tripsString);
      setState(() {
        globalTrips =
            decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
    // لو مفيش حاجة محفوظة، نبدأ بقائمة فاضية (مش sample data)
  }

  // ✅ حفظ الرحلات في الذاكرة الدائمة
  Future<void> _saveTripsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_trips', jsonEncode(globalTrips));
  }

  // ✅ فتح TripsScreen وتحديث البيانات لما نرجع
  Future<void> _openTripsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripsScreen(
          myTrips: globalTrips,
          savedPlaces: widget.savedPlaces,
        ),
      ),
    );
    // ✅ لما يرجع من TripsScreen يحدث القائمة (ممكن حذف أو تعديل)
    await _loadTripsFromStorage();
  }

  // ✅ إنشاء رحلة جديدة وحفظها فوراً
  Future<void> _createNewTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTripScreen(
          savedPlaces: widget.savedPlaces, // ✅ بعت الأماكن المحفوظة
        ),
      ),
    );

    // ✅ CreateTripScreen بترجع { "trip": {...}, "index": ... }
    // لازم نستخرج "trip" منها أولاً، مش نتعامل مع النتيجة كلها كأنها الرحلة
    if (result != null && result is Map<String, dynamic> && result['trip'] != null) {
      final newTrip = Map<String, dynamic>.from(result['trip']);

      // تحقق من عدم التكرار
      final alreadyExists = globalTrips.any((trip) =>
      trip['title'] == newTrip['title'] &&
          trip['destination'] == newTrip['destination'] &&
          trip['startDate'] == newTrip['startDate'] &&
          trip['endDate'] == newTrip['endDate']);

      if (!alreadyExists) {
        setState(() {
          globalTrips.add(newTrip);
        });
        // ✅ حفظ فوري في SharedPreferences
        await _saveTripsToStorage();
      }

      // ✅ انتقل لـ TripsScreen وبعدين حدّث
      await _openTripsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    const kGreenColor = Color(0xFF1E824C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── الترويسة ──
            Padding(
              padding: const EdgeInsets.only(
                  top: 24.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                children: [
                  const Text(
                    "My Visit List",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: LocalAppColor.kblack),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Saved Places Tab (active)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Saved Places",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: LocalAppColor.kblack),
                            ),
                            const SizedBox(height: 8),
                            Container(height: 2.5, color: kGreenColor),
                          ],
                        ),
                      ),
                      // My Trips Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: _openTripsScreen, // ✅ استخدام الدالة الجديدة
                          child: Column(
                            children: [
                              Text(
                                "My Trips",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500),
                              ),
                              const SizedBox(height: 8),
                              Container(height: 2.5, color: Colors.transparent),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── قائمة الأماكن المحفوظة ──
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    sliver: Builder(
                      builder: (context) {
                        if (widget.savedPlaces.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(80.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.bookmark_border,
                                        size: 60, color: Colors.grey),
                                    SizedBox(height: 12),
                                    Text(
                                      "No saved places yet",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final item = widget.savedPlaces[index];
                              return GestureDetector(
                                onTap: () {
                                  final placeModel = PlaceModel.fromJson(
                                    item,
                                    item['category'] ?? 'general',
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(place: placeModel),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                          Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4))
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: Image.network(
                                          item['image'] ??
                                              'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=500',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                              Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey.shade200,
                                                child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          item['name'] ?? 'Place Name',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.favorite,
                                            color: kGreenColor),
                                        onPressed: () =>
                                            widget.onToggleFavorite(item),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: widget.savedPlaces.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── زر إنشاء رحلة جديدة ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: _createNewTrip, // ✅ استخدام الدالة المنظمة
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create New Trip",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenColor,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}