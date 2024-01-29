import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/auth_screen_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

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
  FocusNode confirmpasswordFocusNode = FocusNode();
  FocusNode collegeFocusNode = FocusNode();
  FocusNode disciplineFocusNode = FocusNode();
  FocusNode semesterFocusNode = FocusNode();
  FocusNode contactFocusNode = FocusNode();

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
    confirmpasswordFocusNode.dispose();
    collegeFocusNode.dispose();
    disciplineFocusNode.dispose();
    semesterFocusNode.dispose();
    contactFocusNode.dispose();
    authController.isObsecure.value = true;
    authController.isObsecure2.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                          Text('Sign up', style: customTexttheme.titleLarge),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
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
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.name,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Name required';
                            }
                            return null;
                          },
                          focusNode: nameFocusNode,
                          onFieldSubmitted: (value) {
                            emailFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: authController.email,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Email required';
                            }
                            return null;
                          },
                          focusNode: emailFocusNode,
                          onFieldSubmitted: (value) {
                            passwordFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.password,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Password required';
                            }
                            return null;
                          },
                          focusNode: passwordFocusNode,
                          onFieldSubmitted: (value) {
                            confirmpasswordFocusNode.requestFocus();
                          },
                          obscureText: authController.isObsecure.value,
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: 'fola99caus9',
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
                            'Confirm Password',
                            style: customTexttheme.bodySmall,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.confirmpassword,
                          validator: (text) {
                            if ((text == null || text.isEmpty) &&
                                authController.confirmpassword.text ==
                                    authController.password.text) {
                              return 'Password doesnt match';
                            }
                            return null;
                          },
                          focusNode: confirmpasswordFocusNode,
                          onFieldSubmitted: (value) {
                            collegeFocusNode.requestFocus();
                          },
                          obscureText: authController.isObsecure2.value,
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: 'fola99caus9',
                            hintStyle: customTexttheme.bodySmall!.copyWith(
                              color: textColor.withOpacity(0.25),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 15.w,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: authController
                                  .toggleObsecure2, // Remove the () here
                              child: Icon(
                                authController.isObsecure2.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icCollegeAuth,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'College',
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.college,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'College required';
                            }
                            return null;
                          },
                          focusNode: collegeFocusNode,
                          onFieldSubmitted: (value) {
                            disciplineFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: 'NorthWest Institute',
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
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icDegreeAuth,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Discipline',
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.discipline,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Degree required';
                            }
                            return null;
                          },
                          focusNode: disciplineFocusNode,
                          onFieldSubmitted: (value) {
                            semesterFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: 'Bs Nursing',
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
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icDegreeAuth,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Semester',
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: authController.semester,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Semester required';
                            }
                            return null;
                          },
                          focusNode: semesterFocusNode,
                          onFieldSubmitted: (value) {
                            contactFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: '6th',
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
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icContactAuth,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Contact',
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: authController.contact,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Contact required';
                            }
                            return null;
                          },
                          focusNode: contactFocusNode,
                          decoration: InputDecoration(
                            errorStyle: customTexttheme.bodySmall!.copyWith(
                              color: Colors.red.withOpacity(0.6),
                              height: 0.1.h,
                              fontWeight: FontWeight.w200,
                              fontSize: 12.sp,
                            ),
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
                            hintText: '03448765322',
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.createUser();
                  }
                },
                child: AuthScreenButton(color: color1, text: 'Sign Up'),
              ),
              SizedBox(
                height: 30.h,
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
