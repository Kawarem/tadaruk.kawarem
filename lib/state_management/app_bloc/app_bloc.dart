import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadarok/helpers/app_cash_helper.dart';
import 'package:tadarok/helpers/local_notifications_helper.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc get(context) => BlocProvider.of(context);

  static int notificationsNumber = 20;
  static TimeOfDay notificationStartTime = const TimeOfDay(hour: 8, minute: 0);
  static TimeOfDay notificationEndTime = const TimeOfDay(hour: 20, minute: 0);
  static int timeBetweenEachNotifications = 36;
  int mistakeKind = 0;
  int mistakeRepetition = 1;
  Color circleColor0 = const Color(0xffb5e742);
  Color circleColor1 = const Color(0xffb5e742);
  bool validatorInAddMistakeScreen = false;
  int surahNumber = 0;
  int categoryInHomeScreen = 0;
  bool isAppBarCollapsed = false;
  static bool isNotificationsActivated = false;
  static List<int> notificationsIdsList = [];
  Timer? _sliderValueChangeDebounceTimer;

  AppBloc() : super(AppInitial()) {
    on<AppEvent>((event, emit) async {
      if (event is ChangeNotificationsNumberEvent) {
        notificationsNumber = event.notificationsNumber.toInt();
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        await AppCacheHelper().cacheNotificationsNumber(notificationsNumber);

        // Cancel the previous debounce timer, if any
        _sliderValueChangeDebounceTimer?.cancel();
        // Set a new debounce timer to call scheduleRecurringNotifications after 2 second
        _sliderValueChangeDebounceTimer = Timer(
          const Duration(seconds: 2),
          () => LocalNotificationsHelper.scheduleRecurringNotifications(),
        );
        emit(ChangeNotificationsNumberState());
      } else if (event is ChangeNotificationsStartTimeEvent) {
        notificationStartTime = event.notificationStartTime;
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        await AppCacheHelper()
            .cacheNotificationStartTime(notificationStartTime);
        await LocalNotificationsHelper.scheduleRecurringNotifications();
        emit(ChangeNotificationsTimeState());
      } else if (event is ChangeNotificationsEndTimeEvent) {
        notificationEndTime = event.notificationEndTime;
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        await AppCacheHelper().cacheNotificationEndTime(notificationEndTime);
        await LocalNotificationsHelper.scheduleRecurringNotifications();
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
      } else if (event is ChangeSurahInAddMistakeScreenEvent) {
        surahNumber = event.surahNumber;
        emit(ChangeSurahInAddMistakeScreenState(
            versesNumber: event.surahNumber));
      } else if (event is ChangeDisplayTypeInHomeScreenEvent) {
        categoryInHomeScreen = event.displayTypeInHomeScreen;
        emit(ChangeDisplayTypeInHomeScreenState());
      } else if (event is AppBarCollapsedEvent) {
        emit(AppBarCollapsedState(isCollapsed: isAppBarCollapsed));
      } else if (event is GetSettingsDataFromSharedPreferencesEvent) {
        notificationsNumber =
            await AppCacheHelper().getCachedNotificationsNumber();
        notificationStartTime =
            await AppCacheHelper().getNotificationStartTime();
        notificationEndTime = await AppCacheHelper().getNotificationEndTime();
        timeBetweenEachNotifications = calculateTimeBetweenEachNotifications();
        isNotificationsActivated =
            await AppCacheHelper().getCachedIsNotificationsActivated();
        notificationsIdsList = await AppCacheHelper().getCachedIdsList();
        emit(GetSettingsDataFromSharedPreferencesState());
      } else if (event is ChangeNotificationsActivationEvent) {
        isNotificationsActivated = event.isNotificationsActivated;
        await AppCacheHelper()
            .cacheIsNotificationsActivated(isNotificationsActivated);
        if (isNotificationsActivated) {
          LocalNotificationsHelper.scheduleRecurringNotifications();
        } else {
          await LocalNotificationsHelper.cancelAll();
        }
        emit(ChangeNotificationsActivationState());
      }
    });
  }

  String convertTimeToString({required int hour, required int minute}) {
    return '${(hour == 0) ? '12' : (hour > 12) ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${(hour > 11) ? 'م' : 'ص'}';
  }

  int calculateTimeBetweenEachNotifications() {
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
      return (difference.inMinutes / notificationsNumber).round();
    } else {
      return ((1440 + difference.inMinutes) / notificationsNumber).round();
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
      default:
        return const Color(0xfffc4850);
    }
  }

  void resetAddMistakeScreen() {
    mistakeRepetition = 1;
    mistakeKind = 0;
    circleColor1 = const Color(0xffb5e742);
    changeCircleColor();
  }
}
