import 'dart:io';
import 'dart:async';

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
import '../models/link_model.dart';

Future<Map<String, String>?> getLinkDialog() async {
  final nameController = TextEditingController();
  final linkController = TextEditingController();

  return await Get.defaultDialog(
    title: "Add Link",
    content: Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Name",
          ),
        ),
        TextField(
          controller: linkController,
          decoration: InputDecoration(
            labelText: "Link",
          ),
        ),
      ],
    ),
    textConfirm: "Save",
    textCancel: "Cancel",
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.black,
    onConfirm: () {
      String name = nameController.text;
      String link = linkController.text;

      if (name.isEmpty || link.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter both name and link",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Don't close the dialog if validation fails
      }

      // Implement your logic to save the name and link (e.g., to a database, file, etc.)
      print('Name: $name, Link: $link');

      Get.back(result: {'name': name, 'link': link});
    },
  );
}

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

  Future<String?> _showRenameDialog(String oldFileName) async {
    TextEditingController controller = TextEditingController();
    String fileNameWithoutExtension =
        oldFileName.split('/').last.split('.').first;
    controller.text = fileNameWithoutExtension;
    // controller.text = oldFileName.split('/').last; // Default value in dialog

    return Get.defaultDialog<String>(
      title: 'Rename File',
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'New File Name',
          suffixText: '.' + oldFileName.split('.').last,
        ),
      ),
      textConfirm: 'OK',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: color1,
      onConfirm: () {
        print('Controller.text: ${controller.text}');
        Get.back(
          result: controller.text + '.' + oldFileName.split('.').last,
        );
      },
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
                      List<String> names = [];
                      for (File file in files) {
                        String? newName = await _showRenameDialog(file.path);
                        names.add(newName!);
                      }

                      filesController.uploadFiles(files, parentId ?? '', names);
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
                            allowedExtensions: ['ppt', 'pptx']);

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      List<String> names = [];
                      for (File file in files) {
                        String? newName = await _showRenameDialog(file.path);
                        names.add(newName!);
                      }

                      filesController.uploadFiles(files, parentId ?? '', names);
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
                      List<String> names = [];
                      for (File file in files) {
                        String? newName = await _showRenameDialog(file.path);
                        names.add(newName!);
                      }

                      filesController.uploadFiles(files, parentId ?? '', names);
                      //  filesController.uploadFiles(files, parentId ?? '');
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
                      type: FileType.any,
                    );

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      List<String> names = [];
                      for (File file in files) {
                        String? newName = await _showRenameDialog(file.path);
                        names.add(newName!);
                      }

                      filesController.uploadFiles(files, parentId ?? '', names);
                      // filesController.uploadFiles(files, parentId ?? '');
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
                // add link button
                CustomElevatedButton(
                  onTap: () async {
                    Get.back();
                    Map<String, String>? result = await getLinkDialog();
                    if (result != null) {
                      if (result['name'] != '' && result['link'] != '') {
                        LinkModel link = LinkModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: result['name']!,
                            url: result['link']!);

                        await filesController.addLink(link, parentId!);
                      }
                    }
                    // Get.back();
                  },
                  text: 'Add Link',
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
