import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

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
  bool option2 = false;
  bool option3 = false;

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
                        height: 40.h,
                        width: 320.w,
                        child: TextFormField(
                          decoration: InputDecoration(
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
                      SizedBox(height: 50.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  CustomImageView(
                                    svgPath: IconConstant.icAddPicture,
                                    height: 30.h,
                                    width: 30.w,
                                  ),
                                  Text(
                                    'Add Picture',
                                    style: customTexttheme.bodySmall,
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
                            onTap: () {},
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
                      SizedBox(
                        height: 40.h,
                        width: 320.w,
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            option1FocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
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
                        height: 40.h,
                        width: 320.w,
                        child: TextFormField(
                          focusNode: option1FocusNode,
                          onFieldSubmitted: (value) {
                            option2FocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'option 1',
                            hintStyle: customTexttheme.bodySmall!.copyWith(
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
                        height: 40.h,
                        width: 320.w,
                        child: TextFormField(
                          focusNode: option2FocusNode,
                          onFieldSubmitted: (value) {
                            setState(() {
                              option2 = true;
                            });
                            option3FocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'option 2',
                            hintStyle: customTexttheme.bodySmall!.copyWith(
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
                          height: 40.h,
                          width: 320.w,
                          child: TextFormField(
                            focusNode: option3FocusNode,
                            onFieldSubmitted: (value) {
                              setState(() {
                                option3 = true;
                              });
                              option4FocusNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: 'option 3',
                              hintStyle: customTexttheme.bodySmall!.copyWith(
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
                          height: 40.h,
                          width: 320.w,
                          child: TextFormField(
                            focusNode: option4FocusNode,
                            decoration: InputDecoration(
                              hintText: 'option 4',
                              hintStyle: customTexttheme.bodySmall!.copyWith(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomImageView(
                            svgPath: IconConstant.icPost,
                            height: 35.h,
                            width: 35.w,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            onTap: () {},
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
