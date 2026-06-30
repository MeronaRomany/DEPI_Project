import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'trip_details_screen.dart';

class TripsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> myTrips;
  final List<Map<String, dynamic>> savedPlaces; // ✅ محتاجينها عشان نبعتها للـ Edit

  const TripsScreen({
    super.key,
    required this.myTrips,
    this.savedPlaces = const [],
  });

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List<Map<String, dynamic>> activeTrips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCachedTrips();
  }

  // جلب البيانات بشكل نظيف وآمن يمنع تراكم العناصر وتكرارها
  Future<void> _fetchCachedTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tripsString = prefs.getString('user_trips');

    if (tripsString != null) {
      final List<dynamic> decoded = jsonDecode(tripsString);
      setState(() {
        activeTrips.clear();
        activeTrips = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        activeTrips = List.from(widget.myTrips);
        isLoading = false;
      });
    }
  }

  // ✅ حفظ القائمة كاملة في الذاكرة الدائمة
  Future<void> _persistTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_trips', jsonEncode(activeTrips));
  }

  // ✅ فتح صفحة تفاصيل رحلة معينة والتعامل مع نتيجة الحذف/التعديل
  Future<void> _openTripDetails(int index) async {
    final trip = activeTrips[index];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsScreen(
          tripData: trip,
          tripIndex: index,
          savedPlaces: widget.savedPlaces,
        ),
      ),
    );

    if (result == null || result is! Map<String, dynamic>) return;

    final action = result['action'];

    if (action == 'delete') {
      final delIndex = result['tripIndex'] ?? index;
      if (delIndex >= 0 && delIndex < activeTrips.length) {
        setState(() {
          activeTrips.removeAt(delIndex);
        });
        await _persistTrips();
      }
    } else if (action == 'update') {
      final updatedTrip = result['trip'];
      if (updatedTrip != null && index < activeTrips.length) {
        setState(() {
          activeTrips[index] = Map<String, dynamic>.from(updatedTrip);
        });
        await _persistTrips();
      }
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
            // ترويسة الصفحة الثابتة
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                children: [
                  const Text("My Visit List",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LocalAppColor.kblack)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Column(
                            children: [
                              Text("Saved Places",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                              const SizedBox(height: 8),
                              Container(height: 2.5, color: Colors.transparent),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text("My Trips",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: LocalAppColor.kblack)),
                            const SizedBox(height: 8),
                            Container(height: 2.5, color: kGreenColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // عرض محتوى قائمة الرحلات
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: kGreenColor))
                  : activeTrips.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.card_travel, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text("No planned trips yet",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: activeTrips.length,
                itemBuilder: (context, index) {
                  final trip = activeTrips[index];
                  return GestureDetector(
                    onTap: () => _openTripDetails(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                            child: Image.network(
                              trip['destinationImage'] ??
                                  trip['image'] ??
                                  'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=500',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 140,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (trip['title'] ?? '').toString().isEmpty
                                            ? 'New Trip'
                                            : trip['title'],
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${trip['startDate'] ?? ''} - ${trip['endDate'] ?? ''}",
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                      if ((trip['destination'] ?? '').toString().isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                                              const SizedBox(width: 2),
                                              Text(trip['destination'],
                                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration:
                                  BoxDecoration(color: kGreenColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Text("${trip['placesCount'] ?? 0} Places",
                                      style: const TextStyle(color: kGreenColor, fontSize: 12, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}