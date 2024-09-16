import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  final Uri _url = Uri.parse(KAWAREM_BOT_LINK);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حول'),
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
                  if (await canLaunchUrl(_url)) {
                    await launchUrl(_url);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16).r,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_outlined),
                      SizedBox(
                        width: 16.w,
                      ),
                      Text(
                        'تواصل معنا',
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
