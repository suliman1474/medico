import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/about_model.dart';
import 'package:medico/screens/home/privacy_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool contactus = false;
  DbController dbController = Get.find();
  AuthenticationController authController = Get.find();
  FilesController filesController = Get.find();
  ScreenController screenController = Get.find();
  late Future<UserModel?> user;
  late Future<Uint8List?> profile;
  late AboutModel info;
  @override
  void initState() {
    user = dbController.getUser();
    info = authController.aboutInfo.value!;
    super.initState();
  }

  launchInsta() async {
    final url = info.insta;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  sendMail() async {
    // Android and iOS
    final uri = 'mailto:${info.gmail}?subject=FromMedicoApp&body=Hello';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      throw 'Could not launch $uri';
    }
  }

  whatsapp() async {
    var androidUrl =
        "whatsapp://send?phone=${info.whatsapp}&text=Assalamualaikum, I Am here directly through Medico Slides App. Can you facilitate me, please!";

    try {
      await launchUrl(
        Uri.parse(androidUrl),
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      throw 'Could not launch $androidUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        screenController.onWillPop();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                profile = dbController.getUserImage(user);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                FutureBuilder<Uint8List?>(
                                  future: profile,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Uint8List? imageBytes = snapshot.data;

                                      if (imageBytes != null) {
                                        try {
                                          return Container(
                                            width: 100.w,
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50.r,
                                              ),
                                              child: Image.memory(
                                                imageBytes,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, e, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          return Container();
                                        }
                                      } else {
                                        return Expanded(
                                          flex: 1,
                                          child: CustomImageView(
                                            imagePath:
                                                IconConstant.icTopbarProfile,
                                            height: 100.h,
                                            width: 100.w,
                                            radius: BorderRadius.circular(50).r,
                                          ),
                                        );
                                      }
                                    } else {
                                      return Expanded(
                                        flex: 1,
                                        child: CustomImageView(
                                          imagePath:
                                              IconConstant.icTopbarProfile,
                                          height: 100.h,
                                          width: 100.w,
                                          radius: BorderRadius.circular(50).r,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: customTexttheme.titleLarge!
                                              .copyWith(
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          user.email,
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
                                      user.college,
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
                                      user.discipline,
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
                                    user.contact,
                                    style: customTexttheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ;
                                Get.dialog<bool>(
                                  AlertDialog(
                                    title: Text(
                                      'Reset App',
                                      style: customTexttheme.displaySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    backgroundColor: color1,
                                    content: Text(
                                      'Do you want to reset the app',
                                      style: customTexttheme.displaySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                          filesController
                                              .deleteAllFoldersInsideRoot();
                                        },
                                        child: Text(
                                          'Yes',
                                          style: customTexttheme.displaySmall
                                              ?.copyWith(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back(); // No button
                                        },
                                        child: Text(
                                          'No',
                                          style: customTexttheme.displaySmall
                                              ?.copyWith(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            'Reset App',
                                            style: customTexttheme.bodyLarge!
                                                .copyWith(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            'Rate App',
                                            style: customTexttheme.bodyLarge!
                                                .copyWith(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            'Share App',
                                            style: customTexttheme.bodyLarge!
                                                .copyWith(
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
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: contactus == false
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                child: Text(
                                                  'Contact Us',
                                                  style: customTexttheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: CustomImageView(
                                              onTap: () {
                                                setState(() {
                                                  contactus = !contactus;
                                                });
                                              },
                                              svgPath:
                                                  IconConstant.icForwardWhite,
                                              height: 15.h,
                                              width: 15.w,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              sendMail();
                                            },
                                            child: Container(
                                              height: 50.h,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white,
                                              ),
                                              child: Center(
                                                child: CustomImageView(
                                                  imagePath:
                                                      IconConstant.icGmail,
                                                  height: 40.h,
                                                  width: 40.w,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () {
                                              launchInsta();
                                            },
                                            child: Container(
                                              height: 50.h,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white,
                                              ),
                                              child: Center(
                                                child: CustomImageView(
                                                  imagePath:
                                                      IconConstant.icInsta,
                                                  height: 40.h,
                                                  width: 40.w,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () {
                                              whatsapp();
                                            },
                                            child: Container(
                                              height: 50.h,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white,
                                              ),
                                              child: Center(
                                                child: CustomImageView(
                                                  imagePath:
                                                      IconConstant.icWhatsapp,
                                                  height: 40.h,
                                                  width: 40.w,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 180.w),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                contactus = !contactus;
                                              });
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios_new_rounded,
                                              color: white,
                                              size: 15,
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
                                Get.to(PrivacyPolicy(gmail: info.gmail));
                              },
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            'Privacy Policy',
                                            style: customTexttheme.bodyLarge!
                                                .copyWith(
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
                                authController.logout();
                                screenController.bottomNavIndex.value = 0;
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Icon(
                                        Icons.logout_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 11,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Text(
                                          'Log Out',
                                          style: customTexttheme.bodyLarge!
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
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
              } else {
                return Center(
                  child: Indicator.loader(),
                );
              }
            } else {
              return Center(
                child: Indicator.loader(),
              );
            }
          },
        ),
      ),
    );
  }
}
