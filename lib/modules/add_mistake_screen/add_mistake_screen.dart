import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as Get;
import 'package:quran/quran.dart' as quran;
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';
import 'package:vibration/vibration.dart';

class AddMistakeScreen extends StatefulWidget {
  final bool isEdit;
  final int? id;

  const AddMistakeScreen({
    super.key,
    required this.isEdit,
    this.id,
  });

  @override
  State<AddMistakeScreen> createState() => _AddMistakeScreenState();
}

class _AddMistakeScreenState extends State<AddMistakeScreen>
    with SingleTickerProviderStateMixin {
  final _mistakeController = TextEditingController();
  final _noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _listWheelScrollVerseController = FixedExtentScrollController();
  final _listWheelScrollSurahController = FixedExtentScrollController();
  final _listWheelScrollMistakeKindController = FixedExtentScrollController();
  Timer? _listWheelScrollSurahControllerTimer;
  bool _isListWheelScrollSurahControllerTimerOver = true;
  Timer? _preventAyaFadeAnimationTimer;

  //todo: bug: it is not working in edit screen so I deactivated it for now
  bool _isPreventAyaFadeAnimationTimerOver = false;
  Timer? _isSurahScrollingTimer;
  bool _isSurahScrolling = false;
  Timer? _isVerseScrollingTimer;
  bool _isVerseScrolling = false;
  late AnimationController _fadeTextAnimationController;
  late Animation<double> _fadeTextAnimation;

  void _insertData(context) {
    BlocProvider.of<SqlCubit>(context).insertToDatabase(
        surahNumber: _listWheelScrollSurahController.selectedItem + 1,
        verseNumber: _listWheelScrollVerseController.selectedItem + 1,
        mistakeKind: _listWheelScrollMistakeKindController.selectedItem + 1,
        mistake: _mistakeController.text,
        note: _noteController.text,
        mistakeRepetition: BlocProvider.of<AppBloc>(context).mistakeRepetition);
  }

  void _updateData(context) {
    BlocProvider.of<SqlCubit>(context).updateDatabase(
        id: widget.id!,
        surahNumber: _listWheelScrollSurahController.selectedItem + 1,
        verseNumber: _listWheelScrollVerseController.selectedItem + 1,
        mistakeKind: _listWheelScrollMistakeKindController.selectedItem + 1,
        mistake: _mistakeController.text,
        note: _noteController.text,
        mistakeRepetition: BlocProvider.of<AppBloc>(context).mistakeRepetition);
  }

  @override
  void initState() {
    super.initState();
    _fadeTextAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeTextAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(_fadeTextAnimationController);
    _preventAyaFadeAnimationTimer =
        Timer(const Duration(milliseconds: 1020), () async {
      _isPreventAyaFadeAnimationTimerOver = true;
    });
    if (widget.isEdit) {
      // this event adjust verses number to align with the surah
      BlocProvider.of<AppBloc>(context).add(ChangeSurahInAddMistakeScreenEvent(
          surahNumber: SqlCubit.idData[widget.id]!['surah_number']! - 1));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listWheelScrollSurahController.animateToItem(
            SqlCubit.idData[widget.id]!['surah_number']! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        _listWheelScrollVerseController.animateToItem(
            SqlCubit.idData[widget.id]!['verse_number']! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        _listWheelScrollMistakeKindController.animateToItem(
            SqlCubit.idData[widget.id]!['mistake_kind']! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        BlocProvider.of<AppBloc>(context).add(ChangeMistakeRepetitionEvent(
            mistakeRepetition:
                SqlCubit.idData[widget.id]!['mistake_repetition']!));
        // The real value will be applied inside the widget
        BlocProvider.of<AppBloc>(context)
            .add(ChangeMistakeKindEvent(mistakeKind: 0));
        // BlocProvider.of<AppBloc>(context).add(ChangeMistakeKindEvent(
        //     mistakeKind: SqlCubit.idData[widget.id]!['mistake_kind']! - 1));
        _mistakeController.text = SqlCubit.idData[widget.id]!['mistake']!;
        _noteController.text = SqlCubit.idData[widget.id]!['note']!;
        BlocProvider.of<AppBloc>(context).add(ChangeAyaInAddMistakeScreenEvent(
            selectedSurahInAddMistakeScreen:
                SqlCubit.idData[widget.id]!['surah_number'],
            selectedVerseInAddMistakeScreen:
                SqlCubit.idData[widget.id]!['verse_number']));
        // _isFadeTimerOver = true;
        // _fadeTimer = Timer(const Duration(milliseconds: 1020), () async {
        //   _isFadeTimerOver = true;
        // });
      });
    } else {
      // Not edit
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listWheelScrollSurahController.jumpToItem(3);
        _listWheelScrollSurahController.animateToItem(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        _listWheelScrollVerseController.jumpToItem(5);
        _listWheelScrollVerseController.animateToItem(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        BlocProvider.of<AppBloc>(context).add(ChangeAyaInAddMistakeScreenEvent(
            selectedSurahInAddMistakeScreen: 1,
            selectedVerseInAddMistakeScreen: 1));
        // _fadeTimer = Timer(const Duration(milliseconds: 1020), () async {
        //   _isFadeTimerOver = true;
        // });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fadeTextAnimationController.dispose();
    _mistakeController.dispose();
    _noteController.dispose();
    _listWheelScrollVerseController.dispose();
    _listWheelScrollSurahController.dispose();
    _listWheelScrollMistakeKindController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? id = widget.id;
    bool isEdit = widget.isEdit;
    double notiInnerColor = HSLColor.fromColor(
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.white)
        .lightness;
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        var appBloc = AppBloc.get(context);
        var sqlCubit = SqlCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              (widget.isEdit) ? 'تعديل التنبيه' : 'إضافة تنبيه',
            ),
            leading: IconButton(
              onPressed: () {
                Get.Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            actions: [
              if (widget.isEdit)
                IconButton(
                    onPressed: () {
                      showActionDialog(context,
                          message: 'حذف هذا التنبيه؟',
                          isDeleteMessage: true,
                          isArchived: false,
                          onDeleteFunction: () {
                            sqlCubit.deleteFromDatabase(context, id: id!);
                            Get.Get.back();
                            Get.Get.back();
                            Get.Get.back();
                            validateNotificationsActivation(context);
                          },
                          onArchiveFunction: () {},
                          onCancelFunction: () {
                            Get.Get.back();
                          });
                    },
                    icon: const Icon(Icons.delete_outline_rounded)),
              const SizedBox()
            ],
          ),
          body: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0).r,
                    child: SizedBox(
                      height: 8.h,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: IgnorePointer(
                      ignoring: (isEdit)
                          ? false
                          : (_isPreventAyaFadeAnimationTimerOver)
                              ? false
                              : true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'سورة',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Stack(children: [
                                SizedBox(
                                  width: 70.w,
                                  height: 60.h,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color!,
                                          Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color!,
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.2, 0.7, 1],
                                      ).createShader(bounds);
                                    },
                                    child: ListWheelScrollView.useDelegate(
                                        controller:
                                            _listWheelScrollSurahController,
                                        onSelectedItemChanged: (index) async {
                                          _isSurahScrolling = true;
                                          _isSurahScrollingTimer?.cancel();
                                          if (!isEdit) {
                                            _isListWheelScrollSurahControllerTimerOver =
                                                false;
                                            _listWheelScrollSurahControllerTimer
                                                ?.cancel();
                                            _listWheelScrollSurahControllerTimer =
                                                Timer(
                                              const Duration(milliseconds: 400),
                                              () async {
                                                if (_listWheelScrollVerseController
                                                            .selectedItem +
                                                        1 >
                                                    quranSurahVerses[index]) {
                                                  _listWheelScrollVerseController
                                                      .animateToItem(
                                                          quranSurahVerses[
                                                                  index] -
                                                              1,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          curve:
                                                              Curves.easeInOut);
                                                  Timer(
                                                      const Duration(
                                                          milliseconds: 250),
                                                      () async {
                                                    if (!_isVerseScrolling) {
                                                      _fadeTextAnimationController
                                                          .forward()
                                                          .then((_) {
                                                        appBloc.add(ChangeAyaInAddMistakeScreenEvent(
                                                            selectedSurahInAddMistakeScreen:
                                                                _listWheelScrollSurahController
                                                                        .selectedItem +
                                                                    1,
                                                            selectedVerseInAddMistakeScreen:
                                                                quranSurahVerses[
                                                                    index]));
                                                        _fadeTextAnimationController
                                                            .reverse();
                                                      });
                                                    }
                                                  });
                                                  Timer(
                                                      const Duration(
                                                          milliseconds: 1000),
                                                      () async {
                                                    appBloc.add(
                                                        ChangeSurahInAddMistakeScreenEvent(
                                                            surahNumber:
                                                                index));
                                                  });
                                                } else {
                                                  appBloc.add(
                                                      ChangeSurahInAddMistakeScreenEvent(
                                                          surahNumber: index));
                                                }
                                                _isListWheelScrollSurahControllerTimerOver =
                                                    true;
                                              },
                                            );
                                            if (!(_listWheelScrollVerseController
                                                            .selectedItem +
                                                        1 >
                                                    quranSurahVerses[index]) &&
                                                _isPreventAyaFadeAnimationTimerOver) {
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 20),
                                                  () async {
                                                if (!_isVerseScrolling) {
                                                  _fadeTextAnimationController
                                                      .forward()
                                                      .then((_) {
                                                    appBloc.add(ChangeAyaInAddMistakeScreenEvent(
                                                        selectedSurahInAddMistakeScreen:
                                                            _listWheelScrollSurahController
                                                                    .selectedItem +
                                                                1,
                                                        selectedVerseInAddMistakeScreen:
                                                            _listWheelScrollVerseController
                                                                    .selectedItem +
                                                                1));
                                                    _fadeTextAnimationController
                                                        .reverse();
                                                  });
                                                }
                                              });
                                            }
                                          } else if (_listWheelScrollSurahController
                                                      .selectedItem +
                                                  1 ==
                                              SqlCubit.idData[widget.id]![
                                                  'surah_number']) {
                                            isEdit = false;
                                            _isListWheelScrollSurahControllerTimerOver =
                                                true;
                                            _isPreventAyaFadeAnimationTimerOver =
                                                true;
                                          }
                                          _isSurahScrollingTimer = Timer(
                                              const Duration(milliseconds: 200),
                                              () async {
                                            _isSurahScrolling = false;
                                          });
                                        },
                                        itemExtent: 20.h,
                                        perspective: 0.0001,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                                childCount:
                                                    quranSurahNames.length,
                                                builder: (BuildContext context,
                                                    int index) {
                                                  return Text(
                                                    quranSurahNames[index],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  );
                                                })),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 18.h,
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
                          Column(
                            children: [
                              Container(
                                height: 20.h,
                                width: 1.w,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              Text(
                                ":",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'آية',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Stack(children: [
                                SizedBox(
                                  width: 46.w,
                                  height: 60.h,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .color!,
                                          Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .color!,
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.2, 0.7, 1],
                                      ).createShader(bounds);
                                    },
                                    child: ListWheelScrollView.useDelegate(
                                        controller:
                                            _listWheelScrollVerseController,
                                        onSelectedItemChanged: (index) {
                                          _isVerseScrolling = true;
                                          _isVerseScrollingTimer?.cancel();
                                          if (_isPreventAyaFadeAnimationTimerOver &&
                                              _isListWheelScrollSurahControllerTimerOver) {
                                            Timer(
                                                const Duration(
                                                    milliseconds: 20),
                                                () async {
                                              if (!_isSurahScrolling) {
                                                _fadeTextAnimationController
                                                    .forward()
                                                    .then((_) {
                                                  appBloc.add(ChangeAyaInAddMistakeScreenEvent(
                                                      selectedSurahInAddMistakeScreen:
                                                          _listWheelScrollSurahController
                                                                  .selectedItem +
                                                              1,
                                                      selectedVerseInAddMistakeScreen:
                                                          _listWheelScrollVerseController
                                                                  .selectedItem +
                                                              1));
                                                  _fadeTextAnimationController
                                                      .reverse();
                                                });
                                              }
                                            });
                                          }
                                          _isVerseScrollingTimer = Timer(
                                              const Duration(milliseconds: 200),
                                              () async {
                                            _isVerseScrolling = false;
                                          });
                                        },
                                        itemExtent: 20.h,
                                        perspective: 0.0001,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                                childCount: quranSurahVerses[
                                                    appBloc.surahNumber],
                                                builder: (BuildContext context,
                                                    int index) {
                                                  return Text(
                                                    '${index + 1}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  );
                                                })),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: 30.w,
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
                                          width: 8.w,
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: 30.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: SizedBox(
                      height: 80.h,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).textTheme.displayLarge!.color!,
                              Theme.of(context).textTheme.displayLarge!.color!,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.1, 0.9, 1],
                          ).createShader(bounds);
                        },
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                if (appBloc.selectedVerseInAddMistakeScreen <=
                                    quranSurahVerses[appBloc
                                            .selectedSurahInAddMistakeScreen -
                                        1])
                                  FadeTransition(
                                    opacity: _fadeTextAnimation,
                                    child: Text(
                                      quran.getVerse(
                                          appBloc
                                              .selectedSurahInAddMistakeScreen,
                                          appBloc
                                              .selectedVerseInAddMistakeScreen),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Uthmani',
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .fontSize,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          overflow: TextOverflow.fade),
                                    ),
                                  ),
                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Row(
                      children: [
                        Text(
                          'نوعية التنبيه:',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16).r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(children: [
                          SizedBox(
                            width: 50.w,
                            height: 60.h,
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color!,
                                    Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color!,
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.2, 0.7, 1],
                                ).createShader(bounds);
                              },
                              child: ListWheelScrollView.useDelegate(
                                  controller:
                                      _listWheelScrollMistakeKindController,
                                  onSelectedItemChanged: (index) {
                                    appBloc.add(ChangeMistakeKindEvent(
                                        mistakeKind: index));
                                  },
                                  itemExtent: 20.h,
                                  perspective: 0.0001,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                      childCount: mistakeKinds.length,
                                      builder:
                                          (BuildContext context, int index) {
                                        return Text(
                                          mistakeKinds[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        );
                                      })),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 1.h,
                                    width: 50.w,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  // SizedBox(
                                  //   width: 4.w,
                                  // ),
                                  Container(
                                    height: 1.h,
                                    width: 50.w,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ]),
                        Container(
                          height: 55.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                              color: HSLColor.fromColor(Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor ??
                                      Colors.white)
                                  .withLightness(max(0, 0.25))
                                  .toColor(),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(90),
                                bottomRight: Radius.circular(90),
                              ),
                              border: Border(
                                top: BorderSide(
                                    color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor ??
                                        Colors.white,
                                    width: 5.r),
                                bottom: BorderSide(
                                    color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor ??
                                        Colors.white,
                                    width: 5.r),
                                right: BorderSide(
                                    color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor ??
                                        Colors.white,
                                    width: 5.r),
                              )),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  AnimatedContainer(
                                    width: 43.r,
                                    height: 43.r,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Color.lerp(appBloc.circleColor0,
                                          appBloc.circleColor1, 1),
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svgs/sign${appBloc.mistakeKind}.svg',
                                        width: 37.r,
                                        height: 37.r,
                                        key: ValueKey<int>(appBloc.mistakeKind),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Expanded(flex: 120, child: SizedBox()),
                                  Container(
                                    width: 63.w,
                                    height: 2.h,
                                    color: const Color(0xffA1A1A1),
                                  ),
                                  const Expanded(flex: 100, child: SizedBox()),
                                  Container(
                                    width: 63.w,
                                    height: 2.h,
                                    color: const Color(0xffA1A1A1),
                                  ),
                                  const Expanded(flex: 100, child: SizedBox()),
                                  Container(
                                    width: 63.w,
                                    height: 2.h,
                                    color: const Color(0xffA1A1A1),
                                  ),
                                  const Expanded(flex: 120, child: SizedBox()),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0).r,
                          child: TextFormField(
                              controller: _mistakeController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'يجب ملأ هذا الحقل';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'التنبيه',
                                prefixIcon:
                                    const Icon(Icons.bookmark_outline_rounded),
                                fillColor: Color(0x34808080),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      width: 1.5,
                                      color: Theme.of(context).primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0).r,
                          child: TextFormField(
                              controller: _noteController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'ملاحظة',
                                prefixIcon: const Icon(Icons.note_alt_outlined),
                                fillColor: const Color(0x34808080),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      width: 1.5,
                                      color: Theme.of(context).primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Row(
                      children: [
                        Text(
                          'تكرار التنبيه:',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'أقل',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'أكثر',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                              width: 16.w,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        sliderTheme: SliderThemeData(
                          inactiveTrackColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          activeTrackColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          activeTickMarkColor: Theme.of(context)
                              .appBarTheme
                              .backgroundColor
                              ?.withOpacity(0.8),
                          inactiveTickMarkColor: Theme.of(context)
                              .appBarTheme
                              .backgroundColor
                              ?.withOpacity(0.8),
                        ),
                      ),
                      child: Slider(
                        value: appBloc.mistakeRepetition.toDouble(),
                        onChanged: (value) {
                          appBloc.add(ChangeMistakeRepetitionEvent(
                              mistakeRepetition: value.toInt()));
                        },
                        min: 1,
                        max: 4,
                        divisions: 3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16).r,
                    child: BlocBuilder<SqlCubit, SqlState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_isListWheelScrollSurahControllerTimerOver &&
                                appBloc.selectedVerseInAddMistakeScreen <=
                                    quranSurahVerses[appBloc
                                            .selectedSurahInAddMistakeScreen -
                                        1]) {
                              // insert data
                              if (_listWheelScrollMistakeKindController
                                      .selectedItem ==
                                  0) {
                                // check if data is valid before inserting it to db
                                if (widget.isEdit) {
                                  _updateData(context);
                                  Get.Get.back();
                                  Get.Get.back();
                                } else {
                                  _insertData(context);
                                  Get.Get.back();
                                }
                              } else if (formKey.currentState!.validate()) {
                                if (widget.isEdit) {
                                  _updateData(context);
                                  Get.Get.back();
                                  Get.Get.back();
                                } else {
                                  _insertData(context);
                                  Get.Get.back();
                                }
                              } else {
                                Vibration.vibrate(duration: 50);
                              }
                            } else {
                              // if still scrolling
                              Vibration.vibrate(duration: 50);
                              debugPrint('CTA clicked while scrolling!');
                            }
                          },
                          child: Text(
                            widget.isEdit ? 'تعديل' : 'حفظ',
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
