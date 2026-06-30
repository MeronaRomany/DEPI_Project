import 'package:flutter/material.dart';
import 'package:depi_project/features/home/data/tripadvisor_service.dart';

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

// ── نموذج يوم في الجدول ──────────────────────────────────────────
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

  // Controllers
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  // Step 2: الوجهة
  Map<String, dynamic>? _selectedDestination;

  // Step 3: الأماكن المختارة للزيارة
  List<Map<String, dynamic>> _selectedPlacesToVisit = [];

  // ✅ أشهر الأماكن (API + saved) بعد الدمج
  List<Map<String, dynamic>> _famousPlaces = [];
  bool _isLoadingPlaces = false;

  // Step 4: جدول الأيام
  List<_DaySchedule> _daySchedules = [];

  // Review data
  String _reviewTitle = '';
  String _reviewDestination = '';
  String _reviewStartDate = '';
  String _reviewEndDate = '';

  @override
  void initState() {
    super.initState();

    if (widget.trip != null) {
      final trip = widget.trip!;

      _titleController.text = trip['title'] ?? '';
      _startDateController.text = trip['startDate'] ?? '';
      _endDateController.text = trip['endDate'] ?? '';

      if ((trip['startDate'] ?? '').isNotEmpty) {
        final s = trip['startDate'].split('/');
        _startDate = DateTime(int.parse(s[2]), int.parse(s[1]), int.parse(s[0]));
      }

      if ((trip['endDate'] ?? '').isNotEmpty) {
        final e = trip['endDate'].split('/');
        _endDate = DateTime(int.parse(e[2]), int.parse(e[1]), int.parse(e[0]));
      }

      _selectedDestination = widget.savedPlaces.firstWhere(
            (p) => p['name'] == trip['destination'],
        orElse: () => <String, dynamic>{},
      );

      if (_selectedDestination!.isEmpty) {
        // ✅ لو الـ destination مش موجود في savedPlaces (اتشال مثلاً) نبني object بسيط منه
        final destName = (trip['destination'] ?? '').toString();
        _selectedDestination = destName.isEmpty
            ? null
            : {
          "id": destName,
          "name": destName,
          "image": trip['destinationImage'] ?? trip['image'] ?? '',
        };
      }

      final places = (trip['places'] ?? '').toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      // ✅ نحاول نلاقي كل مكان في savedPlaces، ولو مش موجود نبني object بسيط بالاسم بس
      // عشان يفضل ظاهر ومتعلَّم عليه حتى لو اليوزر شاله من المفضلة بعدين
      _selectedPlacesToVisit = places.map((name) {
        final found = widget.savedPlaces.firstWhere(
              (p) => (p['name'] ?? '').toString() == name,
          orElse: () => <String, dynamic>{},
        );
        if (found.isNotEmpty) return Map<String, dynamic>.from(found);
        return <String, dynamic>{
          "id": name,
          "name": name,
          "category": "attraction",
        };
      }).toList();

      _buildSchedule();

      final savedSchedule = trip['schedule'] as List? ?? [];

      for (int i = 0; i < savedSchedule.length && i < _daySchedules.length; i++) {
        final day = savedSchedule[i];

        final start = day['startTime'].split(':');
        final end = day['endTime'].split(':');

        _daySchedules[i].startTime = TimeOfDay(hour: int.parse(start[0]), minute: int.parse(start[1]));
        _daySchedules[i].endTime = TimeOfDay(hour: int.parse(end[0]), minute: int.parse(end[1]));

        final names = List<String>.from(day['places']);

        // ✅ نجيب الأماكن من _selectedPlacesToVisit (اللي اتبنت فوق) عشان تتطابق وتتعلَّم صح
        _daySchedules[i].selectedPlaces = names.map((name) {
          return _selectedPlacesToVisit.firstWhere(
                (p) => p['name'] == name,
            orElse: () => {"id": name, "name": name, "category": "attraction"},
          );
        }).toList();
      }

      // ✅ تجهيز الـ Review فوراً (وضع التعديل)
      _reviewTitle = _titleController.text;
      _reviewDestination = _selectedDestination?['name'] ?? '';
      _reviewStartDate = _startDateController.text;
      _reviewEndDate = _endDateController.text;

      // ✅ جلب أشهر الأماكن لنفس الـ destination
      if (_selectedDestination != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchFamousPlaces(_selectedDestination!);
        });
      }
    }
  }

  // ── فلترة الأماكن ─────────────────────────────────────────────

  // Dropdown 1: فقط cities و states + الـ destination الحالية لو في وضع تعديل ومش موجودة أصلاً
  List<Map<String, dynamic>> get _destinationPlaces {
    final list = widget.savedPlaces.where((p) {
      final cat = (p['category'] ?? '').toString().toLowerCase();
      return cat == 'state' || cat == 'city';
    }).toList();

    // ✅ لو في destination محفوظة في الرحلة ومش موجودة في القائمة، نضيفها
    if (_selectedDestination != null) {
      final exists = list.any((p) => p['name'] == _selectedDestination!['name']);
      if (!exists) {
        list.insert(0, _selectedDestination!);
      }
    }

    return list;
  }

  // ✅ جلب أشهر الأماكن (من الـ API) ودمجها مع الأماكن المحفوظة بدون تكرار
  Future<void> _fetchFamousPlaces(Map<String, dynamic> destination) async {
    setState(() => _isLoadingPlaces = true);

    final destName = (destination['name'] ?? '').toString().toLowerCase();
    final destLocation = (destination['location'] ?? '').toString().toLowerCase();
    final locationId = destination['id']?.toString() ?? '294019';

    List<Map<String, dynamic>> apiPlaces = [];
    try {
      final attractions = await TripAdvisorService.fetchAttractions(locationId);
      final restaurants = await TripAdvisorService.fetchRestaurants(locationId);
      apiPlaces = [...attractions, ...restaurants];
    } catch (_) {
      apiPlaces = [];
    }

    // ✅ الأماكن المحفوظة اللي بتخص نفس الـ destination
    final savedMatching = widget.savedPlaces.where((p) {
      final cat = (p['category'] ?? '').toString().toLowerCase();
      if (cat == 'state' || cat == 'city') return false;

      final placeLocation = (p['location'] ?? '').toString().toLowerCase();
      return placeLocation.contains(destName) ||
          destName.contains(placeLocation) ||
          (destLocation.isNotEmpty &&
              (placeLocation.contains(destLocation) || destLocation.contains(placeLocation)));
    }).toList();

    // ✅ دمج بدون تكرار (الاسم هو المفتاح)، الأماكن المحفوظة بتاخد أولوية لو فيها نفس الاسم
    final merged = <String, Map<String, dynamic>>{};
    for (final p in apiPlaces) {
      final key = (p['name'] ?? '').toString().toLowerCase().trim();
      if (key.isEmpty) continue;
      merged[key] = p;
    }
    for (final p in savedMatching) {
      final key = (p['name'] ?? '').toString().toLowerCase().trim();
      if (key.isEmpty) continue;
      merged[key] = p;
    }
    // ✅ مهم جداً: الأماكن اللي كانت متختارة بالفعل في الرحلة (وضع التعديل) لازم تفضل ظاهرة
    // حتى لو مش موجودة في نتائج الـ API أو savedPlaces الحالية
    for (final p in _selectedPlacesToVisit) {
      final key = (p['name'] ?? '').toString().toLowerCase().trim();
      if (key.isEmpty) continue;
      if (!merged.containsKey(key)) {
        merged[key] = p;
      }
    }

    setState(() {
      _famousPlaces = merged.values.toList();
      _isLoadingPlaces = false;
    });
  }

  // Dropdown 2: الأماكن المدمجة (مشهورة + saved) جوا الـ destination المختارة
  List<Map<String, dynamic>> get _visitorPlaces {
    if (_selectedDestination == null) return [];
    return _famousPlaces;
  }

  // تجميع الأماكن بـ category
  Map<String, List<Map<String, dynamic>>> get _groupedPlaces {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final place in _visitorPlaces) {
      final cat = _categoryLabel(place['category']);
      map.putIfAbsent(cat, () => []).add(place);
    }
    return map;
  }

  String _categoryLabel(dynamic cat) {
    switch ((cat ?? '').toString().toLowerCase()) {
      case 'restaurant':
        return '🍽 Restaurants';
      case 'cafe':
        return '☕ Cafes';
      case 'museum':
        return '🏛 Museums';
      case 'attraction':
        return '📍 Attractions';
      default:
        return '📌 Others';
    }
  }

  IconData _categoryIcon(String label) {
    if (label.contains('Restaurant')) return Icons.restaurant;
    if (label.contains('Cafe')) return Icons.coffee;
    if (label.contains('Museum')) return Icons.account_balance;
    if (label.contains('Attraction')) return Icons.place;
    return Icons.location_pin;
  }

  // ── بناء جدول الأيام ──────────────────────────────────────────
  void _buildSchedule() {
    if (_startDate == null || _endDate == null) return;
    final days = _endDate!.difference(_startDate!).inDays + 1;
    _daySchedules = List.generate(days, (i) {
      final date = _startDate!.add(Duration(days: i));
      if (i < _daySchedules.length) {
        return _DaySchedule(
          date: date,
          startTime: _daySchedules[i].startTime,
          endTime: _daySchedules[i].endTime,
          selectedPlaces: _daySchedules[i].selectedPlaces,
        );
      }
      return _DaySchedule(date: date);
    });
  }

  // ── Validation ────────────────────────────────────────────────
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
    }

    if (currentStep == 1) {
      if (_selectedDestination == null) {
        _showSnack("Please select a destination");
        return;
      }
    }

    if (currentStep == 2) {
      if (_visitorPlaces.isNotEmpty && _selectedPlacesToVisit.isEmpty) {
        _showSnack("Please select at least one place to visit");
        return;
      }
      _buildSchedule();
    }

    if (currentStep == 3) {
      final emptyDay = _daySchedules.indexWhere((d) => d.selectedPlaces.isEmpty);
      if (emptyDay != -1) {
        _showSnack("Please add places for Day ${emptyDay + 1}");
        return;
      }
    }

    if (currentStep < 4) {
      if (currentStep == 3) {
        setState(() {
          _reviewTitle = _titleController.text;
          _reviewDestination = _selectedDestination?['name'] ?? '';
          _reviewStartDate = _startDateController.text;
          _reviewEndDate = _endDateController.text;
          currentStep++;
        });
      } else {
        setState(() => currentStep++);
      }
    } else {
      _saveTrip();
    }
  }

  void _handleBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _saveTrip() {
    final allPlaces = _selectedPlacesToVisit.map((p) => p['name']).join(', ');

    final schedule = _daySchedules.map((day) {
      return {
        'date': '${day.date.day}/${day.date.month}/${day.date.year}',
        'startTime':
        '${day.startTime.hour.toString().padLeft(2, '0')}:${day.startTime.minute.toString().padLeft(2, '0')}',
        'endTime':
        '${day.endTime.hour.toString().padLeft(2, '0')}:${day.endTime.minute.toString().padLeft(2, '0')}',
        'places': day.selectedPlaces.map((p) => p['name']).toList(),
      };
    }).toList();

    final tripData = {
      "title": _titleController.text,
      "destination": _selectedDestination?['name'] ?? '',
      "destinationImage": _selectedDestination?['image'] ?? '',
      "startDate": _startDateController.text,
      "endDate": _endDateController.text,
      "places": allPlaces,
      "placesCount": _selectedPlacesToVisit.length,
      "schedule": schedule,
      "image": _selectedDestination?['image'] ??
          "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500",
    };

    Navigator.pop(context, {
      "trip": tripData,
      "index": widget.tripIndex,
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF1E824C),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Date Picker ───────────────────────────────────────────────
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1E824C)),
        ),
        child: child!,
      ),
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

  // ── Time Picker ───────────────────────────────────────────────
  Future<void> _pickTime(int dayIndex, bool isStart) async {
    final current = isStart ? _daySchedules[dayIndex].startTime : _daySchedules[dayIndex].endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1E824C)),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _daySchedules[dayIndex].startTime = picked;
      } else {
        _daySchedules[dayIndex].endTime = picked;
      }
    });
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1E824C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.trip == null ? "Create Trip" : "Edit Trip",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: green, onSurface: Colors.black),
        ),
        child: Stepper(
          currentStep: currentStep,
          type: StepperType.horizontal,
          physics: const ClampingScrollPhysics(),
          onStepContinue: _handleNext,
          onStepCancel: _handleBack,
          controlsBuilder: (context, details) => Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      currentStep == 4 ? "Save Trip ✓" : "Next →",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                if (currentStep != 0) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: green),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("← Back",
                          style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          steps: [
            _stepInfo(),
            _stepDestination(),
            _stepPlaces(),
            _stepSchedule(),
            _stepReview(),
          ],
        ),
      ),
    );
  }

  // ── Step 1: Trip Info ─────────────────────────────────────────
  Step _stepInfo() => Step(
    isActive: currentStep >= 0,
    state: currentStep > 0 ? StepState.complete : StepState.indexed,
    title: const Text(""),
    content: Form(
      key: _formKey1,
      child: Column(
        children: [
          _field(
            controller: _titleController,
            label: "Trip Title",
            icon: Icons.card_travel,
            hint: "Summer Adventure...",
            validator: (v) => v == null || v.isEmpty ? "Please enter trip title" : null,
          ),
          const SizedBox(height: 16),
          _dateField(
            controller: _startDateController,
            label: "Start Date",
            icon: Icons.flight_takeoff,
            onTap: () => _pickDate(true),
          ),
          const SizedBox(height: 16),
          _dateField(
            controller: _endDateController,
            label: "End Date",
            icon: Icons.flight_land,
            onTap: () => _pickDate(false),
          ),
          if (_startDate != null && _endDate != null && !_endDate!.isBefore(_startDate!))
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E824C).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, color: Color(0xFF1E824C), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "${_endDate!.difference(_startDate!).inDays + 1} days trip",
                    style: const TextStyle(color: Color(0xFF1E824C), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );

  // ── Step 2: Destination ───────────────────────────────────────
  Step _stepDestination() => Step(
    isActive: currentStep >= 1,
    state: currentStep > 1 ? StepState.complete : StepState.indexed,
    title: const Text(""),
    content: _destinationPlaces.isEmpty
        ? _emptyHint(
      icon: Icons.location_city,
      title: "No saved destinations",
      subtitle: "Save cities or states from the Home screen first, then come back to plan your trip.",
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Where are you going?",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Text("Select from your saved cities & destinations",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 14),
        ..._destinationPlaces.map((place) {
          final isSelected = _selectedDestination?['id'] == place['id'] &&
              _selectedDestination?['name'] == place['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDestination = place;
                _selectedPlacesToVisit = [];
                _famousPlaces = [];
              });
              _fetchFamousPlaces(place);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E824C).withOpacity(0.07) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? const Color(0xFF1E824C) : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(13),
                      bottomLeft: Radius.circular(13),
                    ),
                    child: Image.network(
                      place['image'] ?? '',
                      width: 80,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.location_city, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['name'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF1E824C) : Colors.black87,
                          ),
                        ),
                        if (place['location'] != null)
                          Text(place['location'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E824C) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1E824C) : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );

  // ── Step 3: Places to Visit ───────────────────────────────────
  Step _stepPlaces() => Step(
    isActive: currentStep >= 2,
    state: currentStep > 2 ? StepState.complete : StepState.indexed,
    title: const Text(""),
    content: _isLoadingPlaces
        ? Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          CircularProgressIndicator(color: Color(0xFF1E824C)),
          SizedBox(height: 14),
          Text("Loading popular places...", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    )
        : _visitorPlaces.isEmpty
        ? _emptyHint(
      icon: Icons.explore,
      title: _selectedDestination == null
          ? "No destination selected"
          : "No places found in ${_selectedDestination!['name']}",
      subtitle: _selectedDestination == null
          ? "Go back and select a destination first."
          : "We couldn't find any places for this destination yet.",
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF1E824C), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "Places in ${_selectedDestination?['name'] ?? ''}",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Select the places you want to visit", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 16),
        ..._groupedPlaces.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Row(
                  children: [
                    Icon(_categoryIcon(entry.key), color: const Color(0xFF1E824C), size: 16),
                    const SizedBox(width: 6),
                    Text(entry.key,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E824C))),
                    const SizedBox(width: 6),
                    Text("(${entry.value.length})", style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                  ],
                ),
              ),
              ...entry.value.map((place) {
                final isSelected = _selectedPlacesToVisit.any((p) => p['name'] == place['name']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedPlacesToVisit.removeWhere((p) => p['name'] == place['name']);
                        for (final day in _daySchedules) {
                          day.selectedPlaces.removeWhere((p) => p['name'] == place['name']);
                        }
                      } else {
                        _selectedPlacesToVisit.add(place);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E824C).withOpacity(0.07) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1E824C) : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            place['image'] ?? '',
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 46,
                              height: 46,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.place, color: Colors.grey, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            place['name'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? const Color(0xFF1E824C) : Colors.black87,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E824C) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1E824C) : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        }),
        if (_selectedPlacesToVisit.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E824C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF1E824C), size: 18),
                const SizedBox(width: 8),
                Text(
                  "${_selectedPlacesToVisit.length} place${_selectedPlacesToVisit.length > 1 ? 's' : ''} selected",
                  style: const TextStyle(color: Color(0xFF1E824C), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  // ── Step 4: Schedule ──────────────────────────────────────────
  Step _stepSchedule() => Step(
    isActive: currentStep >= 3,
    state: currentStep > 3 ? StepState.complete : StepState.indexed,
    title: const Text(""),
    content: _daySchedules.isEmpty
        ? _emptyHint(
      icon: Icons.calendar_month,
      title: "No schedule yet",
      subtitle: "Go back and complete the previous steps first.",
    )
        : Column(
      children: List.generate(_daySchedules.length, (i) {
        final day = _daySchedules[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E824C),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text("Day ${i + 1}  •  ${_formatDate(day.date)}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _timePicker(label: "Start", time: day.startTime, onTap: () => _pickTime(i, true)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _timePicker(label: "End", time: day.endTime, onTap: () => _pickTime(i, false)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text("Places for this day:",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    ..._selectedPlacesToVisit.map((place) {
                      final isChecked = day.selectedPlaces.any((p) => p['name'] == place['name']);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              day.selectedPlaces.removeWhere((p) => p['name'] == place['name']);
                            } else {
                              day.selectedPlaces.add(place);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isChecked ? const Color(0xFF1E824C).withOpacity(0.06) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isChecked ? const Color(0xFF1E824C) : Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                                color: isChecked ? const Color(0xFF1E824C) : Colors.grey.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  place['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isChecked ? const Color(0xFF1E824C) : Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                child: Text(_categoryLabel(place['category']).split(' ').first,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (day.selectedPlaces.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${day.selectedPlaces.length} place${day.selectedPlaces.length > 1 ? 's' : ''} planned  •  ${_formatTime(day.startTime)} – ${_formatTime(day.endTime)}",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF1E824C), fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );

  // ── Step 5: Review ────────────────────────────────────────────
  Step _stepReview() => Step(
    isActive: currentStep >= 4,
    state: currentStep > 4 ? StepState.complete : StepState.indexed,
    title: const Text(""),
    content: Column(
      children: [
        const SizedBox(height: 4),
        _reviewCard(icon: Icons.card_travel, label: "Trip Title", value: _reviewTitle.isEmpty ? "(not set)" : _reviewTitle),
        _reviewCard(icon: Icons.location_on, label: "Destination", value: _reviewDestination.isEmpty ? "(not set)" : _reviewDestination),
        _reviewCard(icon: Icons.flight_takeoff, label: "Start Date", value: _reviewStartDate.isEmpty ? "(not set)" : _reviewStartDate),
        _reviewCard(icon: Icons.flight_land, label: "End Date", value: _reviewEndDate.isEmpty ? "(not set)" : _reviewEndDate),
        _reviewCard(
          icon: Icons.place,
          label: "Places to Visit",
          value: _selectedPlacesToVisit.isEmpty ? "(not set)" : _selectedPlacesToVisit.map((p) => p['name']).join(', '),
        ),
        _reviewCard(
          icon: Icons.calendar_month,
          label: "Schedule",
          value: "${_daySchedules.length} day${_daySchedules.length > 1 ? 's' : ''} planned",
          isLast: true,
        ),
        if (_daySchedules.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Daily Schedule", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 10),
                ..._daySchedules.asMap().entries.map((e) {
                  final idx = e.key;
                  final day = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(color: Color(0xFF1E824C), shape: BoxShape.circle),
                          child: Center(
                            child: Text("${idx + 1}",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_formatDate(day.date)}  •  ${_formatTime(day.startTime)} – ${_formatTime(day.endTime)}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                              if (day.selectedPlaces.isNotEmpty)
                                Text(day.selectedPlaces.map((p) => p['name']).join(', '),
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    ),
  );

  // ── Shared Widgets ────────────────────────────────────────────
  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1E824C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E824C), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _dateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1E824C)),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E824C), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _timePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E824C).withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E824C).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF1E824C), size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                Text(_formatTime(time), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E824C))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF1E824C).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF1E824C), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyHint({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}