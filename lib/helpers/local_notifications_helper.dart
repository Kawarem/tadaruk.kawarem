import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

bool haha = false;

class LocalNotificationsHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static DateTime? startTime, endTime;

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // request notification permissions
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    // on notification tap action
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );

    await _didNotificationLaunchApp();
  }

  static Future scheduleRecurringNotifications() async {
    // await showSimpleNotification(
    //     title: 'scheduleRecurringNotifications has been called');
    // debugPrint('scheduleRecurringNotifications called');
    if (AppBloc.isNotificationsActivated) {
      // await showSimpleNotification(title: 'isNotificationsActivated is true');
      // cancel previous notifications
      // await cancelAll();
      // set new notifications
      // List<int> notificationsIdsList =
      //     await AppCacheHelper().getCachedIdsList();
      debugPrint('ids: ${SqlCubit.notificationsIds}');
      if (SqlCubit.notificationsIds.isEmpty) {
        debugPrint('ID list is empty. Cannot schedule notifications.');
        return;
      }
      // await showSimpleNotification(title: 'notificationsIdsList is not empty');
      List<int> idList = List.from(SqlCubit.notificationsIds);
      tz.initializeTimeZones();

      final notificationsNumber = AppBloc.notificationsNumber;
      DateTime startTime = _getStartDateTime(AppBloc.notificationStartTime);
      final endTime = _getEndDateTime(
          AppBloc.notificationStartTime, AppBloc.notificationEndTime);

      for (int i = 1; i <= notificationsNumber; i++) {
        if (startTime.isAfter(endTime)) {
          debugPrint('break');
          break;
        }
        final scheduledNotificationDateTime = tz.TZDateTime.from(
          startTime,
          tz.local,
        );
        if (idList.isEmpty) {
          idList = List.from(SqlCubit.notificationsIds);
        }
        final randomIndex = Random().nextInt(idList.length);
        final randomId = idList[randomIndex];
        debugPrint('$startTime, $i, id: $randomId');
        // remove the id we got from the idList to ensure equal chances for other ids
        idList.removeAt(randomIndex);
        final notificationTitle =
            '${quranSurahNames[SqlCubit.idData[randomId]!['surah_number'] - 1]} الآية ${SqlCubit.idData[randomId]!['verse_number']}';
        String mistake = SqlCubit.idData[randomId]!['mistake'];
        String note = SqlCubit.idData[randomId]!['note'];
        final notificationBody =
            '${(mistake.isNotEmpty) ? 'التنبيه: $mistake\n' : ''}${(note.isNotEmpty) ? 'ملاحظة: $note' : ''}';
        // payload = id, surahNumber, verseNumber, mistakeKind, mistakeRepetition, mistake, note
        final payload =
            '$randomId, ${SqlCubit.idData[randomId]!['surah_number']}, ${SqlCubit.idData[randomId]!['verse_number']}, ${SqlCubit.idData[randomId]!['mistake_kind']}, ${SqlCubit.idData[randomId]!['mistake_repetition']}, ${SqlCubit.idData[randomId]!['mistake']}, ${SqlCubit.idData[randomId]!['note']}';

        const notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_1',
            'Reminding Notifications',
            channelDescription: '',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            color: Color(0xff005154),
          ),
        );

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          notificationTitle,
          notificationBody,
          scheduledNotificationDateTime,
          notificationDetails,
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        startTime = startTime
            .add(Duration(minutes: AppBloc.timeBetweenEachNotifications));
      }

      debugPrint(
          'Recurring notifications scheduled between $startTime and $endTime');
      // await showSimpleNotification(title: 'You can smile');
    } else {
      debugPrint('Notifications are inactive');
    }
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('canceled all notifications');
  }

  static Future<bool> isAndroidPermissionGranted() async {
    bool isGranted = false;
    if (Platform.isAndroid) {
      isGranted = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
    return isGranted;
  }

  static Future<bool?> requestPermissions() async {
    bool? grantedNotificationPermission;
    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      grantedNotificationPermission = grantedNotificationPermission ?? false;
    }
    return grantedNotificationPermission;
  }

  static _didNotificationLaunchApp() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
      if (kDebugMode) {
        print('');
        print('App launched via notification');
        print(
            'Notification payload: ${notificationAppLaunchDetails.notificationResponse!.payload}');
        print('');
      }
      streamController.add(notificationAppLaunchDetails.notificationResponse!);
    }
    haha = true;
  }

  @pragma('vm:entry-point')
  static _onNotificationTap(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      print('Notification tapped');
      print('Notification payload: ${notificationResponse.payload}');
    }
    streamController.add(notificationResponse);
  }

  static DateTime _getStartDateTime(TimeOfDay notificationStartTime) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, notificationStartTime.hour,
        notificationStartTime.minute);
  }

  static DateTime _getEndDateTime(
      TimeOfDay notificationStartTime, TimeOfDay notificationEndTime) {
    if (notificationStartTime == notificationEndTime) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      return DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
          notificationStartTime.hour, notificationStartTime.minute);
    } else {
      final now = DateTime.now();
      DateTime startDateTime = DateTime(now.year, now.month, now.day,
          notificationStartTime.hour, notificationStartTime.minute);
      DateTime endDateTime = DateTime(now.year, now.month, now.day,
          notificationEndTime.hour, notificationEndTime.minute);
      Duration difference = endDateTime.difference(startDateTime);
      if (difference.inMinutes > 0) {
        return endDateTime;
      } else {
        return endDateTime.add(const Duration(days: 1));
      }
    }
  }

// static Future showSimpleNotification(
//     {String title = 'Notifications rescheduled'}) async {
//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//     'your channel id2',
//     'your channel name2',
//     channelDescription: 'your channel description',
//     importance: Importance.high,
//     priority: Priority.max,
//   );
//   const NotificationDetails notificationDetails =
//       NotificationDetails(android: androidNotificationDetails);
//   await _flutterLocalNotificationsPlugin.show(
//       0, title, 'testing', notificationDetails,
//       payload: '2, 1, 1, 1, 1, خطأ, ملاحظة');
// }
}
