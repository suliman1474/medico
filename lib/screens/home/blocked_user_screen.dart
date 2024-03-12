import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/screens/Authentication/login_screen.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.to(const LoginScreen());
            },
            icon: Icon(
              Icons.arrow_circle_left_outlined,
              color: color1,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: secondryColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '''
Dear User,
\nWe regret to inform you that access to the app is currently restricted. We understand this might be frustrating, and we sincerely apologize for any inconvenience caused.
Please be assured that this action was taken to ensure the integrity and functionality of the application for all users. We strive to maintain a safe and enjoyable environment for everyone.
\nThank you for your understanding and cooperation.''',
            style: customTexttheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
