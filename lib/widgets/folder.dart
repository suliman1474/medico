// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../../controllers/screen_controller.dart';

class Folder extends StatefulWidget {
  Widget screen;
  bool update;
  String name;
  bool downloaded;
  Folder({
    super.key,
    required this.screen,
    required this.update,
    required this.name,
    required this.downloaded,
  });

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  ScreenController screenController = Get.find<ScreenController>();
  DbController dbController = Get.find();

  void loadUser() async {
    await dbController.loadUserRole();
  }

  late Widget newscreen;
  late bool visibility;
  late String foldername;
  late bool ifdownloaded;
  @override
  void initState() {
    super.initState();
    loadUser();
    newscreen = widget.screen;
    visibility = widget.update;
    foldername = widget.name;
    ifdownloaded = widget.downloaded;
  }

  @override
  Widget build(BuildContext context) {
    return dbController.userRole.value == UserRole.ADMIN || ifdownloaded
        ? GestureDetector(
            onTap: () {
              print('should go to another page');
              screenController.updatePageAt(AppPage.HomeScreen, newscreen);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
              width: 379.w,
              height: 76.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20).r,
                color: secondryColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10).w,
                          width: 55.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15).r,
                            color: color2,
                          ),
                          child: CustomImageView(
                            svgPath: IconConstant.icFolder,
                            height: 30.h,
                            width: 30.w,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Visibility(
                          visible: visibility &&
                              dbController.userRole.value == UserRole.USER,
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w, top: 5.h),
                            height: 15.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: color1,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        foldername,
                        style: customTexttheme.displayLarge,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: visibility &&
                          dbController.userRole.value == UserRole.USER,
                      child: CustomImageView(
                        svgPath: IconConstant.icDownload,
                        height: 38.h,
                        width: 38.w,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomImageView(
                        svgPath: dbController.userRole.value == UserRole.USER
                            ? IconConstant.icForward
                            : IconConstant.icOption,
                        height: 14.h,
                        width: 9.w,
                        margin: EdgeInsets.only(right: 10.w),
                        onTap: dbController.userRole.value == UserRole.USER
                            ? () {
                                screenController.updatePageAt(
                                    AppPage.HomeScreen, newscreen);
                              }
                            : () {}),
                  ),
                ],
              ),
            ),
          )
        : Stack(
            alignment: Alignment.centerRight,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 1,
                  sigmaY: 1,
                  tileMode: TileMode.decal,
                ),
                child: GestureDetector(
                  onTap: () {
                    print('downloading folder');
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                    width: 379.w,
                    height: 76.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20).r,
                      color: secondryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(10).w,
                            width: 55.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).r,
                              color: color2,
                            ),
                            child: CustomImageView(
                              svgPath: IconConstant.icFolder,
                              height: 30.h,
                              width: 30.w,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              foldername,
                              style: customTexttheme.displayLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: CustomImageView(
                  svgPath: IconConstant.icDownload,
                  height: 38.h,
                  width: 38.w,
                  margin: EdgeInsets.only(right: 40.w),
                ),
              ),
            ],
          );
  }
}
