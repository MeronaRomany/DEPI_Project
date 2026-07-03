import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constant/app_color.dart';
import '../../notification/data/service/location_service.dart';
import '../data/route_service.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double lon;

  const MapPage({super.key, required this.lat, required this.lon});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  map.LatLng? userLocation;

  List<map.LatLng> routePoints = [];

  StreamSubscription? locationSubscription;

  @override
  void initState() {
    super.initState();

    locationSubscription = LocationService().getLocationStream().listen((
      Position position,
    ) {
      final user = map.LatLng(position.latitude, position.longitude);

      setState(() {
        userLocation = user;
      });

      getRoute(user);
    });
  }

  Future<void> getRoute(map.LatLng user) async {
    final route = await RouteService().getRoute(
      user,

      map.LatLng(widget.lat, widget.lon),
    );

    setState(() {
      routePoints = route;
    });
  }

  @override
  void dispose() {
    locationSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final place = map.LatLng(widget.lat, widget.lon);

    return Scaffold(
      appBar: AppBar(
        title: const Text("place"),
        backgroundColor: Appcolor.kred,
      ),

      body: FlutterMap(
        options: MapOptions(initialCenter: place, initialZoom: 15),

        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

            userAgentPackageName: 'com.tourguide.app.v1',
          ),

          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [Polyline(points: routePoints, strokeWidth: 5)],
            ),

          MarkerLayer(
            markers: [
              Marker(
                point: place,

                width: 50,

                height: 50,

                child: const Icon(
                  Icons.location_on,

                  color: Colors.red,

                  size: 45,
                ),
              ),

              if (userLocation != null)
                Marker(
                  point: userLocation!,

                  width: 50,

                  height: 50,

                  child: const Icon(
                    Icons.person_pin_circle,

                    color: Colors.blue,

                    size: 45,
                  ),
                ),
            ],
          ),

          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',

                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
