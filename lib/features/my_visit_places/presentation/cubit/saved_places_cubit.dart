import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/saved_place_dao.dart';
import '../../data/saved_place_entity.dart';

abstract class SavedPlacesState {}
class SavedPlacesInitial extends SavedPlacesState {}
class SavedPlacesLoading extends SavedPlacesState {}
class SavedPlacesLoaded extends SavedPlacesState {
  final List<Map<String, dynamic>> savedPlaces;
  SavedPlacesLoaded(this.savedPlaces);
}

class SavedPlacesCubit extends Cubit<SavedPlacesState> {
  final SavedPlaceDao _dao;

  SavedPlacesCubit(this._dao) : super(SavedPlacesInitial());

  Future<void> loadSavedPlaces() async {
    emit(SavedPlacesLoading());
    try {
      final entities = await _dao.getAllSavedPlaces();
      final places = entities.map((e) => e.toMap()).toList();
      emit(SavedPlacesLoaded(places));
    } catch (e) {
      emit(SavedPlacesLoaded([]));
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> place) async {
    try {
      final id = place['id']?.toString() ?? '';
      final existing = await _dao.getSavedPlaceById(id);
      
      if (existing != null) {
        await _dao.deleteSavedPlaceById(id);
      } else {
        await _dao.insertSavedPlace(SavedPlaceEntity.fromMap(place));
      }
      await loadSavedPlaces();
    } catch (_) {}
  }
}
