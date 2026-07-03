import 'package:get/get.dart';
import '../../data/models/travel_item_entity.dart';
import '../../data/repo/travel_repository.dart';

class TravelController extends GetxController {
  final TravelRepository _repository;

  TravelController(this._repository);

  static const String _defaultLocationId = '294201'; // Cairo, Egypt
  static const String _defaultLocationLabel = 'Cairo, Egypt';

  final RxString currentLocationId = _defaultLocationId.obs;
  final RxString currentLocationLabel = _defaultLocationLabel.obs;

  final RxList<TravelItemEntity> hotels = <TravelItemEntity>[].obs;
  final RxList<TravelItemEntity> restaurants = <TravelItemEntity>[].obs;
  final RxList<TravelItemEntity> attractions = <TravelItemEntity>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearchingLocation = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final locationId = currentLocationId.value;

      final results = await Future.wait([
        _repository.getHotels(locationId),
        _repository.getRestaurants(locationId),
        _repository.getAttractions(locationId),
      ]);

      hotels.value = results[0];
      restaurants.value = results[1];
      attractions.value = results[2];
    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    try {
      isSearchingLocation.value = true;
      errorMessage.value = '';

      final locationId = await _repository.searchLocationId(trimmed);

      if (locationId == null) {
        errorMessage.value = 'No destination found for "$trimmed"';
        return;
      }

      currentLocationId.value = locationId;
      currentLocationLabel.value = trimmed;
      await fetchAll();
    } catch (e) {
      errorMessage.value = 'Failed to search location: $e';
    } finally {
      isSearchingLocation.value = false;
    }
  }

  Future<void> forceRefresh() async {
    await _repository.refreshAll();
    await fetchAll();
  }
}