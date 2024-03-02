import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/about_model.dart';
import 'package:medico/widgets/custom_elevated_button.dart';

class EditAboutScreen extends StatefulWidget {
  const EditAboutScreen({super.key});

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController insta = TextEditingController();
  TextEditingController gmail = TextEditingController();
  TextEditingController name = TextEditingController();
  AuthenticationController authController =
      Get.find<AuthenticationController>();
  final ImagePicker imagePicker = ImagePicker();
  late AboutModel info;
  XFile? imageFile;
  void selectImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      info = authController.aboutInfo.value!;
      name.text = info.ownername;
      description.text = info.description;
      whatsapp.text = info.whatsapp;
      insta.text = info.insta;
      gmail.text = info.gmail;
      final oldPic = info.image;
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                color: color1,
              ),
            ),
            actions: [
              CustomElevatedButton(
                onTap: () async {
                  await authController.updateInfo(
                    description.text,
                    whatsapp.text,
                    insta.text,
                    gmail.text,
                    name.text,
                    imageFile,
                  );
                },
                text: 'Done',
                buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                  color: white,
                ),
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: color1,
                  side: BorderSide.none,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10).r,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: 4,
                    ),
                  ],
                ),
                height: 30.h,
                width: 70.w,
                margin: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 20.w,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120.h,
                    width: 120.w,
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: imageFile != null
                          ? FileImage(File(imageFile!.path))
                          : (oldPic!.isNotEmpty
                              ? NetworkImage(oldPic) as ImageProvider<
                                  Object>? // Assuming profileImage is a URL
                              : AssetImage(IconConstant.icTopbarProfile)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Text(
                      'Change Picture',
                      style: customTexttheme.bodyLarge!.copyWith(
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Owner Name',
                        style: customTexttheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 4,
                          ),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: name,
                      onFieldSubmitted: (value) {
                        // if (value.isEmpty) value = user.name;
                      },
                      style: customTexttheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Description',
                        style: customTexttheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 50.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 4,
                          ),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: description,
                      onFieldSubmitted: (value) {
                        // if (value.isEmpty) value = user.name;
                      },
                      maxLines: 20,
                      style: customTexttheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Whatsapp',
                        style: customTexttheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 4,
                          ),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: whatsapp,
                      onFieldSubmitted: (value) {
                        // if (value.isEmpty) value = user.name;
                      },
                      style: customTexttheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Instagram',
                        style: customTexttheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 4,
                          ),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.url,
                      controller: insta,
                      onFieldSubmitted: (value) {
                        // if (value.isEmpty) value = user.name;
                      },
                      style: customTexttheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Gmail',
                        style: customTexttheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 4,
                          ),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: gmail,
                      onFieldSubmitted: (value) {
                        // if (value.isEmpty) value = user.name;
                      },
                      style: customTexttheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r), // Set y
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
        ),
      );
    });
  }
}
