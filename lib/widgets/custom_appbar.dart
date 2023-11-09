import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_image_view.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(mediaQueryData.size.width, 90.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20, top: 20).h,
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
                    Navigator.of(context).pushNamed('/profile');
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
