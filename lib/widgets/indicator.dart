import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/post_model.dart';
import 'package:medico/models/user_model.dart';
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

  static Widget loader() {
    return LoadingAnimationWidget.flickr(
      leftDotColor: color1,
      rightDotColor: color2,
      size: 40,
    );
  }

  static void openbottomSheet(PostModel post) {
    FeedController feedController = Get.find();
    Get.bottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      BottomSheet(
        constraints: BoxConstraints(minWidth: ScreenUtil().screenWidth),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        onClosing: () {},
        builder: (context) {
          return FutureBuilder(
            future: feedController.getLikedByUsers(post),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while fetching data
                return Center(child: CircularProgressIndicator());
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
                print(likedUsers[0].name);
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
                            fontSize: 30.sp,
                          ),
                        ),
                        for (int i = 0; i < 10; i++)
                          Column(
                            children: [
                              UserOverview(user: likedUsers[0]),
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
