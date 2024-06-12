import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadarok/constants/components.dart';
import 'package:tadarok/modules/home_screen/scroll_to_hide_widget.dart';

import '../add_mistake_screen/add_mistake_screen.dart';
import '../settings_screen/settings_screen.dart';
import 'expandable_app_bar/expandable_app_bar.dart';

ScrollController scrollController = ScrollController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      // body: Column(
      //   children: [
      //     ExpansionTiles(),
      //     ExpansionTiles(),
      //   ],
      // ),
      body: Stack(children: [
        ExpandableAppBar(
          expandedWidget: Text(
            'مساعدك في المراجعة',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          boxDecoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff75BCD1), Color(0xff70C42F)])),
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
            return expansionTiles(context);
          }, childCount: 5)
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
