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

class ValidateTextFormFieldEvent extends AppEvent {
  final bool validator;

  ValidateTextFormFieldEvent({required this.validator});
}

class ChangeSurahInAddMistakeScreen extends AppEvent {
  final int surahNumber;

  ChangeSurahInAddMistakeScreen({required this.surahNumber});
}

class ChangeDisplayTypeInHomeScreenEvent extends AppEvent {
  final int displayTypeInHomeScreen;

  ChangeDisplayTypeInHomeScreenEvent({required this.displayTypeInHomeScreen});
}

class AppBarCollapsedEvent extends AppEvent {}
