import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/models/about_model.dart';

import '../../core/text_theme.dart';
import '../../widgets/custom_image_view.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late AboutModel info;
  ScreenController screenController = Get.find();
  AuthenticationController authController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // info = authController.aboutInfo.value!;
  }

  @override
  Widget build(BuildContext context) {
    // String description =
    //     'At medico slides, our mission is to empower the next generation of medical professionals by providing a comprehensive and organized platform for their educational needs. Our vision is to revolutionize medical education, making it accessible and engaging for all students.\n'
    //     '\n'
    //     'Our goal is to create a vast collection of medical books, MCQs and PDF files, meticulously organized to streamline your learning experience. We aim to be your trusted companion on your academic journey, offering the resources you need to excel in your studies and ultimately contribute to the field of medication.\n'
    //     '\n'
    //     '“Join us in shaping the future of medical education with Medico Slides”.';

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          screenController.onWillPop();
        },
        child: Obx(() {
          info = authController.aboutInfo.value!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      children: [
                        CustomImageView(
                          url: info.image,
                          height: 250.h,
                          width: 240.w,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(15.r),
                        ),
                        Text(
                          info.ownername,
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: secondryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Text(
                            'About Us',
                            style: customTexttheme.titleMedium,
                          ),
                        ),
                        Text(
                          info.description,
                          style: customTexttheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
