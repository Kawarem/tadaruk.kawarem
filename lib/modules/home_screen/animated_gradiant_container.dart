import 'package:flutter/material.dart';

class AnimatedGradiantContainer extends StatefulWidget {
  final List<Color> colors;

  const AnimatedGradiantContainer({super.key, required this.colors});

  @override
  State<AnimatedGradiantContainer> createState() => _AnimatedGradiantState();
}

class _AnimatedGradiantState extends State<AnimatedGradiantContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _leftAlignmentAnimation;
  late Animation<Alignment> _rightAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 12));
    _leftAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerLeft, end: Alignment.topCenter),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topCenter, end: Alignment.centerRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerRight, end: Alignment.bottomCenter),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomCenter, end: Alignment.centerLeft),
          weight: 1),
    ]).animate(_controller);
    _rightAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerRight, end: Alignment.bottomCenter),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomCenter, end: Alignment.centerLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerLeft, end: Alignment.topCenter),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topCenter, end: Alignment.centerRight),
          weight: 1),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: widget.colors,
              begin: _leftAlignmentAnimation.value,
              end: _rightAlignmentAnimation.value,
            )),
          );
        });
  }
}
