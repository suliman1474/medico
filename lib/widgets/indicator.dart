import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/option_model.dart';
import 'package:medico/models/post_model.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/user_overview.dart';

class Indicator {
  static void showLoading() {
    Get.dialog(
      Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: color1,
          rightDotColor: color2,
          size: 40,
        ),
      ),
    );
  }

  static showDeleteDialogPoll(String pollId) {
    FeedController feedController = Get.find();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        content: Text(
          'Are you sure you want to delete this Poll?',
          style: customTexttheme.bodyLarge!.copyWith(fontSize: 22.sp),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                onTap: () {
                  Get.back();
                },
                text: 'Cancel',
                buttonTextStyle: customTexttheme.bodyLarge,
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                height: 40.h,
                width: 100.w,
                margin: EdgeInsets.only(left: 20.w),
              ),
              CustomElevatedButton(
                onTap: () {
                  feedController.deletePoll(pollId);
                },
                text: 'Delete',
                buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                height: 40.h,
                width: 100.w,
                margin: EdgeInsets.only(right: 20.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static showDeleteDialogPost(String postId) {
    FeedController feedController = Get.find();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        content: Text(
          'Are you sure you want to delete this Post?',
          style: customTexttheme.bodyLarge!.copyWith(fontSize: 22.sp),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                onTap: () {
                  Get.back();
                },
                text: 'Cancel',
                buttonTextStyle: customTexttheme.bodyLarge,
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                height: 40.h,
                width: 100.w,
                margin: EdgeInsets.only(left: 20.w),
              ),
              CustomElevatedButton(
                onTap: () {
                  feedController.deletePost(postId);
                },
                text: 'Delete',
                buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                height: 40.h,
                width: 100.w,
                margin: EdgeInsets.only(right: 20.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static showToast(String text, Color color) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget loader() {
    return LoadingAnimationWidget.flickr(
      leftDotColor: color1,
      rightDotColor: color2,
      size: 40,
    );
  }

  static void openbottomSheetLike(PostModel post) {
    FeedController feedController = Get.find();
    Get.bottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      BottomSheet(
        constraints: BoxConstraints(
          minWidth: ScreenUtil().screenWidth,
          minHeight: ScreenUtil().screenHeight / 2,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        onClosing: () {},
        builder: (context) {
          return FutureBuilder(
            future: feedController.getLikedByUsers(post),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while fetching data
                return Center(child: loader());
              } else if (snapshot.hasError) {
                // Show an error message if there's an error
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.done) {
                // Check if the data is empty
                List<UserModel>? likedUsers = snapshot.data as List<UserModel>?;

                if (likedUsers == null || likedUsers.isEmpty) {
                  // Show a message when there are no liked users
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No likes yet.',
                          style: customTexttheme.displayLarge!.copyWith(
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show the list of liked users

                return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Liked by',
                          style: customTexttheme.displayLarge!.copyWith(
                            fontSize: 26.sp,
                          ),
                        ),
                        for (int i = 0; i < likedUsers.length; i++)
                          Column(
                            children: [
                              UserOverview(
                                user: likedUsers[i],
                                bottomsheet: true,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                            ],
                          )

                        // Use the likedUsers list to display information about liked users
                        // For example, you can create a ListView.builder here
                      ],
                    ),
                  ),
                );
              } else {
                // Show a default container if none of the conditions are met
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  static void openbottomSheetVotes(String pollId, OptionModel option) {
    FeedController feedController = Get.find();
    Get.bottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      BottomSheet(
        constraints: BoxConstraints(
          minWidth: ScreenUtil().screenWidth,
          minHeight: ScreenUtil().screenHeight / 2,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        onClosing: () {},
        builder: (context) {
          return FutureBuilder(
            future: feedController.getVoters(pollId, option),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while fetching data
                return Center(child: loader());
              } else if (snapshot.hasError) {
                // Show an error message if there's an error
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.done) {
                // Check if the data is empty
                List<UserModel>? Voters = snapshot.data as List<UserModel>?;

                if (Voters == null || Voters.isEmpty) {
                  // Show a message when there are no liked users
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No Votes yet.',
                          style: customTexttheme.displayLarge!.copyWith(
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show the list of liked users

                return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voted by',
                          style: customTexttheme.displayLarge!.copyWith(
                            fontSize: 26.sp,
                          ),
                        ),
                        for (int i = 0; i < Voters.length; i++)
                          Column(
                            children: [
                              UserOverview(
                                user: Voters[i],
                                bottomsheet: true,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                            ],
                          )

                        // Use the likedUsers list to display information about liked users
                        // For example, you can create a ListView.builder here
                      ],
                    ),
                  ),
                );
              } else {
                // Show a default container if none of the conditions are met
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  static void closeLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
