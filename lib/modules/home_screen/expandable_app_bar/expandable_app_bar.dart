import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/modules/home_screen/animated_gradiant_container.dart';
import 'package:tadaruk/modules/home_screen/expandable_app_bar/fade_animation.dart';
import 'package:tadaruk/modules/home_screen/home_screen.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';

final sliverAppBarKey = GlobalKey();

class ExpandableAppBar extends StatelessWidget {
  final double? expandedHeight; // max height
  final double? toolbarHeight; // min height
  final Widget? expandedWidget; // widget to show when expanded
  final Widget? collapsedWidget; // widget to show when collapsed
  // final BoxDecoration? boxDecoration;
  final List<Color>? colors;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final SliverList sliverList;
  final Color? sliverBackgroundColor;

  ExpandableAppBar(
      {super.key,
      this.expandedHeight,
      this.toolbarHeight,
      this.expandedWidget,
      // this.boxDecoration,
      this.collapsedWidget,
      this.leadingIcon,
      this.actions,
      required this.sliverList,
      this.sliverBackgroundColor,
      this.colors});

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
                if (colors != null)
                  FadeAnimation(
                      animation: animation,
                      isExpandedWidget: true,
                      child: AnimatedGradiantContainer(
                        colors: colors!,
                      )
                      // Container(
                      //   decoration: boxDecoration,
                      // ),
                      ),
                // center big title
                if (expandedWidget != null)
                  Center(
                    child: FadeAnimation(
                      animation: animation,
                      isExpandedWidget: true,
                      child: expandedWidget!,
                    ),
                  ),
                FadeAnimation(
                  animation: animation,
                  isExpandedWidget: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: categoriesRow(context),
                  ),
                ),
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
                          // if (actions != null)
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
                BlocProvider.of<AppBloc>(context).isAppBarCollapsed) {
              BlocProvider.of<AppBloc>(context).isAppBarCollapsed = isCollapsed;
              BlocProvider.of<AppBloc>(context).add(AppBarCollapsedEvent());
            }
            return false;
          },
          child: CustomScrollView(
              controller: scrollController,
              // physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context)),
                sliverList,
                if (AppBloc.displayDataInHomeScreen.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1.5 / 8,
                        ),
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/wondering.svg',
                              width: 180.r,
                              height: 180.r,
                              color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .computeLuminance() <
                                      .5
                                  ? const Color(0xffefefef)
                                  : const Color(0xff1d1d1d),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لا يوجد تنبيهات بعد',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                    .computeLuminance() <
                                                .5
                                            ? const Color(0xffefefef)
                                            : const Color(0xff1d1d1d),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 43.h,
                  ),
                )
              ]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight =
        expandedHeight ?? MediaQuery.of(context).size.height * 2.2 / 8;
    _toolbarHeight = toolbarHeight ?? kToolbarHeight;

    return NestedScrollView(
        headerSliverBuilder: headerSliverBuilder, body: body());
  }
}
