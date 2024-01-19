import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../core/colors.dart';

class CustomFloatingButton extends StatelessWidget {
  final String? parentId;
  CustomFloatingButton({super.key, this.parentId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        addOptions(context);
      },
      backgroundColor: Colors.transparent,
      shape: CircleBorder(),
      elevation: 0,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: CustomImageView(
        svgPath: IconConstant.icAdd,
        height: 40.h,
        width: 40.w,
      ),
    );
  }

  addOptions(BuildContext context) {
    FilesController filesController = Get.find();
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 180.h, horizontal: 50.w),
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    print('pressed');
                    print('parentt id in floating button: ${parentId}');
                    await filesController
                        .showCreateFolderDialog(parentId ?? '');
                    // Get.back();
                  },
                  text: 'Add Folder',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf']);

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();

                      filesController.uploadFiles(files, parentId ?? '');
                    } else {
                      // User canceled the picker
                    }
                  },
                  text: 'Add PDF',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['ppt']);

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();

                      filesController.uploadFiles(files, parentId ?? '');
                    } else {
                      // User canceled the picker
                    }
                  },
                  text: 'Add PPT',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
                    );

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();

                      filesController.uploadFiles(files, parentId ?? '');
                    } else {
                      // User canceled the picker
                    }
                  },
                  text: 'Add Video',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.image,
                    );

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();

                      filesController.uploadFiles(files, parentId ?? '');
                    } else {
                      // User canceled the picker
                    }
                  },
                  text: 'Add Image',
                  buttonTextStyle: customTexttheme.displaySmall!.copyWith(
                    color: Colors.white,
                  ),
                  height: 40.h,
                  width: 150.w,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
              ],
            ),
          );
        });
  }
}
