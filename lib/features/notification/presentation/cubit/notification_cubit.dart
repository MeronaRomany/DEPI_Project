
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showPlaceNotification(
      String name,
      double lat,
      double lon,
      ) {
    try {

      List<String> updatedNames = [];
      List<double> updatedLat = [];
      List<double> updatedLon = [];

      if (state is NotificationSuccess) {
        final current = state as NotificationSuccess;

        updatedNames = List.from(current.namePlaces);
        updatedLat = List.from(current.lat);
        updatedLon = List.from(current.lon);
      }

      updatedNames.add(name);
      updatedLat.add(lat);
      updatedLon.add(lon);

      emit(
        NotificationSuccess(
          namePlaces: updatedNames,
          lat: updatedLat,
          lon: updatedLon,
        ),
      );

    } catch (e) {
      emit(NotificationFail(messageError: e.toString()));
    }
  }
}