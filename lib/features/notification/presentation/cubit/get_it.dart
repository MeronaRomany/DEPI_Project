import 'package:get_it/get_it.dart';

import 'notification_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<NotificationCubit>(
        () => NotificationCubit(),
  );
}