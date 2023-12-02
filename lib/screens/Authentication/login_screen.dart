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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 322.w,
              child: Form(
                key: _formKey,
                child: OverflowBar(
                  overflowSpacing: 3,
                  children: [
                    SizedBox(
                      height: 150.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Log In', style: customTexttheme.titleLarge),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        CustomImageView(
                          svgPath: IconConstant.icEmail,
                          height: 25.h,
                          width: 25.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Email',
                          style: customTexttheme.bodySmall,
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
                          hintText: 'Email',
                          hintStyle: customTexttheme.bodySmall!.copyWith(
                            color: textColor.withOpacity(0.25),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 15.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        CustomImageView(
                          svgPath: IconConstant.icPassword,
                          height: 25.h,
                          width: 20.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Password',
                          style: customTexttheme.bodySmall,
                        ),
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0.r), // Set y
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor.withOpacity(0.6),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0.r), // Set y
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.6),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0.r), // Set y
                          ),
                          hintText: '**********',
                          hintStyle: customTexttheme.bodySmall!.copyWith(
                            color: textColor.withOpacity(0.25),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 15.w,
                          ),
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
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: customTexttheme.labelMedium,
                          ),
                        ),
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
              color: color1,
              text: 'Log in',
            ),
            SizedBox(
              height: 20.h,
            ),
            AuthScreenButton(color: color2, text: 'Log in as Admin'),
            SizedBox(
              height: 30.h,
            ),
            SizedBox(
              width: 177.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SocialButton(image: IconConstant.icGoogle),
                      SizedBox(height: 5.h),
                      Text(
                        'Google',
                        style: customTexttheme.labelMedium,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'or',
                      style: customTexttheme.labelMedium,
                    ),
                  ),
                  Column(
                    children: [
                      SocialButton(image: IconConstant.icApple),
                      SizedBox(height: 5.h),
                      Text(
                        'Apple',
                        style: customTexttheme.labelMedium,
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: customTexttheme.labelMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/signup');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Sign Up',
                        style: customTexttheme.labelLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
