// بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tadarok/app_bloc/app_bloc.dart';
import 'package:tadarok/modules/home_screen/home_screen.dart';
import 'package:tadarok/theme/bloc/theme_bloc.dart';

import 'helpers/my_bloc_observer.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                create: (context) => ThemeBloc()..add(GetCurrentThemeEvent()),
              ),
              BlocProvider(create: (create) => AppBloc())
            ],
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                if (state is LoadedThemeState) {
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
                    home: const HomeScreen(),
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
