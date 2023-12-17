import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../controllers/db_controller.dart';
import '../models/post_model.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final postId;
  Post({
    super.key,
    required this.postId,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  FeedController feedController = Get.find();
  DbController dbController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PostModel post = feedController.postModels
          .firstWhere((post) => post.id == widget.postId);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // feedController.isLiked.value = post.like?.contains(userId) ?? false;
      print('isliked value: ${feedController.isLiked.value}');
      bool isLiked = post.like?.contains(userId) ?? false;

      print('user id: $userId');
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        padding:
            EdgeInsets.only(top: 10.h, bottom: 0.h, left: 10.w, right: 10.w),
        width: 379.w,
        decoration: BoxDecoration(
          color: secondryColor,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageView(
                    imagePath: IconConstant.icAppLogo,
                    height: 40.h,
                    width: 40.w,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(20).r,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medico Slides',
                        style: customTexttheme.displayLarge,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy hh:mma').format(DateTime.now()),
                        style: customTexttheme.bodySmall!.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: post.description != null && post.description!.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Text(
                        post.description! ?? '',
                        style: customTexttheme.bodyLarge,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Container(
              child: post.image != null && post.image!.isNotEmpty
                  ? Image.network(
                      post.image!,
                      height: 172.h,
                      width: 293.w,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
            ),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    post.like?.length.toString() ?? '0,87429385709425',
                    style: customTexttheme.bodySmall!.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: isLiked == true ? Colors.red : textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (post.like!.contains(userId)) {
                        post.like?.remove(userId);
                      } else {
                        post.like?.add(userId);
                      }
                      feedController.isLiked.value = !isLiked;
                      feedController.likePost(post.id, userId);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 8.w, left: 5.w, bottom: 5.h),
                      child: isLiked == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border),
                      // child: CustomImageView(
                      //   svgPath: IconConstant.icHeart,
                      //   height: 35.h,
                      //   width: 35.w,
                      // ),
                    ),
                  ),

                  // CustomImageView(
                  //   svgPath: IconConstant.icShare,
                  //   height: 35.h,
                  //   width: 35.w,
                  // ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
