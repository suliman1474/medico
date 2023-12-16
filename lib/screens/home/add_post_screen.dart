import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/option_model.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../../models/poll_model.dart';
import '../../models/post_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with SingleTickerProviderStateMixin {
  FocusNode option1FocusNode = FocusNode();
  FocusNode option2FocusNode = FocusNode();
  FocusNode option3FocusNode = FocusNode();
  FocusNode option4FocusNode = FocusNode();
  TextEditingController description = TextEditingController();
  TextEditingController question = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> options =
      List.generate(4, (index) => TextEditingController());
  late FeedController feedController;
  bool option2 = false;
  bool option3 = false;
  final ImagePicker imagePicker = ImagePicker();
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

  String? optionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an option.';
    }
    return null;
  }

  String? questionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a question.';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    feedController = Get.find();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SafeArea(
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
            bottom: TabBar(
              // tabAlignment: TabAlignment.center,
              tabs: [
                Tab(
                  child: SizedBox(
                    width: 150.w,
                    child: Center(
                      child: Text(
                        'Post',
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: 150.w,
                    child: Center(
                      child: Text(
                        'Poll',
                      ),
                    ),
                  ),
                ),
              ],
              splashFactory: NoSplash.splashFactory,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: textColor,
              labelStyle: customTexttheme.titleMedium,
              unselectedLabelStyle: customTexttheme.titleMedium,
              labelPadding: EdgeInsets.symmetric(horizontal: 20.w),

              indicator: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: secondryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          'Create Post',
                          style: customTexttheme.titleLarge!
                              .copyWith(color: textColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Text(
                          'Description',
                          style: customTexttheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        // height: 45.h,
                        width: 340.w,
                        child: TextFormField(
                          controller: description,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 5.h, bottom: 5.h),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      imageFile == null ? SizedBox(height: 50.h) : Container(),
                      imageFile != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 15.h, bottom: 8.h),
                              child: Container(
                                height: 200.h,
                                width: 340.w,
                                child: Image.file(
                                  File(
                                    imageFile!.path,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: Row(
                                children: [
                                  CustomImageView(
                                    svgPath: IconConstant.icAddPicture,
                                    height: 30.h,
                                    width: 30.w,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.w, top: 8.h),
                                    child: Text(
                                      'Add Picture',
                                      style: customTexttheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomImageView(
                            svgPath: IconConstant.icPost,
                            height: 35.h,
                            width: 35.w,
                            margin: EdgeInsets.symmetric(horizontal: 0.w),
                            onTap: () {
                              feedController.createPost(
                                  description.text, imageFile);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: secondryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Text(
                          'Create Poll',
                          style: customTexttheme.titleLarge!
                              .copyWith(color: textColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Text(
                          'Description',
                          style: customTexttheme.bodySmall,
                        ),
                      ),
                      //==============Form====
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 45.h,
                              width: 320.w,
                              child: TextFormField(
                                controller: question,
                                validator: questionValidator,
                                onFieldSubmitted: (value) {
                                  option1FocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 5.w,
                                      right: 5.w,
                                      top: 5.h,
                                      bottom: 5.h),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Text(
                                'Options',
                                style: customTexttheme.bodySmall,
                              ),
                            ),
                            SizedBox(
                              height: 45.h,
                              width: 320.w,
                              child: TextFormField(
                                controller: options[0],
                                focusNode: option1FocusNode,
                                validator: optionValidator,
                                onFieldSubmitted: (value) {
                                  option2FocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  hintText: 'option 1',
                                  hintStyle:
                                      customTexttheme.bodySmall!.copyWith(
                                    color: textColor.withOpacity(0.5),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal: 10.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              height: 45.h,
                              width: 320.w,
                              child: TextFormField(
                                controller: options[1],
                                focusNode: option2FocusNode,
                                validator: optionValidator,
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    option2 = true;
                                  });
                                  option3FocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  hintText: 'option 2',
                                  hintStyle:
                                      customTexttheme.bodySmall!.copyWith(
                                    color: textColor.withOpacity(0.5),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal: 10.w,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: option2,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                height: 45.h,
                                width: 320.w,
                                child: TextFormField(
                                  controller: options[2],
                                  focusNode: option3FocusNode,
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      option3 = true;
                                    });
                                    option4FocusNode.requestFocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'option 3',
                                    hintStyle:
                                        customTexttheme.bodySmall!.copyWith(
                                      color: textColor.withOpacity(0.5),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5.h,
                                      horizontal: 10.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: option3,
                              child: SizedBox(
                                height: 45.h,
                                width: 320.w,
                                child: TextFormField(
                                  controller: options[3],
                                  focusNode: option4FocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'option 4',
                                    hintStyle:
                                        customTexttheme.bodySmall!.copyWith(
                                      color: textColor.withOpacity(0.5),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5.h,
                                      horizontal: 10.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icPost,
                            height: 35.h,
                            width: 35.w,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                print('validated');
                                PollModel pollModel = await PollModel(
                                  id: DateTime.now()
                                      .toUtc()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  question: question.text,
                                  timestamp: DateTime.now()
                                      .toUtc()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  options: [],
                                );
                                print('before for lloop');
                                late List<OptionModel?> optionModel;
                                for (int i = 0; i < options.length; i++) {
                                  print('in for loop');
                                  String optionText = options[i].text.trim();
                                  if (optionText.isNotEmpty) {
                                    print('options not empty');
                                    OptionModel option = OptionModel(
                                        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
                                        title: optionText,
                                        voterId: <String>[]);
                                    pollModel.options.add(option);
                                    print('options assigned');
                                  }
                                }
                                // Loop through and print all data in the PollModel
                                feedController.createPoll(pollModel);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
