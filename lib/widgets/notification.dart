import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class NotificationWidget extends StatefulWidget {
  String title;
  String body;
  NotificationWidget({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  ScreenController screenController = Get.find();
  late String title;
  late String body;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.title;
    body = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          screenController.bottomNavIndex.value = 1;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        width: 379.w,
        height: 76.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).r,
          color: secondryColor,
        ),
        child: Row(
          children: [
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CustomImageView(
                imagePath: IconConstant.icAppLogo,
                height: 50.h,
                width: 50.w,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(20).r,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: customTexttheme.bodyMedium,
                ),
                Text(
                  body,
                  style: customTexttheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
