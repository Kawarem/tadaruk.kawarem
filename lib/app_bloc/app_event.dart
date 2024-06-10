part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class ChangeNotificationsNumberEvent extends AppEvent {
  final double notificationsNumber;

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

class ChangeMistakeRepetitionEvent extends AppEvent {
  final double mistakeRepetition;

  ChangeMistakeRepetitionEvent({required this.mistakeRepetition});
}

class ChangeMistakeKindEvent extends AppEvent {
  final int mistakeKind;

  ChangeMistakeKindEvent({required this.mistakeKind});
}
