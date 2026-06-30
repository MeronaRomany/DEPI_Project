part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationSuccess extends NotificationState {
   List<String> namePlaces;
   List<double> lat;
   List<double> lon;
   NotificationSuccess({required this.namePlaces,required this.lat,required this.lon});
}
final class NotificationFail extends NotificationState {
  String messageError;
  NotificationFail({required this.messageError});
}
