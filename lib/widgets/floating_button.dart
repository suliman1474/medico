import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../core/colors.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        addOptions(context);
      },
      backgroundColor: Colors.transparent,
      shape: CircleBorder(),
      elevation: 0,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: CustomImageView(
        svgPath: IconConstant.icAdd,
        height: 40.h,
        width: 40.w,
      ),
    );
  }

  void addOptions(BuildContext context) {
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 180.h, horizontal: 50.w),
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  onTap: () {},
                  text: 'Add Folder',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () {},
                  text: 'Add PDF',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () {},
                  text: 'Add PPT',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () {},
                  text: 'Add Video',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () {},
                  text: 'Add Image',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
              ],
            ),
          );
        });
  }
}
