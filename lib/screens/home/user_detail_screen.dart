import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

class UserDetailScreen extends StatelessWidget {
  UserModel user;
  UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_circle_left_outlined,
              color: color1,
            ),
          ),
          actions: [
            CustomElevatedButton(
              onTap: () {},
              text: 'Block',
              buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                color: white,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: BorderSide.none,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).r,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 4,
                  ),
                ],
              ),
              height: 30.h,
              width: 70.w,
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            ),
          ],
        ),
        body: Container(
          height: 250.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: secondryColor,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    height: 65.h,
                    width: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33.r),
                      child: user.image!.isNotEmpty
                          ? Image.network(
                              user.image!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              IconConstant.icTopbarProfile,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: customTexttheme.titleLarge!.copyWith(
                              color: textColor,
                            ),
                          ),
                          Text(
                            user.email,
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        svgPath: IconConstant.icCollege,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        user.college,
                        style: customTexttheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        svgPath: IconConstant.icDegree,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        user.discipline,
                        style: customTexttheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomImageView(
                      svgPath: IconConstant.icContact,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      user.contact,
                      style: customTexttheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
