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

  AuthenticationController authController = Get.find<AuthenticationController>();
  @override
  // void dispose() {
  //   // Dispose of resources in the dispose method
  //   authController.email.dispose();
  //   authController.password.dispose();
  //   authController.discipline.dispose();
  //   authController.contact.dispose();
  //   authController.name.dispose();
  //   authController.college.dispose();
  //   authController.semester.dispose();
  //   authController.confirmpassword.dispose();
  //   super.dispose();
  // }

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
                          Icon(Icons.person, color: textColor.withOpacity(0.5)),
                          SizedBox(
                            width: 8.w,
                          ),
                          const Text('Name')
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                         controller: authController.name,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Name is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: 'Fola B',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
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
                          controller: authController.email,
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
                          controller: authController.password,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Password is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: '********************',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
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
                      Row(
                        children: [
                          CustomImageView(svgPath: IconConstant.icCollege),
                          SizedBox(
                            width: 8.w,
                          ),
                          const Text('College')
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          controller: authController.college,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'info is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: 'info@example.com',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          CustomImageView(svgPath: IconConstant.icDegree),
                          SizedBox(
                            width: 8.w,
                          ),
                          const Text('Discipline')
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          controller: authController.discipline,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'KMUKAT is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: 'KUMCAT',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          CustomImageView(svgPath: IconConstant.icDegree),
                          SizedBox(
                            width: 8.w,
                          ),
                          const Text('Semester')
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          controller: authController.semester,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'SemesterField is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: '7th',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          CustomImageView(svgPath: IconConstant.icContact),
                          SizedBox(
                            width: 8.w,
                          ),
                          const Text('Contact')
                        ],
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextFormField(
                          controller: authController.contact,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Contact is empty here';
                            }
                            return null;
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: textColor.withOpacity(0.6),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0.r), // Set y
                            ),
                            labelText: 'info@exaple.com',
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              GestureDetector(
                onTap: () async{
                if(_formKey.currentState!.validate()) {
                  await authController.createUser();
                }
                },
                child: AuthScreenButton(
                    color: const Color.fromRGBO(0, 63, 150, 1.0),
                    text: 'Sign Up'),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: 201.42.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SocialButton(image: IconConstant.icGoogle),
                        SizedBox(height: 5.h),
                        Text(
                          'Google',
                          style: TextStyle(
                              color: Colors.black, fontSize: 13.86.sp),
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
                          style: TextStyle(
                              color: Colors.black, fontSize: 13.86.sp),
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
                    "Already have an Account?",
                    style: TextStyle(fontSize: 13.86.sp),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 13.86.sp,
                        color: const Color.fromRGBO(26, 76, 110, 100),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
