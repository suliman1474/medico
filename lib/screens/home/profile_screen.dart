import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool contactus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        imagePath: IconConstant.icTopbarProfile,
                        height: 100.h,
                        width: 100.w,
                        radius: BorderRadius.circular(50).r,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hussain Zakir',
                              style: customTexttheme.titleLarge!.copyWith(
                                color: textColor,
                              ),
                            ),
                            Text(
                              'hussain123@gmail.com',
                              style: customTexttheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomImageView(
                          svgPath: IconConstant.icCollege,
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Northwest Institute',
                          style: customTexttheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomImageView(
                          svgPath: IconConstant.icDegree,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Bs Nursing',
                          style: customTexttheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        svgPath: IconConstant.icContact,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        '0334298382',
                        style: customTexttheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color1,
            ),
            child: Column(
              children: [
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomImageView(
                            svgPath: IconConstant.icReset,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        Expanded(
                            flex: 11,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Reset App',
                                style: customTexttheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: CustomImageView(
                            svgPath: IconConstant.icForwardWhite,
                            height: 15.h,
                            width: 15.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white70,
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomImageView(
                            svgPath: IconConstant.icRate,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        Expanded(
                            flex: 11,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Rate App',
                                style: customTexttheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: CustomImageView(
                            svgPath: IconConstant.icForwardWhite,
                            height: 15.h,
                            width: 15.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white70,
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomImageView(
                            svgPath: IconConstant.icShareapp,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        Expanded(
                            flex: 11,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Share App',
                                style: customTexttheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: CustomImageView(
                            svgPath: IconConstant.icForwardWhite,
                            height: 15.h,
                            width: 15.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white70,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      contactus = !contactus;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: contactus == false
                        ? Row(
                            children: [
                              Flexible(
                                child: CustomImageView(
                                  svgPath: IconConstant.icContactus,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                              ),
                              Expanded(
                                  flex: 11,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Text(
                                      'Contact Us',
                                      style:
                                          customTexttheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 1,
                                child: CustomImageView(
                                  svgPath: IconConstant.icForwardWhite,
                                  height: 15.h,
                                  width: 15.w,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                height: 50.h,
                                width: 50.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: CustomImageView(
                                    imagePath: IconConstant.icGmail,
                                    height: 30.h,
                                    width: 30.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                height: 50.h,
                                width: 50.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: CustomImageView(
                                    imagePath: IconConstant.icInsta,
                                    height: 30.h,
                                    width: 30.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                height: 50.h,
                                width: 50.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: CustomImageView(
                                    imagePath: IconConstant.icWhatsapp,
                                    height: 30.h,
                                    width: 30.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const Divider(
                  color: Colors.white70,
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomImageView(
                            svgPath: IconConstant.icPrivacy,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        Expanded(
                            flex: 11,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Privacy Policy',
                                style: customTexttheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: CustomImageView(
                            svgPath: IconConstant.icForwardWhite,
                            height: 15.h,
                            width: 15.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
