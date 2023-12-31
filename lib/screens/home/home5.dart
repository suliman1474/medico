import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/slides.dart';

class Home5 extends StatefulWidget {
  const Home5({super.key});

  @override
  State<Home5> createState() => _Home5State();
}

class _Home5State extends State<Home5> {
  final ScreenController screenController = Get.find();
  List<Widget> slides = [
    Slides(
      index: 1,
      update: false,
    ),
    Slides(
      index: 2,
      update: false,
    ),
    Slides(
      index: 3,
      update: false,
    ),
    Slides(
      index: 4,
      update: false,
    ),
    Slides(
      index: 5,
      update: false,
    ),
    Slides(
      index: 6,
      update: false,
    ),
    Slides(
      index: 7,
      update: true,
    ),
    Slides(
      index: 8,
      update: true,
    ),
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
                  r'...\1st Semester\English\Slides\',
                  style: customTexttheme.displayLarge,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: slides.length,
          itemBuilder: (context, index) {
            return slides[index];
          },
        ),
      ),
    );
  }
}
