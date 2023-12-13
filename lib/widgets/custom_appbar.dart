import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/screens/home/edit_profile_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../controllers/screen_controller.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(ScreenUtil().screenWidth, 90.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  ScreenController screenController = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 90.h,
        width: 424.w,
        decoration: BoxDecoration(
          color: color1,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(25),
          ).r,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              height: 30.h,
              width: 30.w,
              child: CustomImageView(
                svgPath: IconConstant.icNewsFeedSelected,
                height: 30.h,
                width: 30.w,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          actions: [
            screenController.bottomNavIndex.value == 3
                ? CustomImageView(
                    svgPath: IconConstant.icEdit,
                    height: 35.h,
                    width: 35.w,
                    margin: EdgeInsets.only(right: 20.w, top: 20.h),
                    onTap: () {
                      Get.to(EditProfileScreen());
                    },
                  )
                : Container(
                    margin: EdgeInsets.only(right: 20.w, top: 20.h),
                    height: 45.r,
                    width: 45.r,
                    decoration: BoxDecoration(
                      color: white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CustomImageView(
                        imagePath: IconConstant.icTopbarProfile,
                        fit: BoxFit.cover,
                        onTap: () {
                          setState(() {
                            screenController.bottomNavIndex.value = 3;
                          });
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
