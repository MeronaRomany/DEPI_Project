import 'package:equatable/equatable.dart';
import '../../data/models/travel_item_entity.dart';

enum TravelCategory { all, attractions, hotels, restaurants }

class TravelState extends Equatable {
  final bool isLoading;
  final bool isSearchingLocation;
  final List<TravelItemEntity> attractions;
  final List<TravelItemEntity> hotels;
  final List<TravelItemEntity> restaurants;
  final String currentLocationId;
  final String currentLocationLabel;
  final String? errorMessage;
  final TravelCategory selectedCategory;

  const TravelState({
    this.isLoading = false,
    this.isSearchingLocation = false,
    this.attractions = const [],
    this.hotels = const [],
    this.restaurants = const [],
    this.currentLocationId = '294201',
    this.currentLocationLabel = 'Cairo, Egypt',
    this.errorMessage,
    this.selectedCategory = TravelCategory.all,
  });

  TravelState copyWith({
    bool? isLoading,
    bool? isSearchingLocation,
    List<TravelItemEntity>? attractions,
    List<TravelItemEntity>? hotels,
    List<TravelItemEntity>? restaurants,
    String? currentLocationId,
    String? currentLocationLabel,
    String? errorMessage,
    TravelCategory? selectedCategory,
  }) {
    return TravelState(
      isLoading: isLoading ?? this.isLoading,
      isSearchingLocation: isSearchingLocation ?? this.isSearchingLocation,
      attractions: attractions ?? this.attractions,
      hotels: hotels ?? this.hotels,
      restaurants: restaurants ?? this.restaurants,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      currentLocationLabel: currentLocationLabel ?? this.currentLocationLabel,
      errorMessage: errorMessage, // We allow nulling it out
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSearchingLocation,
        attractions,
        hotels,
        restaurants,
        currentLocationId,
        currentLocationLabel,
        errorMessage,
        selectedCategory,
      ];
}
