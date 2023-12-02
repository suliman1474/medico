import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/auth_screen_button.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/social_button.dart';

import '../../controllers/auth_controller.dart';
import '../../core/text_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  AuthenticationController authController =
      Get.find<AuthenticationController>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of resources in the dispose method
    authController.email.dispose();
    authController.password.dispose();
    authController.name.dispose();
    authController.confirmpassword.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
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
                        height: 40.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Sign up', style: customTexttheme.titleLarge),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icName,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Name',
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.name,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Name is empty here';
                            }
                            return null;
                          },
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            hintText: 'Fola B',
                            hintStyle: customTexttheme.bodySmall!.copyWith(
                              color: textColor.withOpacity(0.25),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 15.w,
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
                          keyboardType: TextInputType.emailAddress,
                          controller: authController.email,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Email is empty here';
                            }
                            return null;
                          },
                          focusNode: emailFocusNode,
                          onFieldSubmitted: (value) {
                            passwordFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'fola@gmail.com',
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
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.password,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Password is empty here';
                            }
                            return null;
                          },
                          focusNode: passwordFocusNode,
                          obscureText: authController.isObsecure.value,
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
                              onTap: authController
                                  .toggleObsecure, // Remove the () here
                              child: Icon(
                                authController.isObsecure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              GestureDetector(
                onTap: () async {
                  print('===================sign up clicked =================');
                  if (_formKey.currentState!.validate()) {
                    print("==================calling user");
                    await authController.createUser();
                  }
                },
                child: AuthScreenButton(color: color1, text: 'Sign Up'),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: 201.42.w,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
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
                      "Already have an Account?",
                      style: customTexttheme.labelMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/login');
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          'Sign In',
                          style: customTexttheme.labelLarge,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
