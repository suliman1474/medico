import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';

import '../../core/text_theme.dart';
import '../../widgets/custom_image_view.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 310.h,
            width: 255.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 220.h,
                  width: 245.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25.r)),
                  child: CustomImageView(
                      imagePath: 'assets/images/profile.png',
                      height: 250.h,
                      width: 40.w,
                      radius: BorderRadius.circular(15.0.r)),
                ),
                Text(
                  'Husain Zakir',
                  style: customTexttheme.titleMedium,
                ),
                Text(
                  '(Project Owner)',
                  style: customTexttheme.displaySmall,
                ),
              ],
            ),
          ),
          Container(
            height: 320.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
                color: secondryColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: 10.h, right: 3.w, left: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Us',
                      style: customTexttheme.titleMedium,
                    ),
                    Text(
                      'At medico slides, our mission is to empower the next generation of medical professionals by providing a comprehensive and organized platform for their educational needs. Our vision is to revolutionize medical education, making it accessible and engaging for all students.\n'
                      '\n'
                      'Our goal is to create a vast collection of medical books, MCQs and PDF files, meticulously organized to streamline your learning experience. We aim to be your trusted companion on your academic journey, offering the resources you need to excel in your studies and ultimately contribute to the field of medication.\n'
                      '\n'
                      '“Join us in shaping the future of medical education with Medico Slides”.',
                      style: customTexttheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
