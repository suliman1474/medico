import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class Slides extends StatefulWidget {
  int index;
  bool update;
  Slides({super.key, required this.index, required this.update});

  @override
  State<Slides> createState() => _SlidesState();
}

class _SlidesState extends State<Slides> {
  late int unit;
  late bool updated;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unit = widget.index;
    updated = widget.update;
  }

  @override
  Widget build(BuildContext context) {
    return updated
        ? Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 1,
                  sigmaY: 1,
                  tileMode: TileMode.decal,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                  height: 190.h,
                  width: 192.w,
                  decoration: BoxDecoration(
                    color: secondryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        height: 71.h,
                        width: 171.w,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5).r,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              height: 44.h,
                              width: 44.w,
                              decoration: BoxDecoration(
                                color: color2,
                                borderRadius: BorderRadius.circular(15).r,
                              ),
                              child: Center(
                                child: CustomImageView(
                                  svgPath: IconConstant.icFile,
                                  height: 35.h,
                                  width: 35.w,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              //margin: EdgeInsets.only(top: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unit $unit: Nursing Process_Medico Slides.ppt',
                                    style: customTexttheme.bodySmall,
                                  ),
                                  Text(
                                    '60 Slides . 1.4 MB . PPT',
                                    style: customTexttheme.bodySmall!.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              CustomImageView(
                svgPath: IconConstant.icDownloadOrange,
                height: 60.h,
                width: 60.h,
              ),
            ],
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            height: 134.h,
            width: 192.w,
            decoration: BoxDecoration(
              color: secondryColor,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  height: 71.h,
                  width: 171.w,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5).r,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        height: 44.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(15).r,
                        ),
                        child: Center(
                          child: CustomImageView(
                            svgPath: IconConstant.icFile,
                            height: 35.h,
                            width: 35.w,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unit $unit: Nursing Process_Medico Slides.ppt',
                              style: customTexttheme.bodySmall,
                            ),
                            Text(
                              '60 Slides . 1.4 MB . PPT',
                              style: customTexttheme.bodySmall!.copyWith(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
