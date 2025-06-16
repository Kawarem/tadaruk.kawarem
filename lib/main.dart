/// بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ
library;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tadaruk/helpers/image_utils.dart';
import 'package:tadaruk/helpers/local_notifications_helper.dart'; //todo notif
import 'package:tadaruk/modules/home_screen/home_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:tadaruk/theme/theme_bloc/theme_bloc.dart';

import 'helpers/local_awesome_notification_helper.dart';
import 'helpers/my_bloc_observer.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // Always initialize Awesome Notifications
  await LocalNotificationAwesomeHelper.initializeLocalNotifications();
  await LocalNotificationAwesomeHelper.initializeIsolateReceivePort();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await ScreenUtil.ensureScreenSize();
  ImageUtils.svgPrecacheImage();
  await LocalNotificationsHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static ReceivedAction receivedAction = ReceivedAction();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      ThemeBloc()..add(GetCurrentThemeEvent())),
              BlocProvider(
                  create: (create) => SqlCubit()..ensureDatabaseInitialized()),
              BlocProvider(
                  create: (create) => AppBloc()
                    ..add(GetSettingsDataFromSharedPreferencesEvent())),
            ],
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                if (state is LoadedThemeState) {
                  return BlocBuilder<SqlCubit, SqlState>(
                    builder: (context, sqlState) {
                      return GetMaterialApp(
                        supportedLocales: const [
                          Locale('ar'),
                        ],
                        locale: const Locale('ar'),
                        localizationsDelegates: const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate
                        ],
                        theme: state.themeData,
                        debugShowCheckedModeBanner: false,
                        title: 'تدارًك',
                        home: HomeScreen(receivedAction: receivedAction),
                      );
                    },
                  );
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 300,
                );
              },
            ),
          );
        });
  }
}
