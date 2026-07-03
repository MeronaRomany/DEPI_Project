import 'package:get_it/get_it.dart';
import '../../../my_visit_places/data/repo.dart';
import '../../../my_visit_places/presentation/cubit/saved_places_cubit.dart';
import '../../../my_visit_places/presentation/cubit/trip_cubit.dart';
import '../../data/db/app_database.dart';

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
