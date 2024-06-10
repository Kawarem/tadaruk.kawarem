import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final bool isExpandedWidget;

  const FadeAnimation(
      {super.key,
      required this.animation,
      required this.child,
      required this.isExpandedWidget});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: Tween(
                begin: isExpandedWidget ? 0.0 : 1.0,
                end: isExpandedWidget ? 1.0 : 0.0)
            .animate(CurvedAnimation(
                parent: animation,
                curve: Interval(isExpandedWidget ? 0.5 : 0.2,
                    isExpandedWidget ? 1.0 : 0.55))),
        child: child);
  }
}
