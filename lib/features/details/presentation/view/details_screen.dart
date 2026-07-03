import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../my_visit_places/data/model.dart';
import '../../../my_visit_places/presentation/cubit/saved_places_cubit.dart';

class DetailsScreen extends StatefulWidget {
  final PlaceModel place;

  const DetailsScreen({
    super.key,
    required this.place,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Set<Marker> markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _setupMarker();
  }

  void _setupMarker() {
    if (widget.place.latitude != null && widget.place.longitude != null) {
      markers.add(
        Marker(
          markerId: MarkerId(widget.place.id),
          position: LatLng(widget.place.latitude!, widget.place.longitude!),
          infoWindow: InfoWindow(title: widget.place.name),
        ),
      );
    }
  }

  void _moveToLocation() {
    if (widget.place.latitude != null &&
        widget.place.longitude != null &&
        _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(widget.place.latitude!, widget.place.longitude!),
            zoom: 15.0,
            tilt: 45.0,
          ),
        ),
      );
    }
  }

  Future<void> _openGoogleMaps() async {
    if (widget.place.latitude != null && widget.place.longitude != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${widget.place.latitude},${widget.place.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Hero(
                  tag: widget.place.id,
                  child: Image.network(
                    widget.place.image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
                    builder: (context, state) {
                      final isSaved = (state is SavedPlacesLoaded) &&
                          state.savedPlaces.any((p) => p['id'] == widget.place.id);
                      
                      return GestureDetector(
                        onTap: () => context.read<SavedPlacesCubit>().toggleFavorite(widget.place.toMap()),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              widget.place.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 20),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.place.location,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    widget.place.description,
                    style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 30),
                  if (widget.place.latitude != null && widget.place.longitude != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openGoogleMaps,
                        icon: const Icon(Icons.directions),
                        label: const Text("Get Directions"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  const Text("Location on Map", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.place.latitude != null && widget.place.longitude != null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.place.latitude!, widget.place.longitude!),
                          zoom: 14.5,
                        ),
                        markers: markers,
                        myLocationEnabled: true,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          _moveToLocation();
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Location data not available"),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
