// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';

import '../../controllers/screen_controller.dart';
import '../models/folder_model.dart';

class Folder extends StatefulWidget {
  FolderModel folder;
  UniqueKey keyU;
  bool ifdownloaded;
  bool updatable;

  Folder(
      {super.key,
      required this.folder,
      required this.keyU,
      required this.ifdownloaded,
      this.updatable = false});

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
    //   'Rename',
    // 'Copy',
    // 'Move',
    'Delete',
    // 'Sharing',
    // 'Appearance',
  ];

  late Widget newscreen;
  // bool visibility = widget.updatable;
  late String foldername;
  late bool ifdownloaded;
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
    ifdownloaded = widget.ifdownloaded;
    foldername = folder!.name;
    // ifdownloaded = widget.downloaded;
  }

  @override
  Widget build(BuildContext context) {
    FilesController filesController = Get.find();
    return Obx(() {
      ;

      return dbController.userRole.value == UserRole.ADMIN || ifdownloaded
          ? Stack(
              key: key,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                  //  width: 379.w,
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
                              visible: widget.updatable &&
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
                          visible: widget.updatable &&
                              dbController.userRole.value == UserRole.USER,
                          child: GestureDetector(
                            onTap: () {
                              // filesController.downloadFilesFromFolder(
                              //     folder!.id, folder?.path);
                              ;
                              filesController.findFilesToDownload(folder!.id);
                            },
                            child: CustomImageView(
                              svgPath: IconConstant.icDownload,
                              height: 38.h,
                              width: 38.w,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<String>(
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
                          icon: CustomImageView(
                            svgPath: IconConstant.icOption,
                            height: 20.h,
                            width: 10.w,
                            margin: EdgeInsets.only(right: 10.w),
                          ),
                          onSelected: (value) async {
                            // Handle the selected option
                            switch (value) {
                              //  case 'Rename':
                              // Handle rename action
                              // break;
                              // case 'Copy':
                              // // Handle copy action
                              // // break;
                              // case 'Move':
                              // Handle move actions
                              // break;
                              case 'Delete':
                                //if addmin then delete folder from database
                                if (dbController.userRole.value ==
                                    UserRole.ADMIN) {
                                  await filesController.deleteAdminFolder(
                                      folder!.id, folder!.path);
                                  break;
                                }
                                // if user then delette folder from hive database
                                else {
                                  ;
                                  dbController.deleteFolderUser(folder!.id);
                                  break;
                                }

                              // Handle delete action
                              // break;
                              // case 'Sharing':
                              //   // Handle delete action
                              //   setState(() {
                              //     sharing = !sharing;
                              //   });
                              // // break;
                              // case 'Appearance':
                              // Handle delete action
                              // setState(() {
                              //   appearance = !appearance;
                              // });
                              // break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {
                              // 'Rename',
                              // 'Copy',
                              // 'Move',
                              'Delete',
                              // 'Sharing',
                              // 'Appearance',
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
                                            style: customTexttheme.displaySmall,
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
                                              inactiveTrackColor: Colors.grey,
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
                                            style: customTexttheme.displaySmall,
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
              key: key,
              alignment: Alignment.centerRight,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 1,
                    sigmaY: 1,
                    tileMode: TileMode.decal,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                      // width: 379.w,
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 25.w),
                  child: MaterialButton(
                    color: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                    onPressed: () async {
                      ;
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result == true) {
                        ;
                        Get.dialog<bool>(
                          AlertDialog(
                            title: Text(
                              'Download Confirmation',
                              style: customTexttheme.displaySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            backgroundColor: color1,
                            content: Text(
                              'Do you want to download files from this folder?',
                              style: customTexttheme.displaySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  filesController.downloadFilesFromFolder(
                                      folder!.id, folder?.path); // Yes button
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
                      } else {
                        Indicator.showToast(
                            'No Internet Connection', Colors.red);

                        //  print(InternetConnectionChecker().lastTryResults);
                      }
                    },
                    child: Text(
                      'Download',
                      style: customTexttheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                // GestureDetector(
                //   child: CustomImageView(
                //     svgPath: IconConstant.icDownload,
                //     height: 38.h,
                //     width: 38.w,
                //     margin: EdgeInsets.only(right: 40.w),
                //   ),
                // ),
              ],
            );
    });
  }
}
