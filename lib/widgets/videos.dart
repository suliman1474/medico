import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        width: 379.w,
        height: 76.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).r,
          color: secondryColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                // margin: EdgeInsets.all(10.r),
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color2,
                ),
                child: Center(
                  child: CustomImageView(
                    svgPath: IconConstant.icPlay,
                    height: 25.h,
                    width: 25.w,
                    fit: BoxFit.scaleDown,
                    margin: EdgeInsets.only(left: 3.w),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Unit 1: Paragraph Writing Skills ',
                  style: customTexttheme.displayLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
