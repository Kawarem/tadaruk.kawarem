import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marqueer/marqueer.dart';
import 'package:quran/quran.dart' as quran;
import 'package:tadaruk/constants/colors.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/modules/add_mistake_screen/add_mistake_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:vibration/vibration.dart';

Widget categoryButtonInHomeScreen(context,
        {required String title, required int index}) =>
    GestureDetector(
      onTap: () {
        bloc.BlocProvider.of<AppBloc>(context).add(
            ChangeDisplayTypeInHomeScreenEvent(displayTypeInHomeScreen: index));
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45).r,
          color: Color.lerp(
              !(AppBloc.displayTypeInHomeScreen == index)
                  ? Colors.white
                  : Theme.of(context).appBarTheme.backgroundColor,
              (AppBloc.displayTypeInHomeScreen == index)
                  ? Colors.white
                  : Theme.of(context).appBarTheme.backgroundColor,
              1),
        ),
        duration: const Duration(milliseconds: 250),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
            fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily,
            color: Color.lerp(
                !(AppBloc.displayTypeInHomeScreen == index)
                    ? Theme.of(context).appBarTheme.backgroundColor
                    : Colors.white,
                (AppBloc.displayTypeInHomeScreen == index)
                    ? Theme.of(context).appBarTheme.backgroundColor
                    : Theme.of(context)
                                .appBarTheme
                                .backgroundColor!
                                .computeLuminance() <
                            0.5
                        ? const Color(0xffefefef)
                        : const Color(0xff1d1d1d),
                1),
          ),
          duration: const Duration(milliseconds: 250),
          child: Text(title),
        ),
      ),
    );

Widget expansionTiles(context,
    {required List<Map<String, dynamic>> model,
    required SqlCubit sqlCubit,
    required bool isArchived}) {
  String title = '';
  String message = '';
  int index = 0;
  switch (AppBloc.displayTypeInHomeScreen) {
    case 0:
      title = 'سورة ${model[0]['surah']}';
      message =
          'تنفيذ الإجراء التالي على جميع تنبيهات سورة ${model[0]['surah']}'
          '${(isArchived) ? ' المؤرشفة' : ''}'
          '؟';
      index = model[0]['surah_number'];
    case 1:
      title = 'الصفحة ${model[0]['page_number']}';
      message =
          'تنفيذ الإجراء التالي على جميع تنبيهات الصفحة ${model[0]['page_number']}؟';
      index = model[0]['page_number'];
    case 2:
      title = 'الجزء ${model[0]['juz_number']}';
      message =
          'تنفيذ الإجراء التالي على جميع تنبيهات الجزء ${model[0]['juz_number']}؟';
      index = model[0]['juz_number'];
    case 3:
      title = mistakeKinds[model[0]['mistake_kind'] - 1];
      message = 'تنفيذ الإجراء التالي على جميع التنبيهات من النوع ($title)؟';
      index = model[0]['mistake_kind'];
    case 4:
      switch (model[0]['mistake_repetition']) {
        case 1:
          title = 'الأقل تكراراً';
        case 2:
          title = 'قليل التكرار';
        case 3:
          title = 'كثير التكرار';
        case 4:
          title = 'الأكثر تكراراً';
      }
      message = 'تنفيذ الإجراء التالي على جميع تنبيهات نوع التكرار ($title)؟';
      index = model[0]['mistake_repetition'];
  }

  return GestureDetector(
    onLongPress: () {
      showActionDialog(context,
          sqlCubit: sqlCubit,
          message: message,
          isDeleteMessage: false,
          isArchived: isArchived, onArchiveFunction: () async {
        await sqlCubit.archiveAndUnarchiveAllMistakesFor(context,
            isArchived: isArchived, index: index);
        Get.back();
      }, onDeleteFunction: () async {
        await sqlCubit.deleteAllMistakesFor(context,
            index: index, isArchived: isArchived);
        Get.back();
      }, onCancelFunction: () {
        Get.back();
      });
      Vibration.vibrate(duration: 40);
    },
    child: ExpansionTile(
      collapsedIconColor: Theme.of(context)
                  .expansionTileTheme
                  .backgroundColor!
                  .computeLuminance() <
              .5
          ? const Color(0xffefefef)
          : const Color(0xff1d1d1d),
      // Check whether to show svg or text based on the category chosen
      title: (AppBloc.displayTypeInHomeScreen == 0)
          ? SvgPicture.asset(
              'assets/svgs/surah_names/Surah_${model[0]['surah_number']}_of_114_(modified).svg',
              width: 90.w,
              height: 30.h,
              alignment: AlignmentDirectional.topStart,
              color: Theme.of(context)
                          .expansionTileTheme
                          .backgroundColor!
                          .computeLuminance() <
                      .5
                  ? const Color(0xffefefef)
                  : const Color(0xff1d1d1d),
            )
          : Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
      onExpansionChanged: (isExpanded) {
        if (!isExpanded) {
          bloc.BlocProvider.of<AppBloc>(context)
              .add(ExpansionTileCollapsedEvent());
        }
      },
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isEven) {
                      return mistakeCard(
                        context,
                        id: model[index ~/ 2]['mistake_id'],
                        category: AppBloc.displayTypeInHomeScreen,
                        sqlCubit: sqlCubit,
                        isArchived: isArchived,
                      );
                    }
                    return Container(
                      width: double.infinity,
                      height: 1.h,
                      color: const Color(0xffbdbdbd),
                    );
                  },
                  childCount: math.max(0, model.length * 2 - 1),
                ),
              ),
            ],
          ),
        ),
        // ])
      ],
    ),
  );
}

Widget mistakeCard(
  context, {
  required int id,
  required int category,
  required SqlCubit sqlCubit,
  required bool isArchived,
}) {
  final int surahNumber = SqlCubit.idData[id]!['surah_number'];
  final String mistake = SqlCubit.idData[id]!['mistake'];
  final int mistakeKind = SqlCubit.idData[id]!['mistake_kind'];
  final int verseNumber = SqlCubit.idData[id]!['verse_number'];
  final int mistakeRepetition = SqlCubit.idData[id]!['mistake_repetition'];
  final String note = SqlCubit.idData[id]!['note'];

  String mistakeKindText;
  switch (mistakeKind) {
    case 1:
      mistakeKindText = 'تنبيه كلّي في الآية:  ';
    case 2:
      mistakeKindText = 'هي نقص في الآية:  ';
    case 3:
      mistakeKindText = 'هي زيادة في الآية:  ';
    case 4:
      mistakeKindText = 'تنبيه تشكيلي في الآية:  ';
    default:
      mistakeKindText = 'هي إبدال في الآية:  ';
  }
  Color containerColor;
  switch (mistakeRepetition) {
    case 1:
      containerColor = const Color(0xffb5e742);
    case 2:
      containerColor = const Color(0xfffae800);
    case 3:
      containerColor = const Color(0xfffa8e00);
    default:
      containerColor = const Color(0xfffc4850);
  }
  return InkWell(
    key: Key(id.toString()),
    onTap: () {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Container();
          },
          barrierDismissible: true,
          barrierLabel: '',
//transitionDuration: const Duration(microseconds: 400),
          transitionBuilder: (context, a1, a2, widget) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(a1),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1).animate(a1),
                child: AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                  content: Container(
                    constraints: BoxConstraints(
                      maxHeight: 450.h,
                    ),
                    width: 300.w,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        sqlCubit.archiveAndUnarchiveMistake(
                                          context,
                                          id: id,
                                          isArchived: isArchived,
                                        );
                                        Get.back();
                                      },
                                      icon: (isArchived)
                                          ? const Icon(Icons.unarchive_outlined)
                                          : const Icon(Icons.archive_outlined)),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(
                                            () => AddMistakeScreen(
                                                  isEdit: true,
                                                  id: id,
                                                ),
                                            transition: Transition.fadeIn);
                                      },
                                      icon: const Icon(Icons.edit)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Stack(children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 70.w,
                                          height: 22.h,
                                          child: Center(
                                            child: Text(
                                              quranSurahNames[surahNumber - 1],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Container(
                                              height: 1.h,
                                              width: 60.w,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Container(
                                              height: 1.h,
                                              width: 60.w,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ])
                                ],
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                ":",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Stack(children: [
                                    SizedBox(
                                      height: 22.h,
                                      width: 30.w,
                                      child: Center(
                                        child: Text(
                                          '$verseNumber',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 1.h,
                                          width: 30.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: 30.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    )
                                  ])
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Center(
                            child: Text(
                              quran.getVerse(surahNumber, verseNumber),
                              style: TextStyle(
                                  fontFamily: 'Uthmani',
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                          ),
                          if (mistake.isNotEmpty || note.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8).r,
                              child: const Divider(),
                            ),
                          // SizedBox(
                          //   height: 16.h,
                          // ),
                          if (mistake.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'التنبيه: ',
                                  style: TextStyle(
                                    color: const Color(0xffe53835),
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontFamily,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                  ),
                                ),
                                Expanded(
                                  child: Text(mistake,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ],
                            ),
                          if (note.isNotEmpty)
                            Column(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ملظة: ',
                                      style: TextStyle(
                                        color: const Color(0xff469e4a),
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontFamily,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(note,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ),
                                  ],
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (mistake.length >= 5 && category != 0)
            marqueerAnimation(context,
                mistake: mistake,
                mistakeKindText: mistakeKindText,
                verseNumber: verseNumber,
                category: category,
                surahNumber: surahNumber)
          else if (mistake.length >= 10)
            marqueerAnimation(context,
                mistake: mistake,
                mistakeKindText: mistakeKindText,
                verseNumber: verseNumber,
                category: category,
                surahNumber: surahNumber)
          else
            textToShowInsideCard(context,
                mistake: mistake,
                mistakeKindText: mistakeKindText,
                verseNumber: verseNumber,
                category: category,
                surahNumber: surahNumber),
          Row(
            children: [
              SizedBox(
                width: 8.w,
              ),
              Container(
                width: 7.r,
                height: 7.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90).r,
                  color: containerColor,
                ),
                // child: SvgPicture.asset(
                //   'assets/svgs/sign${1}.svg',
                // ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget textToShowInsideCard(context,
        {required String mistake,
        required mistakeKindText,
        required int verseNumber,
        required int category,
        required int surahNumber}) =>
    Row(
      children: [
        if (mistake.isNotEmpty)
          Row(
            children: [
              Text(
                mistake,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '|',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                width: 8.w,
              ),
            ],
          ),
        Text(
          mistakeKindText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  Theme.of(context).scaffoldBackgroundColor.computeLuminance() <
                          0.5
                      ? const Color(0xe0efefef)
                      : const Color(0xd91d1d1d)),
        ),
        Text(
          '$verseNumber',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (category != 0)
          Row(
            children: [
              Text(
                '  في سورة  ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .computeLuminance() <
                            0.5
                        ? const Color(0xe0efefef)
                        : const Color(0xd91d1d1d)),
              ),
              Text(
                quranSurahNames[surahNumber - 1],
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontFamily: 'Uthmani'),
              ),
            ],
          ),
      ],
    );

Widget marqueerAnimation(context,
        {required String mistake,
        required mistakeKindText,
        required int verseNumber,
        required int category,
        required int surahNumber}) =>
    SizedBox(
      width: 300.w,
      height: 30.h,
      child: Marqueer(
          separatorBuilder: (context, index) => SizedBox(
                width: 64.w,
              ),
          child: textToShowInsideCard(context,
              mistake: mistake,
              mistakeKindText: mistakeKindText,
              verseNumber: verseNumber,
              category: category,
              surahNumber: surahNumber)),
    );

Future showMistakeDialogWhenAppLunchedThroughNotification(
    context, String payload) async {
  final parts = payload.split(',');
  final int id = int.parse(parts[0].trim());
  final int surahNumber = int.parse(parts[1].trim());
  final int verseNumber = int.parse(parts[2].trim());
  final int mistakeKind = int.parse(parts[3].trim());
  final int mistakeRepetition = int.parse(parts[4].trim());
  final String mistake = parts[5].trim();
  final String note = parts[6].trim();
  // final int surahNumber = SqlCubit.idData[id]!['surah_number'];
  // final int verseNumber = SqlCubit.idData[id]!['verse_number'];
  // final int mistakeKind = SqlCubit.idData[id]!['mistake_kind'];
  // final int mistakeRepetition = SqlCubit.idData[id]!['mistake_repetition'];
  // final String mistake = SqlCubit.idData[id]!['mistake'];
  // final String note = SqlCubit.idData[id]!['note'];
  return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      barrierDismissible: true,
      barrierLabel: '',
//transitionDuration: const Duration(microseconds: 400),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1).animate(a1),
            child: AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8).r,
              ),
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: 450.h,
                ),
                width: 300.w,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close)),
                          IconButton(
                              onPressed: () {
                                Get.to(
                                    () => AddMistakeScreen(
                                          isEdit: true,
                                          id: id,
                                        ),
                                    transition: Transition.fadeIn);
                              },
                              icon: const Icon(Icons.edit)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 3.h,
                              ),
                              Stack(children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 70.w,
                                      height: 22.h,
                                      child: Center(
                                        child: Text(
                                          quranSurahNames[surahNumber - 1],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: 60.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: 60.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ])
                            ],
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 3.h,
                              ),
                              Stack(children: [
                                SizedBox(
                                  height: 22.h,
                                  width: 30.w,
                                  child: Center(
                                    child: Text(
                                      '$verseNumber',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 1.h,
                                      width: 30.w,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      height: 1.h,
                                      width: 30.w,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                )
                              ])
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Center(
                        child: Text(
                          quran.getVerse(surahNumber, verseNumber),
                          style: TextStyle(
                              fontFamily: 'Uthmani',
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      ),
                      if (mistake.isNotEmpty || note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8).r,
                          child: const Divider(),
                        ),
                      if (mistake.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التنبيه: ',
                              style: TextStyle(
                                color: const Color(0xffe53835),
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontFamily,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                              ),
                            ),
                            Expanded(
                              child: Text(mistake,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      if (note.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ملاحظة: ',
                                  style: TextStyle(
                                    color: const Color(0xff469e4a),
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontFamily,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                  ),
                                ),
                                Expanded(
                                  child: Text(note,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ],
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

Future<Object?> showActionDialog(context,
        {SqlCubit? sqlCubit,
        required String message,
        required bool isDeleteMessage,
        required bool isArchived,
        required Function()? onDeleteFunction,
        required Function()? onArchiveFunction,
        required Function()? onCancelFunction}) =>
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        barrierDismissible: true,
        barrierLabel: '',
        //transitionDuration: const Duration(microseconds: 400),
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1).animate(a1),
                  child: AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8).r,
                    ),
                    content: SizedBox(
                      width: 300.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            message,
                            style: Theme.of(context).textTheme.displayLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          ElevatedButton(
                            onPressed: onDeleteFunction,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(170.w, 43.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8).r),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8).h,
                              child: Text(
                                'حذف',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                                    .primaryColor
                                                    .computeLuminance() <
                                                0.5
                                            ? const Color(0xffefefef)
                                            : const Color(0xff1d1d1d)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          (!isDeleteMessage)
                              ? Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: onArchiveFunction,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(170.w, 43.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8).r),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                                vertical: 8)
                                            .h,
                                        child: Text(
                                          (isArchived)
                                              ? 'إلغاء الأرشفة'
                                              : 'أرشفة',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                              .primaryColor
                                                              .computeLuminance() <
                                                          0.5
                                                      ? const Color(0xffefefef)
                                                      : const Color(
                                                          0xff1d1d1d)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(
                            width: 170.w,
                            height: 43.h,
                            child: TextButton(
                              onPressed: onCancelFunction,
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                                overlayColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.grey.withOpacity(0.1);
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                              ),
                              child: Text(
                                'إلغاء',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                    .computeLuminance() <
                                                0.5
                                            ? const Color(0xffefefef)
                                            : const Color(0xff1d1d1d)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
        });

void validateNotificationsActivation(context) {
  if (SqlCubit.notificationsIds.isEmpty) {
    if (AppBloc.isNotificationsActivated) {
      bloc.BlocProvider.of<AppBloc>(context).add(
          ChangeNotificationsActivationEvent(isNotificationsActivated: false));
      debugPrint('Notifications disabled');
      Fluttertoast.showToast(
          msg: 'تم إلغاء تفعيل الإشعارات',
          backgroundColor: TOAST_BACKGROUND_COLOR);
    }
  } else {
    debugPrint('meow');
  }
}

Widget categoriesRow(context) {
  Color topColor = HSLColor.fromColor(
          Theme.of(context).appBarTheme.backgroundColor ?? Colors.white)
      .withLightness(0.25)
      .toColor();
  return Container(
    width: double.infinity,
    color: topColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5).r,
      child: bloc.BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 16.r,
                  ),
                  Text(
                    'عرض حسب:',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: topColor.computeLuminance() < 0.5
                            ? Color(0xffefefef)
                            : Color(0xff1d1d1d)),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  categoryButtonInHomeScreen(context, title: 'السور', index: 0),
                  SizedBox(
                    width: 8.w,
                  ),
                  categoryButtonInHomeScreen(context,
                      title: 'الصفحات', index: 1),
                  SizedBox(
                    width: 8.w,
                  ),
                  categoryButtonInHomeScreen(context,
                      title: 'الأجزاء', index: 2),
                  SizedBox(
                    width: 8.w,
                  ),
                  categoryButtonInHomeScreen(context,
                      title: 'نوعية التنبيه', index: 3),
                  SizedBox(
                    width: 8.w,
                  ),
                  categoryButtonInHomeScreen(context,
                      title: 'تكرار التنبيه', index: 4),
                  SizedBox(
                    width: 16.r,
                  ),
                ],
              ));
        },
      ),
    ),
  );
}
