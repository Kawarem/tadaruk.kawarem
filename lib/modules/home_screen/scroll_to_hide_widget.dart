import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';

class ScrollToHideWidget extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final double height;

  const ScrollToHideWidget(
      {super.key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 200),
      required this.height});

  // bool isVisible = true;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   widget.controller.addListener(listen);
  // }
  //
  // void listen() {
  //   final direction = widget.controller.position.userScrollDirection;
  //   if (direction == ScrollDirection.forward) {
  //     show();
  //   } else if (direction == ScrollDirection.reverse) {
  //     hide();
  //   }
  //   if (widget.controller.position.pixels < 5.h) {
  //     show();
  //   }
  // }
  //
  // void show() {
  //   if (!isVisible)
  //     setState(() {
  //       isVisible = true;
  //     });
  // }
  //
  // void hide() {
  //   if (isVisible)
  //     setState(() {
  //       isVisible = false;
  //     });
  // }9

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScrollToHideCubit(controller),
      child: BlocBuilder<ScrollToHideCubit, ScrollToHideState>(
        builder: (context, scrollState) {
          return BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppBarCollapsedState) {
                if (state.isCollapsed) {
                  BlocProvider.of<ScrollToHideCubit>(context).appBarCollapsed();
                }
              }
            },
            child: AnimatedContainer(
              duration: duration,
              height: scrollState.isVisible ? height : 0,
              child: Wrap(children: [child]),
            ),
          );
        },
      ),
    );
  }
}

class ScrollToHideCubit extends Cubit<ScrollToHideState> {
  final ScrollController _controller;

  ScrollToHideCubit(this._controller)
      : super(ScrollToHideState(isVisible: true)) {
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    final direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      emit(state.copyWith(isVisible: true));
    } else if (direction == ScrollDirection.reverse) {
      emit(state.copyWith(isVisible: false));
    }
    // else if (appBarIsCollapsedGlobal) {
    //   emit(state.copyWith(isVisible: true));
    // }
  }

  void appBarCollapsed() {
    emit(state.copyWith(isVisible: true));
  }

  @override
  Future<void> close() {
    _controller.removeListener(_handleScroll);
    return super.close();
  }
}

class ScrollToHideState {
  bool isVisible;

  ScrollToHideState({
    required this.isVisible,
  });

  ScrollToHideState copyWith({
    bool? isVisible,
  }) {
    return ScrollToHideState(
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
