// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tadaruk/constants/colors.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/helpers/local_notifications_helper.dart';
import 'package:tadaruk/modules/backup_and_restore_screen/backup_and_restore_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final Uri _url = Uri.parse(TELEGRAM_CHANNEL_LINK);

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        var appBloc = AppBloc.get(context);
        var sqlCubit = SqlCubit.get(context);
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
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(() => const ThemesScreen(),
                      //         transition: Transition.leftToRightWithFade);
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16).r,
                      //     child: Row(
                      //       children: [
                      //         const Icon(Icons.storefront),
                      //         SizedBox(
                      //           width: 16.w,
                      //         ),
                      //         Text(
                      //           'الثيمات',
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //         const Expanded(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.end,
                      //             children: [
                      //               Icon(Icons.arrow_forward_ios_rounded),
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8)
                            .r,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            _activateNotificationsLogic(
                                !AppBloc.isNotificationsActivated, appBloc);
                          },
                          child: Row(
                            children: [
                              Icon(AppBloc.isNotificationsActivated
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
                                      value: AppBloc.isNotificationsActivated,
                                      onChanged:
                                          (isNotificationsActivated) async {
                                        await _activateNotificationsLogic(
                                            isNotificationsActivated, appBloc);
                                        if (isNotificationsActivated) {
                                          await Permission.scheduleExactAlarm
                                              .request();
                                          // await AndroidAlarmManager.periodic(
                                          //     const Duration(seconds: 1),
                                          //     0,
                                          //     callback);
                                        } else {
                                          // await AndroidAlarmManager.cancel(0);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: AppBloc.isNotificationsActivated ? 1 : 0.5,
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
                                  AppBloc.notificationsNumber.toString(),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                            Slider(
                              value: AppBloc.notificationsNumber.toDouble(),
                              onChanged: (value) {
                                if (AppBloc.isNotificationsActivated) {
                                  appBloc.add(ChangeNotificationsNumberEvent(
                                      notificationsNumber: value));
                                }
                              },
                              min: 1,
                              max: 30,
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
                                          if (AppBloc
                                              .isNotificationsActivated) {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime: AppBloc
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
                                                      hour: AppBloc
                                                          .notificationStartTime
                                                          .hour,
                                                      minute: AppBloc
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
                                          if (AppBloc
                                              .isNotificationsActivated) {
                                            showTimePicker(
                                              context: context,
                                              initialTime:
                                                  AppBloc.notificationEndTime,
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
                                                      hour: AppBloc
                                                          .notificationEndTime
                                                          .hour,
                                                      minute: AppBloc
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
                      InkWell(
                        onTap: () async {
                          await Share.share(
                              '''تطبيق تدارُك - الحل الأمثل لإدارة عملية المراجعة الذاتية\n
هل تواجه صعوبة في تتبع أخطائك أثناء حفظ القرآن الكريم والاحتفاظ بها لإعادة المراجعة؟ تطبيق تدارُك هو الحل الذي تحتاجه!\n
تطبيق تدارُك يمنحك تجربة مراجعة ذاتية فريدة من نوعها، حيث يمكنك بسهولة تسجيل وتخزين أخطاءك لمراجعتها لاحقًا. ما عليك سوى إدخال الأخطاء في التطبيق، وسيقوم بتنظيمها وحفظها بشكل آمن.\n
لكن الأمر لا ينتهي هنا! تطبيق تدارُك يذهب إلى أبعد من ذلك بدعمه لإشعارات تذكرك بأخطائك لمراجعتها. ما عليك سوى ضبط الفترات الزمنية التي تناسبك، والتطبيق سيرسل إشعارات في الوقت المناسب لتذكيرك بمراجعة أخطائك.\n
وللمزيد من التخصيص، يمكنك اختيار ألوان التطبيق بما يتناسب مع ذوقك الشخصي. كما يوفر لك إمكانية عمل نسخة احتياطية لأخطائك، لضمان عدم فقدانها.\n
كل هذه الميزات مدمجة في تصميم جميل وسهل التفاعل، ليمنحك تجربة مراجعة ذاتية سلسة وممتعة.\n
قم بتنزيل تطبيق تدارُك الآن واكتشف الفرق الذي سيحدثه في عملية مراجعتك الذاتية!
لتحميل التطبيق اضغط على الرابط التالي: $TELEGRAM_CHANNEL_LINK''');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16).r,
                          child: Row(
                            children: [
                              const Icon(Icons.share_outlined),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'مشاركة التطبيق',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(_url)) {
                            await launchUrl(_url);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16).r,
                          child: Row(
                            children: [
                              const Icon(Icons.update_rounded),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'التحقق من وجود تحديثات',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.to(() => const BackupAndRestoreScreen(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16).r,
                          child: Row(
                            children: [
                              const Icon(Icons.backup_outlined),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'النسخ الاحتياطي والاستعادة',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16).r,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  'حول',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 36.w,
                                ),
                                Text(
                                  'الإصدار $VERSION',
                                  style: Theme.of(context).textTheme.bodySmall,
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
                        AnimatedOpacity(
                          opacity: AppBloc.isNotificationsActivated ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Center(
                            child: Text(
                                'سيتم عرض إشعار كل ${AppBloc.timeBetweenEachNotifications} دقيقة',
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

  Future<void> _activateNotificationsLogic(
      bool isNotificationsActivated, AppBloc appBloc) async {
    if (isNotificationsActivated) {
      bool areNotificationsEnabled =
          await LocalNotificationsHelper.isAndroidPermissionGranted();
      if (areNotificationsEnabled) {
        if (SqlCubit.notificationsIdsList.isEmpty) {
          Vibration.vibrate(duration: 50);
          Fluttertoast.cancel();
          Fluttertoast.showToast(
              msg: 'يرجى إضافة خطأ لتفعيل الإشعارات',
              backgroundColor: TOAST_BACKGROUND_COLOR);
        } else {
          appBloc.add(ChangeNotificationsActivationEvent(
              isNotificationsActivated: isNotificationsActivated));
          Fluttertoast.cancel();
          Fluttertoast.showToast(
              msg: 'تم تفعيل الإشعارات',
              backgroundColor: TOAST_BACKGROUND_COLOR);
        }
      } else {
        Vibration.vibrate(duration: 50);
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: 'يرجى تفعيل الإشعارات',
            backgroundColor: TOAST_BACKGROUND_COLOR);
        LocalNotificationsHelper.requestPermissions();
      }
    } else {
      appBloc.add(ChangeNotificationsActivationEvent(
          isNotificationsActivated: isNotificationsActivated));
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'تم إلغاء تفعيل الإشعارات',
          backgroundColor: TOAST_BACKGROUND_COLOR);
    }
  }
}

// @pragma('vm:entry-point')
// void callback() async {
//   await LocalNotificationsHelper.scheduleRecurringNotifications();
// }
