import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';

class ArchivedMistakesScreen extends StatelessWidget {
  const ArchivedMistakesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SqlCubit, SqlState>(
      builder: (context, state) {
        var sqlCubit = SqlCubit.get(context);
        return BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('الأرشيف'),
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: categoriesRow(context)),
                  if (AppBloc.displayDataInArchivedMistakesScreen.isEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 1.1 / 4,
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/wondering.svg',
                                width: 180.r,
                                height: 180.r,
                                color: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .color,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'لا يوجد تنبيهات مؤرشفة',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return expansionTiles(context,
                          model: AppBloc
                              .displayDataInArchivedMistakesScreen[index],
                          sqlCubit: sqlCubit,
                          isArchived: true);
                    },
                        childCount:
                            AppBloc.displayDataInArchivedMistakesScreen.length),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
