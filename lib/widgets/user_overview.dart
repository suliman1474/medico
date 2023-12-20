import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';

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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
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
            margin: bottomsheet
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 20.w,
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
    );
  }
}
