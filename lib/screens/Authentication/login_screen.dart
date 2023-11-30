import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/auth_screen_button.dart';
import 'package:medico/widgets/social_button.dart';

import '../../controllers/auth_controller.dart';
import '../../core/text_theme.dart';
import '../../widgets/custom_image_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthenticationController controller = Get.find<AuthenticationController>();
  @override
  void dispose() {
    // Dispose of resources in the dispose method
    controller.email.dispose();
    controller.password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 322.w,
              child: Form(
                key: _formKey,
                child: OverflowBar(
                  overflowSpacing: 5,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Log in', style: customTexttheme.titleLarge),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        CustomImageView(svgPath: IconConstant.icProfile),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Email',
                          style: customTexttheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 49.h,
                      child: TextFormField(
                        controller: controller.email,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Email is empty here';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: textColor.withOpacity(0.25)),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(
                                10.0.r), // Set your desired border radius
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        CustomImageView(svgPath: IconConstant.icPrivacy),
                        SizedBox(
                          width: 8.w,
                        ),
                        const Text('Password')
                      ],
                    ),
                    SizedBox(
                      height: 49.h,
                      child: TextFormField(
                        controller: controller.password,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Password is empty here';
                          }
                          return null;
                        },
                        obscureText: controller.isObsecure.value,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0.r), // Set y
                          ),
                          labelText: '********************',
                          labelStyle:
                              TextStyle(color: Colors.black.withOpacity(0.25)),
                          suffixIcon: GestureDetector(
                            onTap:
                                controller.toggleObsecure, // Remove the () here
                            child: Icon(
                              controller.isObsecure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 13.86,
                                  fontWeight: FontWeight.w600,
                                  color: textColor.withOpacity(0.6)),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            AuthScreenButton(
                color: const Color.fromRGBO(214, 90, 0, 1.0), text: 'Log in'),
            SizedBox(
              height: 30.h,
            ),
            AuthScreenButton(
                color: const Color.fromRGBO(0, 63, 150, 1.0),
                text: 'Log in as Admin'),
            SizedBox(
              height: 60.h,
            ),
            SizedBox(
              width: 177.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SocialButton(image: IconConstant.icGoogle),
                      SizedBox(height: 5.h),
                      Text(
                        'Google',
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.86.sp),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: const Text('or'),
                  ),
                  Column(
                    children: [
                      SocialButton(image: IconConstant.icApple),
                      SizedBox(height: 5.h),
                      Text(
                        'Apple',
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.86.sp),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account?",
                  style: TextStyle(fontSize: 13.86.sp),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 13.86.sp,
                      color: const Color.fromRGBO(26, 76, 110, 100),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
