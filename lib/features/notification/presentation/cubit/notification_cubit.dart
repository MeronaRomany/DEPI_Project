import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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
