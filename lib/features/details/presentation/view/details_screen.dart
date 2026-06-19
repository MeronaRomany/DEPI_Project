import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:depi_project/features/home/data/model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final PlaceModel place; // استقبال الموديل

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
    // إعداد العلامة (Marker) فور إنشاء الـ State
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

  // دالة لتحريك الكاميرا للموقع المحدد
  void _moveToLocation() {
    if (widget.place.latitude != null &&
        widget.place.longitude != null &&
        _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(widget.place.latitude!, widget.place.longitude!),
            zoom: 15.0, // تقريب جيد للمكان
            tilt: 45.0,   // زاوية ميلان ثلاثية الأبعاد
            bearing: 0.0,
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
          // الجزء العلوي (الصورة وزر الرجوع)
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      );
                    },
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
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: const Icon(Icons.favorite_border, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),

          // تفاصيل النصوص
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والتقييم
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

                  // الموقع النصي
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

                  // الوصف
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.place.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // زر فتح الخريطة الخارجية
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),

                  // عنوان الخريطة
                  const Text(
                    "Location on Map",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // الخريطة التفاعلية
          SliverToBoxAdapter(
            child: Container(
              height: 300, // ارتفاع الخريطة
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.place.latitude != null && widget.place.longitude != null
                    ? GoogleMap(
                  // 1. تحديد الموقع الأولي للكاميرا ليكون عند المكان مباشرة
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.place.latitude ?? 30.0444,
                        widget.place.longitude ?? 31.2357
                    ),
                    zoom: 14.5,
                  ),
                  markers: markers,
                  myLocationEnabled: true,
                  // 2. عند إنشاء الخريطة، نقوم بتحريك الكاميرا (لتأكيد التركيز)
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