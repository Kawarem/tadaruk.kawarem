import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadarok/app_bloc/app_bloc.dart';
import 'package:tadarok/constants/components.dart';
import 'package:tadarok/modules/home_screen/expandable_app_bar/fade_animation.dart';
import 'package:tadarok/modules/home_screen/home_screen.dart';

final sliverAppBarKey = GlobalKey();

class ExpandableAppBar extends StatelessWidget {
  final double? expandedHeight; // max height
  final double? toolbarHeight; // min height
  final Widget? expandedWidget; // widget to show when expanded
  final Widget? collapsedWidget; // widget to show when collapsed
  final BoxDecoration? boxDecoration;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final SliverList sliverList;
  final Color? sliverBackgroundColor;

  ExpandableAppBar(
      {super.key,
      this.expandedHeight,
      this.toolbarHeight,
      this.expandedWidget,
      this.boxDecoration,
      this.collapsedWidget,
      this.leadingIcon,
      this.actions,
      required this.sliverList,
      this.sliverBackgroundColor});

  late double _expandedHeight;
  late double _toolbarHeight;

  double calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - _toolbarHeight) /
        (_expandedHeight - _toolbarHeight);
    if (expandRatio > 1.0) expandRatio = 1;
    if (expandRatio < 0.0) expandRatio = 0;
    return expandRatio;
  }

  List<Widget> headerSliverBuilder(context, innerBoxIsScrolled) {
    return [
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          // backgroundColor: Color(0xff12a36c),
          key: sliverAppBarKey,
          pinned: true,
          floating: true,
          snap: true,
          stretch: true,
          expandedHeight: _expandedHeight,
          toolbarHeight: _toolbarHeight,
          flexibleSpace: LayoutBuilder(builder: (context, constraints) {
            // get expand ratio based on the constraints
            final expandRatio = calculateExpandRatio(constraints);
            final animation = AlwaysStoppedAnimation(expandRatio);

            return Stack(
              children: [
                // background color, image or gradient
                FadeAnimation(
                  animation: animation,
                  isExpandedWidget: true,
                  child: Container(
                    decoration: boxDecoration,
                  ),
                ),
                // center big title
                if (expandedWidget != null)
                  Center(
                      child: FadeAnimation(
                          animation: animation,
                          isExpandedWidget: true,
                          child: expandedWidget!)),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: _toolbarHeight,
                      child: Row(
                        children: [
                          // leading icon
                          if (leadingIcon != null) leadingIcon!,
                          // collapsed widget
                          if (collapsedWidget != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: leadingIcon != null ? 0 : 20),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16.r,
                                  ),
                                  collapsedWidget!,
                                ],
                              ),
                            ),
                          if (actions != null)
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: actions!.reversed.toList(),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  animation: animation,
                  isExpandedWidget: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      // TODO: change color to adapt to Theme
                      color: const Color(0xff02786A),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4)
                            .r,
                        child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Text(
                                  'عرض كل:',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                buttonInHomeScreen(context,
                                    title: 'السور', index: 0),
                                SizedBox(
                                  width: 8.w,
                                ),
                                buttonInHomeScreen(context,
                                    title: 'الصفحات', index: 1),
                                SizedBox(
                                  width: 8.w,
                                ),
                                buttonInHomeScreen(context,
                                    title: 'الأجزاء', index: 2),
                                SizedBox(
                                  width: 8.w,
                                ),
                                buttonInHomeScreen(context,
                                    title: 'الأحزاب', index: 3),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      )
    ];
  }

  Widget body() {
    return Container(
      // color: widget.sliverBackgroundColor ??
      //     Theme.of(context).scaffoldBackgroundColor,
      child: Builder(builder: (context) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final appBarContext = sliverAppBarKey.currentContext;
            final appBarState = Scrollable.of(appBarContext!).position;
            final isCollapsed = appBarState.pixels >
                (appBarState.maxScrollExtent) - kToolbarHeight;
            if (isCollapsed !=
                BlocProvider.of<AppBloc>(context).appBarIsCollapsed) {
              BlocProvider.of<AppBloc>(context).appBarIsCollapsed = isCollapsed;
              BlocProvider.of<AppBloc>(context).add(AppBarCollapsedEvent());
            }
            return false;
          },
          child: CustomScrollView(controller: scrollController, slivers: [
            SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            sliverList,
            // SliverFillRemaining(
            //     child: Column(
            //   children: [
            //     Expanded(child: SizedBox()),
            //     ElevatedButton(onPressed: () {}, child: Text('data')),
            //   ],
            // ))
          ]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight =
        expandedHeight ?? MediaQuery.of(context).size.height * 3 / 8;
    _toolbarHeight = toolbarHeight ?? kToolbarHeight;

    return NestedScrollView(
        headerSliverBuilder: headerSliverBuilder, body: body());
  }
}
