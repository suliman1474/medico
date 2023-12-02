import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/widgets/custom_image_view.dart';

class SocialButton extends StatelessWidget {
  SocialButton({super.key, required this.image});
  String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(56, 101, 120, 100),
          width: 1.98.sp,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
          child: CustomImageView(
        svgPath: image,
        height: 30.h,
        width: 30.w,
      )),
    );
  }
}
