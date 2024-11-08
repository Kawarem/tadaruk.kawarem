import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadaruk/constants/colors.dart';

enum AppTheme {
  theme0("Dark Green"),
  theme1("Dark Blue"),
  theme2("Light Purple"),
  theme3("Light Pale Blue"),
  theme4("Dark Purple"),
  theme5("Light Pale Green"),
  theme6("Maron"),
  theme7("Pale Red");

  const AppTheme(this.name);

  final String name;
}

final appThemeData = {
  AppTheme.theme0: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme0.appBarColor,
        titleTextStyle: TextStyle(
            color: theme0.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme0.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme0.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme0.primaryColor,
    canvasColor: theme0.primaryColor,
    scaffoldBackgroundColor: theme0.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme0.primaryColor,
      secondary: theme0.primaryColor,
    ),
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
      titleMedium:
          TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
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
      // trackOutlineColor:
      // WidgetStateProperty.resolveWith(
      //       (final Set<WidgetState> states) {
      //     if (states
      //         .contains(WidgetState.selected)) {
      //       return theme0.primaryColor;
      //     } else {
      //       return null;
      //     }
      //   },
      // ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme1: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme1.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme1.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme1.primaryColor,
    canvasColor: theme1.primaryColor,
    scaffoldBackgroundColor: theme1.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme1.primaryColor,
      secondary: theme1.primaryColor,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 14.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 12.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE),
          fontSize: 14.sp,
          fontFamily: 'Rubik',
          overflow: TextOverflow.ellipsis),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme1.primaryColor,
      inactiveTrackColor: const Color(0xff005154),
      inactiveTickMarkColor: const Color(0xff02786a),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme1.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme1.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme1.primaryColor
                : theme1.textColor),
        filled: true,
        fillColor: theme1.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme1.primaryColor,
        foregroundColor: theme1.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff275978).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff275978).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff275978),
      backgroundColor: const Color(0xff275978),
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
            return theme1.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme2: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme2.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme2.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme2.primaryColor,
    canvasColor: theme2.primaryColor,
    scaffoldBackgroundColor: theme2.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme2.primaryColor,
      secondary: theme2.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme2.textColor, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall: TextStyle(
          color: const Color(0xff0F1515), fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge: TextStyle(
          color: const Color(0xffFFFCFD), fontSize: 24.sp, fontFamily: 'Rubik'),
      titleMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme2.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme2.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme2.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme2.primaryColor
                : theme2.textColor),
        filled: true,
        fillColor: theme2.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme2.primaryColor,
        foregroundColor: theme2.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xffe5dfec).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xffe5dfec).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xffe5dfec),
      backgroundColor: const Color(0xffe5dfec),
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
            return theme2.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme3: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme3.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme3.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme3.primaryColor,
    canvasColor: theme3.primaryColor,
    scaffoldBackgroundColor: theme3.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme3.primaryColor,
      secondary: theme3.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme3.textColor, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall: TextStyle(
          color: const Color(0xff0F1515), fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge: TextStyle(
          color: const Color(0xffFFFCFD), fontSize: 24.sp, fontFamily: 'Rubik'),
      titleMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme3.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme3.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme3.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme3.primaryColor
                : theme3.textColor),
        filled: true,
        fillColor: theme3.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme3.primaryColor,
        foregroundColor: theme3.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff4a57aa).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff4a57aa).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff4a57aa),
      backgroundColor: const Color(0xff4a57aa),
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
            return theme3.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme4: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme4.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme4.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme4.primaryColor,
    canvasColor: theme4.primaryColor,
    scaffoldBackgroundColor: theme4.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme4.primaryColor,
      secondary: theme4.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme4.textColor, // Set the desired icon color
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
      titleMedium:
          TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme4.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme4.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme4.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme4.primaryColor
                : theme4.textColor),
        filled: true,
        fillColor: theme4.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme4.primaryColor,
        foregroundColor: theme4.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff695dc6).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff695dc6).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff695dc6),
      backgroundColor: const Color(0xff695dc6),
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
            return theme4.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme5: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme5.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme5.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme5.primaryColor,
    canvasColor: theme5.primaryColor,
    scaffoldBackgroundColor: theme5.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme5.primaryColor,
      secondary: theme5.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme5.textColor, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall: TextStyle(
          color: const Color(0xff0F1515), fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge: TextStyle(
          color: const Color(0xffFFFCFD), fontSize: 24.sp, fontFamily: 'Rubik'),
      titleMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme5.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme5.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme5.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme5.primaryColor
                : theme5.textColor),
        filled: true,
        fillColor: theme5.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme5.primaryColor,
        foregroundColor: theme5.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff467690).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff467690).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff467690),
      backgroundColor: const Color(0xff467690),
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
            return theme5.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme6: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme6.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme6.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme6.primaryColor,
    canvasColor: theme6.primaryColor,
    scaffoldBackgroundColor: theme6.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme6.primaryColor,
      secondary: theme6.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme6.textColor, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall: TextStyle(
          color: const Color(0xff0F1515), fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge: TextStyle(
          color: const Color(0xffFFFCFD), fontSize: 24.sp, fontFamily: 'Rubik'),
      titleMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme6.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme6.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme6.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme6.primaryColor
                : theme6.textColor),
        filled: true,
        fillColor: theme6.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme6.primaryColor,
        foregroundColor: theme6.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff748f4d).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff748f4d).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff748f4d),
      backgroundColor: const Color(0xff748f4d),
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
            return theme6.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
  AppTheme.theme7: ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: theme7.appBarColor,
        titleTextStyle: TextStyle(
            color: theme1.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik'),
        iconTheme: IconThemeData(color: theme1.textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: theme7.backgroundColor,
            statusBarIconBrightness: Brightness.light)),
    primaryColor: theme7.primaryColor,
    canvasColor: theme7.primaryColor,
    scaffoldBackgroundColor: theme7.backgroundColor,
    splashColor: Colors.white.withOpacity(0.12),
    highlightColor: Colors.white.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: theme7.primaryColor,
      secondary: theme7.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: theme7.textColor, // Set the desired icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      bodyMedium: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 14.sp, fontFamily: 'Rubik'),
      bodySmall: TextStyle(
          color: const Color(0xffC9C9C9), fontSize: 12.sp, fontFamily: 'Rubik'),
      displayLarge: TextStyle(
          color: const Color(0xff0F1515), fontSize: 18.sp, fontFamily: 'Rubik'),
      displayMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 16.sp, fontFamily: 'Rubik'),
      displaySmall: TextStyle(
          color: const Color(0xff0F1515), fontSize: 12.sp, fontFamily: 'Rubik'),
      headlineLarge: TextStyle(
          color: const Color(0xffFFFCFD), fontSize: 24.sp, fontFamily: 'Rubik'),
      titleMedium: TextStyle(
          color: const Color(0xff0F1515), fontSize: 14.sp, fontFamily: 'Rubik'),
      headlineMedium: TextStyle(
          color: const Color(0xffCACACE), fontSize: 14.sp, fontFamily: 'Rubik'),
      labelLarge: TextStyle(
          color: const Color(0xffC9C9C9),
          fontSize: 24.sp,
          fontFamily: 'Uthmani'),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: theme7.primaryColor,
      inactiveTrackColor: const Color(0xff534D56),
      inactiveTickMarkColor: const Color(0xff816e8d),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme7.textColor, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: theme7.primaryColor),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? theme7.primaryColor
                : theme7.textColor),
        filled: true,
        fillColor: theme7.textFormFieldColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme7.primaryColor,
        foregroundColor: theme7.textColor,
        minimumSize: Size(170.w, 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: const Color(0xff4a4b70).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      iconColor: const Color(0xff4a4b70).computeLuminance() < .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      shape: const Border(),
      collapsedBackgroundColor: const Color(0xff4a4b70),
      backgroundColor: const Color(0xff4a4b70),
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
            return theme7.primaryColor;
          } else {
            return const Color(0xff9a999e);
          }
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
    ),
  ),
  //---------------------------------------------------------------
};
