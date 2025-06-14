import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Always initialize Awesome Notifications
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  runApp(const MyApp());
}

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class NotificationController {
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
              channelKey: 'alerts',
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
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
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
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
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
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
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
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.greenAccent),
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
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            largeIcon: 'asset://assets/tadaruk_app_icon.png',
            bigPicture: '://data:image/jpeg;base64,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',
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

///  *********************************************
///     MAIN WIDGET
///  *********************************************
///
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Color mainColor = const Color(0xFF9D50DD);

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  // This widget is the root of your application.

  static const String routeHome = '/', routeNotification = '/notification-page';

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(MaterialPageRoute(
        builder: (_) =>
            const MyHomePage(title: 'Awesome Notifications Example App')));
    if (initialRouteName == routeNotification &&
        NotificationController.initialAction != null) {
      pageStack.add(MaterialPageRoute(
          builder: (_) => NotificationPage(
              receivedAction: NotificationController.initialAction!)));
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(
            builder: (_) =>
                const MyHomePage(title: 'Awesome Notifications Example App'));

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
            builder: (_) => NotificationPage(receivedAction: receivedAction));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Notifications - Simple Example',
      navigatorKey: MyApp.navigatorKey,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}

///  *********************************************
///     HOME PAGE
///  *********************************************
///
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Push the buttons below to create new notifications',
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: '1',
              onPressed: () => NotificationController.createNewNotification(),
              tooltip: 'Create New notification',
              child: const Icon(Icons.outgoing_mail),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '2',
              onPressed: () => NotificationController.scheduleNewNotification(),
              tooltip: 'Schedule New notification',
              child: const Icon(Icons.access_time_outlined),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '3',
              onPressed: () => NotificationController.resetBadgeCounter(),
              tooltip: 'Reset badge counter',
              child: const Icon(Icons.exposure_zero),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '4',
              onPressed: () => NotificationController.cancelNotifications(),
              tooltip: 'Cancel all notifications',
              child: const Icon(Icons.delete_forever),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

///  *********************************************
///     NOTIFICATION PAGE
///  *********************************************
class NotificationPage extends StatefulWidget {
  const NotificationPage({
    Key? key,
    required this.receivedAction,
  }) : super(key: key);

  final ReceivedAction receivedAction;

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  bool get hasTitle => widget.receivedAction.title?.isNotEmpty ?? false;
  bool get hasBody => widget.receivedAction.body?.isNotEmpty ?? false;
  bool get hasLargeIcon => widget.receivedAction.largeIconImage != null;
  bool get hasBigPicture => widget.receivedAction.bigPictureImage != null;

  double bigPictureSize = 0.0;
  double largeIconSize = 0.0;
  bool isTotallyCollapsed = false;
  bool bigPictureIsPredominantlyWhite = true;

  ScrollController scrollController = ScrollController();

  Future<bool> isImagePredominantlyWhite(ImageProvider imageProvider) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    final dominantColor =
        paletteGenerator.dominantColor?.color ?? Colors.transparent;
    return dominantColor.computeLuminance() > 0.5;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    if (hasBigPicture) {
      isImagePredominantlyWhite(widget.receivedAction.bigPictureImage!)
          .then((isPredominantlyWhite) => setState(() {
                bigPictureIsPredominantlyWhite = isPredominantlyWhite;
              }));
    }
  }

  void _scrollListener() {
    bool pastScrollLimit = scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 240;

    if (!hasBigPicture) {
      isTotallyCollapsed = true;
      return;
    }

    if (isTotallyCollapsed) {
      if (!pastScrollLimit) {
        setState(() {
          isTotallyCollapsed = false;
        });
      }
    } else {
      if (pastScrollLimit) {
        setState(() {
          isTotallyCollapsed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bigPictureSize = MediaQuery.of(context).size.height * .4;
    largeIconSize =
        MediaQuery.of(context).size.height * (hasBigPicture ? .16 : .2);

    if (!hasBigPicture) {
      isTotallyCollapsed = true;
    }

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: isTotallyCollapsed || bigPictureIsPredominantlyWhite
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            systemOverlayStyle:
                isTotallyCollapsed || bigPictureIsPredominantlyWhite
                    ? SystemUiOverlayStyle.dark
                    : SystemUiOverlayStyle.light,
            expandedHeight: hasBigPicture
                ? bigPictureSize + (hasLargeIcon ? 40 : 0)
                : (hasLargeIcon)
                    ? largeIconSize + 10
                    : MediaQuery.of(context).padding.top + 28,
            backgroundColor: Colors.transparent,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              centerTitle: true,
              expandedTitleScale: 1,
              collapseMode: CollapseMode.pin,
              title: (!hasLargeIcon)
                  ? null
                  : Stack(children: [
                      Positioned(
                        bottom: 0,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: hasBigPicture
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: largeIconSize,
                              width: largeIconSize,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(largeIconSize)),
                                child: FadeInImage(
                                  placeholder: const NetworkImage(
                                      'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                                  image: widget.receivedAction.largeIconImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              background: hasBigPicture
                  ? Padding(
                      padding: EdgeInsets.only(bottom: hasLargeIcon ? 60 : 20),
                      child: FadeInImage(
                        placeholder: const NetworkImage(
                            'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                        height: bigPictureSize,
                        width: MediaQuery.of(context).size.width,
                        image: widget.receivedAction.bigPictureImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : null,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          if (hasTitle)
                            TextSpan(
                              text: widget.receivedAction.title!,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          if (hasBody)
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: hasTitle ? 16.0 : 0.0,
                                ),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                        widget.receivedAction.bodyWithoutHtml ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium)),
                              ),
                            ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black12,
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.receivedAction.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
