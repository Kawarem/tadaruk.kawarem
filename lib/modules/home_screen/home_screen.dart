import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/helpers/local_notifications_helper.dart';
import 'package:tadaruk/modules/add_mistake_screen/add_mistake_screen.dart';
import 'package:tadaruk/modules/archived_mistakes_screen/archived_mistakes_screen.dart';
import 'package:tadaruk/modules/home_screen/expandable_app_bar/expandable_app_bar.dart';
import 'package:tadaruk/modules/home_screen/scroll_to_hide_widget.dart';
import 'package:tadaruk/modules/settings_screen/settings_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';

ScrollController scrollController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

//  to listen to any notification clicked
    listenToNotificationStream();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void listenToNotificationStream() {
    LocalNotificationsHelper.streamController.stream
        .listen((notificationResponse) async {
      if (kDebugMode) {
        print(notificationResponse.payload!.toString());
      }
      showMistakeDialogWhenAppLunchedThroughNotification(
          context, notificationResponse.payload!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<SqlCubit, SqlState>(
      builder: (context, state) {
        var sqlCubit = SqlCubit.get(context);
        return bloc.BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(children: [
                ExpandableAppBar(
                  expandedWidget: Text(
                    'مساعدك في المراجعة',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  colors: const [Color(0xff75BCD1), Color(0xff70C42F)],
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
                          Get.to(() => ArchivedMistakesScreen(),
                              transition: Transition.leftToRightWithFade);
                        },
                        icon: Icon(
                          Icons.archive_outlined,
                          color: Theme.of(context).appBarTheme.iconTheme!.color,
                        )),
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
                              style: Theme.of(context).textTheme.displayLarge,
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
