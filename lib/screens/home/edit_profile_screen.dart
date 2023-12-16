import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  DbController dbController = Get.find();
  late Future<UserModel?> user;
  AuthenticationController authController =
      Get.find<AuthenticationController>();
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    user = dbController.getUser();

    super.initState();
  }

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
      final oldPic = authController.userProfile.value?.image ?? '';
      print('old pic : ${oldPic}');
      return Scaffold(
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
                  await authController.updateUserProfile(
                    nameController.text,
                    collegeController.text,
                    disciplineController.text,
                    semesterController.text,
                    contactController.text,
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
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              ),
            ],
          ),
          body: FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print('snapshot has data: ${snapshot.data!.name}');
                  final user = snapshot.data!;
                  nameController.text = user.name;
                  collegeController.text = user.college;
                  semesterController.text = user.semester;
                  disciplineController.text = user.discipline;
                  contactController.text = user.contact;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    child: SingleChildScrollView(
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
                                      : const AssetImage(
                                          'assets/images/profile.png')),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: Text(
                              'Change Profile',
                              style: customTexttheme.bodyLarge!.copyWith(
                                color: color1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              CustomImageView(
                                svgPath: IconConstant.icName2,
                                height: 25.h,
                                width: 25.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'Name',
                                style: customTexttheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(top: 5.h),
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
                              controller: nameController,
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) value = user.name;
                              },
                              style: customTexttheme.bodySmall,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 15.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomImageView(
                                svgPath: IconConstant.icCollege,
                                height: 25.h,
                                width: 20.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'College',
                                style: customTexttheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(top: 5.h),
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
                              controller: collegeController,
                              // initialValue: user.college,
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) value = user.college;
                              },
                              style: customTexttheme.bodySmall,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 15.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomImageView(
                                svgPath: IconConstant.icDegree,
                                height: 25.h,
                                width: 25.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'Discipline',
                                style: customTexttheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(top: 5.h),
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
                              controller: disciplineController,
                              // initialValue: user.discipline,
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) value = user.discipline;
                              },
                              style: customTexttheme.bodySmall,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 15.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomImageView(
                                svgPath: IconConstant.icDegree,
                                height: 25.h,
                                width: 25.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'Semester',
                                style: customTexttheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(top: 5.h),
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
                              controller: semesterController,
                              //initialValue: user.semester,
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) value = user.semester;
                              },
                              style: customTexttheme.bodySmall,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 15.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomImageView(
                                svgPath: IconConstant.icContact,
                                height: 25.h,
                                width: 20.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'Contact',
                                style: customTexttheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(top: 5.h),
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
                              controller: contactController,
                              // initialValue: user.contact,
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) value = user.contact;
                              },
                              style: customTexttheme.bodySmall,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(10.r), // Set y
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
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ));
    });
  }
}
