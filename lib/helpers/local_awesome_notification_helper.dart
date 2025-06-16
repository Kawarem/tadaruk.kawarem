import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class LocalNotificationAwesomeHelper {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/ic_stat_custom_svg', //
        [
          NotificationChannel(
              channelKey: 'channel_1',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.greenAccent,
              ledColor: Colors.greenAccent)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    /*AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);*/
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction, BuildContext context) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        print(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    print(receivedAction.payload);
    MyApp.receivedAction = receivedAction;
    print(MyApp.receivedAction.payload);
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    //todo set GIF
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('السماح بالإشعارات',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'يرجى السماح بالإشعارات، بغرض التذكير بالتنبيهات للتدارك!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'رفض',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'سماح',
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'channel_1',
            title: 'Huston! The eagle hasfds  landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            largeIcon: 'asset://assets/notification_icons/png/sign4c.png',
            bigPicture: 'https://legacy.quran.com/images/ayat_retina/33_21.png',
            //icon: 'asset://assets/tadaruk_app_icon.png',
            //color: Colors.amber,
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await myNotifyScheduleInHours(
        title: 'test',
        msg: 'test message',
        heroThumbUrl:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        hoursFromNow: 5,
        username: 'test user',
        repeatNotif: false);
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future<void> scheduleRecurringNotifications() async {
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

        //todo push notification

        bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
        if (!isAllowed) isAllowed = await displayNotificationRationale();
        if (!isAllowed) return;
        String localTimeZone =
            await AwesomeNotifications().getLocalTimeZoneIdentifier();

        await AwesomeNotifications().createNotification(
            schedule: NotificationInterval(
                timeZone: localTimeZone, interval: null, allowWhileIdle: true),
            content: NotificationContent(
                id: i, // -1 is replaced by a random number
                channelKey: 'channel_1',
                title: notificationTitle,
                body: notificationBody,
                largeIcon: 'asset://assets/notification_icons/png/sign4c.png',
                bigPicture:
                    'https://legacy.quran.com/images/ayat_retina/33_5.png',
                //icon: 'asset://assets/tadaruk_app_icon.png',
                //color: Colors.amber,
                //'asset://assets/images/balloons-in-sky.jpg',
                notificationLayout: NotificationLayout.BigPicture,
                payload: {'payload_ID': payload}),
            actionButtons: [
              NotificationActionButton(key: 'REDIRECT', label: 'مراجعة'),
              /*NotificationActionButton(
                  key: 'REPLY',
                  label: 'Reply Message',
                  requireInputText: true,
                  actionType: ActionType.SilentAction),*/
              NotificationActionButton(
                  key: 'DISMISS',
                  label: 'تجاهل',
                  actionType: ActionType.DismissAction,
                  isDangerousOption: true)
            ]);

        /*
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


        */
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
}

Future<void> myNotifyScheduleInHours({
  required int hoursFromNow,
  required String heroThumbUrl,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar(
      //weekday: nowDate.day,
      hour: nowDate.hour,
      minute: 0,
      second: nowDate.second,
      repeats: repeatNotif,
      //allowWhileIdle: true,
    ),
    // schedule: NotificationCalendar.fromDate(
    //    date: DateTime.now().add(const Duration(seconds: 10))),
    content: NotificationContent(
      id: -1,
      channelKey: 'basic_channel',
      title: '${Emojis.food_bowl_with_spoon} $title',
      body: '$username, $msg',
      bigPicture: heroThumbUrl,
      notificationLayout: NotificationLayout.BigPicture,
      //actionType : ActionType.DismissAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'NOW',
        label: 'btnAct1',
      ),
      NotificationActionButton(
        key: 'LATER',
        label: 'btnAct2',
      ),
    ],
  );
}
