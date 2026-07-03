import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import '../../../home/presentation/view/layouts/mobile/app_colors.dart';
import '../../data/model.dart';
import '../cubit/trip_cubit.dart';
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
  Future<void> _openTripsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripsScreen(savedPlaces: widget.savedPlaces),
      ),
    );
  }

  Future<void> _createNewTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTripScreen(savedPlaces: widget.savedPlaces),
      ),
    );

    if (result != null &&
        result is Map<String, dynamic> &&
        result['trip'] != null) {
      if (mounted) {
        context.read<TripCubit>().addTrip(result['trip']);
        _openTripsScreen();
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
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Column(
                children: [
                  const Text(
                    "My Visit List",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: LocalAppColor.kblack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Saved Places",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: LocalAppColor.kblack,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(height: 2.5, color: kGreenColor),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openTripsScreen,
                          child: Column(
                            children: [
                              Text(
                                "My Trips",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade500,
                                ),
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
            Expanded(
              child: widget.savedPlaces.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No saved places yet",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.savedPlaces.length,
                      itemBuilder: (context, index) {
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
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item['name'] ?? 'Place Name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: kGreenColor,
                                  ),
                                  onPressed: () =>
                                      widget.onToggleFavorite(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _createNewTrip,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create New Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenColor,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
