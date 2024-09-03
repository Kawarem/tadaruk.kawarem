import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadaruk/state_management/sql_cubit/sql_cubit.dart';

class BackupAndRestoreScreen extends StatelessWidget {
  const BackupAndRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sqlCubit = SqlCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي والاستعادة'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  sqlCubit.backupDatabase();
                },
                child: Container(
                  padding: const EdgeInsets.all(16).r,
                  child: Row(
                    children: [
                      const Icon(Icons.file_copy_outlined),
                      SizedBox(
                        width: 16.w,
                      ),
                      Text(
                        'إنشاء نسخة احتياطية محلياً',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  sqlCubit.restoreDatabase();
                },
                child: Container(
                  padding: const EdgeInsets.all(16).r,
                  child: Row(
                    children: [
                      const Icon(Icons.restore_page_outlined),
                      SizedBox(
                        width: 16.w,
                      ),
                      Text(
                        'استعادة نسخة احتياطية محلية',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
