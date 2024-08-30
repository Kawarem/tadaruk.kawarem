import 'package:flutter/material.dart';

Color TOAST_BACKGROUND_COLOR = const Color(0xff373737).withOpacity(0.5);

class AppColors {
  Color primaryColor;
  Color secondaryColor;
  Color backgroundColor;
  Color appBarColor;
  Color textColor;
  Color textFormFieldColor;

  AppColors(
      {required this.primaryColor,
      required this.secondaryColor,
      required this.backgroundColor,
      required this.appBarColor,
      required this.textColor,
      required this.textFormFieldColor});
}

AppColors theme0 = AppColors(
    primaryColor: const Color(0xff12a36c),
    secondaryColor: const Color(0xff12a36c),
    backgroundColor: const Color(0xff0A2429),
    appBarColor: const Color(0xff12a36c),
    textColor: Colors.white,
    textFormFieldColor: const Color(0xff484848));

AppColors theme1 = AppColors(
    primaryColor: const Color(0xff12a36c),
    secondaryColor: const Color(0xff12a36c),
    backgroundColor: Colors.white,
    appBarColor: const Color(0xff12a36c),
    textColor: Colors.black,
    textFormFieldColor: const Color(0xff484848));
