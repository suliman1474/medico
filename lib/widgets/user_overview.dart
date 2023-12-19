import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';

class UserOverview extends StatelessWidget {
  final UserModel user;

  const UserOverview({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            height: 65.h,
            width: 65.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.5.r),
              child: Image.network(
                user.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: customTexttheme.titleMedium!
                    .copyWith(color: textColor, fontSize: 14.sp),
              ),
              Text(
                user.email,
                style: customTexttheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}
