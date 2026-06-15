import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const DetailsScreen({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> localSubPlaces = [
      {"name": "Premium Restaurant", "type": "Restaurant", "icon": "🍽️", "rating": "4.8"},
      {"name": "Cozy Corner Cafe", "type": "Cafe", "icon": "☕", "rating": "4.6"},
      {"name": "Historical Museum Center", "type": "Museum", "icon": "🏛️", "rating": "4.9"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFFE23E3E),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                placeData['name'] ?? 'Details',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(placeData['image'] ?? '', fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.25)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFE23E3E), size: 20),
                      const SizedBox(width: 6),
                      Text("Located in: ${placeData['location'] ?? 'Egypt'}", style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("About this Place", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "Welcome to ${placeData['name']}. One of the most beautiful destinations to explore.",
                    style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  // لستة الخدمات والمطاعم
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: localSubPlaces.length,
                    itemBuilder: (context, index) {
                      final subPlace = localSubPlaces[index];
                      return Card(
                        child: ListTile(
                          leading: Text(subPlace['icon']!, style: const TextStyle(fontSize: 22)),
                          title: Text(subPlace['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(subPlace['type']!),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}