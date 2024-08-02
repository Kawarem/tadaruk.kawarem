import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as Get;
import 'package:tadarok/constants/data.dart';
import 'package:tadarok/modules/home_screen/home_screen.dart';
import 'package:tadarok/state_management/app_bloc/app_bloc.dart';
import 'package:tadarok/state_management/sql_cubit/sql_cubit.dart';
import 'package:vibration/vibration.dart';

class AddMistakeScreen extends StatefulWidget {
  final bool isEdit;
  final int? id;
  final int? surahNumber;
  final int? verseNumber;
  final int? mistakeKind;
  final String? mistake;
  final String? note;
  final double? mistakeRepetition;

  const AddMistakeScreen({
    super.key,
    required this.isEdit,
    this.id,
    this.surahNumber,
    this.verseNumber,
    this.mistakeKind,
    this.mistake,
    this.note,
    this.mistakeRepetition,
  });

  @override
  State<AddMistakeScreen> createState() => _AddMistakeScreenState();
}

class _AddMistakeScreenState extends State<AddMistakeScreen> {
  final _mistakeController = TextEditingController();
  final _noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _listWheelScrollVerseController = FixedExtentScrollController();
  final _listWheelScrollSurahController = FixedExtentScrollController();
  final _listWheelScrollMistakeKindController = FixedExtentScrollController();

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
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // _listWheelScrollSurahController.jumpToItem(3);
        _listWheelScrollSurahController.animateToItem(widget.surahNumber! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        // _listWheelScrollVerseController.jumpToItem(5);
        _listWheelScrollVerseController.animateToItem(widget.verseNumber! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        _listWheelScrollMistakeKindController.animateToItem(
            widget.mistakeKind! - 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        BlocProvider.of<AppBloc>(context).add(ChangeMistakeRepetitionEvent(
            mistakeRepetition: widget.mistakeRepetition!));
        BlocProvider.of<AppBloc>(context)
            .add(ChangeMistakeKindEvent(mistakeKind: widget.mistakeKind! - 1));
        _mistakeController.text = widget.mistake!;
        _noteController.text = widget.note!;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listWheelScrollSurahController.jumpToItem(3);
        _listWheelScrollSurahController.animateToItem(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
        _listWheelScrollVerseController.jumpToItem(5);
        _listWheelScrollVerseController.animateToItem(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
      });
    }
  }

  @override
  void dispose() {
    _mistakeController.dispose();
    _noteController.dispose();
    _listWheelScrollVerseController.dispose();
    _listWheelScrollSurahController.dispose();
    _listWheelScrollMistakeKindController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? id = widget.id;
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        var appBloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة خطأ',
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
                                scale: Tween<double>(begin: 0.5, end: 1)
                                    .animate(a1),
                                child: FadeTransition(
                                    opacity: Tween<double>(begin: 0.5, end: 1)
                                        .animate(a1),
                                    child: AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8).r,
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
                                              'هل أنت متأكد أنك تريد حذف هذا الخطأ؟',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 32.h,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                BlocProvider.of<SqlCubit>(
                                                        context)
                                                    .deleteFromDatabase(
                                                        id: id!);
                                                Get.Get.offAll(
                                                    () => const HomeScreen());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(170.w, 43.h),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(8)
                                                            .r),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 8)
                                                        .h,
                                                child: Text(
                                                  'حذف',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            SizedBox(
                                              width: 170.w,
                                              height: 43.h,
                                              child: TextButton(
                                                onPressed: () {
                                                  Get.Get.back();
                                                },
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                                  8)
                                                              .r,
                                                    ),
                                                  ),
                                                  overlayColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return Colors.grey
                                                            .withOpacity(0.1);
                                                      }
                                                      return Colors.transparent;
                                                    },
                                                  ),
                                                ),
                                                child: Text(
                                                  'تراجع',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )));
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
                                        if (_listWheelScrollVerseController
                                                    .selectedItem +
                                                1 >
                                            quranSurahVerses[index]) {
                                          await _listWheelScrollVerseController
                                              .animateToItem(
                                                  quranSurahVerses[index] - 1,
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.easeInOut);
                                        }
                                        appBloc.add(
                                            ChangeSurahInAddMistakeScreenEvent(
                                                surahNumber: index));
                                      },
                                      itemExtent: 20.h,
                                      perspective: 0.0001,
                                      physics: const FixedExtentScrollPhysics(),
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
                                        width: 4.w,
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
                                        width: 4.w,
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
                                      onSelectedItemChanged: (index) {},
                                      itemExtent: 20.h,
                                      perspective: 0.0001,
                                      physics: const FixedExtentScrollPhysics(),
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
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Row(
                      children: [
                        Text(
                          'حيث أن نوعية الخطأ:',
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
                              // TODO: Change color
                              color: const Color(0xff005154),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(45),
                                bottomRight: Radius.circular(45),
                              ),
                              border: Border(
                                top: BorderSide(
                                    color: const Color(0xff02786A), width: 5.r),
                                bottom: BorderSide(
                                    color: const Color(0xff02786A), width: 5.r),
                                right: BorderSide(
                                    color: const Color(0xff02786A), width: 5.r),
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
                                      borderRadius: BorderRadius.circular(45),
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
                    // autovalidateMode: (state is ValidateTextFormFieldState)
                    //     ? (state.validator)
                    //         ? AutovalidateMode.always
                    //         : AutovalidateMode.disabled
                    //     : AutovalidateMode.disabled,
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
                              decoration: const InputDecoration(
                                labelText: 'الخطأ',
                                prefixIcon:
                                    Icon(Icons.bookmark_outline_rounded),
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
                              decoration: const InputDecoration(
                                labelText: 'ملاحظة',
                                prefixIcon: Icon(Icons.note_alt_outlined),
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
                          'تكرار الخطأ:',
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
                    child: Slider(
                      value: appBloc.mistakeRepetition.toDouble(),
                      onChanged: (value) {
                        appBloc.add(ChangeMistakeRepetitionEvent(
                            mistakeRepetition: value));
                      },
                      min: 1,
                      max: 4,
                      divisions: 3,
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
                            if (_listWheelScrollMistakeKindController
                                    .selectedItem ==
                                0) {
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
                          },
                          child: Text(
                            widget.isEdit ? 'تعديل' : 'حفظ',
                            style: Theme.of(context).textTheme.displayLarge,
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
