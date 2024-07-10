import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadarok/modules/themes_screen/themes_screen.dart';
import 'package:tadarok/state_management/app_bloc/app_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        var appBloc = AppBloc.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
          ),
          body: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const ThemesScreen(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16).r,
                          child: Row(
                            children: [
                              const Icon(Icons.storefront),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'الثيمات',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios_rounded),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8)
                            .r,
                        child: Row(
                          children: [
                            Icon(appBloc.isNotificationsActivated
                                ? Icons.notifications_active_outlined
                                : Icons.notifications_off_outlined),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'تفعيل الإشعارات',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Switch(
                                      value: appBloc.isNotificationsActivated,
                                      onChanged: (isNotificationsActivated) {
                                        appBloc.add(
                                            ChangeNotificationsActivationEvent(
                                                isNotificationsActivated:
                                                    isNotificationsActivated));
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: appBloc.isNotificationsActivated ? 1 : 0.5,
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8)
                                  .r,
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_none_rounded),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Text(
                                    'عدد الإشعارات',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appBloc.notificationsNumber.toString(),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                            Slider(
                              value: appBloc.notificationsNumber.toDouble(),
                              onChanged: (value) {
                                if (appBloc.isNotificationsActivated) {
                                  appBloc.add(ChangeNotificationsNumberEvent(
                                      notificationsNumber: value));
                                }
                              },
                              min: 1,
                              max: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8)
                                  .r,
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Text(
                                    'فترة فعالية الإشعارات',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                      horizontal: 56.0, vertical: 8)
                                  .r,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('من',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      GestureDetector(
                                        onTap: () {
                                          if (appBloc
                                              .isNotificationsActivated) {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime: appBloc
                                                        .notificationStartTime)
                                                .then((value) {
                                              appBloc.add(
                                                  ChangeNotificationsStartTimeEvent(
                                                      notificationStartTime:
                                                          value!));
                                            });
                                          }
                                        },
                                        child: Container(
                                            width: 90.w,
                                            padding: const EdgeInsets.all(8).r,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8).r,
                                                color: Colors.white
                                                    .withOpacity(0.12)),
                                            child: Center(
                                              child: Text(
                                                  appBloc.convertTimeToString(
                                                      hour: appBloc
                                                          .notificationStartTime
                                                          .hour,
                                                      minute: appBloc
                                                          .notificationStartTime
                                                          .minute),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('إلى',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      GestureDetector(
                                        onTap: () {
                                          if (appBloc
                                              .isNotificationsActivated) {
                                            showTimePicker(
                                              context: context,
                                              initialTime:
                                                  appBloc.notificationEndTime,
                                            ).then((value) {
                                              appBloc.add(
                                                  ChangeNotificationsEndTimeEvent(
                                                      notificationEndTime:
                                                          value!));
                                            });
                                          }
                                        },
                                        child: Container(
                                            width: 90.w,
                                            padding: const EdgeInsets.all(8).r,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8).r,
                                                color: Colors.white
                                                    .withOpacity(0.12)),
                                            child: Center(
                                              child: Text(
                                                  appBloc.convertTimeToString(
                                                      hour: appBloc
                                                          .notificationEndTime
                                                          .hour,
                                                      minute: appBloc
                                                          .notificationEndTime
                                                          .minute),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0).r,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        AnimatedOpacity(
                          opacity: appBloc.isNotificationsActivated ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Center(
                            child: Text(
                                'سيتم عرض إشعار كل ${appBloc.timeBetweenEachNotifications} دقيقة تقريباً',
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
