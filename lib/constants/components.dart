import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadarok/state_management/app_bloc/app_bloc.dart';

Widget buttonInHomeScreen(context,
        {required String title, required int index}) =>
    GestureDetector(
      onTap: () {
        BlocProvider.of<AppBloc>(context).add(
            ChangeDisplayTypeInHomeScreenEvent(displayTypeInHomeScreen: index));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45).r,
          color: (BlocProvider.of<AppBloc>(context).displayTypeInHomeScreen ==
                  index)
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
              fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily,
              color:
                  (BlocProvider.of<AppBloc>(context).displayTypeInHomeScreen ==
                          index)
                      ? Theme.of(context).primaryColor
                      : Colors.white),
        ),
      ),
    );

Widget expansionTiles(context, List<Map<String, dynamic>> model) =>
    ExpansionTile(
      title: Text(
        'سورة ${model[0]['surah']}',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      children: [
        // Container(
        //   color: Theme.of(context).scaffoldBackgroundColor,
        //   child: CustomScrollView(shrinkWrap: true, slivers: [
        //     SliverFillRemaining(
        //       child: ListView.separated(
        //         shrinkWrap: true,
        //         physics: NeverScrollableScrollPhysics(),
        //         itemCount: mistakesList[0].mistakesNumber,
        //         itemBuilder: (context, index) {
        //           return mistakeCard(context,
        //               word: 'العالمين', mistakeKind: 'ناقصة', verse: 2);
        //         },
        //         separatorBuilder: (BuildContext context, int index) {
        //           return Divider(
        //             color: Colors.white,
        //           );
        //         },
        //       ),
        //     ),
        //   ]),
        // ),

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
                      String mistakeKind;
                      switch (model[index ~/ 2]['mistake_kind']) {
                        case 1:
                          mistakeKind = 'هي نقص في الآية:  ';
                        case 2:
                          mistakeKind = 'هي إبدال في الآية:  ';
                        case 3:
                          mistakeKind = 'هي زيادة في الآية:  ';
                        case 4:
                          mistakeKind = 'خطأ تشكيلي في الآية:  ';
                        default:
                          mistakeKind = 'خطأ مجمل في الآية:  ';
                      }
                      return mistakeCard(context,
                          word: model[index ~/ 2]['mistake'],
                          mistakeKind: mistakeKind,
                          verse: model[index ~/ 2]['verse_number']);
                    }
                    return const Divider();
                  },
                  childCount: math.max(0, model.length * 2 - 1),
                ),
              ),
            ],
          ),
        ),
        // ])
      ],
    );

Widget mistakeCard(context,
        {required String word,
        required String mistakeKind,
        required int verse}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                word,
                style: Theme.of(context).textTheme.bodyLarge,
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
              Text(
                mistakeKind,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '$verse',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 8.w,
              ),
              Container(
                width: 7.w,
                height: 7.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
