import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadarok/constants/colors.dart';

enum AppTheme {
  greenDark("Green Dark"),
  greenLight("Green Light"),
  redDark("Red Dark");

  const AppTheme(this.name);

  final String name;
}

final appThemeData = {
  AppTheme.greenDark: ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: theme0.appBarColor,
      titleTextStyle: TextStyle(
          color: theme0.textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Rubik'),
      iconTheme: IconThemeData(color: theme0.textColor),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarBrightness: Brightness.light,
      // systemNavigationBarColor: theme0.backgroundColor,
      // systemNavigationBarIconBrightness: Brightness.light,
      //   //statusBarColor: greenDark.appBarColor
      // )
    ),
    primaryColor: theme0.primaryColor,
    canvasColor: theme0.primaryColor,
    scaffoldBackgroundColor: theme0.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
        primary: theme0.primaryColor, secondary: Colors.grey[400]!),
    iconTheme: const IconThemeData(
      color: Colors.white, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge:
          TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge:
          TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium:
          TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall:
          TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge:
          TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Rubik'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme0.primaryColor,
      inactiveTrackColor: const Color(0xff005154),
      inactiveTickMarkColor: const Color(0xff02786a),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme0.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme0.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme0.primaryColor
                : theme0.textColor),
        filled: true,
        fillColor: theme0.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme0.primaryColor,
        foregroundColor: theme0.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: const RoundedRectangleBorder(),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: theme0.textColor,
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff023b3d),
      backgroundColor: const Color(0xff023b3d),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xffbdbdbd),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          } else {
            return Colors.white;
          }
        },
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return theme0.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
  ),
  AppTheme.greenLight: ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: theme1.appBarColor,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: theme1.appBarColor)),
      primaryColor: theme1.primaryColor,
      scaffoldBackgroundColor: theme1.backgroundColor),
  AppTheme.redDark: ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.red[700]),
    brightness: Brightness.dark,
    primaryColor: Colors.red[700],
  ),
};
