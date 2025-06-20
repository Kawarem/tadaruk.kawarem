import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tadaruk/theme/theme_bloc/theme_bloc.dart';

import '../../theme/app_theme.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الثيمات'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).r,
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is LoadedThemeState) {
              return GridView.count(
                crossAxisSpacing: 16,
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme0.svg',
                    isSelected: (state.themeIndex == 0),
                    index: 0,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme1.svg',
                    isSelected: (state.themeIndex == 1),
                    index: 1,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme2.svg',
                    isSelected: (state.themeIndex == 2),
                    index: 2,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme3.svg',
                    isSelected: (state.themeIndex == 3),
                    index: 3,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme4.svg',
                    isSelected: (state.themeIndex == 4),
                    index: 4,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme5.svg',
                    isSelected: (state.themeIndex == 5),
                    index: 5,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme6.svg',
                    isSelected: (state.themeIndex == 6),
                    index: 6,
                  ),
                  themeCard(
                    context,
                    svg: 'assets/svgs/theme7.svg',
                    isSelected: (state.themeIndex == 7),
                    index: 7,
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

Widget themeCard(context,
        {required String svg, required bool isSelected, required int index}) =>
    GestureDetector(
      onTap: () {
        BlocProvider.of<ThemeBloc>(context)
            .add(ThemeChangedEvent(theme: AppTheme.values[index]));
      },
      child: Stack(children: [
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25).r,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SvgPicture.asset(
            svg,
            width: 100.r,
            height: 100.r,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25).r,
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 5.r)),
          ),
        ),
      ]),
    );
