import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadarok/constants/components.dart';
import 'package:tadarok/modules/add_mistake_screen/add_mistake_screen.dart';
import 'package:tadarok/modules/home_screen/expandable_app_bar/expandable_app_bar.dart';
import 'package:tadarok/modules/home_screen/scroll_to_hide_widget.dart';
import 'package:tadarok/modules/settings_screen/settings_screen.dart';
import 'package:tadarok/state_management/app_bloc/app_bloc.dart';
import 'package:tadarok/state_management/sql_cubit/sql_cubit.dart';

ScrollController scrollController = ScrollController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<SqlCubit, SqlState>(
      builder: (context, state) {
        var sqlCubit = SqlCubit.get(context);
        return Scaffold(
          body: Stack(children: [
            ExpandableAppBar(
              expandedWidget: Text(
                'مساعدك في المراجعة',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              colors: const [Color(0xff75BCD1), Color(0xff70C42F)],
              collapsedWidget: Text(
                'تدارُك',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const SettingsScreen(),
                          transition: Transition.leftToRightWithFade);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const SettingsScreen()));
                    },
                    icon: const Icon(Icons.settings))
              ],
              sliverList: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return expansionTiles(context, sqlCubit.homeScreenData[index]);
              }, childCount: sqlCubit.homeScreenData.length)
                  //     SliverChildListDelegate([
                  //   ExpansionTiles(),
                  //   ExpansionTiles(),
                  // ])
                  ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ScrollToHideWidget(
                  controller: scrollController,
                  height: 43.h,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          bloc.BlocProvider.of<AppBloc>(context).circleColor1 =
                              const Color(0xffb5e742);
                          bloc.BlocProvider.of<AppBloc>(context)
                              .changeCircleColor();
                          Get.to(() => const AddMistakeScreen(),
                              transition: Transition.fade);
                        },
                        child: Text(
                          'إضافة خطأ',
                          style: Theme.of(context).textTheme.displayLarge,
                        )),
                  ),
                ))
          ]),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AddMistakeScreen()));
          //   },
          //   shape: const CircleBorder(),
          //   child: const Icon(Icons.add),
          // ),
        );
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('تدارُك'),
    //     actions: [
    //       IconButton(
    //           onPressed: () {
    //             Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => SettingsScreen()));
    //           },
    //           icon: const Icon(Icons.settings))
    //     ],
    //   ),
    //   body: Column(
    //     children: [
    //       ExpansionTiles(),
    //       ExpansionTiles(),
    //     ],
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => AddMistakeScreen()));
    //     },
    //     shape: const CircleBorder(),
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }
}
