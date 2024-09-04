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
    textColor: const Color(0xffFFFCFD),
    textFormFieldColor: const Color(0xff484848));

AppColors theme1 = AppColors(
    primaryColor: const Color(0xffCAE9FF),
    secondaryColor: const Color(0xffBEE9E8),
    backgroundColor: const Color(0xff1B4965),
    appBarColor: const Color(0xff62B6CB),
    textColor: const Color(0xffFFFCFD),
    //todo: change
    textFormFieldColor: const Color(0xff484848));

AppColors theme2 = AppColors(
    primaryColor: const Color(0xff656176),
    secondaryColor: const Color(0xff534D56),
    backgroundColor: const Color(0xffF8F1FF),
    appBarColor: const Color(0xff656176),
    textColor: const Color(0xff0F1515),
    textFormFieldColor: const Color(0xff484848));
