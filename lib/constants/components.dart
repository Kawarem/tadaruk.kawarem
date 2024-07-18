import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marqueer/marqueer.dart';
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
          color:
              (BlocProvider.of<AppBloc>(context).categoryInHomeScreen == index)
                  ? Colors.white
                  : Theme.of(context).primaryColor,
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
              fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily,
              color: (BlocProvider.of<AppBloc>(context).categoryInHomeScreen ==
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
                      Color containerColor;
                      switch (model[index ~/ 2]['mistake_repetition']) {
                        case 1:
                          containerColor = const Color(0xffb5e742);
                        case 2:
                          containerColor = const Color(0xfffae800);
                        case 3:
                          containerColor = const Color(0xfffa8e00);
                        default:
                          containerColor = const Color(0xfffc4850);
                      }
                      return mistakeCard(
                        context,
                        id: model[index ~/ 2]['mistake_id'],
                        mistake: model[index ~/ 2]['mistake'],
                        mistakeKind: mistakeKind,
                        verse: model[index ~/ 2]['verse_number'],
                        containerColor: containerColor,
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
    );

Widget mistakeCard(
  context, {
  required int id,
  required String mistake,
  required String mistakeKind,
  required int verse,
  required Color containerColor,
}) =>
    InkWell(
      key: Key(id.toString()),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (mistake.length > 10)
              SizedBox(
                width: 300.w,
                height: 30.h,
                child: Marqueer(
                  separatorBuilder: (context, index) => SizedBox(
                    width: 64.w,
                  ),
                  child: Row(
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
                ),
              )
            else
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
            )
          ],
        ),
      ),
    );
