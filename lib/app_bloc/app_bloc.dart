import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc get(context) => BlocProvider.of(context);

  int notificationsNumber = 20;
  TimeOfDay notificationStartTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay notificationEndTime = const TimeOfDay(hour: 20, minute: 0);
  String timeBetweenEachNotifications = '36';
  int mistakeKind = 0;
  int mistakeRepetition = 1;
  Color circleColor0 = const Color(0xffb5e742);
  Color circleColor1 = const Color(0xffb5e742);
  bool validatorInAddMistakeScreen = false;
  int surahNumber = 0;
  int displayTypeInHomeScreen = 0;
  bool appBarIsCollapsed = false;

  AppBloc() : super(AppInitial()) {
    on<AppEvent>((event, emit) {
      if (event is ChangeNotificationsNumberEvent) {
        notificationsNumber = event.notificationsNumber.toInt();
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        emit(ChangeNotificationsNumberState());
      } else if (event is ChangeNotificationsStartTimeEvent) {
        notificationStartTime = event.notificationStartTime;
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        emit(ChangeNotificationsTimeState());
      } else if (event is ChangeNotificationsEndTimeEvent) {
        notificationEndTime = event.notificationEndTime;
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        emit(ChangeNotificationsTimeState());
      } else if (event is ChangeMistakeRepetitionEvent) {
        mistakeRepetition = event.mistakeRepetition.toInt();
        circleColor0 = circleColor1;
        circleColor1 = changeCircleColor();
        emit(ChangeMistakeRepetitionState());
      } else if (event is ChangeMistakeKindEvent) {
        mistakeKind = event.mistakeKind;
        emit(ChangeMistakeKindState());
      } else if (event is ValidateTextFormFieldEvent) {
        emit(ValidateTextFormFieldState(validator: event.validator));
      } else if (event is ChangeSurahInAddMistakeScreen) {
        surahNumber = event.surahNumber;
        emit(ChangeSurahInAddMistakeScreenState(
            versesNumber: event.surahNumber));
      } else if (event is ChangeDisplayTypeInHomeScreenEvent) {
        displayTypeInHomeScreen = event.displayTypeInHomeScreen;
        emit(ChangeDisplayTypeInHomeScreenState());
      } else if (event is AppBarCollapsedEvent) {
        emit(AppBarCollapsedState(isCollapsed: appBarIsCollapsed));
        // }
      }
    });
  }

  String convertTimeToString({required int hour, required int minute}) {
    return '${(hour == 0) ? '12' : (hour > 12) ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${(hour > 11) ? 'م' : 'ص'}';
  }

  String calculateTimeBetweenEachNotifications() {
    DateTime endDateTime;
    DateTime startDateTime = DateTime(
        2024, 6, 12, notificationStartTime.hour, notificationStartTime.minute);
    if (notificationStartTime == notificationEndTime) {
      endDateTime = DateTime(
          2024, 6, 13, notificationEndTime.hour, notificationEndTime.minute);
    } else {
      endDateTime = DateTime(
          2024, 6, 12, notificationEndTime.hour, notificationEndTime.minute);
    }

    Duration difference = endDateTime.difference(startDateTime);
    if (difference.inMinutes > 0) {
      return (difference.inMinutes / notificationsNumber).round().toString();
    } else {
      return ((1440 + difference.inMinutes) / notificationsNumber)
          .round()
          .toString();
    }
  }

  Color changeCircleColor() {
    switch (mistakeRepetition) {
      case 1:
        return const Color(0xffb5e742);
      case 2:
        return const Color(0xfffae800);
      case 3:
        return const Color(0xfffa8e00);
      case 4:
        return const Color(0xfffc4850);
    }
    return const Color(0xffb5e742);
  }
}
