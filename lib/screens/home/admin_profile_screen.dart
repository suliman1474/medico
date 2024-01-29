import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/screens/home/edit_profile_screen.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  AuthenticationController authController = Get.find();
  DbController dbController = Get.find();
  late Future<UserModel?> user;
  late Future<Uint8List?> profile;
  @override
  void initState() {
    user = dbController.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: offwhite,
            size: 28,
          ),
        ),
        actions: [
          CustomImageView(
            svgPath: IconConstant.icEdit,
            height: 35.h,
            width: 35.w,
            margin: EdgeInsets.only(right: 20.w, top: 10.h),
            onTap: () {
              Get.to(EditProfileScreen);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final user = snapshot.data!;
              profile = dbController.getUserImage(user);
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
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
                                print('image is found in hive');
                                try {
                                  return Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        50.r,
                                      ),
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, e, stackTrace) {
                                          print(
                                            'Error in image displaying: $e',
                                          );
                                          print('stack trace: $stackTrace');
                                          return Container(
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error decoding image: $e');
                                  return Container();
                                }
                              } else {
                                return Expanded(
                                  flex: 1,
                                  child: CustomImageView(
                                    imagePath: IconConstant.icTopbarProfile,
                                    height: 100.h,
                                    width: 100.w,
                                    radius: BorderRadius.circular(50).r,
                                  ),
                                );
                              }
                            } else {
                              print('image is not found in hive');
                              return Expanded(
                                flex: 1,
                                child: CustomImageView(
                                  imagePath: IconConstant.icTopbarProfile,
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
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: customTexttheme.titleLarge!.copyWith(
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
                    CustomElevatedButton(
                      onTap: () {
                        authController.logout();
                      },
                      text: 'Log Out',
                      buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      width: 350.w,
                      height: 50.h,
                      margin: EdgeInsets.symmetric(vertical: 30.h),
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
    );
  }
}
