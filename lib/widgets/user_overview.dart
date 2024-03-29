import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/screens/home/user_detail_screen.dart';

class UserOverview extends StatelessWidget {
  final UserModel user;
  bool bottomsheet;

  UserOverview({
    super.key,
    required this.user,
    required this.bottomsheet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(UserDetailScreen(user: user));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        // padding: bottomsheet
        //     ? EdgeInsets.symmetric(horizontal: 20.w)
        //     : EdgeInsets.zero,
        height: 83.h,
        width: 392.w,
        decoration: BoxDecoration(
          color: secondryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
              height: bottomsheet ? 50.h : 65.h,
              width: bottomsheet ? 50.w : 65.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: bottomsheet
                    ? BorderRadius.circular(25.r)
                    : BorderRadius.circular(33.r),
                child: user.image!.isNotEmpty
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: user.image!,
                        placeholder: (context, url) => Container(
                          height: 30,
                          width: 30,
                          child: LinearProgressIndicator(
                            color: Colors.grey.shade200,
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          IconConstant.icTopbarProfile,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        IconConstant.icTopbarProfile,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: bottomsheet
                      ? customTexttheme.titleMedium!.copyWith(
                          color: textColor,
                          fontSize: 17.sp,
                        )
                      : customTexttheme.titleMedium!.copyWith(
                          color: textColor,
                          fontSize: 30.sp,
                        ),
                ),
                Text(
                  user.email,
                  style: bottomsheet
                      ? customTexttheme.bodySmall!.copyWith(
                          fontSize: 13.sp,
                        )
                      : customTexttheme.bodySmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
