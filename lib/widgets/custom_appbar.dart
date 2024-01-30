import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/search_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/screens/home/admin_profile_screen.dart';
import 'package:medico/screens/home/edit_profile_screen.dart';
import 'package:medico/screens/home/notifications_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';

import '../controllers/screen_controller.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(ScreenUtil().screenWidth, 90.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  ScreenController screenController = Get.find<ScreenController>();
  DbController dbController = Get.find();
  UserSearchController searchController = Get.find<UserSearchController>();
  late Future<UserModel?> user;
  late Future<Uint8List?> profile;
  String selectedValue = 'Name';
  List<String> filters = [
    'Name',
    'College',
    'Discipline',
    'Semester',
  ];
  @override
  void initState() {
    user = dbController.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 90.h,
        width: 424.w,
        decoration: BoxDecoration(
          color: color1,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(25),
          ).r,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: dbController.userRole.value == UserRole.USER
              ? GestureDetector(
                  onTap: () {
                    Get.to(NotificationsScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: 30.h,
                    width: 30.w,
                    child: CustomImageView(
                      svgPath: IconConstant.icNewsFeedSelected,
                      height: 30.h,
                      width: 30.w,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          actions: [
            screenController.bottomNavIndex.value == 3
                ? dbController.userRole.value == UserRole.USER
                    ? CustomImageView(
                        svgPath: IconConstant.icEdit,
                        height: 35.h,
                        width: 35.w,
                        margin: EdgeInsets.only(right: 20.w, top: 20.h),
                        onTap: () {
                          Get.to(EditProfileScreen());
                        },
                      )
                    : Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 0.w,
                            ),
                            height: 40.h,
                            width: 340.w,
                            child: TextFormField(
                              controller: searchController.search.value,
                              onChanged: (value) {
                                if (selectedValue == 'Name') {
                                  searchController.filterUsers(value);
                                } else if (selectedValue == 'College') {
                                  searchController.filterUsersbyCollege(value);
                                } else if (selectedValue == 'Discipline') {
                                  searchController
                                      .filterUsersbyDiscipline(value);
                                } else {
                                  searchController.filterUsersbySemester(value);
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search',
                                hintStyle: customTexttheme.bodyLarge,
                                suffixIcon: Container(
                                  height: 28.h,
                                  width: 28.w,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal: 10.w,
                                  ),
                                  child: Center(
                                    child: CustomImageView(
                                      svgPath: IconConstant.icSearch,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                enabled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10).r,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10).r,
                                ),
                                contentPadding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 0.w,
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            constraints: BoxConstraints(
                              maxHeight: 400.h,
                              maxWidth: 205.w,
                            ),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.zero,
                            position: PopupMenuPosition.under,
                            icon: Icon(
                              Icons.filter_list,
                            ),
                            initialValue: selectedValue,
                            onSelected: (value) {
                              // Handle the selected option
                              setState(() {
                                selectedValue = value;
                              });
                              print(selectedValue);
                            },
                            itemBuilder: (BuildContext context) {
                              return filters.map((String choice) {
                                return PopupMenuItem<String>(
                                  height: 40.h,
                                  textStyle: customTexttheme.displaySmall,
                                  value: choice,
                                  child: Text(
                                    choice,
                                    style: customTexttheme.displaySmall,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      )
                : FutureBuilder(
                    future: user,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          profile = dbController.getUserImage(user);
                          return FutureBuilder<Uint8List?>(
                            future: profile,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Uint8List? imageBytes = snapshot.data;

                                if (imageBytes != null) {
                                  try {
                                    return GestureDetector(
                                      onTap: () {
                                        dbController.userRole.value ==
                                                UserRole.USER
                                            ? screenController
                                                .bottomNavIndex.value = 3
                                            : Get.to(AdminProfileScreen());
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: 20.w,
                                          top: 20.h,
                                        ),
                                        width: 45.w,
                                        height: 45.h,
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
                                            errorBuilder:
                                                (context, e, stackTrace) {
                                              return Container(
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    return Container();
                                  }
                                } else {
                                  return Container(
                                    margin:
                                        EdgeInsets.only(right: 20.w, top: 20.h),
                                    height: 45.r,
                                    width: 45.r,
                                    decoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CustomImageView(
                                        imagePath: IconConstant.icTopbarProfile,
                                        fit: BoxFit.cover,
                                        onTap: () {
                                          dbController.userRole.value ==
                                                  UserRole.USER
                                              ? screenController
                                                  .bottomNavIndex.value = 3
                                              : Get.to(AdminProfileScreen());
                                        },
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Container();
                              }
                            },
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
          ],
        ),
      );
    });
  }
}
