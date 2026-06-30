import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showPlaceNotification(String name) {
    try {
      List<String> updatedList = [];

      if (state is NotificationSuccess) {
        updatedList = List<String>.from(
          (state as NotificationSuccess).namePlaces,
        );
      }

      updatedList.add(name);

      emit(NotificationSuccess(namePlaces: updatedList));
    } catch (e) {
      emit(NotificationFail(messageError: e.toString()));
    }
  }
}
