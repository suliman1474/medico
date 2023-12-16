import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class UserOverview extends StatelessWidget {
  // final UserModel user;
  final String image;
  final String name;
  final String email;
  const UserOverview({
    super.key,
    required this.image,
    required this.name,
    required this.email,
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
              child: CustomImageView(
                imagePath: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: customTexttheme.titleLarge!.copyWith(
                  color: textColor,
                ),
              ),
              Text(
                email,
                style: customTexttheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}
