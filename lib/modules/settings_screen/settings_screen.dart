import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadarok/modules/themes_screen/themes_screen.dart';

import '../../app_bloc/app_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  String? timetest;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        var bloc = AppBloc.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ThemesScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16).r,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
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
                            const Icon(Icons.notifications_none_rounded),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'عدد الإشعارات',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            bloc.notificationsNumber.toString(),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ],
                      ),
                      Slider(
                        value: bloc.notificationsNumber.toDouble(),
                        onChanged: (value) {
                          BlocProvider.of<AppBloc>(context).add(
                              ChangeNotificationsNumberEvent(
                                  notificationsNumber: value.toInt()));
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
                              style: Theme.of(context).textTheme.bodyLarge,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('من',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                GestureDetector(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime:
                                                bloc.notificationStartTime)
                                        .then((value) {
                                      bloc.add(
                                          ChangeNotificationsStartTimeEvent(
                                              notificationStartTime: value!));
                                    });
                                  },
                                  child: Container(
                                      width: 90.w,
                                      padding: const EdgeInsets.all(8).r,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8).r,
                                          color:
                                              Colors.white.withOpacity(0.12)),
                                      child: Center(
                                        child: Text(
                                            bloc.convertTimeToString(
                                                hour: bloc
                                                    .notificationStartTime.hour,
                                                minute: bloc
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('إلى',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                GestureDetector(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: bloc.notificationEndTime,
                                    ).then((value) {
                                      bloc.add(ChangeNotificationsEndTimeEvent(
                                          notificationEndTime: value!));
                                    });
                                  },
                                  child: Container(
                                      width: 90.w,
                                      padding: const EdgeInsets.all(8).r,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8).r,
                                          color:
                                              Colors.white.withOpacity(0.12)),
                                      child: Center(
                                        child: Text(
                                            bloc.convertTimeToString(
                                                hour: bloc
                                                    .notificationEndTime.hour,
                                                minute: bloc.notificationEndTime
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
                  Padding(
                    padding: const EdgeInsets.all(16.0).r,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Center(
                          child: Text(
                              'سيتم عرض إشعار كل ${bloc.timeBetweenEachNotifications} دقيقة تقريباً',
                              style: Theme.of(context).textTheme.displaySmall),
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
