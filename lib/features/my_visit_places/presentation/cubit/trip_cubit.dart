import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Map<String, dynamic>> trips;
  TripLoaded(this.trips);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

class TripCubit extends Cubit<TripState> {
  final TripRepository _repository;

  TripCubit(this._repository) : super(TripInitial());

  Future<void> loadTrips() async {
    emit(TripLoading());
    try {
      final trips = await _repository.getAllTrips();
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  Future<void> addTrip(Map<String, dynamic> tripData) async {
    try {
      await _repository.saveTrip(tripData);
      await loadTrips();
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  Future<void> updateTrip(Map<String, dynamic> tripData) async {
    try {
      await _repository.saveTrip(tripData);
      await loadTrips();
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  Future<void> deleteTrip(Map<String, dynamic> tripData) async {
    try {
      await _repository.deleteTrip(tripData);
      await loadTrips();
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }
}
