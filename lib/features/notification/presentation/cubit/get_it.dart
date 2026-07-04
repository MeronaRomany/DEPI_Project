import 'package:get_it/get_it.dart';
import '../../../my_visit_places/data/repo.dart';
import '../../../my_visit_places/presentation/cubit/saved_places_cubit.dart';
import '../../../my_visit_places/presentation/cubit/trip_cubit.dart';
import '../../data/db/app_database.dart';
import '../../../travel/data/db/travel_dao.dart';
import '../../../travel/data/db/travel_database.dart';
import '../../../travel/data/remote/travel_api_service.dart';
import '../../../travel/data/repo/travel_repository.dart';
import '../../../travel/presentation/cubit/travel_cubit.dart';
import '../../../travel/data/models/travel_item_entity.dart';
import 'package:flutter/foundation.dart';

import '../../../Auth/data/repo.dart';
import '../../../Auth/presentation/cubit/auth_cubit.dart';
import 'notification_cubit.dart';

final getIt = GetIt.instance;

void setup(AppDatabase db) {
  // Database DAOs
  getIt.registerSingleton(db.tripDao);
  getIt.registerSingleton(db.placeDao);
  getIt.registerSingleton(db.savedPlaceDao);

  // Repositories
  getIt.registerLazySingleton<TripRepository>(() => TripRepository(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Cubits
  getIt.registerLazySingleton<NotificationCubit>(() => NotificationCubit());
  getIt.registerLazySingleton<TripCubit>(() => TripCubit(getIt()));
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerLazySingleton<SavedPlacesCubit>(() => SavedPlacesCubit(getIt()));
}

Future<void> setupTravel() async {
  TravelDao dao;

  try {
    final db = await $FloorTravelDatabase.databaseBuilder('travel.db').build();
    dao = db.travelDao;
    debugPrint("TravelDatabase opened successfully.");
  } catch (e) {
    debugPrint("TravelDatabase failed, using in-memory fallback: $e");
    dao = _InMemoryTravelDao();
  }

  getIt.registerSingleton<TravelDao>(dao);
  getIt.registerLazySingleton<TravelApiService>(() => TravelApiService());
  getIt.registerLazySingleton<TravelRepository>(
    () => TravelRepository(getIt<TravelDao>(), getIt<TravelApiService>()),
  );
  getIt.registerFactory<TravelCubit>(() => TravelCubit(getIt<TravelRepository>()));
}

class _InMemoryTravelDao implements TravelDao {
  @override
  Future<List<TravelItemEntity>> getByCategory(String category, String locationId) async => [];
  @override
  Future<void> insertItems(List<TravelItemEntity> items) async {}
  @override
  Future<void> deleteByCategory(String category, String locationId) async {}
  @override
  Future<void> clearAll() async {}
}
