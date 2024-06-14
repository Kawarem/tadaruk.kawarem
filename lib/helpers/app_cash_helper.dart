import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheHelper {
  Future<void> cacheNotificationsNumber(int notificationsNumber) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("NOTIFICATIONS_NUMBER", notificationsNumber);
  }

  Future<int> getCachedNotificationsNumber() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedNotificationsNumber =
        sharedPreferences.getInt("NOTIFICATIONS_NUMBER");
    if (cachedNotificationsNumber != null) {
      return cachedNotificationsNumber;
    } else {
      return 20;
    }
  }

  Future<void> cacheNotificationStartTime(
      TimeOfDay notificationStartTime) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String notificationStartTimeString =
        '${notificationStartTime.hour}:${notificationStartTime.minute}';
    await sharedPreferences.setString(
        'NOTIFICATIONS_START_TIME', notificationStartTimeString);
  }

  Future<TimeOfDay> getNotificationStartTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? notificationStartTimeString =
        sharedPreferences.getString('NOTIFICATIONS_START_TIME');
    if (notificationStartTimeString != null) {
      List<String> timeParts = notificationStartTimeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } else {
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  Future<void> cacheNotificationEndTime(TimeOfDay notificationEndTime) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String notificationEndTimeString =
        '${notificationEndTime.hour}:${notificationEndTime.minute}';
    await sharedPreferences.setString(
        'NOTIFICATIONS_END_TIME', notificationEndTimeString);
  }

  Future<TimeOfDay> getNotificationEndTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? notificationEndTimeString =
        sharedPreferences.getString('NOTIFICATIONS_END_TIME');
    if (notificationEndTimeString != null) {
      List<String> timeParts = notificationEndTimeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } else {
      return const TimeOfDay(hour: 20, minute: 0);
    }
  }
}
