part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class ChangeNotificationsNumberEvent extends AppEvent {
  final int notificationsNumber;

  ChangeNotificationsNumberEvent({required this.notificationsNumber});
}

class ChangeNotificationsStartTimeEvent extends AppEvent {
  final TimeOfDay notificationStartTime;

  ChangeNotificationsStartTimeEvent({required this.notificationStartTime});
}

class ChangeNotificationsEndTimeEvent extends AppEvent {
  final TimeOfDay notificationEndTime;

  ChangeNotificationsEndTimeEvent({required this.notificationEndTime});
}
