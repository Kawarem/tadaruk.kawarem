import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_bloc/app_bloc.dart';

class AddMistakeScreen extends StatelessWidget {
  const AddMistakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
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
                              'آية',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Stack(children: [
                              SizedBox(
                                width: 40.w,
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
                                      onSelectedItemChanged: (index) {},
                                      itemExtent: 18.h,
                                      perspective: 0.0001,
                                      physics: const FixedExtentScrollPhysics(),
                                      childDelegate:
                                          ListWheelChildBuilderDelegate(
                                              childCount: 100,
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
                                    height: 21.h,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Container(
                                        height: 1.h,
                                        width: 24.w,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17.h,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Container(
                                        height: 1.h,
                                        width: 24.w,
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
                                      onSelectedItemChanged: (index) {},
                                      itemExtent: 18.h,
                                      perspective: 0.0001,
                                      physics: const FixedExtentScrollPhysics(),
                                      childDelegate:
                                          ListWheelChildBuilderDelegate(
                                              childCount: surah.length,
                                              builder: (BuildContext context,
                                                  int index) {
                                                return Text(
                                                  surah[index],
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
                                    height: 21.h,
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
                                    height: 17.h,
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
                                  Container(
                                    width: 43.r,
                                    height: 43.r,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: appBloc.circleColor,
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/svgs/sign${appBloc.mistakeKind}.svg'),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'الخطأ',
                          prefixIcon: Icon(Icons.bookmark_outline_rounded),
                        )),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'التصحيح',
                          prefixIcon: Icon(Icons.check_circle_outline_rounded),
                        )),
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'حفظ',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
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

const List<String> surah = ['الفاتحة', 'البقرة', 'آل عمران'];
const List<String> mistakeKinds = ['نقص', 'إبدال', 'زيادة', 'تشكيل', 'مجمل'];
