import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/trip_cubit.dart';
import 'create_trip_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const TripDetailsScreen({super.key, required this.tripData});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> trip;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    trip = Map<String, dynamic>.from(widget.tripData);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deleteTrip() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Trip"),
        content: const Text("Are you sure you want to delete this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<TripCubit>().deleteTrip(trip);
      Navigator.pop(context);
    }
  }

  Future<void> _editTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateTripScreen(trip: trip)),
    );

    if (result != null &&
        result is Map<String, dynamic> &&
        result['trip'] != null &&
        mounted) {
      setState(() {
        trip = Map<String, dynamic>.from(result['trip']);
      });
    }
  }

  Map<String, dynamic> _currentTrip(TripState state) {
    if (state is TripLoaded && trip['id'] != null) {
      final updated = state.trips.cast<Map<String, dynamic>>().firstWhere(
        (item) => item['id'] == trip['id'],
        orElse: () => {},
      );
      if (updated.isNotEmpty) {
        return updated;
      }
    }
    return trip;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        final currentTrip = _currentTrip(state);
        final schedule = (currentTrip['schedule'] as List?) ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7F9),
          body: Column(
            children: [
              _buildHeader(currentTrip),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(currentTrip),
                    _buildScheduleTab(schedule),
                    _buildPlacesTab(currentTrip),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(Map<String, dynamic> tripData) {
    final imageUrl = (tripData['destinationImage'] ?? tripData['image'] ?? '')
        .toString();
    return Stack(
      children: [
        Image.network(
          imageUrl.isNotEmpty
              ? imageUrl
              : 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
          height: 260,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 260,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripData['title'] ?? 'No Title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tripData['destination'] ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _editTrip,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteTrip,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1E824C),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF1E824C),
        tabs: const [
          Tab(text: "Info"),
          Tab(text: "Schedule"),
          Tab(text: "Places"),
        ],
      ),
    );
  }

  Widget _buildInfoTab(Map<String, dynamic> tripData) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _card(
          "📅 Dates",
          "${tripData['startDate'] ?? ''} → ${tripData['endDate'] ?? ''}",
        ),
        _card("📍 Destination", tripData['destination'] ?? ''),
        _card("🗺 Places Count", "${tripData['placesCount'] ?? 0} places"),
        _card(
          "📌 All Places",
          (tripData['places'] ?? '').toString().isEmpty
              ? 'No places added'
              : tripData['places'],
        ),
      ],
    );
  }

  Widget _buildScheduleTab(List schedule) {
    if (schedule.isEmpty)
      return const Center(child: Text("No schedule available"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final day = Map<String, dynamic>.from(schedule[index]);
        final places = (day['places'] as List?) ?? [];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E824C),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "📅 ${day['date'] ?? ''}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "⏰ ${day['startTime'] ?? ''} → ${day['endTime'] ?? ''}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 10),
              const Text(
                "Places:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...places.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place,
                        size: 16,
                        color: Color(0xFF1E824C),
                      ),
                      const SizedBox(width: 6),
                      Text("$p"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlacesTab(Map<String, dynamic> tripData) {
    final places = (tripData['places'] ?? '')
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (places.isEmpty) return const Center(child: Text("No places added"));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "All Places",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...places.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.place, color: Color(0xFF1E824C)),
                const SizedBox(width: 10),
                Expanded(child: Text(p)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
