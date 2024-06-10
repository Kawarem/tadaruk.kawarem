import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc get(context) => BlocProvider.of(context);

  int notificationsNumber = 20;

  TimeOfDay notificationStartTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay notificationEndTime = const TimeOfDay(hour: 20, minute: 0);

  String convertTimeToString({required int hour, required int minute}) {
    return '${(hour == 0) ? '12' : (hour > 12) ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${(hour > 11) ? 'م' : 'ص'}';
  }

  String timeBetweenEachNotifications = '36';

  String calculateTimeBetweenEachNotifications() {
    return (((notificationEndTime.hour - notificationStartTime.hour) * 60 +
                notificationStartTime.minute -
                notificationEndTime.minute) /
            notificationsNumber)
        .round()
        .toString();
  }

  AppBloc() : super(AppInitial()) {
    on<AppEvent>((event, emit) {
      if (event is ChangeNotificationsNumberEvent) {
        notificationsNumber = event.notificationsNumber;
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
      }
    });
  }
}
