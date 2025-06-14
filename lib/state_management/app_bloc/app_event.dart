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
  final int mistakeRepetition;

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

class ChangeSurahInAddMistakeScreenEvent extends AppEvent {
  final int surahNumber;

  ChangeSurahInAddMistakeScreenEvent({required this.surahNumber});
}

class ChangeDisplayTypeInHomeScreenEvent extends AppEvent {
  final int displayTypeInHomeScreen;

  ChangeDisplayTypeInHomeScreenEvent({required this.displayTypeInHomeScreen});
}

class AppBarCollapsedEvent extends AppEvent {}

class ExpansionTileCollapsedEvent extends AppEvent {}

class GetSettingsDataFromSharedPreferencesEvent extends AppEvent {}

class InsertDataToDatabaseEvent extends AppEvent {
  final int surahNumber;
  final int verseNumber;
  final int mistakeKind;
  final String mistake;
  final int mistakeRepetition;

  InsertDataToDatabaseEvent({
    required this.surahNumber,
    required this.verseNumber,
    required this.mistakeKind,
    required this.mistake,
    required this.mistakeRepetition,
  });
}

class ChangeNotificationsActivationEvent extends AppEvent {
  final bool isNotificationsActivated;

  ChangeNotificationsActivationEvent({required this.isNotificationsActivated});
}

class ChangeAyaInAddMistakeScreenEvent extends AppEvent {
  final int selectedSurahInAddMistakeScreen;
  final int selectedVerseInAddMistakeScreen;

  ChangeAyaInAddMistakeScreenEvent(
      {required this.selectedSurahInAddMistakeScreen,
      required this.selectedVerseInAddMistakeScreen});
}
