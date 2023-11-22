import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  String? image;
  String? post;
  Post({
    super.key,
    this.image,
    this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
      width: 379.w,
      decoration: BoxDecoration(
        color: secondryColor,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CustomImageView(
                  imagePath: IconConstant.icAppLogo,
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(20).r,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medico Slides',
                      style: customTexttheme.displayLarge,
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy hh:mma').format(DateTime.now()),
                      style: customTexttheme.bodySmall!.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            child: post != null && post!.isNotEmpty
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text(
                      post!,
                      style: customTexttheme.bodyLarge,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Container(
            child: image != null && image!.isNotEmpty
                ? CustomImageView(
                    imagePath: image,
                    height: 172.h,
                    width: 293.w,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(10.r),
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                  )
                : const SizedBox.shrink(),
          ),
          Divider(
            indent: 20.w,
            endIndent: 20.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomImageView(
                  svgPath: IconConstant.icHeart,
                  height: 24.h,
                  width: 24.w,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Text(
                    '2.7k',
                    style: customTexttheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                CustomImageView(
                  svgPath: IconConstant.icShare,
                  height: 24.h,
                  width: 24.w,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
