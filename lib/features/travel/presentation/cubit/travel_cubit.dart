import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/travel_repository.dart';
import 'travel_state.dart';

class TravelCubit extends Cubit<TravelState> {
  final TravelRepository _repository;

  TravelCubit(this._repository) : super(const TravelState()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final results = await Future.wait([
        _repository.getHotels(state.currentLocationId),
        _repository.getRestaurants(state.currentLocationId),
        _repository.getAttractions(state.currentLocationId),
      ]);

      emit(state.copyWith(
        hotels: results[0],
        restaurants: results[1],
        attractions: results[2],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load data: $e',
      ));
    }
  }

  Future<void> searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSearchingLocation: true, errorMessage: null));
    try {
      final locationId = await _repository.searchLocationId(trimmed);

      if (locationId == null) {
        emit(state.copyWith(
          isSearchingLocation: false,
          errorMessage: 'No destination found for "$trimmed"',
        ));
        return;
      }

      emit(state.copyWith(
        currentLocationId: locationId,
        currentLocationLabel: trimmed,
        isSearchingLocation: false,
      ));
      
      await fetchAll();
    } catch (e) {
      emit(state.copyWith(
        isSearchingLocation: false,
        errorMessage: 'Failed to search location: $e',
      ));
    }
  }

  void selectCategory(TravelCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> forceRefresh() async {
    await _repository.refreshAll();
    await fetchAll();
  }
}
