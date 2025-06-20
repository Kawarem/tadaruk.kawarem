import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/helpers/local_notifications_helper.dart'; //todo notif
import 'package:tadaruk/modules/add_mistake_screen/add_mistake_screen.dart';
import 'package:tadaruk/modules/archived_mistakes_screen/archived_mistakes_screen.dart';
import 'package:tadaruk/modules/home_screen/expandable_app_bar/expandable_app_bar.dart';
import 'package:tadaruk/modules/home_screen/scroll_to_hide_widget.dart';
import 'package:tadaruk/modules/settings_screen/settings_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';

import 'package:tadaruk/helpers/local_awesome_notification_helper.dart';

ScrollController scrollController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.receivedAction});

  final ReceivedAction? receivedAction;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    LocalNotificationAwesomeHelper.startListeningNotificationEvents();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {
      LocalNotificationAwesomeHelper.onActionReceivedMethod(
          receivedAction, context);
    });

    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    listenToNotificationStream();
    super.initState();
    // FlutterNativeSplash.remove();

//  to listen to any notification clicked
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void listenToNotificationStream() {
    print('lolololololoolookjdklsjflakszjc;lakj;dkjf;asf');
    print(widget.receivedAction?.title);
    print(widget.receivedAction?.payload);

    //print(widget.receivedAction);
    /*
    LocalNotificationsHelper.streamController.stream
        .listen((notificationResponse) async {
      if (kDebugMode) {
        print(notificationResponse.payload!.toString());
      }
      */ /*showMistakeDialogWhenAppLunchedThroughNotification(
          context, notificationResponse.payload!);*/ /*
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Color gradiantAnimationColor = Theme.of(context).primaryColor;

    return bloc.BlocBuilder<SqlCubit, SqlState>(
      builder: (context, state) {
        var sqlCubit = SqlCubit.get(context);
        return bloc.BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(children: [
                ExpandableAppBar(
                  expandedWidget: FutureBuilder<String>(
                    future: RandomAhadithPicker().getRandomAhadith(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        debugPrint('${snapshot.error}');
                        return const SizedBox();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'قال ﷺ :{${snapshot.data}}',
                            style: Theme.of(context).textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                        );
                      }
                    },
                  ),
                  colors: [
                    HSLColor.fromColor(gradiantAnimationColor)
                        .withLightness(
                            (HSLColor.fromColor(gradiantAnimationColor)
                                            .lightness +
                                        0.2 >=
                                    1)
                                ? (HSLColor.fromColor(gradiantAnimationColor)
                                        .lightness -
                                    0.2)
                                : (HSLColor.fromColor(gradiantAnimationColor)
                                        .lightness +
                                    0.2))
                        .toColor(),
                    HSLColor.fromColor(gradiantAnimationColor)
                        .withHue(
                            (HSLColor.fromColor(gradiantAnimationColor).hue +
                                    27) %
                                360)
                        .toColor()
                  ],
                  collapsedWidget: Text(
                    'تدارُك',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => SettingsScreen(),
                              transition: Transition.leftToRightWithFade);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Theme.of(context).appBarTheme.iconTheme!.color,
                        )),
                    IconButton(
                        onPressed: () {
                          Get.to(() => const ArchivedMistakesScreen(),
                              transition: Transition.leftToRightWithFade);
                        },
                        icon: Icon(
                          Icons.archive_outlined,
                          color: Theme.of(context).appBarTheme.iconTheme!.color,
                        )),
                    ((kDebugMode)
                        ? IconButton(
                            onPressed: () {
                              //LocalNotificationsHelper.showSimpleNotification();
                              LocalNotificationAwesomeHelper
                                  .createNewNotification();
                            },
                            icon: Icon(
                              Icons.notification_important_outlined,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme!
                                  .color,
                            ))
                        : const SizedBox()),
                  ],
                  sliverList: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return expansionTiles(context,
                          model: AppBloc.displayDataInHomeScreen[index],
                          sqlCubit: sqlCubit,
                          isArchived: false);
                    }, childCount: AppBloc.displayDataInHomeScreen.length),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ScrollToHideWidget(
                      controller: scrollController,
                      height: 43.h,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              bloc.BlocProvider.of<AppBloc>(context)
                                  .resetAddMistakeScreen();
                              Get.to(
                                  () => const AddMistakeScreen(
                                        isEdit: false,
                                      ),
                                  transition: Transition.fade);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder()),
                            child: Text(
                              'إضافة تنبيه',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                                  .primaryColor
                                                  .computeLuminance() <
                                              0.5
                                          ? const Color(0xffefefef)
                                          : const Color(0xff1d1d1d)),
                            )),
                      ),
                    )),
              ]),
            );
          },
        );
      },
    );
  }
}
