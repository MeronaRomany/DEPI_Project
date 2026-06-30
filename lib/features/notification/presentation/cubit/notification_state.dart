part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationSuccess extends NotificationState {
   final List<String> namePlaces;
   NotificationSuccess({required this.namePlaces});
}
final class NotificationFail extends NotificationState {
  final String messageError;
  NotificationFail({required this.messageError});
}
