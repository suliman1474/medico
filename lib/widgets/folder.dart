// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/screens/home/folders_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../../controllers/screen_controller.dart';
import '../models/folder_model.dart';
import '../screens/home/home2.dart';

class Folder extends StatefulWidget {
  FolderModel folder;
  UniqueKey keyU;
  Folder({
    super.key,
    required this.folder,
    required this.keyU,
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

  List<String> menuOptions = [
    'Rename',
    'Copy',
    'Move',
    'Delete',
    'Sharing',
    'Appearance',
  ];

  late Widget newscreen;
  bool visibility = true;
  late String foldername;
  bool ifdownloaded = true;
  bool options = false;
  bool sharing = false;
  bool appearance = false;
  FolderModel? folder;
  late UniqueKey key;
  @override
  void initState() {
    super.initState();
    loadUser();
    folder = widget.folder;
    // newscreen = widget.screen;
    // visibility = widget.update;
    key = widget.keyU;
    foldername = folder!.name;
    // ifdownloaded = widget.downloaded;
  }

  @override
  Widget build(BuildContext context) {
    return dbController.userRole.value == UserRole.ADMIN || ifdownloaded
        ? Stack(
            children: [
              Container(
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
                      child: dbController.userRole.value == UserRole.USER
                          ? CustomImageView(
                              svgPath: IconConstant.icForward,
                              height: 14.h,
                              width: 9.w,
                              margin: EdgeInsets.only(right: 10.w),
                              onTap: () {
                                // screenController.updatePageAt(
                                //   AppPage.HomeScreen,
                                //   newscreen,
                                // );
                              },
                            )
                          : PopupMenuButton<String>(
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
                              icon: CustomImageView(
                                svgPath: IconConstant.icOption,
                                height: 20.h,
                                width: 10.w,
                                margin: EdgeInsets.only(right: 10.w),
                              ),
                              onSelected: (value) {
                                // Handle the selected option
                                switch (value) {
                                  case 'Rename':
                                  // Handle rename action
                                  // break;
                                  case 'Copy':
                                  // Handle copy action
                                  // break;
                                  case 'Move':
                                  // Handle move action
                                  // break;
                                  case 'Delete':
                                  // Handle delete action
                                  // break;
                                  case 'Sharing':
                                    // Handle delete action
                                    setState(() {
                                      sharing = !sharing;
                                    });
                                  // break;
                                  case 'Appearance':
                                  // Handle delete action
                                  // setState(() {
                                  //   appearance = !appearance;
                                  // });
                                  // break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return {
                                  'Rename',
                                  'Copy',
                                  'Move',
                                  'Delete',
                                  'Sharing',
                                  'Appearance',
                                }.map((String choice) {
                                  return PopupMenuItem<String>(
                                    height: 40.h,
                                    textStyle: customTexttheme.displaySmall,
                                    value: choice,
                                    child: choice == 'Sharing'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                choice,
                                                style: customTexttheme
                                                    .displaySmall,
                                              ),
                                              Transform.scale(
                                                scale: 0.6,
                                                child: Switch(
                                                  value: sharing,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      sharing = value;
                                                    });
                                                  },
                                                  activeColor: color1,
                                                  inactiveTrackColor:
                                                      Colors.grey,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                              ),
                                            ],
                                          )
                                        : choice == 'Appearance'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    choice,
                                                    style: customTexttheme
                                                        .displaySmall,
                                                  ),
                                                  Transform.scale(
                                                    scale: 0.6,
                                                    child: Switch(
                                                      value: appearance,
                                                      onChanged: (value) {
                                                        // setState(() {
                                                        //   appearance = value;
                                                        // });
                                                      },
                                                      activeColor: color1,
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                choice,
                                                style: customTexttheme
                                                    .displaySmall,
                                              ),
                                  );
                                }).toList();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
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
