import 'package:flutter/material.dart';

import '../../data/tripadvisor_service.dart';

class CreateTripScreen extends StatefulWidget {
  final Map<String, dynamic>? trip;
  final int? tripIndex;
  final List<Map<String, dynamic>> savedPlaces;

  const CreateTripScreen({
    super.key,
    this.trip,
    this.tripIndex,
    this.savedPlaces = const [],
  });

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _DaySchedule {
  final DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<Map<String, dynamic>> selectedPlaces;

  _DaySchedule({
    required this.date,
    this.startTime = const TimeOfDay(hour: 9, minute: 0),
    this.endTime = const TimeOfDay(hour: 18, minute: 0),
    List<Map<String, dynamic>>? selectedPlaces,
  }) : selectedPlaces = selectedPlaces ?? [];
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  int currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Map<String, dynamic>? _selectedDestination;
  List<Map<String, dynamic>> _selectedPlacesToVisit = [];
  List<Map<String, dynamic>> _famousPlaces = [];
  bool _isLoadingPlaces = false;
  List<_DaySchedule> _daySchedules = [];

  String _reviewTitle = '';
  String _reviewDestination = '';
  String _reviewStartDate = '';
  String _reviewEndDate = '';

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    final trip = widget.trip!;
    _titleController.text = trip['title'] ?? '';
    _startDateController.text = trip['startDate'] ?? '';
    _endDateController.text = trip['endDate'] ?? '';

    _startDate = _parseDate(trip['startDate']);
    _endDate = _parseDate(trip['endDate']);

    final destName = (trip['destination'] ?? '').toString();
    _selectedDestination = widget.savedPlaces.firstWhere(
      (p) => p['name'] == destName,
      orElse: () => destName.isEmpty ? <String, dynamic>{} : {
        "id": destName,
        "name": destName,
        "image": trip['destinationImage'] ?? trip['image'] ?? '',
      },
    );

    if (_selectedDestination?.isEmpty ?? true) _selectedDestination = null;

    final placesStr = (trip['places'] ?? '').toString();
    final placesNames = placesStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

    _selectedPlacesToVisit = placesNames.map((name) {
      return widget.savedPlaces.firstWhere(
        (p) => (p['name'] ?? '').toString() == name,
        orElse: () => {"id": name, "name": name, "category": "attraction"},
      );
    }).toList();

    _buildSchedule();

    final savedSchedule = trip['schedule'] as List? ?? [];
    for (int i = 0; i < savedSchedule.length && i < _daySchedules.length; i++) {
      final dayData = savedSchedule[i];
      _daySchedules[i].startTime = _parseTime(dayData['startTime']) ?? _daySchedules[i].startTime;
      _daySchedules[i].endTime = _parseTime(dayData['endTime']) ?? _daySchedules[i].endTime;
      
      final names = List<String>.from(dayData['places'] ?? []);
      _daySchedules[i].selectedPlaces = names.map((name) {
        return _selectedPlacesToVisit.firstWhere(
          (p) => p['name'] == name,
          orElse: () => {"id": name, "name": name, "category": "attraction"},
        );
      }).toList();
    }

    _updateReviewData();
    if (_selectedDestination != null) {
      _fetchFamousPlaces(_selectedDestination!);
    }
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null || date.toString().isEmpty) return null;
    try {
      final parts = date.toString().split('/');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
    return null;
  }

  TimeOfDay? _parseTime(dynamic time) {
    if (time == null || time.toString().isEmpty) return null;
    try {
      final parts = time.toString().split(':');
      if (parts.length == 2) {
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (_) {}
    return null;
  }

  void _updateReviewData() {
    _reviewTitle = _titleController.text;
    _reviewDestination = _selectedDestination?['name'] ?? '';
    _reviewStartDate = _startDateController.text;
    _reviewEndDate = _endDateController.text;
  }

  List<Map<String, dynamic>> get _destinationPlaces {
    final list = widget.savedPlaces.where((p) {
      final cat = (p['category'] ?? '').toString().toLowerCase();
      return cat == 'state' || cat == 'city';
    }).toList();

    if (_selectedDestination != null) {
      if (!list.any((p) => p['name'] == _selectedDestination!['name'])) {
        list.insert(0, _selectedDestination!);
      }
    }
    return list;
  }

  Future<void> _fetchFamousPlaces(Map<String, dynamic> destination) async {
    if (!mounted) return;
    setState(() => _isLoadingPlaces = true);

    final destName = (destination['name'] ?? '').toString().toLowerCase();
    final locationId = destination['id']?.toString() ?? '294019';

    List<Map<String, dynamic>> apiPlaces = [];
    try {
      final attractions = await TripAdvisorService.fetchAttractions(locationId);
      final restaurants = await TripAdvisorService.fetchRestaurants(locationId);
      apiPlaces = [...attractions, ...restaurants];
    } catch (_) {}

    final savedMatching = widget.savedPlaces.where((p) {
      final cat = (p['category'] ?? '').toString().toLowerCase();
      if (cat == 'state' || cat == 'city') return false;
      final placeLocation = (p['location'] ?? '').toString().toLowerCase();
      return placeLocation.contains(destName) || destName.contains(placeLocation);
    }).toList();

    final merged = <String, Map<String, dynamic>>{};
    for (final p in apiPlaces) {
      final key = (p['name'] ?? '').toString().toLowerCase().trim();
      if (key.isNotEmpty) merged[key] = p;
    }
    for (final p in savedMatching) {
      final key = (p['name'] ?? '').toString().toLowerCase().trim();
      if (key.isNotEmpty) merged[key] = p;
    }

    if (!mounted) return;
    setState(() {
      _famousPlaces = merged.values.toList();
      _isLoadingPlaces = false;
    });
  }

  void _buildSchedule() {
    if (_startDate == null || _endDate == null) return;
    final daysCount = _endDate!.difference(_startDate!).inDays + 1;
    if (daysCount <= 0) return;

    final List<_DaySchedule> newSchedules = [];
    for (int i = 0; i < daysCount; i++) {
      final date = _startDate!.add(Duration(days: i));
      if (i < _daySchedules.length) {
        newSchedules.add(_DaySchedule(
          date: date,
          startTime: _daySchedules[i].startTime,
          endTime: _daySchedules[i].endTime,
          selectedPlaces: _daySchedules[i].selectedPlaces,
        ));
      } else {
        newSchedules.add(_DaySchedule(date: date));
      }
    }
    _daySchedules = newSchedules;
  }

  void _handleNext() {
    if (currentStep == 0) {
      if (!(_formKey1.currentState?.validate() ?? false)) return;
      if (_startDate == null || _endDate == null) {
        _showSnack("Please select start and end dates");
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        _showSnack("End date must be after start date");
        return;
      }
    } else if (currentStep == 1) {
      if (_selectedDestination == null) {
        _showSnack("Please select a destination");
        return;
      }
    } else if (currentStep == 2) {
      if (_selectedPlacesToVisit.isEmpty) {
        _showSnack("Please select at least one place to visit");
        return;
      }
      _buildSchedule();
    } else if (currentStep == 3) {
      if (_daySchedules.any((d) => d.selectedPlaces.isEmpty)) {
        _showSnack("Please add places for all days");
        return;
      }
    }

    if (currentStep < 4) {
      setState(() {
        if (currentStep == 3) _updateReviewData();
        currentStep++;
      });
    } else {
      _saveTrip();
    }
  }

  void _saveTrip() {
    final allPlacesNames = _selectedPlacesToVisit.map((p) => p['name']).join(', ');
    final scheduleData = _daySchedules.map((day) => {
      'date': '${day.date.day}/${day.date.month}/${day.date.year}',
      'startTime': '${day.startTime.hour.toString().padLeft(2, '0')}:${day.startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${day.endTime.hour.toString().padLeft(2, '0')}:${day.endTime.minute.toString().padLeft(2, '0')}',
      'places': day.selectedPlaces.map((p) => p['name']).toList(),
    }).toList();

    final tripData = {
      if (widget.trip?['id'] != null) 'id': widget.trip!['id'],
      "title": _titleController.text,
      "destination": _selectedDestination?['name'] ?? '',
      "destinationImage": _selectedDestination?['image'] ?? '',
      "startDate": _startDateController.text,
      "endDate": _endDateController.text,
      "places": allPlacesNames,
      "placesCount": _selectedPlacesToVisit.length,
      "schedule": scheduleData,
      "image": _selectedDestination?['image'] ?? "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500",
    };

    Navigator.pop(context, {"trip": tripData});
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1E824C)));
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? (_startDate ?? DateTime.now())),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      } else {
        _endDate = picked;
        _endDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      }
    });
  }

  Future<void> _pickTime(int dayIndex, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _daySchedules[dayIndex].startTime : _daySchedules[dayIndex].endTime,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) _daySchedules[dayIndex].startTime = picked;
      else _daySchedules[dayIndex].endTime = picked;
    });
  }

  String _formatTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1E824C);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white, centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text(widget.trip == null ? "Create Trip" : "Edit Trip", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Stepper(
        currentStep: currentStep,
        type: StepperType.horizontal,
        onStepContinue: _handleNext,
        onStepCancel: () => currentStep > 0 ? setState(() => currentStep--) : Navigator.pop(context),
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: details.onStepContinue, style: ElevatedButton.styleFrom(backgroundColor: green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(currentStep == 4 ? "Save Trip ✓" : "Next →", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              if (currentStep != 0) ...[const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: details.onStepCancel, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: green), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("← Back", style: TextStyle(color: green, fontWeight: FontWeight.bold))))],
            ],
          ),
        ),
        steps: [_stepInfo(), _stepDestination(), _stepPlaces(), _stepSchedule(), _stepReview()],
      ),
    );
  }

  Step _stepInfo() => Step(
    isActive: currentStep >= 0, state: currentStep > 0 ? StepState.complete : StepState.indexed, title: const Text(""),
    content: Form(key: _formKey1, child: Column(children: [
      _field(controller: _titleController, label: "Trip Title", icon: Icons.card_travel, validator: (v) => v?.isEmpty ?? true ? "Required" : null),
      const SizedBox(height: 16),
      _dateField(controller: _startDateController, label: "Start Date", icon: Icons.flight_takeoff, onTap: () => _pickDate(true)),
      const SizedBox(height: 16),
      _dateField(controller: _endDateController, label: "End Date", icon: Icons.flight_land, onTap: () => _pickDate(false)),
    ])),
  );

  Step _stepDestination() => Step(
    isActive: currentStep >= 1, state: currentStep > 1 ? StepState.complete : StepState.indexed, title: const Text(""),
    content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Where are you going?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      ..._destinationPlaces.map((place) {
        final isSelected = _selectedDestination?['name'] == place['name'];
        return _destinationItem(place, isSelected);
      }),
    ]),
  );

  Widget _destinationItem(Map<String, dynamic> place, bool isSelected) => GestureDetector(
    onTap: () {
      setState(() { _selectedDestination = place; _selectedPlacesToVisit = []; _famousPlaces = []; });
      _fetchFamousPlaces(place);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: isSelected ? const Color(0xFF1E824C).withOpacity(0.07) : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: isSelected ? const Color(0xFF1E824C) : Colors.grey.shade200, width: isSelected ? 2 : 1)),
      child: ListTile(
        leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(place['image'] ?? '', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.location_city))),
        title: Text(place['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF1E824C) : Colors.black87)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1E824C)) : null,
      ),
    ),
  );

  Step _stepPlaces() => Step(
    isActive: currentStep >= 2, state: currentStep > 2 ? StepState.complete : StepState.indexed, title: const Text(""),
    content: _isLoadingPlaces ? const Center(child: CircularProgressIndicator()) : Column(children: _famousPlaces.map((p) {
      final isSelected = _selectedPlacesToVisit.any((v) => v['name'] == p['name']);
      return CheckboxListTile(
        title: Text(p['name'] ?? ''),
        value: isSelected,
        onChanged: (v) => setState(() {
          if (v == true) _selectedPlacesToVisit.add(p);
          else {
            _selectedPlacesToVisit.removeWhere((v) => v['name'] == p['name']);
            for (var d in _daySchedules) d.selectedPlaces.removeWhere((v) => v['name'] == p['name']);
          }
        }),
      );
    }).toList()),
  );

  Step _stepSchedule() => Step(
    isActive: currentStep >= 3, state: currentStep > 3 ? StepState.complete : StepState.indexed, title: const Text(""),
    content: Column(children: _daySchedules.asMap().entries.map((entry) {
      final i = entry.key; final day = entry.value;
      return Card(child: ExpansionTile(
        title: Text("Day ${i+1} - ${_formatDate(day.date)}"),
        children: [
          Row(children: [
            Expanded(child: ListTile(title: const Text("Start"), subtitle: Text(_formatTime(day.startTime)), onTap: () => _pickTime(i, true))),
            Expanded(child: ListTile(title: const Text("End"), subtitle: Text(_formatTime(day.endTime)), onTap: () => _pickTime(i, false))),
          ]),
          ..._selectedPlacesToVisit.map((p) => CheckboxListTile(
            title: Text(p['name'] ?? ''),
            value: day.selectedPlaces.any((v) => v['name'] == p['name']),
            onChanged: (v) => setState(() {
              if (v == true) day.selectedPlaces.add(p);
              else day.selectedPlaces.removeWhere((v) => v['name'] == p['name']);
            }),
          )),
        ],
      ));
    }).toList()),
  );

  Step _stepReview() => Step(
    isActive: currentStep >= 4, title: const Text(""),
    content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _reviewRow(Icons.title, "Title", _reviewTitle),
      _reviewRow(Icons.place, "Destination", _reviewDestination),
      _reviewRow(Icons.date_range, "Dates", "$_reviewStartDate - $_reviewEndDate"),
      const Divider(),
      const Text("Schedule Summary:", style: TextStyle(fontWeight: FontWeight.bold)),
      ..._daySchedules.map((d) => Padding(padding: const EdgeInsets.only(top: 4), child: Text("• ${_formatDate(d.date)}: ${d.selectedPlaces.length} places"))),
    ]),
  );

  Widget _reviewRow(IconData icon, String label, String value) => ListTile(leading: Icon(icon, color: const Color(0xFF1E824C)), title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _field({required TextEditingController controller, required String label, required IconData icon, String? Function(String?)? validator}) => TextFormField(controller: controller, validator: validator, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF1E824C)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))));

  Widget _dateField({required TextEditingController controller, required String label, required IconData icon, required VoidCallback onTap}) => TextField(controller: controller, readOnly: true, onTap: onTap, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF1E824C)), suffixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))));
}
