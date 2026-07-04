import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import '../../../../core/constant/app_color.dart';
import '../../data/model.dart';
import '../cubit/saved_places_cubit.dart';
import '../cubit/trip_cubit.dart';
import 'trips_screen.dart';
import 'create_trip_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

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
                   Text(
                    "My Visit List",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.kblack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                             Text(
                              "Saved Places",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Appcolor.kblack,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(height: 2.5, color: kGreenColor),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TripsScreen(),
                              ),
                            );
                          },
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
              child: BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
                builder: (context, state) {
                  if (state is SavedPlacesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kGreenColor),
                    );
                  }
                  
                  final savedPlaces = state is SavedPlacesLoaded ? state.savedPlaces : [];

                  if (savedPlaces.isEmpty) {
                    return const Center(
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
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: savedPlaces.length,
                    itemBuilder: (context, index) {
                      final item = savedPlaces[index];
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
                                    context.read<SavedPlacesCubit>().toggleFavorite(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTripScreen(),
                    ),
                  );

                  if (result != null &&
                      result is Map<String, dynamic> &&
                      result['trip'] != null) {
                    if (context.mounted) {
                      context.read<TripCubit>().addTrip(result['trip']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TripsScreen(),
                        ),
                      );
                    }
                  }
                },
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
