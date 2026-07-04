import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../my_visit_places/data/model.dart';
import '../../../my_visit_places/presentation/cubit/saved_places_cubit.dart';

class DetailsScreen extends StatefulWidget {
  final PlaceModel place;

  const DetailsScreen({super.key, required this.place});

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
      final url =
          'https://www.google.com/maps/search/?api=1&query=${widget.place.latitude},${widget.place.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _openWebsite() async {
    final uri = widget.place.website ?? widget.place.webUrl;
    if (uri == null || uri.isEmpty) return;
    final parsed = Uri.tryParse(uri);
    if (parsed != null && await canLaunchUrl(parsed)) {
      await launchUrl(parsed, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openEmail() async {
    final email = widget.place.email;
    if (email == null || email.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sharePlace() async {
    final text = [
      widget.place.name,
      widget.place.address ?? widget.place.location,
      widget.place.website ?? widget.place.webUrl ?? '',
    ].where((value) => value.isNotEmpty).join(' - ');

    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Place details copied to clipboard')),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _detailRow(IconData icon, String title, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (widget.place.category.isNotEmpty) {
      chips.add(_chip(widget.place.category.toUpperCase()));
    }
    if (widget.place.priceLevel != null && widget.place.priceLevel!.isNotEmpty) {
      chips.add(_chip('Price ${widget.place.priceLevel!}'));
    }
    if (widget.place.attractionType != null && widget.place.attractionType!.isNotEmpty) {
      chips.add(_chip(widget.place.attractionType!));
    }
    if (widget.place.cuisine != null && widget.place.cuisine!.isNotEmpty) {
      chips.add(_chip(widget.place.cuisine!));
    }

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
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 320,
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
                        color: Colors.white.withValues(alpha: 0.9),
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
                            color: Colors.white.withValues(alpha: 0.9),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.place.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                            Text(widget.place.rating.toStringAsFixed(1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (chips.isNotEmpty)
                    Wrap(spacing: 8, runSpacing: 8, children: chips),
                  const SizedBox(height: 12),
                  _detailRow(Icons.location_on, 'Location', widget.place.address ?? widget.place.location),
                  _detailRow(Icons.location_city, 'City', widget.place.city),
                  _detailRow(Icons.flag, 'Country', widget.place.country),
                  _detailRow(Icons.emoji_events, 'Ranking', widget.place.ranking),
                  _detailRow(Icons.attach_money, 'Price level', widget.place.priceLevel),
                  _detailRow(Icons.access_time, 'Opening hours', widget.place.openingHours),
                  _detailRow(Icons.phone, 'Phone', widget.place.phone),
                  _detailRow(Icons.language, 'Website', widget.place.website ?? widget.place.webUrl),
                  _detailRow(Icons.email, 'Email', widget.place.email),
                  if (widget.place.description.trim().isNotEmpty) ...[
                    _sectionTitle('About'),
                    Text(
                      widget.place.description,
                      style: const TextStyle(color: Colors.black54, height: 1.5),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (widget.place.latitude != null && widget.place.longitude != null)
                        ElevatedButton.icon(
                          onPressed: _openGoogleMaps,
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                        ),
                      if ((widget.place.website ?? widget.place.webUrl ?? '').isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: _openWebsite,
                          icon: const Icon(Icons.language),
                          label: const Text('Website'),
                        ),
                      if ((widget.place.email ?? '').isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: _openEmail,
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                    ],
                  ),
                  if ((widget.place.amenities ?? []).isNotEmpty) ...[
                    _sectionTitle('Amenities'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.place.amenities!
                          .map((item) => _chip(item))
                          .toList(),
                    ),
                  ],
                  if (widget.place.hotelFacilities != null && widget.place.hotelFacilities!.isNotEmpty) ...[
                    _sectionTitle('Facilities'),
                    Text(widget.place.hotelFacilities!, style: const TextStyle(color: Colors.black87)),
                  ],
                  if (widget.place.travelerReviews != null && widget.place.travelerReviews!.isNotEmpty) ...[
                    _sectionTitle('Traveler reviews'),
                    ...widget.place.travelerReviews!.map((review) {
                      final author = review['author']?.toString() ?? 'Traveler';
                      final rating = review['rating']?.toString() ?? '';
                      final text = review['text']?.toString() ?? review['comment']?.toString() ?? '';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                if (rating.isNotEmpty) Text(rating),
                              ],
                            ),
                            if (text.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(text, style: const TextStyle(color: Colors.black54)),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.read<SavedPlacesCubit>().toggleFavorite(widget.place.toMap()),
                          icon: const Icon(Icons.bookmark_add_outlined),
                          label: const Text('Save Place'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E824C)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _sharePlace,
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.place.latitude != null && widget.place.longitude != null) ...[
                    _sectionTitle('Location on map'),
                    SizedBox(
                      height: 260,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: GoogleMap(
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
                        ),
                      ),
                    ),
                  ] else ...[
                    _sectionTitle('Location on map'),
                    const Text('Location data is not available for this place.'),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFF1E824C).withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
  );
}
