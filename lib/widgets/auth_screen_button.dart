import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreenButton extends StatelessWidget {
  AuthScreenButton({super.key, required this.color, required this.text});
  String text;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 322.w,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10.r)),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold),
      )),
    );
  }
}
