import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/videos.dart';

class Home6 extends StatefulWidget {
  const Home6({super.key});

  @override
  State<Home6> createState() => _Home6State();
}

class _Home6State extends State<Home6> {
  final ScreenController screenController = Get.find();
  List<Widget> folders = [
    Video(),
    Video(),
    Video(),
    Video(),
    Video(),
    Video(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(ScreenUtil().screenWidth, 50.h),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  screenController.goBackAt(AppPage.HomeScreen);
                },
                child: CustomImageView(
                  svgPath: IconConstant.icBack,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              GestureDetector(
                onTap: () {
                  screenController.goBackAt(AppPage.HomeScreen);
                },
                child: Text(
                  r'...\English\Video Lectures\',
                  style: customTexttheme.displayLarge,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return folders[index];
        },
      ),
    );
  }
}
